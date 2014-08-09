module Wavy

  module Models

    class Template

      # (String) Original template content
      attr_reader :content

      # (String) Original template path
      attr_reader :path

      # (String) Compiled template content
      attr_reader :compiled

      # Creates a new view template
      #
      # @param (String) content Content of file
      # @param (String) path Path to file
      #
      # @return (String) content The view content (string/html)
      def initialize(content, path)
        @content = content
        @path = path
        @compiled = ""
      end

      # Parse the template.
      #
      # @return (String) @compiled Compiled output
      def parse
        @compiled = Wavy::Parsers::Mixin.parse(@content, @path)

        return @compiled
      end

    end

  end

end