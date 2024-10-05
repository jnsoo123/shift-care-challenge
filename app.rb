require_relative 'init'

begin
  reader = Options::Reader.new

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
