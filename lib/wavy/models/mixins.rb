module Wavy

  module Models

    class Mixins

      @dataFunctions = {}
      @dataTemplates = {}

      # Add a mixin function to the data model.
      #
      # @param (String) id Unique name of the import
      # @param (Tree::MixinNode) node Mixin node object
      def self.addFunction(id, node)
        if !@dataFunctions[id]
          @dataFunctions[id] = node
        end
      end

      # Add a mixin include to the data model.
      #
      # @param (String) id Unique name of the import
      # @param (Tree::MixinNode) node Mixin node object
      def self.addTemplate(id, node)
        if !@dataTemplates[id]
          @dataTemplates[id] = node
        end
      end

      # Get all of the mixin function definitions.
      #
      # @return (Object) @dataFunctions Object of mixins
      def self.getFunctions()
        return @dataFunctions
      end

      # Get all of the mixin include definitions.
      #
      # @return (Object) @dataTemplates Object of mixins
      def self.getTemplates()
        return @dataTemplates
      end

    end

  end

end