require 'minitest/autorun'
require 'mocha/minitest'
require_relative '../lib/zoksh'

class ZokshTest < Minitest::Test
  def setup
    @zoksh_key = 'zoksh_key'
    @zoksh_secret = 'zoksh_secret'
    @zoksh = Zoksh::Zoksh.new(@zoksh_key, @zoksh_secret)
  end

  def test_zoksh_initialization
    assert_instance_of Zoksh::Connector, @zoksh.instance_variable_get(:@connector)
    assert_instance_of Zoksh::Payment, @zoksh.instance_variable_get(:@payment)
    assert_nil @zoksh.instance_variable_get(:@webhook)
  end

  def test_webhook_without_webhook_end_point_set
    assert_raises(StandardError) do
      @zoksh.webhook_endpoint = "invalid_url"
      @zoksh.webhook
    end
  end

  def test_set_webhook_end_point
    webhook_url = 'https://example.com/webhook'
    webhook = mock('Webhook')

    Zoksh::Webhook.expects(:new).with(@zoksh.instance_variable_get(:@connector), URI(webhook_url)).returns(webhook)
    @zoksh.webhook_endpoint = webhook_url
    assert_equal webhook, @zoksh.instance_variable_get(:@webhook)
  end

  def test_webhook
    webhook = mock('Webhook')
    @zoksh.instance_variable_set(:@webhook, webhook)

    assert_equal webhook, @zoksh.webhook
  end



  def test_create_order
    order_body = { amount: 100, token: 'ABC', merchant: { orderId: '123' } }
    result = { 'status' => 'success', 'message' => 'Order created' }

    @zoksh.instance_variable_get(:@connector).expects(:sign_and_send).with('/v2/order', order_body).returns(result)

    response = @zoksh.create_order(order_body)

    assert_equal result, response
  end

  def test_validate_payment
    transaction_hash = 'valid_transaction_hash'
    result = { 'status' => 'success', 'message' => 'Payment validated' }
    
    @zoksh.instance_variable_get(:@connector).expects(:sign_and_send).with('/v2/validate-payment', { transaction: transaction_hash}).returns(result)

    response = @zoksh.validate_payment(transaction_hash)

    assert_equal result, response
  end

  # Add more test cases as needed

end
