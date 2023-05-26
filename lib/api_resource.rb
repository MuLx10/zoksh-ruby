require_relative 'connector'

module Zoksh
  class ApiResource
    attr_reader :connector
  
    def initialize(conn)
      @connector = conn
    end
  end
end