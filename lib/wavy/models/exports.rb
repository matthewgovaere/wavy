module Wavy

  module Models

    class Exports

      @data = {}

      # Add an import to the data model.
      #
      # @param (String) id Unique name of the import
      # @param (Tree::ImportNode) node Import node object
      # @param (String) file File path
      def self.add(id, node, file = '')
        if file == ''
          file = id
        end

        if !@data[id]
          @data[id] = node
        else
          puts file + ' is being exported more than once.'
        end
      end

      # Get all of the import definitions.
      #
      # @return (Object) @data Object of imports
      def self.get()
        return @data
      end

    end

  end

end