module Wavy
  module Tests
    module Configuration

      class Exports < Test::Unit::TestCase

        def test_single_template
          path = absolute_path('examples/config/basic_template_export.wavy')
          root = File.expand_path(File.dirname(path))

          content = Wavy::Utils::FileSys.load(path)
          Wavy::Parsers::Export.load(content, root)
          exports = Wavy::Models::Exports.get

          result = ''

          exports.each do |key, export|
            result = Wavy::Core.render(export.path)['template']
          end

          exact = File.expand_path(PATH_RESULTS + '/basic.html')
          exact = Wavy::Utils::FileSys.load(exact)

          assert_equal exact, result
        end

      end

    end
  end
end