class SensorKinect < Formula
  desc "Kinect sensor module for OpenNI"
  homepage 'https://github.com/ruedigerH2/SensorKinect/'
  url 'https://github.com/ruedigerH2/SensorKinect.git', :revision => '97a258a4ae0f2e4c4565adec74f917847a3ab1dd'
  version '0.94'
  sha1 '97a258a4ae0f2e4c4565adec74f917847a3ab1dd'
  head 'https://github.com/ruedigerH2/SensorKinect.git'

  conflicts_with 'sensor'

  option :universal

  depends_on 'openni' => (build.universal?) ? ['universal'] : []

  def install
    ENV.universal_binary if build.universal?

    # Fix build files
    inreplace 'Source/Utils/XnSensorServer/SensorServer.cpp', "/var/log/primesense/XnSensorServer/", "#{var}/log/primesense/XnSensorServer/"
    inreplace 'Platform/Linux/Build/EngineLibMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/Build/Utils/EngineUtilMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/CreateRedist/RedistMaker', 'echo $((N_CORES*2))', 'echo $((1))'
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build SensorKinect
    cd 'Platform/Linux/CreateRedist'
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    cd Dir.glob('../Redist/Sensor-Bin-MacOSX-v*')[0]

    bin.install Dir['Bin/*']
    lib.install Dir['Lib/*']
    (etc+'primesense').install 'Config/GlobalDefaultsKinect.ini'
  end

  def post_install
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceSensorV2KM.dylib #{etc}/primesense"
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceFile.dylib #{etc}/primesense"
    mkpath "#{var}/log/primesense/XnSensorServer"
    chmod 0777, "#{var}/log/primesense/XnSensorServer"
  end

  def caveats; <<-EOS.undent
    OpenNI formula is now provided by homebrew-science.
    Tap homebrew-science in advance.
      `brew tap homebrew/science`
    EOS
  end
end
