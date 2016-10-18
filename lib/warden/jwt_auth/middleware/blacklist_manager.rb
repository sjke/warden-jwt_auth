# frozen_string_literal: true

module Warden
  module JWTAuth
    class Middleware
      # Adds JWT to the blacklist
      class BlacklistManager < Middleware
        ENV_KEY = 'warden-jwt_auth.blacklist_manager'

        attr_reader :config

        def initialize(app, config)
          @app = app
          @config = config
        end

        def call(env)
          env[ENV_KEY] = true
          add_token_to_blacklist(env)
          @app.call(env)
        end

        private

        def add_token_to_blacklist(env)
          return unless env['PATH_INFO'].match(config.blacklist_token_paths)
          token = HeaderParser.parse_from_env(env)
          jti = TokenCoder.decode(token, config)['jti']
          config.blacklist.push(jti)
        end
      end
    end
  end
end
