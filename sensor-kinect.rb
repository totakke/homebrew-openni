require 'formula'

class SensorKinect < Formula
  homepage 'https://github.com/avin2/SensorKinect/'
  url 'https://github.com/avin2/SensorKinect/archive/v0.91-5.1.0.25.tar.gz'
  version '0.91-5.1.0.25'
  sha1 'ca50ff27d706a92f71063154e8353efe0bf1eba2'

  head 'https://github.com/avin2/SensorKinect.git'

  devel do
    url 'https://github.com/avin2/SensorKinect/archive/v0.93-5.1.2.1.tar.gz'
    version '0.93-5.1.2.1'
    sha1 'd34f49da4edf8c5febc93a4c95c13d2bee73048e'
  end

  depends_on 'openni'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # Fix build files
    inreplace 'Source/Utils/XnSensorServer/SensorServer.cpp', "/var/log/primesense/XnSensorServer/", "#{var}/log/primesense/XnSensorServer/"
    inreplace 'Platform/Linux/Build/EngineLibMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/Build/Utils/EngineUtilMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/CreateRedist/RedistMaker', 'echo $((N_CORES*2))', 'echo $((2))'
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build SensorKinect
    cd 'Platform/Linux/CreateRedist'
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    redist_dir = Dir.glob('../Redist/Sensor-Bin-MacOSX-v*')[0]
    cd redist_dir

    # Install bins
    bin.install Dir['Bin/*']

    # Install libs
    lib.install Dir['Lib/*']

    # Copy config file
    mkpath "#{etc}/primesense"
    cp 'Config/GlobalDefaultsKinect.ini', "#{etc}/primesense"

    # niReg
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceSensorV2KM.dylib #{etc}/primesense"
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceFile.dylib #{etc}/primesense"

    # Create log directory
    mkpath "#{var}/log/primesense/XnSensorServer"
    chmod 0777, "#{var}/log/primesense/XnSensorServer"
  end
end
