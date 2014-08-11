module Wavy

  module Utils

    class FileSys

      # Check and load file
      #
      # @param (String) name File path
      # @param (Boolean) partial_check Also check for "_" on file
      def self.load(name, partial_check = true)
        if File.exists?(name)
          open(name).read
        else
          if partial_check
            load_partial(name)
          else
            raise 'File not found.'
          end
        end
      end

      # Check if a file with "_" exists
      #
      # @param (String) name File path
      def self.load_partial(name)
        a = name.split("/")
        new_name = "_" + a[-1]
        a = a.first a.size - 1

        if a.length > 1
          new_name = a.join("/") + "/" + new_name
        end

        load(new_name, false)
      end

      def guess_indent(file)
        i = 0
        file.each_line.with_index {|line, i|
          break if i > 3
          match = /^\s+/.match(line)
          next unless match
          return {
            :tab? => line.start_with?("\t"),
            :indent => match[0].size
          }
        }
        return { # returns default settings
          :tab? => true,
          :indent => 4
        }
      end

    end

  end
end