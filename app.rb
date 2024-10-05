require_relative 'init'

begin
  reader = OptionsReader.new

  Client.build_data(reader.raw_data)

  CommandLineRunner.run(reader)
rescue Exceptions::InvalidFile => e
  puts e.message
  exit(1) unless defined?(Minitest)
rescue Exceptions::FilePathMissing => e
  puts e.message
  exit(1) unless defined?(Minitest)
rescue Exceptions::MissingArgument => e
  puts e.message
  exit(1) unless defined?(Minitest)
rescue Exceptions::InvalidField => e
  puts e.message
  exit(1) unless defined?(Minitest)
end
