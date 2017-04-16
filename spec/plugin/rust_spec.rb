require 'spec_helper'

describe "rust" do
  pending "Broken on TravisCI due to old Vim version"

  let(:filename) { 'test.rs' }

  specify "match clauses" do
    set_file_contents <<-EOF
      match one {
          Ok(two) => some_expression(three),
      }
    EOF

    vim.search('Ok')
    split

    assert_file_contents <<-EOF
      match one {
          Ok(two) => {
              some_expression(three)
          },
      }
    EOF

    join

    assert_file_contents <<-EOF
      match one {
          Ok(two) => some_expression(three),
      }
    EOF
  end

  specify "structs" do
    set_file_contents <<-EOF
      SomeStruct { foo: bar, bar: baz }
    EOF

    vim.search('foo')
    split

    assert_file_contents <<-EOF
      SomeStruct {
          foo: bar,
          bar: baz
      }
    EOF

    join

    assert_file_contents <<-EOF
      SomeStruct { foo: bar, bar: baz }
    EOF
  end

  specify "structs (trailing comma)" do
    set_file_contents <<-EOF
      SomeStruct { foo: bar, bar: baz }
    EOF

    vim.command('let b:splitjoin_trailing_comma = 1')
    vim.search('foo')
    split

    assert_file_contents <<-EOF
      SomeStruct {
          foo: bar,
          bar: baz,
      }
    EOF

    join

    assert_file_contents <<-EOF
      SomeStruct { foo: bar, bar: baz }
    EOF
  end
end
