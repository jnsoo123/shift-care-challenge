require 'json'

class FilePathToRawDataAdapter
  def self.call(filepath)
    new(filepath).adapt
  end

  attr_reader :clients

  def initialize(filepath)
    @filepath = filepath
    @clients = []
  end

  def adapt
    @raw_data ||= JSON.parse(File.read(@filepath))
  rescue Errno::ENOENT => e
    raise Exceptions::InvalidFile, 'File not found'
  rescue JSON::ParserError => e
    raise Exceptions::InvalidFile, 'Invalid JSON file'
  end
end