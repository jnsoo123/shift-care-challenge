Dir['models/*.rb'].each   { |file| require_relative file }
Dir['services/*.rb'].each { |file| require_relative file }

# For testing purposes
require 'pry'