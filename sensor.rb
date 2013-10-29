require 'formula'

class Sensor < Formula
  homepage 'http://www.openni.org/'
  url 'https://github.com/PrimeSense/Sensor/archive/Stable-5.1.0.41.tar.gz'
  version 'stable-5.1.0.41'
  sha1 '04ec8fcae2c9d8f02c20238a071db1cabe0aeac7'

  head 'https://github.com/PrimeSense/Sensor.git'

  devel do
    url 'https://github.com/PrimeSense/Sensor/archive/Unstable-5.1.2.1.tar.gz'
    version 'unstable-5.1.2.1'
    sha1 '72b933ea48afe6216c2e9301fa023e1daac649d3'
  end

  conflicts_with 'sensor-kinect'

  depends_on 'openni'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    ENV.cxx += ' -stdlib=libstdc++' if ENV.compiler == :clang && MacOS.version >= :mavericks

    # Fix build files
    inreplace 'Source/Utils/XnSensorServer/SensorServer.cpp', "/var/log/primesense/XnSensorServer/", "#{var}/log/primesense/XnSensorServer/"
    inreplace 'Platform/Linux/Build/EngineLibMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/Build/Utils/EngineUtilMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/CreateRedist/RedistMaker', 'echo $((N_CORES*2))', 'echo $((2))'
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build Sensor
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
    cp 'Config/GlobalDefaults.ini', "#{etc}/primesense"

    # niReg
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceSensorV2.dylib #{etc}/primesense"
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceFile.dylib #{etc}/primesense"

    # Create log directory
    mkpath "#{var}/log/primesense/XnSensorServer"
    chmod 0777, "#{var}/log/primesense/XnSensorServer"
  end
end
