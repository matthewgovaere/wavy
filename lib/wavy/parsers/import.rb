module Wavy

  module Parsers

    class Import

      # Creates a new Core
      #
      # @param (String) content Content of the file
      # @param (String) root Root path of the file
      def self.load(content, root)
        pattern = /^(@import)\s\"(.*)\"/
        matches = content.scan(pattern)
        
        Wavy::Parsers::Export.load(content, root)

        if matches.length > 0
          matches.each do |match|
            file_path = match[1]
            path = root + "/" + file_path + FILE_SUFFIX

            file_content = FILE_IMPORTER.load(path)
            import_node = Wavy::Nodes::Import.new(path, file_content)

            current_root = File.expand_path(File.dirname(path))

            self.load(file_content, current_root)

            Wavy::Models::Imports.add(path, import_node)
          end
        end
      end

      # Extracts all user defintions
      def self.extract()
        files = Wavy::Models::Imports.get

        files.each do |key, value|
          Wavy::Parsers::Mixin.definedFunctions(value.content)
          #Wavy::Parsers::Mixin.definedTemplates(value.content)
        end
      end

    end

  end

end