module Wavy
  module Tests
    module Templates

      class Imports < Test::Unit::TestCase

        def get(template, expected)
          template_path = absolute_path('/examples/templates/' + template)
          root = File.expand_path(File.dirname(template_path))

          content = Wavy::Utils::FileSys.load(template_path)
          result = Wavy::Parsers::Mixin.parse(content, template_path)

          expected = File.expand_path(PATH_RESULTS + '/' + expected)
          expected = Wavy::Utils::FileSys.load(expected)

          return {
            'expected' => expected,
            'result' => result
          }
        end

        def test_template
          template = 'import.html.wavy'
          expected = 'basic.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_template_nested
          template = 'nested/nested.html.wavy'
          expected = 'imported/nested.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_template_nested_parent
          template = 'nested/nested_parent.html.wavy'
          expected = 'basic.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_partial
          template = 'import_partial.html.wavy'
          expected = 'imported/partial.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_partial_html_suffix
          template = 'import_partial_html.html.wavy'
          expected = 'imported/partial.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_partial_no_suffix
          template = 'import_partial_no_suffix.html.wavy'
          expected = 'imported/partial.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_partial_nested
          template = 'import_partial_nested.html.wavy'
          expected = 'imported/partial_nested.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_partial_nested_sub
          template = 'import_partial_nested_sub.html.wavy'
          expected = 'imported/partial_nested_sub.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_partial_nested_with_sub
          template = 'import_partial_nested_with_sub.html.wavy'
          expected = 'imported/partial_nested_with_sub.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

        def test_multiple
          template = 'import_multiple.html.wavy'
          expected = 'imported/multiple.html'

          check = get(template, expected)
          assert_equal check['expected'], check['result']
        end

      end

    end
  end
end