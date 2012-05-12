require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sensor < Formula
  homepage 'https://github.com/totakke/openni-formula'
  url 'https://github.com/PrimeSense/Sensor/tarball/Stable-5.1.0.41'
  version '5.1.0.41'
  md5 ''

  devel do
    url 'https://github.com/PrimeSense/Sensor/tarball/Unstable-5.1.0.41'
    version '5.1.0.41'
    md5 ''
  end

  depends_on 'openni'

  def install

    cd 'Platform/Linux/CreateRedist'

    # Build OpenNI
    system 'chmod u+x RedistMaker'
    system './RedistMaker'

    cd '../Redist/Sensor-Bin-MacOSX-v5.1.0.41'

    # Create config directory
    mkdir "#{etc}/primesense"

    # Install bins
    bin.install Dir['Bin/*']

    # Install libs
    lib.install Dir['Lib/*']

    # Register modules
    # NOTE: Need to create /var/lib/ni direcotry for registering modules.
    #       A user need to register them manually after installing.
#    system "#{bin}/niReg -r #{lib}/libXnDeviceSensorV2.dylib #{etc}/primesense"
#    system "#{bin}/niReg -r #{lib}/libXnDeviceFile.dylib #{etc}/primesense"

    # Copy config file
    system "cp Config/GlobalDefaults.ini #{etc}/primesense"

    ohai 'Please setup manually:
  $ sudo mkdir -p /var/log/primesense/XnSensorServer
  $ sudo chmod a+w /var/log/primesense/XnSensorServer'
  
  end

end
