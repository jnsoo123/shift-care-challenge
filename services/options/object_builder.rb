module Options
  class ObjectBuilder
    def self.call(parser)
      new(parser).perform
    end

    def initialize(parser)
      @parser   = parser
      @filepath = parser.filepath
      @raw_data = build_raw_data
    end

    def perform
      @raw_data
    end

    private

    def build_raw_data
      ::FilePathToRawDataTransformer.call(@filepath)
    end
  end
end