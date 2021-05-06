# frozen_string_literal: true

require 'test_helper'

class LynxCliTest < Minitest::Test
  def test_show_help
    result = lynx_run(options: '-h')
    assert_equal(0, result[:exit])
  end

  def test_can_load_valid_file
    result = lynx_run('version.rb')
    assert_equal(0, result[:exit])
  end

  def test_should_reject_bad_file
    result = lynx_run('not_ruby.rb')
    refute_equal(0, result[:exit])
  end

  def test_should_reject_nonexistent_file
    result = lynx_run('no_file_like_this.rb')
    refute_equal(0, result[:exit])
  end
end
