require 'package'

class Harfbuzz < Package
  description 'HarfBuzz is an OpenType text shaping engine.'
  homepage 'https://www.freedesktop.org/wiki/Software/HarfBuzz/'
  @_ver = '2.9.1'
  version @_ver
  license 'Old-MIT, ISC and icu'
  compatibility 'all'
  source_url "https://github.com/harfbuzz/harfbuzz/archive/#{@_ver}.tar.gz"
  compatibility 'all'
  source_url 'https://github.com/harfbuzz/harfbuzz.git'
  git_hashtag @_ver

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/harfbuzz/2.9.1_armv7l/harfbuzz-2.9.1-chromeos-armv7l.tpxz',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/harfbuzz/2.9.1_armv7l/harfbuzz-2.9.1-chromeos-armv7l.tpxz',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/harfbuzz/2.9.1_i686/harfbuzz-2.9.1-chromeos-i686.tar.xz',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/harfbuzz/2.9.1_x86_64/harfbuzz-2.9.1-chromeos-x86_64.tpxz'
  })
  binary_sha256({
    aarch64: 'f0bd45d8a15150c36fe81f438ac6d5ea46354ec7e5e04ed7a1983aadf7e5c4cd',
     armv7l: 'f0bd45d8a15150c36fe81f438ac6d5ea46354ec7e5e04ed7a1983aadf7e5c4cd',
       i686: '0265d4de7f8c5685a1cb302d24872f092cb97848e45fbb43975137069aa2fed7',
     x86_64: 'b853e2d9095141bea78409f2c32fdd72a0cc4b7c24cb0524f868d22ee941f684'
  })

  depends_on 'cairo' => :build
  depends_on 'chafa' => :build
  depends_on 'glib' => :build
  depends_on 'gobject_introspection'
  depends_on 'ragel' => :build
  depends_on 'freetype_sub'
  depends_on 'py3_six' => :build
  depends_on 'graphite' => :build

  def self.build
    system "meson #{CREW_MESON_OPTIONS} \
    --default-library=both \
    -Dintrospection=enabled \
    -Dbenchmark=disabled \
    -Dtests=disabled \
    -Dgraphite=enabled \
    -Ddocs=disabled \
    builddir"
    system 'meson configure builddir'
    system 'ninja -C builddir'
  end

  def self.install
    system "DESTDIR=#{CREW_DEST_DIR} ninja install -C builddir"
  end
end
