# syntax = docker/dockerfile:1

# このDockerfileは本番向けに設計されていますが、開発環境用にボリュームマッピングを利用するので、
# WORKDIRとコピー先のパスをホスト側のディレクトリ「/GasMileageLog」と一致させます。

ARG RUBY_VERSION=3.4.2
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

# Install packages needed to build gems (libyaml-dev を追加)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Bundler のバージョンを合わせる
RUN gem install bundler:2.6.3

# gemのビルドに必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# アプリケーションのgemをインストール
COPY Gemfile Gemfile.lock ./
# Install gems
RUN bundle install

# Remove caches
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby"/*/cache "${BUNDLE_PATH}/ruby"/*/bundler/gems/*/.git

# Precompile bootsnap
RUN bundle exec bootsnap precompile --gemfile

# アプリケーションコードのコピー
COPY . .

# bootsnapのプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# assetsのプリコンパイル（本番向け、シークレットが不要な場合）
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /GasMileageLog /GasMileageLog

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /GasMileageLog /usr/local/bundle
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/GasMileageLog/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
