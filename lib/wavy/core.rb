require 'fileutils'

require 'wavy/utils'
require 'wavy/nodes'
require 'wavy/models'
require 'wavy/parsers'

module Wavy

  # File suffix
  FILE_SUFFIX = ".wavy"

  # Find and read files
  FILE_IMPORTER = Wavy::Utils::FileSys

  class Core

    String @root_path

    String @view
    String @config

    # Creates a new Core
    #
    # @param (String) config Main configuration file
    # @param (String) view Template to compile
    # @param (Boolean|String) Path to save output
    def initialize(config, view, save)
      @view = view
      @config = config
      @save = save
      @config_root = File.expand_path(File.dirname(@config))
    end

    # Reads configuration and view files. Begins parsing.
    def compile()
      begin

        @config = FILE_IMPORTER.load(@config, true)

        Wavy::Parsers::Import.load(@config, @config_root)
        Wavy::Parsers::Import.extract

        if @view == false
          exports = Wavy::Models::Exports.get

          exports.each do |key, export|

            if File.directory?(export.path)
              template_dir = export.path

              Dir.glob(template_dir + "/**/*.wavy") do |template|
                filename = File.basename(template)

                if filename[0] != "_"

                  file_path = File.expand_path(template)
                  full_path = template.dup
                  full_path.slice! template_dir

                  filename = File.basename(template)

                  template = FILE_IMPORTER.load(template)
                  render(template, full_path, file_path)
                end
              end
            else
              filename = File.basename(export.path)
              template = FILE_IMPORTER.load(export.path)
              render(template, filename, export.path)
            end
          end
        else
          if File.directory?(@view)
            template_dir = @view

            Dir.glob(template_dir + "/**/*.wavy") do |template|
              filename = File.basename(template)

              if filename[0] != "_"

                file_path = File.expand_path(template)
                full_path = template.dup
                full_path.slice! template_dir

                filename = File.basename(template)

                template = FILE_IMPORTER.load(template)
                render(template, full_path, file_path)
              end
            end
          else
            filename = File.basename(@view)
            template = FILE_IMPORTER.load(@view)
            render(template, filename, @view)
          end
        end

      rescue Exception => e
        puts e.message
      end
    end

    # Saves parsed template.
    #
    # @param (String) view Content of the template
    # @param (String) filename The path and filename of the template
    # @param (String) path Path to where the templates should be saved
    def render(view, filename, path)
      output = Wavy::Models::Template.new(view, path).parse

      if @save != false
        file_path = filename.gsub("#{FILE_SUFFIX}", "")
        file_name = File.basename(file_path)

        if file_name[0] != "_"
          path = File.expand_path(@save)

          if file_path[0] == "/"
            file_path[0] = "" 
          end

          if path[-1,1] == "/"
            path = path + file_path
          else
            path = path + "/" + file_path
          end

          begin
            dirname = File.dirname(path)

            unless File.directory?(dirname)
              FileUtils.mkdir_p(dirname)
            end

            file = File.open(path, "w")
            file.write(output) 
          rescue IOError => e
            raise 'Could not save file.'
          ensure
            file.close unless file == nil
          end
        end
      else
        puts output
      end
    end

  end

end