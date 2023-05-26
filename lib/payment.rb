require_relative 'api_resource'
require_relative 'connector'

module Zoksh
  class Payment < ApiResource
    ERROR_CODE = {
      TRANSACTION_MISSING: 'transaction-missing'
    }.freeze
  
    PATH_VALIDATE = '/v2/validate-payment'.freeze
  
    def validate(transaction_hash)
      raise ArgumentError, ERROR_CODE[:TRANSACTION_MISSING] if transaction_hash.nil? || transaction_hash.strip.empty?
  
      connector.sign_and_send(PATH_VALIDATE, { transaction: transaction_hash })
    end
  end
end