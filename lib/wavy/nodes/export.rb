module Wavy

  module Nodes

    class Export

      # (String) Content of import file
      attr_reader :path

      # Creates a new Import node
      #
      # @param (String) path Path to file
      # @param (String) content Content of file
      def initialize(path)
        @path = path
      end

    end

  end

end