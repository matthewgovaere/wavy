module Wavy

  module Nodes

    class Mixin

      # (String) Content within mixin
      attr_reader :content

      # (Array) Params of mixin
      attr_reader :params
      
      # Creates a new Mixin node
      #
      # @param (String) name Name of mixin
      # @param (String) content Content of mixin
      # @param (String|Boolean) params Specified arguments
      def initialize(name, content, params = false)
        @name = name
        @content = content

        if params != false
          @params = get_params(params)
        end
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