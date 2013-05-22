require 'helper'

describe NodWebshop::Client do

  before do
    @keys = NodWebshop::Configuration::VALID_CONFIG_KEYS
  end

  describe 'with module configuration' do
    before do
      NodWebshop.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key.to_s)
        end
      end
    end

    after do
      NodWebshop.reset
    end

    it "should inherit module configuration" do
      api = NodWebshop::Client.new
      @keys.each do |key|
        api.send(key).must_equal key.to_s
      end
    end

    describe 'with class configuration' do
      before do
        @config = {
          :api_user       => 'usr',
          :api_key        => 'key',
          :format         => :json,
          :endpoint       => 'test',
          :user_agent     => 'ua'
        }
      end

      it 'should override module configuration' do
        api = NodWebshop::Client.new(@config)
        @keys.each do |key|
          api.send(key).must_equal @config[key]
        end
      end

      it 'should override module configuration after' do
        api = NodWebshop::Client.new

        @config.each do |key, value|
          api.send("#{key}=", value)
        end

        @keys.each do |key|
          api.send("#{key}").must_equal @config[key]
        end
      end
    end
  end

  describe 'client' do
    before do
      @config = {
        :api_user       => 'test',
        :api_key        => 'secret',
      }

      @client = NodWebshop::Client.new(@config)
    end

    it "should allow access to the auth headers after initialization" do
      @client.must_respond_to :auth_headers
    end

    it "should correctly retrieve all products" do
      VCR.use_cassette "get_all_products" do
        prod = @client.products

        prod.must_be_instance_of Hash
        prod.wont_be_empty
      end
    end

    it "should correctly retrieve addresses" do
      VCR.use_cassette "get_all_addresses" do
        addresses = @client.addresses
        addresses.must_be_instance_of Array
        addresses.wont_be_empty
      end
    end

    it "should correctly retrieve orders" do
      VCR.use_cassette "get_all_orders" do
        orders = @client.orders["orders"]
        orders.must_be_instance_of Array
        orders.wont_be_empty
      end
    end

    it "should correctly retrieve product_categories" do
      VCR.use_cassette "get_all_product_categories" do
        cats = @client.product_categories
        cats.must_be_instance_of Array
        cats.wont_be_empty
      end
    end

    it "should correctly retrieve manufactureres" do
      VCR.use_cassette "get_all_manufactureres" do
        manu = @client.manufacturers
        manu.must_be_instance_of Array
        manu.wont_be_empty
      end
    end

    it "should correctly retrieve invoices" do
      skip "Not yet implemented"
      VCR.use_cassette "get_all_invoices" do
        invoices = @client.invoices
        invoices.must_be_instance_of Array
        invoices.wont_be_empty
      end
    end

    it "should correctly retrieve payments" do
      VCR.use_cassette "get_all_payments" do
        payments = @client.payments["payments"]
        payments.must_be_instance_of Array
        payments.wont_be_empty
      end
    end

    it "should correctly retrieve payment_options" do
      VCR.use_cassette "get_all_payment_options" do
        pmo = @client.payment_options
        pmo.must_be_instance_of Array
        pmo.wont_be_empty
      end
    end

    it "should correctly retrieve transport_options" do
      VCR.use_cassette "get_all_transport_options" do
        to = @client.transport_options
        to.must_be_instance_of Array
        to.wont_be_empty
      end
    end

    it "should correctly retrieve full products feed" do
      VCR.use_cassette "get_all_products_full_feed" do
        feed = @client.products_full_feed
        feed.must_be_instance_of Array
        feed.wont_be_empty
      end
    end

    it "should correctly retrieve exchange_rates" do
      VCR.use_cassette "get_all_exchange_rates" do
        er = @client.exchange_rates
        er.must_be_instance_of Array
        er.wont_be_empty
      end
    end
  end
end
