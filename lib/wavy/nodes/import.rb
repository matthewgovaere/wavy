module Wavy

  module Nodes

    class Import

      # (String) Content of import file
      attr_reader :content

      # Creates a new Import node
      #
      # @param (String) path Path to file
      # @param (String) content Content of file
      def initialize(path, content)
        @path = path
        @content = content
      end

    end

  end

end