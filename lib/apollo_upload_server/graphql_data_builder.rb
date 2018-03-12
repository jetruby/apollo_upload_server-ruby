require 'json'

module ApolloUploadServer
  class GraphQLDataBuilder
    def call(params)
      operations = safe_json_parse(params['operations'])
      file_mapper = safe_json_parse(params['map'])

      return nil if operations.nil? || file_mapper.nil?
      if operations.is_a?(Hash)
        single_transformation(file_mapper, operations, params)
      else
        { '_json' => multiple_transformation(file_mapper, operations, params) }
      end
    end

    private

    def single_transformation(file_mapper, operations, params)
      operations = operations.dup
      file_mapper.each do |file_index, paths|
        paths.each do |path|
          splited_path = path.split('.')
          # splited_path => 'variables.input.profile_photo'; splited_path[0..-2] => ['variables', 'input']
          # dig from first to penultimate key, and merge last key with value as file

          field = get_parent_field(operations, splited_path)
          assign_file(field, splited_path, params[file_index])
        end
      end
      operations
    end

    def multiple_transformation(file_mapper, operations, params)
      operations = operations.dup
      file_mapper.each do |file_index, paths|
        paths.each do |path|
          splited_path = path.split('.')
          # dig from second to penultimate key, and merge last key with value as file to operation with first key index
          field = operations[splited_path.first.to_i].dig(*splited_path[1..-2])
          assign_file(field, splited_path, params[file_index])
        end
      end
      operations
    end

    def safe_json_parse(data)
      JSON.parse(data)
    rescue JSON::ParserError
      nil
    end

    def get_parent_field(operations, splited_path)
      # returns parent element of file field

      splited_path[0..-2].inject(operations) do |element, key|
        case element
        when Array
          element[Integer(key)]
        else
          element[key]
        end
      end
    end


    def assign_file(field, splited_path, file)
      if field.is_a? Hash
        field.merge!(splited_path.last => file)
      elsif field.is_a? Array
        field[splited_path.last.to_i] = file
      end
    end
  end
end
