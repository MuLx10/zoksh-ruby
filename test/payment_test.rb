require 'minitest/autorun'
require_relative '../lib/payment'

class PaymentTest < Minitest::Test
  def setup
    @connector_mock = Minitest::Mock.new
    @payment = Zoksh::Payment.new(@connector_mock)
  end

  def test_validate_with_valid_transaction_hash
    transaction_hash = 'abc123'

    expected_request_body = { transaction: transaction_hash }
    expected_response = { success: true }

    @connector_mock.expect(:sign_and_send, expected_response, ["/v2/validate-payment", expected_request_body])

    result = @payment.validate(transaction_hash)

    assert_equal expected_response, result
    @connector_mock.verify
  end
end
