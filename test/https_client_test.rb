# frozen_string_literal: true

require 'test_helper'

class HttpsClientTest < Minitest::Test
  def test_https_client
    result = lynx_run('https_client.rb')
    assert_equal(0, result[:exit])
  end
end
