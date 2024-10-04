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
  end
end