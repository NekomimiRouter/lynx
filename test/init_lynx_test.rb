# frozen_string_literal: true

require 'test_helper'

class InitLynxTest < Minitest::Test
  def test_init_lynx
    # Assert system return 0
    result = lynx_run
    assert_equal(0, result[:exit])
  end
end
