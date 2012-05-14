require 'formula'

class SensorKinect < Formula

  homepage 'https://github.com/totakke/openni-formula'
  url 'https://github.com/avin2/SensorKinect/tarball/master'
  version '5.0.3.3'
  md5 '' # TODO

  @@redist_dir_name = 'Sensor-Bin-MacOSX-v5.0.3.3'

  devel do
    url 'https://github.com/avin2/SensorKinect/tarball/unstable'
    version '5.1.0.25-unstable'
    md5 '' # TODO

    @@redist_dir_name = 'Sensor-Bin-MacOSX-v5.1.0.25'
  end

  depends_on 'openni'

  def install

    config_dir = "#{etc}/primesense"
    
    cd 'Platform/Linux/CreateRedist'

    # Build SnesorKinect
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
#    system "#{bin}/niReg -r #{lib}/libXnDeviceSensorV2.dylib #{etc}/primesense"
#    system "#{bin}/niReg -r #{lib}/libXnDeviceFile.dylib #{etc}/primesense"

    # Copy config file
    cp 'Config/GlobalDefaults.ini', config_dir

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
