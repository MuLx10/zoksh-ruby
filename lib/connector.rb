require 'openssl'
require 'json'
require 'net/http'

SANDBOX_NETWORK_PATH = 'payments.sandbox.zoksh.com'
PROD_NETWORK_PATH = 'payments.zoksh.com'

module Zoksh
  class Connector
    attr_reader :zoksh_key, :zoksh_secret, :base_path
  
    def initialize(zoksh_key, zoksh_secret, sandbox = true)
      @zoksh_key = zoksh_key
      @zoksh_secret = zoksh_secret
      @base_path = sandbox ? SANDBOX_NETWORK_PATH : PROD_NETWORK_PATH
    end
  
    def calculate_signature(path, body, use_time = -1)
      post_body = body.to_json
      ts = use_time != -1 ? use_time : (Time.now.to_f * 1000).to_i
      hmac = OpenSSL::HMAC.new(zoksh_secret, OpenSSL::Digest.new('sha256'))
  
      to_sign = "#{ts}#{path}#{post_body}"
      signature = hmac.update(to_sign).hexdigest
      { ts: ts, signature: signature }
    end
  
    def sign_and_send(path, body, stamp = -1)
      signature = calculate_signature(path, body, stamp)
      uri = URI("https://#{base_path}#{path}")
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req['ZOKSH-KEY'] = zoksh_key
      req['ZOKSH-TS'] = signature[:ts]
      req['ZOKSH-SIGN'] = signature[:signature]
      req.body = body.to_json
  
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
  
      res.body
    end
  end
end