require 'active_support'
require 'active_support/core_ext'

module Roxe
  class Response
    attr_reader :response, :resource

    # response: Net::HTTP
    # resource: Symbol
    def initialize(response:, resource:)
      @response = Hash.from_xml(response.body)['Response']
      @resource = resource
    end

    def build
      response[resource.to_s.capitalize][resource.to_s.capitalize.singularize]
    end
  end
end
