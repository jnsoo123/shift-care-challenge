Dir['models/*.rb'].each   { |file| require_relative file }
Dir['services/*.rb'].each { |file| require_relative file }
Dir['services/**/*.rb'].each { |file| require_relative file }
require_relative 'exceptions.rb'

# For testing purposes
require 'pry'