require 'json'

class FilePathToRawDataAdapter
  def self.call(filepath)
    new(filepath).adapt
  end

  def initialize(filepath)
    @filepath = filepath
  end

  def adapt
    @raw_data ||= JSON.parse(File.read(@filepath))
  rescue Errno::ENOENT => _e
    raise Exceptions::InvalidFile, 'File not found'
  rescue JSON::ParserError => _e
    raise Exceptions::InvalidFile, 'Invalid JSON file'
  rescue TypeError => _e
    raise Exceptions::InvalidFile, 'File not found'
  end
end