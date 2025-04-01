class Virglrenderer < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://github.com/vale21/virglrenderer.git", revision: "v0.8.2-utm"
  version "v0.8.2-utm"
  license "MIT"

  bottle do
    root_url "https://github.com/vale21/homebrew-mac-mulator/releases/download/v1.0.0"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "fef4cc3956081b2481ea26ed42fdf9269cb4d3856c6c3ecfcc9f85d4d99575b3"
    sha256 cellar: :any, arm64_sonoma: "4abf8086fbfe1157c92411648d9f158875a25f6f1d349ad189b937ba98ae2536"
    sha256 cellar: :any, arm64_ventura: "e50117b4132020d2120d288d1587c8249144cbf859ffe8bedaedbc9e2f366885"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vale21/mac-mulator/libangle"
  depends_on "vale21/mac-mulator/libepoxy-angle"

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
