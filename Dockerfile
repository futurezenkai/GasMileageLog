# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.4.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Railsアプリケーションは /GasMileageLog に配置
WORKDIR /GasMileageLog

# ベースパッケージのインストール（build-essential を含む）
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        curl \
        libjemalloc2 \
        libvips \
        postgresql-client \
        build-essential && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# build時の環境変数を引数にする（デフォルトは production だが、docker-compose で上書き可）
ARG RAILS_ENV=production
ARG BUNDLE_WITHOUT="development"
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

# ===================== build ステージ =====================
FROM base AS build

# ビルドに必要な追加パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        git \
        libpq-dev \
        pkg-config \
        libyaml-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Bundler のバージョン固定
RUN gem install bundler:2.6.3

# Gemfile と Gemfile.lock のコピーと gem のインストール
COPY Gemfile Gemfile.lock ./
# frozen モードでロックファイルと依存関係が合致していることを前提
RUN bundle install

# キャッシュの削除
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby"/*/cache "${BUNDLE_PATH}/ruby"/*/bundler/gems/*/.git

# bootsnap のプリコンパイル（gemfileベース）
RUN bundle exec bootsnap precompile --gemfile

# アプリケーション全体のコピー
COPY . .

# bootsnap の再プリコンパイル（app/ と lib/）
RUN bundle exec bootsnap precompile app/ lib/

# assets のプリコンパイル（本番用、SECRET_KEY_BASE が不要な場合）
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ===================== 最終ステージ =====================
FROM base

# build ステージで作成した gems とアプリケーションコードをコピー
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /GasMileageLog /GasMileageLog

# セキュリティ向上のため非rootユーザーで実行
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /GasMileageLog /usr/local/bundle
USER 1000:1000

# Railsコマンドをコンテナ内で直接「rails」と入力して使えるようにする
ENV PATH="/GasMileageLog/bin:${PATH}"

# Entrypoint でデータベース準備などを実施
ENTRYPOINT ["/GasMileageLog/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
