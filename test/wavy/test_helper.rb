require 'wavy'

module Wavy

  module Tests

    PATH_RESULTS = 'test/wavy/results'
    PATH_EXAMPLES = 'test/wavy/examples'

    class Test::Unit::TestCase
      def absolute_path(file)
        File.expand_path("#{File.dirname(__FILE__)}/#{file}")
      end
    end

  end

end