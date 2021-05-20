# frozen_string_literal: true
require 'os'

# Set HTTPS Proxy for GitHub
HTTPS_PROXY = ENV['HTTPS_PROXY'] || ENV['https_proxy']

# Use musl toolchain
# Arch Linux: pacman -S musl
# Debian: apt install musl-dev musl-tools
CC = if OS.mac?
       'cc'
     else
       'musl-gcc'
     end

BUILD_DIR = 'build'
C_SOURCE = 'src/main.c'

MRUBY_SOURCE = "#{BUILD_DIR}/mruby"

MRUBY_INCLUDE = "#{MRUBY_SOURCE}/include"
MRUBY_BUILD = "#{MRUBY_SOURCE}/build"

LIB_MRUBY = "#{MRUBY_BUILD}/host/lib/libmruby.a"

LIBRESSL_SOURCE = "#{BUILD_DIR}/libressl"
LIBRESSL_INSTALL = if OS.mac?
                     `brew --prefix libressl`.strip
                   else
                     '/tmp/libressl'
                   end
LIBRESSL_INCLUDE = if OS.mac?
                     "#{LIBRESSL_INSTALL}/include/"
                   else
                     "#{LIBRESSL_INSTALL}/usr/local/include/"
                   end
LIBRESSL_LIB = if OS.mac?
                 "#{LIBRESSL_INSTALL}/lib"
               else
                 "#{LIBRESSL_INSTALL}/usr/local/lib"
               end
LIB_TLS = "#{LIBRESSL_LIB}/libtls.a"
LIB_SSL = "#{LIBRESSL_LIB}/libssl.a"

MAKE_JOBS = OS.cpu_count

EXECUTABLE = 'lynx'

namespace :lynx do
  desc 'Generate lynx binary which is dynatmic linked to libressl for test only'
  task mac_compile: 'mruby:mac_libmruby' do
    sh "#{CC} -std=c99 -I#{MRUBY_INCLUDE} -I#{LIBRESSL_INCLUDE} #{C_SOURCE} #{LIB_MRUBY} #{LIB_SSL} #{LIB_TLS} -o #{BUILD_DIR}/#{EXECUTABLE}"
  end

  desc 'Generate lynx binary which is statically linked against musl'
  task compile: 'mruby:libmruby' do
    sh "#{CC} -std=c99 -I#{MRUBY_INCLUDE} -I#{LIBRESSL_INCLUDE} #{C_SOURCE} #{LIB_MRUBY} #{LIB_SSL} #{LIB_TLS} -lm -static -o #{BUILD_DIR}/#{EXECUTABLE}"
    sh "strip #{BUILD_DIR}/#{EXECUTABLE}"
    sh "file #{BUILD_DIR}/#{EXECUTABLE}"
  end

  desc 'Remove lynx binary'
  task :clean do
    sh "rm -rfv #{BUILD_DIR}/#{EXECUTABLE}"
  end
end

namespace :mruby do
  desc 'Build mac version of libmruby.a'
  task mac_libmruby: %i[mruby:mac_config] do
    unless File.exist?(LIB_MRUBY.to_s)
      sh "cd #{BUILD_DIR}/mruby && https_proxy=#{HTTPS_PROXY} rake"
      sh "cd #{BUILD_DIR}/mruby && https_proxy=#{HTTPS_PROXY} rake test"
    end
  end

  desc 'Build libmruby.a'
  task libmruby: %i[mruby:config libressl:libssl] do
    unless File.exist?(LIB_MRUBY.to_s)
      sh "cd #{BUILD_DIR}/mruby && https_proxy=#{HTTPS_PROXY} rake"
      sh "cd #{BUILD_DIR}/mruby && https_proxy=#{HTTPS_PROXY} rake test"
    end
  end

  desc 'Configure mruby'
  task config: :source do
    sh "rm -fv  #{MRUBY_SOURCE}/build_config/*.rb"
    sh "cp build_config/musl_linux_amd64.rb  #{MRUBY_SOURCE}/build_config/default.rb"
  end

  desc 'Configure mruby in mac'
  task mac_config: :source do
    sh "rm -fv  #{MRUBY_SOURCE}/build_config/*.rb"
    sh "cp build_config/macos_amd64.rb  #{MRUBY_SOURCE}/build_config/default.rb"
  end

  desc 'Fetch mruby source from GitHub'
  task :source do
    unless File.exist?(MRUBY_SOURCE.to_s)
      sh "mkdir -p #{BUILD_DIR}"
      sh "https_proxy=#{HTTPS_PROXY} git clone https://github.com/mruby/mruby.git #{MRUBY_SOURCE}"
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

namespace :libressl do
  desc 'Build libssl.a libtls.a'
  task libssl: :source do
    unless File.exist?(LIB_SSL) && File.exist?(LIB_TLS)
      sh "cd #{LIBRESSL_SOURCE} && make -j #{MAKE_JOBS}"
      absolute_install = File.expand_path(LIBRESSL_INSTALL)
      sh "mkdir -p #{absolute_install}"
      # Don't use default hook, we shall install the cert manually
      sh "cd #{LIBRESSL_SOURCE} && DESTDIR=#{absolute_install} make install -o install-exec-hook"
      sh "cp #{LIBRESSL_SOURCE}/cert.pem ."
    end
  end

  desc 'Fetch libressl source from GitHub'
  task :source do
    unless File.exist?(LIBRESSL_SOURCE.to_s)
      sh "mkdir -p #{BUILD_DIR}"
      sh "https_proxy=#{HTTPS_PROXY} git clone https://github.com/libressl-portable/portable.git #{LIBRESSL_SOURCE}"
      sh "cd #{LIBRESSL_SOURCE} && ./autogen.sh"
      sh "cd #{LIBRESSL_SOURCE} && CC=#{CC} ./configure --disable-shared --with-openssldir=. "
    end
  end

  desc 'Remove libressl build files'
  task :clean do
    sh "cd #{LIBRESSL_SOURCE} && make clean" unless OS.mac?
    sh "rm -rfv #{LIBRESSL_INSTALL}" unless OS.mac?
    sh "rm -rfv #{LIBRESSL_INSTALL}." unless OS.mac?
  end

  desc 'Remove libressl source and build files'
  task :clobber do
    sh "rm -rfv #{LIBRESSL_SOURCE}" unless OS.mac?
    sh "rm -rfv #{LIBRESSL_INSTALL}" unless OS.mac?
    sh "rm -rfv #{LIBRESSL_INSTALL}." unless OS.mac?
  end
end

namespace :cleanroom do
  desc 'Clobber and build'
  task build: %i[run:clobber run:build]
end

namespace :run do
  desc 'Build release'
  task build: (OS.mac? ? %i[lynx:mac_compile] : %i[lynx:compile])

  desc 'Remove build files'
  task clean: %i[lynx:clean mruby:clean libressl:clean]

  desc 'Remove build files and source files'
  task clobber: %i[libressl:clobber mruby:clobber] do
    sh "rm -rfv #{BUILD_DIR}"
  end

  require 'rake/testtask'
  Rake::TestTask.new(:test) do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb'].exclude('test/lynx_scripts')
    t.verbose = true
  end
end

task default: %i[run:build run:test]
