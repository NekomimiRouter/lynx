# frozen_string_literal: true

require 'test_helper'

class Sqlite3DriverTest < Minitest::Test
  def setup
    clean_dir('./tmp')
  end

  def test_sqlite3_driver
    result = lynx_run('sqlite3.rb')
    assert_equal(0, result[:exit])
  end
end
