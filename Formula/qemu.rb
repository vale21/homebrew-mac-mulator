class Qemu < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  url "https://github.com/qemu/qemu.git", using: :git, revision: "v9.2.2"
  version "v0.4.9"
  license "GPL-2.0-only"

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "vale21/mac-mulator/libangle"
  depends_on "vale21/mac-mulator/libepoxy-angle"
  depends_on "vale21/mac-mulator/virglrenderer"
  depends_on "vale21/mac-mulator/spice-server"
  depends_on "libpng"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "spice-protocol"
  depends_on "vde"
  depends_on "python@3.13"
  depends_on "sdl2"

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "test-image" do
    url "https://web.archive.org/web/20181007135558/https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  # waiting for upstreaming of https://github.com/akihikodaki/qemu/tree/macos
  # patch :p1 do
  #   url "https://raw.githubusercontent.com/vale21/homebrew-qemu-virgl/87072b7ccc07f5087bf0848fa8920f8b3f8d5a47/Patches/qemu-v05.diff"
  #   sha256 "6d27699ba454b5ecb7411822a745b89dce3dea5fccabfb56c84ad698f3222dd4"
  # end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-curses
      --enable-libssh
      --enable-vde
      --enable-spice
      --enable-virglrenderer
      --enable-sdl
      --enable-gtk
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --extra-cflags=-I#{Formula["libangle"].opt_prefix}/include
      --extra-cflags=-I#{Formula["libepoxy-angle"].opt_prefix}/include
      --extra-cflags=-I#{Formula["virglrenderer"].opt_prefix}/include
      --extra-cflags=-I#{Formula["spice-protocol"].opt_prefix}/include/spice-1
      --extra-cflags=-I#{Formula["sdl2"].opt_prefix}/include
      --extra-ldflags=-L#{Formula["libangle"].opt_prefix}/lib
      --extra-ldflags=-L#{Formula["libepoxy-angle"].opt_prefix}/lib
      --extra-ldflags=-L#{Formula["virglrenderer"].opt_prefix}/lib
      --extra-ldflags=-L#{Formula["spice-protocol"].opt_prefix}/lib
      --extra-ldflags=-L#{Formula["sdl2"].opt_prefix}/lib
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    args << "--enable-cocoa" if OS.mac?

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    expected = "QEMU Project"
    assert_match expected, shell_output("#{bin}/qemu-system-aarch64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-alpha --version")
    assert_match expected, shell_output("#{bin}/qemu-system-arm --version")
    assert_match expected, shell_output("#{bin}/qemu-system-cris --version")
    assert_match expected, shell_output("#{bin}/qemu-system-hppa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-i386 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-m68k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblaze --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblazeel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64el --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mipsel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-nios2 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-or1k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv32 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-rx --version")
    assert_match expected, shell_output("#{bin}/qemu-system-s390x --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4eb --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-tricore --version")
    assert_match expected, shell_output("#{bin}/qemu-system-x86_64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensaeb --version")
    resource("test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")
  end
end
