# frozen_string_literal: true

require 'json'
require 'apollo_upload_server/wrappers/uploaded_file'

module ApolloUploadServer
  class GraphQLDataBuilder
    OutOfBounds = Class.new(ArgumentError)

    def initialize(strict_mode: false)
      @strict_mode = strict_mode
    end

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

    def verify_array_index!(path, index, size)
      return unless @strict_mode
      return if 0 <= index && index < size

      raise OutOfBounds, "Path #{path.join('.')} maps to out-of-bounds index: #{index}"
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
      wrapped_file = Wrappers::UploadedFile.new(file)

      if field.is_a? Hash
        field.merge!(splited_path.last => wrapped_file)
      elsif field.is_a? Array
        index = parse_array_index(splited_path)
        verify_array_index!(splited_path, index, field.size)
        field[index] = wrapped_file
      end
    end

    def parse_array_index(path)
      return path.last.to_i unless @strict_mode

      Integer(path.last)
    rescue ArgumentError
      raise OutOfBounds, "Not a valid path to an array value: #{path.join('.')}"
    end
  end
end
