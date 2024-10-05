require_relative 'init'

begin
  # ARGV.replace(['-p', 'clients.json'])

  parser   = Options::Parser.new
  raw_data = Options::ObjectBuilder.call(parser)

  CommandLineRunner.run(parser, raw_data)
rescue Exceptions::InvalidFile => e
  puts e.message
  exit(1) unless defined?(Minitest)
rescue Exceptions::FilePathMissing => e
  puts e.message
  exit(1) unless defined?(Minitest)
rescue Exceptions::ValidationError => e
  puts e.message
  exit(1) unless defined?(Minitest)
rescue Exceptions::MissingArgument => e
  puts e.message
  exit(1) unless defined?(Minitest)
end
