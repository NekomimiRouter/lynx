# lynx

[![CI Tests](https://github.com/NekomimiRouter/lynx/actions/workflows/test.yml/badge.svg)](https://github.com/NekomimiRouter/lynx/actions/workflows/test.yml)

Lynx is a self-contained DSL engine based on [mruby](https://github.com/mruby/mruby) and still in development.

To make it on-the-go(without using host's glibc), we statically link the binary against [musl-libc](https://www.musl-libc.org/) and generate a single executable(Linux ELF)

The project has two parts:

[mruby-lynx](https://github.com/NekomimiRouter/mruby-lynx) is the Ruby part where the DSL is constructed.

[lynx](https://github.com/NekomimiRouter/lynx) is the C part, mainly to read files and evaluate them. And we put other native runtime dependencies in this repo because we want to get a more fine-grained control of the build and test process.

**Notice**: If you want to port mruby-lynx, take care of missing dependencies.

Other mruby gems could be found on [mruby/mgem-list](https://github.com/mruby/mgem-list), we recommend you to read some of them.


## How to start

### Install musl toolchain

On Debian 11 or Ubuntu 20.04

```
sudo apt install build-essential musl-dev musl-tools
```

On Arch Linux

```
sudo pacman -S base-devel musl --needed
```

### Install Ruby Gems

```
bundle install
```

### Use Rake to build, test and clean up

```
# Show all commands
$ rake -AT

rake cleanroom:build   # Clobber and build

rake libressl:clean    # Remove libressl build files
rake libressl:clobber  # Remove libressl source and build files
rake libressl:libssl   # Build libssl.a libtls.a
rake libressl:source   # Fetch libressl source from GitHub

rake lynx:clean        # Remove lynx binary
rake lynx:compile      # Generate lynx binary which is statically linked against musl

rake mruby:clean       # Remove mruby build files
rake mruby:clobber     # Remove mruby source and build files
rake mruby:config      # Configure mruby
rake mruby:libmruby    # Build libmruby.a
rake mruby:source      # Fetch mruby source from GitHub

rake run:build         # Build release
rake run:clean         # Remove build files
rake run:clobber       # Remove build files and source files
rake run:test          # Run tests

```

For lynx, we have the following build process:

1. Fetch mruby source from GitHub into `./build/mruby`
2. Install `./build_config/musl_linux_amd64.rb` to `./build/mruby/build`
3. Fetch other native libraries(source) into `./build`
4. Configure and build all libs, make sure everything is statically linked against musl-libc
5. Invoke Rake tasks defined by mruby to generate `libmruby.a`, it will also fetch `mruby-lynx` from GitHub
6. Compile the CLI `src/main.c` and statically link it against `libmruby.a` and other archives(static libs)
7. Finally get `./build/lynx`, an ELF for Linux, stripped and statically linked

To build and test:

```
rake
```

To remove all temporary files then re-build:

```
rake run:clobber
rake run:build
```

or

```
rake cleanroom:build
```

## For developers

Check out `build_config/*.rb` and `./Rakefile` first.


### Test

Lynx use two ways to test:
1. mruby binary test when building `libmruby.a`
2. integration test, use `open3` to spawn a lynx process, evaluating scripts and capturing outputs

### mruby Documentation

- [mruby.org](http://mruby.org/docs/)
