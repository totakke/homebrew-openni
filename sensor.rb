require 'formula'

class Sensor < Formula
  homepage 'https://github.com/totakke/openni-formula'
  url 'https://github.com/PrimeSense/Sensor/tarball/Stable-5.1.0.41'
  version '5.1.0.41'
  md5 'bed5b928d9299ee5580d12213f13ba41'

  @@redist_dir_name = 'Sensor-Bin-MacOSX-v5.1.0.41'

  devel do
    url 'https://github.com/PrimeSense/Sensor/tarball/Unstable-5.1.0.41'
    version '5.1.0.41-unstable'
    md5 '9c910f5230a8240e1cb00c0f60eaa7e9'

    @@redist_dir_name = 'Sensor-Bin-MacOSX-v5.1.0.41'
  end

  depends_on 'openni'

  def install

    config_dir = "#{etc}/primesense"

    cd 'Platform/Linux/CreateRedist'

    # Build Sensor
    system 'chmod u+x RedistMaker'
    system './RedistMaker'

    cd '../Redist/' + @@redist_dir_name

    # Create config directory
    if !File.exist?(config_dir) then
      mkdir config_dir
    end

    # Install bins
    bin.install Dir['Bin/*']

    # Install libs
    lib.install Dir['Lib/*']

    # Register modules
    # NOTE: Need to create /var/lib/ni direcotry for registering modules.
    #       A user need to register them manually after installing.
#   system "#{bin}/niReg -r #{lib}/libXnDeviceSensorV2.dylib #{etc}/primesense"
#   system "#{bin}/niReg -r #{lib}/libXnDeviceFile.dylib #{etc}/primesense"

    # Copy config file
    system 'cp -f Config/GlobalDefaults.ini ' + config_dir

    # Manual setup instruction
    ohai 'Please setup manually:

  $ sudo mkdir /var/lib/ni
  $ sudo niReg -r /urr/local/lib/libXnDevice*.dylib /usr/local/etc/primesense
  $ sudo mkdir -p /var/log/primesense/XnSensorServer
  $ sudo chmod a+w /var/log/primesense/XnSensorServer
'
  
  end

end
