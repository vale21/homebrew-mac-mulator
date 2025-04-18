# frozen_string_literal: true

# Formula to install libangle (UTM variant)
class Libangle < Formula
  desc 'Conformant OpenGL ES implementation for Windows, Mac, Linux, iOS and Android'
  homepage 'https://github.com/google/angle'
  url 'https://github.com/utmapp/WebKit.git', using: :git, revision: 'rel/UTM/v4.5.0'
  version 'v4.5.0-utm'
  license 'BSD-3-Clause'

  bottle do
    root_url 'https://github.com/vale21/homebrew-mac-mulator/releases/download/v1.0.0'
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: '13b488d97f212c382416d9040fdedaee81552fd72c5fa218cacffe14a8e9d843'
    sha256 cellar: :any, arm64_sonoma: 'e6b9b731ec55f0fe4c2886fc29f590ba00aa71775e803d7ac2f714f9015fdec2'
    sha256 cellar: :any, arm64_ventura: '3171b6cb39248f178ba7d18665453caffdf0a922e1a0b152f71129d4566f1011'
    sha256 cellar: :any, sequoia: '963a82fdd76456b8b3ac77b6d5e40d72b396f10a3ecab44162546d8fae46af46'
    sha256 cellar: :any, sonoma: 'bea640b5bc1e46870a32b21457f788885e5ccc3010f761ff853d71cb8bae1488'
    sha256 cellar: :any, ventura: '341bcb5ec9b23f39c739833f6d778ba4299098c960424f7b9667b804385f5504'
  end

  depends_on 'rsync' => :build

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def install
    build_dir = buildpath
    depot_tools = build_dir / 'depot_tools'

    unless depot_tools.exist?
      system 'git', 'clone', 'https://chromium.googlesource.com/chromium/tools/depot_tools.git', depot_tools
    end

    ENV.prepend_path 'PATH', depot_tools.realpath
    ENV.delete_if { |k, _| k != 'PATH' }

    sdk = 'macosx'
    arch = if Hardware::CPU.intel?
             'x86_64'
           elsif Hardware::CPU.arm?
             'arm64'
           else
             raise 'Unsupported architecture'
           end

    system 'xcodebuild', 'archive', \
           '-archivePath', "ANGLE-#{arch}", \
           '-scheme', 'ANGLE', \
           '-sdk', sdk, \
           '-arch', arch, \
           '-configuration', 'Release', \
           'WEBCORE_LIBRARY_DIR=/usr/local/lib', \
           'NORMAL_UMBRELLA_FRAMEWORKS_DIR=', \
           'CODE_SIGNING_ALLOWED=NO', \
           'IPHONEOS_DEPLOYMENT_TARGET="14.0"' \
           'MACOSX_DEPLOYMENT_TARGET="11.0"' \
           'XROS_DEPLOYMENT_TARGET="1.0"'

    lib.install Dir["ANGLE-#{arch}.xcarchive/Products/usr/local/lib/*"]

    source_dir = buildpath / "ANGLE-#{arch}.xcarchive/Products/usr/local/include/ANGLE"

    # Headers
    egl_dir   = include / 'EGL'
    angle_dir = include / 'ANGLE'
    gles_dir  = include / 'GLES2'
    [egl_dir, angle_dir, gles_dir].each(&:mkpath)
    FileUtils.cp_r Dir[source_dir / '*'], egl_dir
    FileUtils.cp_r Dir[source_dir / '*'], angle_dir
    FileUtils.cp_r Dir[source_dir / '*'], gles_dir

    # Framework
    create_framework_wrapper(lib / 'libEGL.dylib', 'Egl', include / 'EGL')
    create_framework_wrapper(lib / 'libGLESv2.dylib', 'Glesv2', include / 'GLES2')
  end

  def create_framework_wrapper(dylib_path, framework_name, headers_source)
    require 'fileutils'
    framework = lib / "#{framework_name}.framework"
    framework.mkpath
    version_dir = framework / 'Versions/A'
    version_dir.mkpath

    FileUtils.cp dylib_path, version_dir / framework_name.to_s

    headers_dir = version_dir / 'Headers'
    headers_dir.mkpath
    FileUtils.cp_r Dir[headers_source / '*'], headers_dir

    ln_sf 'A', framework / 'Versions/Current'
    ln_sf 'Versions/Current/Headers', framework / 'Headers'
    ln_sf "Versions/Current/#{framework_name}", framework / framework_name.to_s
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  test do
    system 'true'
  end
end
