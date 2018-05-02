class Nite < Formula
  desc "The most advance and robust 3D computer vision middleware"
  homepage "http://openni.ru/"
  url "http://openni.ru/wp-content/uploads/2012/12/NITE-Bin-MacOSX-v1.5.2.21.tar.zip"
  version "1.5.2.21"
  sha256 "1d67ab0e69ef3417f8e02f0c4aac0fbbb4eb3bdce267e8617097b6f6da8a5641"

  option :universal

  depends_on "openni" => build.universal? ? ["universal"] : []

  def install
    ENV.universal_binary if build.universal?

    # commented to fix the following error when installing: "Error: Calling Formula#cxxstdlib_check in install is disabled!"
    # cxxstdlib_check :skip

    system "tar", "zxvf", "NITE-Bin-MacOSX-v1.5.2.21.tar.bz2"
    cd "NITE-Bin-Dev-MacOSX-v1.5.2.21"

    ohai "Installing..."

    inreplace "Samples/Boxes.java/Manifest.txt", "/usr/share/java", "#{share}/java"
    inreplace "Samples/Build/Common/CommonJavaMakefile", "/usr/share/java", "#{share}/java"

    # Install libs
    lib.install Dir["Bin/libXnVNite*.dylib"]
    lib.install Dir["Bin/libXnVCNITE*.dylib"]
    lib.install Dir["Bin/libXnVNITE.jni*.dylib"]

    # Install includes
    (include+"nite").install Dir["Include/*"]

    # Install jar
    (share+"java").install "Bin/com.primesense.NITE.jar"

    # Install features modules
    Dir.glob("Features*").each do |fdir|
      cd fdir
      dst_fdir = "#{etc}/primesense/" + File.basename(fdir)
      mkpath dst_fdir
      cp_r Dir["Data/*"], dst_fdir, :remove_destination => true
      Dir.glob("Bin/lib*.dylib").each do |dlib|
        lib.install dlib
      end
      Dir.glob("Bin/XnVSceneServer*").each do |xvss|
        chmod 0755, xvss
        bin.install xvss
      end
      cd ".."
    end

    # Install hands modules
    Dir.glob("Hands*").each do |hdir|
      cd hdir
      dst_hdir = "#{etc}/primesense/" + File.basename(hdir)
      mkpath dst_hdir
      cp_r Dir["Data/*"], dst_hdir, :remove_destination => true
      Dir.glob("Bin/lib*.dylib").each do |dlib|
        lib.install dlib
      end
      cd ".."
    end

    # TODO: Install .NET

    # Run make
    system "make" if File.exist?("Makefile")

    (share+"nite/samples").install Dir["Samples/*"]
    (share+"nite").install "Data"
    doc.install "Documentation"
  end

  def post_install
    system "#{HOMEBREW_PREFIX}/bin/niReg", "#{lib}/libXnVFeatures_1_5_2.dylib", "#{etc}/primesense/Features_1_5_2"
    system "#{HOMEBREW_PREFIX}/bin/niReg", "#{lib}/libXnVHandGenerator_1_5_2.dylib", "#{etc}/primesense/Hands_1_5_2"

    system "#{HOMEBREW_PREFIX}/bin/niLicense", "PrimeSense", "0KOIk2JeIBYClPWVnMoRKn5cdY4="
  end

  def caveats; <<~EOS
    OpenNI formula is now provided by brewsci/science.
    Tap brewsci/science in advance.
      `brew tap brewsci/science`
    EOS
  end
end
