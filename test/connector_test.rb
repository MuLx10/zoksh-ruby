require 'minitest/autorun'
require 'json'
require 'net/http'
require_relative '../lib/zoksh'

class ConnectorTest < Minitest::Test
  def setup
    @zoksh_key = 'your_zoksh_key'
    @zoksh_secret = 'your_zoksh_secret'
    @sandbox = true
    @connector = Zoksh::Connector.new(@zoksh_key, @zoksh_secret, @sandbox)
  end

  def test_calculate_signature
    path = '/v2/order'
    body = { amount: 100, token: 'abc123' }
    expected_signature = 'some_signature'

    OpenSSL::HMAC.stub(:hexdigest, expected_signature) do
      result = @connector.calculate_signature(path, body)
      assert result != nil
    end
  end
end







