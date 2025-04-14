# frozen_string_literal: true

# Formula to install spice server
class SpiceServer < Formula
  desc 'Spice-Server'
  homepage 'https://www.spice-space.org/'
  url 'https://gitlab.freedesktop.org/spice/spice/uploads/29ef6b318d554e835a02e2141f888437/spice-0.15.2.tar.bz2'
  sha256 '6d9eb6117f03917471c4bc10004abecff48a79fb85eb85a1c45f023377015b81'
  head 'https://gitlab.freedesktop.org/spice/spice.git', branch: 'master'
  version 'v0.15.2'
  license 'GPL-2.0-only'

  bottle do
    root_url 'https://github.com/vale21/homebrew-mac-mulator/releases/download/v1.0.0'
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: '6b127cdd19756ef1f94d70a9c51726840dd7a076543fbd665fde46b33237fc51'
    sha256 cellar: :any, arm64_sonoma: '03ea81c20e5687f650b92b675ba6ded525d91dcb33a9e21573568498d7404a44'
    sha256 cellar: :any, arm64_ventura: 'e54032995490ee9dbb5d086aa9bd3767decbe2dfb136b182117ec19b51b3a547'
    sha256 cellar: :any, sequoia: 'b9575830333e41ed9dc1442275c40ae83189e2ac12eeb058365953657a9d0d26'
    sha256 cellar: :any, sonoma: 'd5c813960af63690d318da9d8e0b585e49ff0135df2ae2055455c83253372c5c'
    sha256 cellar: :any, ventura: 'a53cba63e5921a7322fb9716baf209e1b8bd81a2568e43884f3df69a95430389'
  end

  depends_on 'libtool' => :build
  depends_on 'meson' => :build
  depends_on 'ninja' => :build
  depends_on 'pkg-config' => :build
  depends_on 'spice-protocol' => :build

  depends_on 'capstone'
  depends_on 'dtc'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'jpeg-turbo'
  depends_on 'libpng'
  depends_on 'libslirp'
  depends_on 'libssh'
  depends_on 'libusb'
  depends_on 'lzo'
  depends_on 'ncurses'
  depends_on 'nettle'
  depends_on 'pixman'
  depends_on 'snappy'
  depends_on 'vde'
  depends_on 'zstd'

  depends_on 'opus'

  uses_from_macos 'bison' => :build
  uses_from_macos 'flex' => :build

  on_linux do
    depends_on 'attr'
    depends_on 'gtk+3'
    depends_on 'libcap-ng'
  end

  fails_with gcc: '5'

  def install
    ENV['LIBTOOL'] = 'glibtool'

    args = %W[
      --prefix=#{prefix}
    ]

    system './configure', *args
    system 'make', 'install'
  end
end
