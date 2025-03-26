class Virglrenderer < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://github.com/utmapp/virglrenderer.git", revision: "dc039d9ecd74fc671a85bfbe7c4e4bc552b7b855"
  version "20211212.1"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vale21/mac-mulator/libangle"
  depends_on "vale21/mac-mulator/libepoxy-angle"

  # waiting for upstreaming of https://github.com/akihikodaki/virglrenderer/tree/macos
  # patch :p1 do
  #   url "https://raw.githubusercontent.com/vale21/homebrew-qemu-virgl/d8e807a58717d551ecb73a6e721e49559cec1a3d/Patches/virglrenderer-v04.diff"
  #   sha256 "cb9e2ea4d73cd99375bd9fc9a008f4d7e53249a6259d63ff8f367a08c4fd8b9c"
  # end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dc_args=-I#{Formula["libepoxy-angle"].opt_prefix}/include",
             "-Dc_link_args=-L#{Formula["libepoxy-angle"].opt_prefix}/lib", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "true"
  end
end
