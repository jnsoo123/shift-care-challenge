require 'json'

module Options
  module Transformers
    class FilePathToRawData
      def self.call(filepath)
        new(filepath).perform
      end

      def initialize(filepath)
        @filepath = filepath
      end

      def perform
        parse_to_array_of_hashes
      rescue Errno::ENOENT => _e
        raise Exceptions::InvalidFile, 'File not found'
      rescue JSON::ParserError => _e
        raise Exceptions::InvalidFile, 'Invalid JSON file'
      rescue TypeError => _e
        raise Exceptions::InvalidFile, 'Please enter a file (e.g. ruby app.rb -p filepath)'
      end

      def parse_to_array_of_hashes
        data = JSON.parse(File.read(@filepath))

        if data.is_a?(Array)
          data
        else
          [data]
        end
      end
    end
  end
end
