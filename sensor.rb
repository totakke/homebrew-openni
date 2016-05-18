class Sensor < Formula
  homepage 'http://www.primesense.com'
  url 'https://github.com/PrimeSense/Sensor/archive/Stable-5.1.6.6.tar.gz'
  sha1 'caa461ddac5d7a562d44a2c278eea62b12aafe4c'
  head 'https://github.com/PrimeSense/Sensor.git'

  conflicts_with 'sensor-kinect'

  depends_on 'openni' => (build.universal?) ? ['universal'] : []

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # Fix build files
    inreplace 'Source/Utils/XnSensorServer/SensorServer.cpp', "/var/log/primesense/XnSensorServer/", "#{var}/log/primesense/XnSensorServer/"
    inreplace 'Platform/Linux/Build/EngineLibMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/Build/Utils/EngineUtilMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/CreateRedist/RedistMaker', 'echo $((N_CORES*2))', 'echo $((1))'
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build Sensor
    cd 'Platform/Linux/CreateRedist'
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    cd Dir.glob('../Redist/Sensor-Bin-MacOSX-v*')[0]

    bin.install Dir['Bin/*']
    lib.install Dir['Lib/*']
    (etc+'primesense').install 'Config/GlobalDefaults.ini'
  end

  def post_install
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceSensorV2.dylib #{etc}/primesense"
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
