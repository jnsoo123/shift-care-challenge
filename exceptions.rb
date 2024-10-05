module Exceptions
  class InvalidFile < StandardError; end;
  class FilePathMissing < StandardError; end;
  class MissingArgument < StandardError; end;
  class ValidationError < StandardError; end;
end