# frozen_string_literal: true

MRuby::Build.new do |conf|
  conf.gembox 'full-core'

  conf.gem mgem: 'mruby-json'
  conf.gem mgem: 'mruby-sqlite'
  conf.gem mgem: 'mruby-httpsclient'
  # TODO: Add a usable http client

  conf.gem mgem: 'mruby-tls' do |g|
    g.cc.include_paths << '/usr/local/opt/libressl/include'
    g.linker.library_paths << '/usr/local/opt/libressl/lib'
  end

  conf.gem github: 'nekomimirouter/mruby-lynx', branch: 'main'
  # conf.gem '/Users/guochunzhong/git/oss/mruby-lynx' # for development

  conf.cc do |cc|
    cc.command = 'cc'
  end

  conf.linker do |linker|
    linker.command = 'cc'
  end

  # Turn on `enable_debug` for better debugging
  conf.enable_debug
  conf.enable_bintest
  conf.enable_test
end
