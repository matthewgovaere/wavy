module Wavy

  module Models

    class Template

      # (String) Original template content
      attr_reader :content

      # (String) Compiled template content
      attr_reader :compiled

      # Creates a new view template
      #
      # @return (String) content The view content (string/html)
      def initialize(content)
        @content = content
        @compiled = ""
      end

      # Parse the template.
      #
      # @return (String) @compiled Compiled output
      def parse
        @compiled = Wavy::Parsers::Mixin.parse(@content)

        return @compiled
      end

    end

  end

end