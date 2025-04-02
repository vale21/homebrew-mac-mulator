class LibepoxyAngle < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://github.com/vale21/libepoxy.git", using: :git, revision: "v1.5.8-utm"
  version "v1.5.8-utm"
  license "MIT"

  bottle do
    root_url "https://github.com/vale21/homebrew-mac-mulator/releases/download/v1.0.0"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "49b563fdbacaff23afa92ff67518cddff64f6c9db3768095ff1f31c7cef25b2b"
    sha256 cellar: :any, arm64_sonoma: "538a3995e75cfba549a50f7b208002dd3392da744acadbcd63b482c83f95ce91"
    sha256 cellar: :any, arm64_ventura: "fcd2ba1fce9b729bef8269ca73e620a0e8137f667e651b83d0d1f3ace4aab5e4"
    sha256 cellar: :any, sequoia: "033ea0b4706a7c9f14be0316c8a33e33cadf2984feb7f879653d60dcffc06516"
    sha256 cellar: :any, sonoma: "21b137eb7c36f28ee9bdbe08dab5111ce44b8bb88d47476a20b528061591c37e"
    sha256 cellar: :any, ventura: "d7d2b58d2ad0ad51a762c454cd25e3b286d26f57aa504986d833b44de9246d5a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "vale21/mac-mulator/libangle"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dc_args=-I#{Formula["libangle"].opt_prefix}/include",
             "-Dc_link_args=-L#{Formula["libangle"].opt_prefix}/lib", "-Degl=yes", "-Dx11=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      int main()
      {
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);

          glClear(GL_COLOR_BUFFER_BIT);
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lepoxy", "-framework", "OpenGL", "-o", "test"
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
