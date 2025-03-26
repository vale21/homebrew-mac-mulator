class Libangle < Formula
  desc "Conformant OpenGL ES implementation for Windows, Mac, Linux, iOS and Android"
  homepage "https://github.com/google/angle"
  url "https://github.com/utmapp/WebKit.git", using: :git, revision: "b5f22a32a49682059749b2cccac06231a20c1387"
  version "20211212.1"
  license "BSD-3-Clause"

  # bottle do
  #   root_url "https://github.com/knazarov/homebrew-qemu-virgl/releases/download/libangle-20211212.1"
  #   sha256 cellar: :any, arm64_big_sur: "6e776fc996fa02df211ee7e79512d4996558447bde65a63d2c7578ed1f63f660"
  #   sha256 cellar: :any, big_sur: "1c201f77bb6d877f2404ec761e47e13b97a3d61dff7ddfc484caa3deae4e5c1b"
  # end

  # depends_on "meson" => :build
  # depends_on "ninja" => :build

  resource "depot_tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git", revision: "dc86a4b9044f9243886ca0da0c1753820ac51f45"
  end

  def install
    mkdir "build" do
      # OLD_PATH=$PATH
      # export PATH="$(realpath "$BUILD_DIR/depot_tools.git"):$OLD_PATH"
      # pwd="$(pwd)"
      system cd "$BUILD_DIR/WebKit.git/Source/ThirdParty/ANGLE"
      system xcodebuild archive -archivePath "ANGLE" \
                                          -scheme "ANGLE" \
                                          -sdk $SDK \
                                          -arch $ARCH \
                                          -configuration Release \
                                          WEBCORE_LIBRARY_DIR="/usr/local/lib" \
                                          NORMAL_UMBRELLA_FRAMEWORKS_DIR="" \
                                          CODE_SIGNING_ALLOWED=NO \
                                          MACOSX_DEPLOYMENT_TARGET="11.0" \
                                          XROS_DEPLOYMENT_TARGET="1.0"
      system rsync -a "ANGLE.xcarchive/Products/usr/local/lib/" "$PREFIX/lib"
      system rsync -a "include/" "$PREFIX/include"
      # cd "$pwd"
      # export PATH=$OLD_PATH
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test libangle`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "true"
  end
end
