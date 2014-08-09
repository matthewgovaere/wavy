module Wavy

  module Parsers

    class Mixin

      # Finds all user-defined mixins.
      #
      # @param (String) data Content
      def self.definedFunctions(data)
        pattern = /^(@mixin)\s(.*)\((.*)\.*\)\s{((?:[^{}]|{\$([^}]*)}|{{([^}]*)}})*)}/
        matches = data.scan(pattern)

        if matches.length > 0
          matches.each do |match|
            name = "function-" + match[1]
            content = match[3]
            params = match[2]

            mixin_node = Wavy::Nodes::Mixin.new(name, content, params)

            Wavy::Models::Mixins.addFunction(name, mixin_node)
          end
        end
      end

      # Finds all user-defined mixins.
      #
      # @param (String) data Content
      # @param (String|Boolean) path Template path
      def self.definedTemplates(data, path = false)
        pattern = /(@include)\s\"(.*)\"/
        matches = data.scan(pattern)

        if matches.length > 0
          matches.each do |match|
            file = match[1]
            name = "template-" + file

            if path != false
              base_dir = File.expand_path(File.dirname(path))

              # Check if full filename was included
              if File.file?(base_dir + "/" + file)
                content = FILE_IMPORTER.load(base_dir + "/" + file)
                mixin_node = Wavy::Nodes::Mixin.new(name, content, false)

                Wavy::Models::Mixins.addTemplate(name, mixin_node)
              else
                file_pattern = /(#{file})\..*/
                file_dir = file.scan(/(.*)\//)

                if file_dir[0]
                  Dir.glob(base_dir + "/" + file_dir[0][0] + "/*") do |filename|
                    file_matches = filename.scan(file_pattern)

                    if file_matches.length > 0
                      file_matches.each do |file_match|
                        file_match = file_match[0]
                        puts filename

                        content = FILE_IMPORTER.load(filename)
                        mixin_node = Wavy::Nodes::Mixin.new(name, content, false)

                        Wavy::Models::Mixins.addTemplate(name, mixin_node)
                      end
                    else
                      raise 'Could not find included file.'
                    end
                  end
                else
                  raise 'Could not find included file.'
                end
              end
            end
          end
        end
      end

      # Parses all function and template mixins
      #
      # @param (String) data Content
      # @param (String|Boolean) path Template path
      #
      # @return (String) data Parsed content
      def self.parse(template, path = false)
        template = parseFunctions(template)
        template = parseTemplates(template, path)

        return template
      end

      # Finds all included mixin functions.
      #
      # @param (String) data Content
      #
      # @return (String) data Parsed content
      def self.parseFunctions(template)
        # Search for mixin includes
        pattern = /(@include)\s(.*)\((.*)\)/
        matches = template.scan(pattern)

        mixins = Wavy::Models::Mixins.getFunctions

        # Go through and parse each include
        if matches.length > 0
          matches.each do |match|
            if(mixins["function-"+match[1]])
              mixin = mixins["function-"+match[1]]
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

      # Finds all included mixin functions.
      #
      # @param (String) data Content
      # @param (String) path Template path
      #
      # @return (String) data Parsed content
      def self.parseTemplates(template, path)
        # Search for mixin includes
        pattern = /(@include)\s\"(.*)\"/
        matches = template.scan(pattern)

        mixins = Wavy::Models::Mixins.getTemplates

        # Go through and parse each include
        if matches.length > 0
          matches.each do |match|
            if(mixins["template-"+match[1]])
              mixin = mixins["template-"+match[1]]
              content = mixin.content

              # Search for includes within mixins
              content = parse(content, path)

              # Find mixin string to replace
              find = "@include \"#{match[1]}\""
              template = template.gsub(find, content)
            else
              Wavy::Parsers::Mixin.definedTemplates(template, path)

              template = parseTemplates(template, path)
            end
          end
        end

        return template
      end

    end

  end

end