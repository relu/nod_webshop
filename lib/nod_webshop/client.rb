require 'httparty'
require 'addressable/uri'
require 'base64'
require 'openssl'
require 'ostruct'

module NodWebshop
  class Client
    include HTTParty

    attr_accessor :auth_headers
    attr_accessor(*Configuration::VALID_CONFIG_KEYS)

    def initialize(options={})
      merged_options = NodWebshop.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end

      self.class.base_uri self.endpoint
      self.class.format self.format if [:json, :xml].include?(self.format)

      @headers = {
        'X-NodWS-User'    => self.api_user,
        'X-NodWS-Accept'  => self.format.to_s
      }
    end

    def headers(verb="get", path='', qs={}, custom={})
      content_type = if self.format == :json
                       'application/json'
                     else
                       'text/xml'
                     end

      uri = Addressable::URI.parse(path.gsub(/^\/|\/$/, ''))
      uri.query_values = qs unless qs.empty?

      h = {
        'Date'          => Time.now.gmtime.rfc2822,
        'Accept'        => content_type,
        'Content-Type'  => content_type,
        'X-NodWS-Auth'  => auth_string(verb, uri.to_s),
        'User-Agent'    => self.user_agent
      }

      h.merge! @headers

      h.merge! custom if custom

      h
    end

    %w{manufacturers products product_categories addresses orders invoices
      payment_options payments transport_options}.each do |item|

      class_eval <<-EVAL
        def #{item}(params=nil)
          id = ''
          collection = "#{item}".gsub('_', '-')
          uri = "/\#{collection}/"
          opts = {}

          if params and params.is_a?(Hash)
            opts[:query] = params
            opts[:headers] = headers("get", uri, opts)
          else
            id = params
            uri += id.to_s unless id.nil?
            opts[:headers] = headers("get", uri)
          end

          r = self.class.get(uri, opts)
          first = r[r.keys.first]

          if first.is_a?(Hash) and first.keys.include?(collection)
            obj = first[collection]
          else
            obj = first
          end

          if obj.is_a?(Array)
            obj.map { |x| OpenStruct.new(x) }
          else
            OpenStruct.new(obj)
          end
        end
      EVAL
    end

    %w{addresses orders}.each do |item|
      class_eval <<-EVAL
        def add_#{item}(params={})
          uri = "/#{item}/"

          opts = {
            :headers => headers("post", uri, params),
            :query => params
          }

          r = self.class.post(uri, opts)
          r["id"]
        end

        def update_#{item}(id, params={})
          uri = "/#{item}/\#{id}"

          opts = {
            :headers => headers("put", uri, params),
            :query => params
          }

          self.class.put(uri, opts)
        end

        def delete_#{item}(id)
          uri = "/#{item}/\#{id}"
          self.class.delete(uri, :headers => headers("delete", uri))
        end
      EVAL
    end

    def products_full_feed
      uri = '/products/full-feed/'
      r = self.class.get(uri, :headers => self.headers("get", uri))
      r["products"].map { |x| OpenStruct.new(x) }
    end

    def exchange_rates
      uri = '/exchange-rates/'
      r = self.class.get(uri, :headers => self.headers("get", uri))
      r["exchange_rates"].map { |x| OpenStruct.new(x) }
    end

    private

    def auth_string(verb="get", qs='')
      s = "#{verb.upcase}#{qs}/#{self.api_user}#{Time.now.gmtime.rfc2822}"
      hmac = OpenSSL::HMAC.digest('sha1', self.api_key, s)

      Base64.strict_encode64(hmac)
    end
  end
end
