module Wavy

  module Parsers

    class Export

      # Creates a new Core
      #
      # @param (String) content Content of the file
      # @param (String) root Root path of the file
      def self.load(content, root)
        pattern = /^(@export)\s\"(.*)\"/
        matches = content.scan(pattern)

        if matches.length > 0
          matches.each do |match|
            file_path = match[1]
            path = root + "/" + file_path
            path = File.expand_path(path)
            #import_node = Wavy::Nodes::Export.new(path)
            #Wavy::Models::Exports.add(path, import_node)
            if File.directory?(path)
              template_dir = path

              Dir.glob(template_dir + "/**/*.wavy") do |template|
                filename = File.basename(template)

                if filename[0] != "_"
                  import_node = Wavy::Nodes::Export.new(template)
                  Wavy::Models::Exports.add(template, import_node)
                end
              end
            else
              import_node = Wavy::Nodes::Export.new(path)
              Wavy::Models::Exports.add(path, import_node)
            end
          end
        end
      end

      # Extracts all user defintions
      def self.extract()
        files = Wavy::Models::Imports.get

        files.each do |key, value|
          Wavy::Parsers::Mixin.definedConfigTemplate(value.content)
        end
      end

    end

  end

end