require 'minitest/autorun'
require_relative '../lib/webhook'
require_relative '../lib/connector'

class WebHookTest < Minitest::Test
  def setup
    @zoksh_key = 'your_zoksh_key'
    @zoksh_secret = 'your_zoksh_secret'
    @connector = Zoksh::Connector.new(@zoksh_key, @zoksh_secret)

    @webhook_endpoint = URI('https://example.com/webhook')
    @webhook = Zoksh::Webhook.new(@connector, @webhook_endpoint)
  end

  def test_handle_with_valid_signature
    headers = {
      'zoksh-key' => @zoksh_key,
      'zoksh-ts' => '1637170468000',
      'zoksh-sign' => 'valid_signature'
    }
    body = { 'data' => 'example data' }

    @connector.stub(:calculate_signature, { signature: 'valid_signature' }) do
      assert_equal true, @webhook.handle(headers, body)
    end
  end

  def test_handle_with_invalid_signature
    headers = {
      'zoksh-key' => @zoksh_key,
      'zoksh-ts' => '1637170468000',
      'zoksh-sign' => 'invalid_signature'
    }
    body = { 'data' => 'example data' }

    @connector.stub(:calculate_signature, { signature: 'valid_signature' }) do
      assert_raises(StandardError) do
        @webhook.handle(headers, body)
      end
    end
  end

  def test_express_with_valid_signature
    request = MiniTest::Mock.new
    response = MiniTest::Mock.new

    headers = {
      'ZOKSH-KEY' => @zoksh_key,
      'ZOKSH-TS' => '1637170468000',
      'ZOKSH-SIGN' => 'valid_signature'
    }
    body = { 'data' => 'example data' }

    request.expect(:headers, headers)
    request.expect(:body, body)
    response.expect(:status, 200)

    @webhook.stub(:test, true) do
      @webhook.express(request, response, nil)
    end
  end
end
