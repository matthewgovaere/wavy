module Wavy

  module Models

    class Mixins

      @data = {}

      # Add a mixin to the data model.
      #
      # @param (String) id Unique name of the import
      # @param (Tree::MixinNode) node Mixin node object
      def self.add(id, node)
        if !@data[id]
          @data[id] = node
        end
      end

      # Get all of the mixin definitions.
      #
      # @return (Object) @data Object of mixins
      def self.get()
        return @data
      end

    end

  end

end