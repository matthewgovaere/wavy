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

        if File.directory?(@view)
          template_dir = @view
          
          Dir.glob(template_dir + "/**/*.wavy") do |template|
            file_path = File.expand_path(template)
            full_path = template.dup
            full_path.slice! template_dir

            filename = File.basename(template)

            template = FILE_IMPORTER.load(template)
            render(template, full_path, file_path)
          end
        else
          filename = File.basename(@view)
          template = FILE_IMPORTER.load(@view)
          render(template, filename, @view)
        end

      rescue Exception => e
        puts e.message
      end
    end

    # Saves parsed template.
    #
    # @param (String) view Content of the view
    def render(view, filename, path)
      output = Wavy::Models::Template.new(view, path).parse

      if @save != false
        filename = filename.gsub("#{FILE_SUFFIX}", "")
        path = File.expand_path(@save)

        if filename[0] == "/"
          filename[0] = "" 
        end

        if path[-1,1] == "/"
          path = path + filename
        else
          path = path + "/" + filename
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
      else
        puts output
      end
    end

  end

end