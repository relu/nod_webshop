module NodWebshop
  module Configuration
    VALID_CONFIG_KEYS      = [:api_user, :api_key, :format, :user_agent, :endpoint].freeze

    DEFAULT_ENDPOINT        = "https://api.b2b.nod.ro"
    DEFAULT_USER_AGENT      = "NodWebshop API Gem #{NodWebshop::VERSION}"
    DEFAULT_API_USER        = nil
    DEFAULT_API_KEY         = nil
    DEFAULT_FORMAT          = :json

    attr_accessor(*VALID_CONFIG_KEYS)

    def self.extended(base)
      base.reset
    end

    def reset
      self.endpoint   = DEFAULT_ENDPOINT
      self.user_agent = DEFAULT_USER_AGENT
      self.api_user   = DEFAULT_API_USER
      self.api_key    = DEFAULT_API_KEY
      self.format     = DEFAULT_FORMAT
    end

    def configure
      yield self
    end

    def options
      Hash[ *VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end
  end
end
