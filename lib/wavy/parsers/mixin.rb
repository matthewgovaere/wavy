module Wavy

  module Parsers

    class Mixin

      # Finds all user-defined mixins.
      #
      # @param (String) data Content
      def self.defined(data)
        pattern = /^(@mixin)\s(.*)\((.*)\.*\)\s{((?:[^{}]|{\$([^}]*)}|{{([^}]*)}})*)}/
        matches = data.scan(pattern)

        if matches.length > 0
          matches.each do |match|
            mixin_node = Wavy::Nodes::Mixin.new(match[1], match[2], match[3])

            Wavy::Models::Mixins.add(match[1], mixin_node)
          end
        end
      end

      # Finds all included mixins.
      #
      # @param (String) data Content
      #
      # @return (String) data Parsed content
      def self.parse(template)
        # Search for mixin includes
        pattern = /(@include)\s(.*)\((.*)\)/
        matches = template.scan(pattern)

        mixins = Wavy::Models::Mixins.get

        # Go through and parse each include
        if matches.length > 0
          matches.each do |match|
            if(mixins[match[1]])
              mixin = mixins[match[1]]
              params = match[2].split(",");
              content = mixin.content

              # Replace variables
              mixin.params.each_with_index do |param, index|
                if params[index]
                  new_param = params[index].strip.gsub(/\'/, "")
                else 
                  new_param = ""
                end

                content = content.gsub("{$#{param}}", new_param)
              end

              # Search for includes within mixins
              content = parse(content)

              # Find mixin string to replace
              find = "@include #{match[1]}(#{match[2]})"
              template = template.gsub(find, content)
            end
          end
        end

        return template
      end

    end

  end

end