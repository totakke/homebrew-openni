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
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    cd '../Redist/' + @@redist_dir_name

    # Create config directory
    if !File.exist?(config_dir) then
      mkpath config_dir
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
    cp 'Config/GlobalDefautls.ini', config_dir

    # Manual setup instruction
    ohai 'Please setup manually:'
    if !File.exist?('/var/lib/ni') then
      ohai '  $ sudo mkdir -p /var/lib/ni'
    end
    ohai '  $ sudo niReg /usr/local/lib/libXnDeviceSensorV2.dylib /usr/local/etc/primesense'
    ohai '  $ sudo niReg /usr/local/lib/libXnDeviceFile.dylib /usr/local/etc/primesense'
    if !File.exist?('/var/log/primesense/XnSensorServer') then
      ohai '  $ sudo mkdir -p /var/log/primesense/XnSensorServer'
      ohai '  $ sudo chmod a+w /var/log/primesense/XnSensorServer'
    end
  
  end

end
