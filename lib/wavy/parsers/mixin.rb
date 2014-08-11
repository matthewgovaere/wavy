module Wavy

  module Parsers

    class Mixin

      # Parses all function and template mixins
      #
      # @param (String) data Content
      # @param (String|Boolean) path Template path
      #
      # @return (String) data Parsed content
      def self.parse(template, path = false)
        template = parseTemplates(template, path)

        return template
      end

      # Finds all included mixin functions.
      #
      # @param (String) data Content
      # @param (String) path Template path
      #
      # @return (String) data Parsed content
      def self.parseTemplates(template, path)
        pattern = /(@import)\s\"(.*)\"/

        indent = ""
        template_new = ""

        saved_templates = Wavy::Models::Mixins.getTemplates

        template.each_line.with_index do |line, i|
          matches = line.scan(pattern)

          line = parseFunctions(line)

          if matches.length > 0
            matches.each do |match|
              if(saved_templates["template-"+match[1]])
                imported_file = saved_templates["template-"+match[1]]
              else
                Wavy::Parsers::Mixin.definedTemplate(line, path)
                saved_templates = Wavy::Models::Mixins.getTemplates

                imported_file = saved_templates["template-"+match[1]]
              end

              content = imported_file.content

              find = "@import \"#{match[1]}\""

              new_content = ""

              current_indent = indent.dup
              current_indent << line.slice(0..(line.index(find)))
              current_indent[-1] = ""
              content = parseFunctions(content)
              content.each_line.with_index do |content_line, ii|
                if i > 0 && ii > 0
                  new_content << current_indent
                end

                new_content << content_line
              end

              new_line = current_indent
              new_line << new_content
              new_line << "\n"

              line = new_line
            end
          end

          template_new << line
        end

        return template_new
      end

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
      # @param (String) content Content
      # @param (String|Boolean) path Template path
      def self.definedTemplate(content, path = false)
        pattern = /(@import)\s\"(.*)\"/
        matches = content.scan(pattern)

        if matches.length > 0
          matches.each do |match|
            file = match[1]

            name = "template-" + file

            if path != false
              base_dir = File.expand_path(File.dirname(path))
              file_base_dir = File.expand_path(path)
              full_filename = base_dir + "/" + file

              # Check if full filename was included
              if File.file?(full_filename)

                content = FILE_IMPORTER.load(base_dir + "/" + file)
                content = parse(content, path)
                mixin_node = Wavy::Nodes::Mixin.new(name, content, false)

                Wavy::Models::Mixins.addTemplate(name, mixin_node)
              else
                imported_path_file = File.basename(file)

                if imported_path_file[0] == "_"
                  imported_path_file[0] = ""
                else
                  imported_path_file = file
                end
  
                file_pattern = /(#{imported_path_file})\..*/
                file_dir = file.scan(/(.*)\//)
                file_contains_paths = file.include? '/'

                if file_dir[0] || file_contains_paths == false
                  if file_dir[0]
                    dir_check_path = base_dir + "/" + file_dir[0][0] + "/*"
                  else
                    dir_check_path = base_dir + "/*"
                  end

                  directory_check = Dir.glob(dir_check_path)

                  if directory_check.length > 0

                    Dir.glob(dir_check_path) do |file_path|
                      filename = File.basename(file_path)
                      
                      if filename[0] == "_"
                        filename[0] = ""

                        check_file_path = File.dirname(file_path) + "/" + filename
                      else
                        check_file_path = File.dirname(file_path) + "/" + filename
                      end

                      file_matches = check_file_path.scan(file_pattern)

                      if file_matches.length > 0
                        file_matches.each do |file_match|
                          file_match = file_match[0]

                          content = FILE_IMPORTER.load(file_path)
                          content = parseTemplates(content, file_path)

                          mixin_node = Wavy::Nodes::Mixin.new(name, content, false)

                          Wavy::Models::Mixins.addTemplate(name, mixin_node)
                        end
                      end
                    end
                  else
                    raise "Could not find imported file A: " + file + "\n   From: " + path
                  end
                else
                  raise "Could not find imported file B: " + path
                end
              end
            end
          end
        end
      end

      # Finds all included mixin functions.
      #
      # @param (String) template Content
      #
      # @return (String) template Parsed content
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
              content = parseFunctions(content)

              # Find mixin string to replace
              find = "@include #{match[1]}(#{match[2]})"

              indent = ""
              new_template = ""
              new_content = ""

              template.each_line.with_index do |line, i|
                matches = line.scan(find)

                if matches.length > 0
                  current_indent = indent.dup
                  current_indent << line.slice(0..(line.index(find)))
                  current_indent[-1] = ""

                  line.delete!("\n")

                  content.each_line.with_index do |content_line, ii|

                    if ii > 1
                      new_content << current_indent
                    end

                    if ii > 0
                      new_content << content_line
                    end
                  end

                  line = line.gsub(find, new_content)
                end

                new_template << line
              end

              template = new_template
            end
          end
        end

        return template
      end

    end

  end

end