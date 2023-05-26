require_relative 'api_resource'
require_relative 'connector'

module Zoksh
  class Webhook < Zoksh::ApiResource
    ERROR_CODE = {
      INVALID_REQUEST: 'invalid-request',
      MISSING_REQUEST_HEADERS: 'missing-request-headers',
      INVALID_REQUEST_HEADERS: 'invalid-request-headers',
      MISSING_REQUEST_BODY: 'missing-request-body',
      INVALID_SIGNATURE: 'invalid-signature'
    }.freeze
  
    attr_reader :endpoint
  
    def initialize(connector, webhook_endpoint)
      super(connector)
      @endpoint = webhook_endpoint
    end
  
    def parse_request(req)
      raise StandardError, ERROR_CODE[:INVALID_REQUEST] if req.nil?
      raise StandardError, ERROR_CODE[:MISSING_REQUEST_HEADERS] if req[:headers].nil?
      raise StandardError, ERROR_CODE[:MISSING_REQUEST_BODY] if req[:body].nil?
  
      headers = req[:headers]
      zoksh_key = headers['zoksh-key']
      zoksh_ts = headers['zoksh-ts']
      zoksh_sign = headers['zoksh-sign']
  
      raise StandardError, ERROR_CODE[:INVALID_REQUEST_HEADERS] if zoksh_key.nil? || zoksh_ts.nil? || zoksh_sign.nil?
  
      body = req[:body]
      { zoksh_key: zoksh_key, zoksh_ts: zoksh_ts, zoksh_sign: zoksh_sign, body: body }
    end
  
    def test(req)
      parsed_request = parse_request(req)
      zoksh_sign = parsed_request[:zoksh_sign]
      zoksh_ts = parsed_request[:zoksh_ts]
      body = parsed_request[:body]
      signature = connector.calculate_signature(endpoint.path, body, zoksh_ts)[:signature]
  
      raise StandardError, ERROR_CODE[:INVALID_SIGNATURE] if signature != zoksh_sign
  
      true
    end
  
    def handle(headers, body)
      test(headers: headers, body: body)
    end
  
    def express(req, _res, next_handler=nil)
      test(req)
      next_handler.call(true)
    rescue StandardError => e
      next_handler&.call(e)
    end
  end
end
