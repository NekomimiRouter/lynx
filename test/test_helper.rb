# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# Set /path/to/lynx/executable
LYNX_EXEC = './build/lynx'

LYNX_SCRIPTS = './test/lynx_scripts'
