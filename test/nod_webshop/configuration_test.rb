require 'helper'

describe 'configuration' do
  after do
    NodWebshop.reset
  end

  describe '.configure' do
    NodWebshop::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        NodWebshop.configure do |config|
          config.send("#{key}=", key)
          NodWebshop.send(key).must_equal key
        end
      end

      describe '.key' do
        it "should return default value for #{key}" do
          NodWebshop.send(key).must_equal NodWebshop::Configuration.const_get("DEFAULT_#{key.upcase}")
        end
      end
    end
  end
end
