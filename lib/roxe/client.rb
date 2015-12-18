module Roxe
  class Client
    attr_reader :connexion, :consumer_token, :consumer_secret
    attr_accessor :token, :secret

    # connexion: Roxe::Connexion
    # token: String
    # token_secret: String
    def initialize(connexion:, token:, secret:)
      @connexion = connexion
      @token = token
      @secret = secret
    end

    def oauth
      Roxe::OAuth.new(connexion: connexion, credentials: credentials)
    end

    def http
      Http.new(oauth: oauth, api_url: connexion.api_url)
    end

    def renew_access_token(oauth_session_handle)
      new_token, new_secret = *oauth.renew_access_token(oauth_session_handle)

      self.token = new_token
      self.secret = new_secret

      { token: new_token, secret: new_secret }
    end

    private

    def request_headers
      { 'User-Agent' => user_agent }
    end

    def user_agent
      @user_agent ||= 'RoxeRubyGem/#{Roxe::VERSION}'
    end

    def credentials
      { consumer_key: connexion.consumer_key,
        consumer_secret: connexion.consumer_secret,
        token: token,
        token_secret: secret }
    end
  end
end
