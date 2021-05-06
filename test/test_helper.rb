# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require 'open3'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# Simple wrappers for CLI
def lynx_run(script = nil, options: nil, lynx: './build/lynx', script_dir: './test/lynx_scripts')
  executable = File.expand_path(lynx)
  script = File.join(File.expand_path(script_dir), script) unless script.nil?

  result = {}
  cmd = [executable, options, script].compact.join(' ')
  result[:cmd] = cmd

  Open3.popen3(cmd) do |_stdin, stdout, stderr, thread|
    result[:stdout] = stdout.read
    result[:stderr] = stderr.read

    result[:pid] = thread[:pid].to_i
    result[:exit] = thread.value.to_i
  end

  result
end
