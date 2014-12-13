require 'reek/source/core_extras'

module Reek
  module Source
    #
    # Finds Ruby source files in a filesystem.
    #
    class SourceLocator
      def initialize(paths)
        @paths = paths.map { |path| path.chomp(File::SEPARATOR) }
      end

      def sources
        valid_paths.map { |path| File.new(path).to_reek_source }
      end

      private

      def valid_paths
        all_source_files(@paths).select do |path|
          if test 'f', path
            true
          else
            $stderr.puts "Error: No such file - #{path}"
            false
          end
        end
      end

      def all_source_files(paths)
        paths.flat_map do |path|
          next if should_be_ignored?(path)
          if test 'd', path
            all_source_files(Dir["#{path}/**/*.rb"])
          else
            path
          end
        end.sort
      end

      def should_be_ignored?(path)
        GlobalExcludeConfiguration.contains?(path)
      end
    end
  end
end
