require 'apollo_upload_server/graphql_data_builder'

module ApolloUploadServer
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      params = request.params

      if env['CONTENT_TYPE'].to_s.include?('multipart/form-data') && params['operations'].present? && params['map'].present?
        result = GraphQLDataBuilder.new.call(request.params)
        result&.each do |key, value|
          request.update_param(key, value)
        end
      end

      @app.call(env)
    end
  end
end
