
module Reek
  module Source
    class GlobalExcludeConfiguration
      @configuration = []

      class << self
        def key
          'Exclude'
        end

        def configure(paths)
          @configuration += paths.map {|path| path.chomp(File::SEPARATOR)}
        end

        def contains?(path)
          @configuration.include? path
        end
      end
    end
  end
end
