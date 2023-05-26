require_relative 'connector'
require_relative 'order'
require_relative 'payment'
require_relative 'webhook'

module Zoksh
  class Zoksh
    attr_reader :connector, :order, :payment, :webhook
  
    def initialize(zoksh_key, zoksh_secret, testnet = true)
      raise ArgumentError, 'Zoksh key missing' if zoksh_key.nil? || zoksh_key.empty?
      raise ArgumentError, 'Zoksh secret missing' if zoksh_secret.nil? || zoksh_secret.empty?
  
      @connector = Connector.new(zoksh_key, zoksh_secret, testnet)
      @order = Order.new(@connector)
      @payment = Payment.new(@connector)
      @webhook = nil
    end
  
    def webhook_endpoint=(url)
      parsed_url = URI.parse(url)
      raise ArgumentError, 'Invalid webhook endpoint URL' unless parsed_url.is_a?(URI::HTTP)
  
      @webhook = Webhook.new(@connector, parsed_url)
    end
  
    def create_order(body)
      @connector.sign_and_send('/v2/order', body)
    end
  
    def validate_payment(transaction_hash)
      @connector.sign_and_send('/v2/validate-payment', { transaction: transaction_hash })
    end
  end
end