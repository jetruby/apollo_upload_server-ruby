require 'json'

module ApolloUploadServer
  class GraphQLDataBuilder
    def call(params)
      operations = safe_json_parse(params['operations'])
      file_mapper = safe_json_parse(params['map'])

      return nil if operations.nil? || file_mapper.nil?
      single_operation = operations.is_a?(Hash)
      file_mapper.to_a.each do |file_index, paths|
        paths.each do |path|
          splited_path = path.split('.')
          if single_operation
            # splited_path => 'variables.input.profile_photo'; splited_path[0..-2] => ['variables', 'input']
            # dig from first to penultimate key, and merge last key with value as file
            operations.dig(*splited_path[0..-2]).merge!(splited_path.last => params[file_index])
          else
            # dig from second to penultimate key, and merge last key with value as file to operation with first key index
            operations[splited_path.first.to_i].dig(*splited_path[1..-2]).merge!(splited_path.last => params[file_index])
          end
        end
      end
      single_operation ? [operations] : operations
    end

    private

    def safe_json_parse(data)
      JSON.parse(data)
    rescue JSON::ParserError
      nil
    end
  end
end
