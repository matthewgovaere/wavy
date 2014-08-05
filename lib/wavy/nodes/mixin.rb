module Wavy

  module Nodes

    class Mixin

      # (Array) Params of mixin
      attr_reader :params
      
      # (String) Content within mixin
      attr_reader :content

      # Creates a new Mixin node
      #
      # @param (String) name Name of mixin
      # @param (String) params Specified arguments
      # @param (String) content Content of mixin
      def initialize(name, params, content)
        @name = name
        @params = get_params(params)
        @content = content
      end

      # Converts string of mixin parameters to an array.
      #
      # @return (Array) params Array of clean parameters
      def get_params(args)
        params = []

        args = args.split(",")

        args.each do |arg|
          arg = arg.strip
          if arg.index('$') == 0
            arg[0] = ''
            params.push(arg)
          end
        end

        return params
      end

    end

  end

end