require 'apollo_upload_server/graphql_data_builder'
require 'rack'

module ApolloUploadServer
  class Middleware
    attr_accessor :strict_mode

    def initialize(app)
      @app = app
    end

    def call(env)
      unless env['CONTENT_TYPE'].to_s.include?('multipart/form-data')
        return @app.call(env)
      end

      request = Rack::Request.new(env)
      params = request.params

      if (params['operation']&.length&.> 0) && (params['map']&.length&.> 0)
        result = GraphQLDataBuilder.new(strict_mode: self.class.strict_mode).call(request.params)
        result&.each do |key, value|
          request.update_param(key, value)
        end
      end

      @app.call(env)
    end

    class << self
      attr_accessor :strict_mode
    end
  end
end
