require "pathname"

module Dry
  module View
    class Path
      include Dry::Equalizer(:dir, :root)

      attr_reader :dir, :root

      def initialize(dir, options = {})
        @dir = Pathname(dir)
        @root = Pathname(options.fetch(:root, dir))
      end

      def lookup(name, format)
        template?(name, format) || template?("shared/#{name}", format) || !root? && chdir('..').lookup(name, format)
      end

      def chdir(dirname)
        self.class.new(dir.join(dirname), root: root)
      end

      def to_s
        dir
      end

      private

      def root?
        dir == root
      end

      # Search for a template using a wildcard for the engine extension
      def template?(name, format)
        glob = dir.join("#{name}.#{format}.*")
        Dir[glob].first
      end
    end
  end
end
