require_relative 'init'

def run_app
  # ARGV.replace(['-p', 'clients.json'])

  if ARGV.empty?
    puts 'Please provide arguments. Run `ruby app.rb -h` for help'
    exit(1)
  end

  parser   = Options::Parser.new
  raw_data = Options::Transformers::FilePathToRawData.call(parser.filepath)

  AppRunner.run(parser, raw_data)
rescue Exceptions::InvalidFile => e
  puts e.message
rescue Exceptions::ValidationError => e
  puts e.message
rescue Exceptions::MissingArgument => e
  puts e.message
end

run_app
