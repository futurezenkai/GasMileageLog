# syntax = docker/dockerfile:1

# このDockerfileは本番向けに設計されていますが、開発環境用にボリュームマッピングを利用するので、
# WORKDIRとコピー先のパスをホスト側のディレクトリ「/GasMileageLog」と一致させます。

ARG RUBY_VERSION=3.1.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Railsアプリケーションはここに置く
WORKDIR /GasMileageLog

# ベースパッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# production向けの環境変数設定（docker-compose.yml側で開発環境に上書き可能）
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

FROM base AS build

# gemのビルドに必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# アプリケーションのgemをインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# アプリケーションコードのコピー
COPY . .

# bootsnapのプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# assetsのプリコンパイル（本番向け、シークレットが不要な場合）
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# 最終ステージ
FROM base

# ビルドステージからアプリケーションとgemをコピーする
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /GasMileageLog /GasMileageLog

# セキュリティ向上のため非rootユーザーを使用（/GasMileageLogの所有権を変更）
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /GasMileageLog
USER 1000:1000

# Entrypointはデータベースの準備などを行うスクリプトを指す（パスを合わせる）
ENTRYPOINT ["/GasMileageLog/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
