require_relative 'api_resource'

module Zoksh
  class Order < ApiResource
    ERROR_CODE = {
      INVALID_AMOUNT: 'invalid-amount',
      MERCHANT_MISSING: 'merchant-order-missing'
    }.freeze
  
    PATH_CREATE = '/v2/order'.freeze
  
    def create(info)
      raise StandardError, ERROR_CODE[:INVALID_AMOUNT] if info[:amount].nil?
      im = info[:amount].to_s.strip
      raise StandardError, ERROR_CODE[:INVALID_AMOUNT] if im.empty?
  
      begin
        am = Float(info[:amount])
        raise StandardError, ERROR_CODE[:INVALID_AMOUNT] if am.nan? || am < 0
      rescue StandardError => e
        raise e
      end
  
      raise StandardError, ERROR_CODE[:MERCHANT_MISSING] if info[:merchant].nil? || info[:merchant][:orderId].nil?
  
      connector.sign_and_send(PATH_CREATE, info)
    end
  end
end
