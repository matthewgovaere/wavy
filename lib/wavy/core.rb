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
    String @filename

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
      @filename = File.basename(@view)
    end

    # Reads configuration and view files. Begins parsing.
    def compile()
      begin
        @config = FILE_IMPORTER.load(@config, true)
        Wavy::Parsers::Import.load(@config, @config_root)
        Wavy::Parsers::Import.extract
        
        @view = FILE_IMPORTER.load(@view)
        render(@view)
      rescue Exception => e
        puts e.message
      end
    end

    # Saves parsed template.
    #
    # @param (String) view Content of the view
    def render(view)
      output = Wavy::Models::Template.new(view).parse

      if @save != false
        filename = @filename.gsub("#{FILE_SUFFIX}", "")
        path = File.expand_path(@save)
        path = path + "/" + filename

        begin
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