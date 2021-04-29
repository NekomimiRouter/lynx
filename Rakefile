# frozen_string_literal: true

# Set HTTPS Proxy for GitHub
HTTPS_PROXY = ENV['HTTPS_PROXY'] || ENV['https_proxy']

# Use musl toolchain
# Arch Linux: pacman -S musl
# Debian: apt install musl-dev musl-tools
CC = 'musl-gcc'

BUILD_DIR = 'build'
C_SOURCE = 'src/main.c'

MRUBY_SOURCE = "#{BUILD_DIR}/mruby"
MRUBY_INCLUDE = "#{MRUBY_SOURCE}/include"
MRUBY_BUILD = "#{MRUBY_SOURCE}/build"
LIB_MRUBY = "#{MRUBY_BUILD}/host/lib/libmruby.a"

EXECUTABLE = 'lynx'

namespace :lynx do
  desc 'Generate lynx binary which is statically linked against musl'
  task compile: 'mruby:libmruby' do
    sh "#{CC} -std=c99 -I#{MRUBY_INCLUDE} #{C_SOURCE} #{LIB_MRUBY} -lm -static -o #{BUILD_DIR}/#{EXECUTABLE}"
    sh "strip #{BUILD_DIR}/#{EXECUTABLE}"
    sh "file #{BUILD_DIR}/#{EXECUTABLE}"
  end

  desc 'Remove lynx binary'
  task :clean do
    sh "rm -rfv #{BUILD_DIR}/#{EXECUTABLE}"
  end
end

namespace :mruby do
  desc 'Build libmruby.a'
  task libmruby: :mruby_source do
    unless File.exist?(LIB_MRUBY.to_s)
      sh "cd #{BUILD_DIR}/mruby && https_proxy=#{HTTPS_PROXY} rake"
      sh "cd #{BUILD_DIR}/mruby && https_proxy=#{HTTPS_PROXY} rake test"
    end
  end

  desc 'Fetch mruby source from GitHub'
  task :mruby_source do
    unless File.exist?(MRUBY_SOURCE.to_s)
      sh "mkdir -p #{BUILD_DIR}"
      sh "https_proxy=#{HTTPS_PROXY} git clone https://github.com/mruby/mruby.git #{MRUBY_SOURCE}"
      sh "rm -fv  #{MRUBY_SOURCE}/build_config/*.rb"
      sh "cp build_config/musl_linux_amd64.rb  #{MRUBY_SOURCE}/build_config/default.rb"
    end
  end

  desc 'Remove mruby build files'
  task :clean do
    sh "rm -rfv #{MRUBY_BUILD}"
  end

  desc 'Remove mruby source and build files'
  task :clobber do
    sh "rm -rfv #{MRUBY_SOURCE}"
  end
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/lynx_scripts')
  t.verbose = true
end

task compile: 'lynx:compile'

task clean: %i[lynx:clean mruby:clean]
task :clobber do
  sh "rm -rfv #{BUILD_DIR}"
end

task default: %i[compile test]
