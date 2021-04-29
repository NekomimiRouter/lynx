# frozen_string_literal: true

require 'test_helper'

class InitLynxTest < Minitest::Test
  def test_init_lynx
    # Assert system return 0
    ret0 = system("#{LYNX_EXEC} #{LYNX_SCRIPTS}/version.rb")
    assert_equal(true, ret0)
  end
end
