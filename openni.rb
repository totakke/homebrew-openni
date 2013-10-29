require 'formula'

class Openni < Formula
  homepage 'http://www.openni.org/'
  url 'https://github.com/OpenNI/OpenNI/archive/Stable-1.5.2.23.tar.gz'
  version 'stable-1.5.2.23'
  sha1 '1127cd9d82062b1a1ef68d25e39b4b65ac399c79'

  head 'https://github.com/OpenNI/OpenNI.git'

  devel do
    url 'https://github.com/OpenNI/OpenNI/archive/Unstable-1.5.4.0.tar.gz'
    version 'unstable-1.5.4.0'
    sha1 '69eb24999b70c46e0befd5eff4a9c9a70d218f41'
  end

  depends_on :automake
  depends_on :libtool
  depends_on 'libusb' => 'universal'
  depends_on 'doxygen' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?

    ENV.cxx += ' -stdlib=libstdc++' if ENV.compiler == :clang && MacOS.version >= :mavericks

    # Fix build files
    inreplace 'Source/OpenNI/XnOpenNI.cpp', '/var/lib/ni/', "#{var}/lib/ni/"
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build OpenNI
    cd 'Platform/Linux/CreateRedist'
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    redist_dir = Dir.glob('../Redist/OpenNI-Bin-Dev-MacOSX-v*')[0]
    cd redist_dir

    # Install bins
    bin.install Dir['Bin/ni*']

    # Install libs
    lib.install Dir['Lib/*']

    # Install includes
    mkpath "#{include}/ni"
    cp_r Dir['Include/*'], "#{include}/ni"

    # Install jar files
    jar_dir = "#{share}/java"
    mkpath jar_dir
    cp_r Dir['Jar/*'], jar_dir

    # Install samples
    sample_dir = "#{prefix}/sample"
    mkpath sample_dir
    cp_r Dir['Samples/*'], sample_dir

    # Install docs
    doc.install Dir['Documentation']

    mkpath "#{var}/lib/ni"
    system "#{bin}/niReg #{lib}/libnimMockNodes.dylib"
    system "#{bin}/niReg #{lib}/libnimCodecs.dylib"
    system "#{bin}/niReg #{lib}/libnimRecorder.dylib"
  end
end
