require_relative 'init'

begin
  # ARGV.replace(['-p', 'clients.json'])

  parser   = Options::Parser.new
  raw_data = Options::Transformers::FilePathToRawData.call(parser.filepath)

  AppRunner.run(parser, raw_data)
rescue Exceptions::InvalidFile => e
  puts e.message
rescue Exceptions::FilePathMissing => e
  puts e.message
rescue Exceptions::ValidationError => e
  puts e.message
rescue Exceptions::MissingArgument => e
  puts e.message
end
