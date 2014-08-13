require 'wavy/version'
require 'wavy/help'

module Wavy

  class << self

  end

  # Compile specified view(s)
  #
  # @param (String) config Main configuration file
  # @param (String) view Template to compile
  # @param (Boolean|String) Path to save output
  def self.compile(config, view, save = false)
    core = Core.new(config, view, save).compile
  end

  # Execute compile method via bash
  #
  # @param (ARGV) args Arguments
  def self.execute(args)
    begin
      if args[0]
        case args[0]
        when "--help", "-h"
          puts "#{WAVY_HELP_OUTPUT}"
        when "--version", "-v"
          puts Wavy::Version.get
        else
          config = args[0]

          if args[1] && args[2]
            view = args[1]
            save = args[2]
          else
            #raise 'Missing template.'
            view = false
            if args[1]
              save = args[1]
            else
              save = false
            end
          end

          compile(config, view, save)
        end
      else
        raise 'Missing main configuration file.'
      end
    rescue Exception => e
      puts e.message
      abort
    end
  end

end

require 'wavy/core'