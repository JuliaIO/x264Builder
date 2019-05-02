# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "x264Builder"
version = v"2018.02.12-pre-noyasm"

# Collection of sources required to build x264Builder
sources = [
    "https://download.videolan.org/x264/snapshots/x264-snapshot-20180212-2245-stable.tar.bz2" =>
    "fa1069c4a6ec442687e33b118572c9dd893e82ebe2f10bbe21dc51996060a3cc",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd x264-snapshot-20180212-2245-stable/
./configure --prefix=$prefix --host=$target --enable-shared --disable-cli --disable-asm
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    # Windows
    Windows(:i686),
    Windows(:x86_64),

    # linux
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),

    # musl
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),

    # The BSD's
    FreeBSD(:x86_64),
    MacOS(:x86_64),
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libx264", :libx264)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

