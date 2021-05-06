# frozen_string_literal: true

MRuby::Build.new do |conf|
  conf.gembox 'full-core'

  conf.gem :mgem => 'mruby-sqlite'
  conf.gem :mgem => 'mruby-httpsclient'
  # TODO: Add a usable http client

  conf.gem mgem: 'mruby-tls' do |g|
    g.cc.include_paths << '/tmp/libressl/usr/local/include'
    g.linker.library_paths << '/tmp/libressl/usr/local/lib'
  end

  # conf.gem github: 'nekomimirouter/mruby-lynx', branch: 'main'
  conf.gem '/home/kowalski/development/lynx_kowalski_dev/mruby-lynx' # for development

  conf.cc do |cc|
    cc.command = 'musl-gcc'
  end

  conf.linker do |linker|
    linker.command = 'musl-gcc'
  end

  conf.enable_bintest
  conf.enable_test
end
