require 'active_support'
require 'active_support/core_ext'

module Roxe
  class Response
    attr_reader :response, :resource

    # response: Net::HTTP
    # resource: Symbol
    def initialize(response:, resource:)
      @response = Hash.from_xml(response.body)['Response']
      @resource = resource.to_s.capitalize
    end

    def build
      response[resource][resource.singularize]
    end
  end
end
