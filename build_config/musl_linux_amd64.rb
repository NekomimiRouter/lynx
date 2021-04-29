# frozen_string_literal: true

MRuby::Build.new do |conf|
  conf.gembox 'full-core'
  conf.gem github: 'nekomimirouter/mruby-lynx', branch: 'main'
  # conf.gem '/absolute/path/to/local/mruby-lynx' # for development

  conf.cc do |cc|
    cc.command = 'musl-gcc'
  end

  conf.linker do |linker|
    linker.command = 'musl-gcc'
  end

  conf.enable_bintest
  conf.enable_test
end
