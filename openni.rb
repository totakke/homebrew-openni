require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Openni < Formula
  homepage 'https://github.com/totakke/openni-formula'
  url 'https://github.com/OpenNI/OpenNI/tarball/Stable-1.5.2.23'
  version '1.5.2.23'
  md5 '12389c56bf3685a741f6bcfa068585ff'

  devel do
    url 'https://github.com/PrimeSense/Sensor/tarball/Unstable-1.5.2.23'
    version '1.5.2.23'
    md5 ''
  end

  depends_on 'libusb-freenect'
  depends_on 'doxygen'

  def install

    cd 'Platform/Linux/CreateRedist'

    # Build OpenNI
    system 'chmod u+x RedistMaker'
    system './RedistMaker'

    cd '../Redist/OpenNI-Bin-Dev-MacOSX-v1.5.2.23'

    # Install bins
    bin.install Dir['Bin/ni*']

    # Install libs
    lib.install Dir['Lib/*']

    # Install includes
    include.install Dir['Include/*']

    # NOTE: Need to create /var/lib/ni direcotry for registering modules.
    #       A user need to register them manually after installing.
#    system "#{bin}/niReg -r #{lib}/libnimMockNodes.dylib"
#    system "#{bin}/niReg -r #{lib}/libnimCodecs.dylib"
#    system "#{bin}/niReg -r #{lib}/libnimRecorder.dylib"

    # Install jar files
    mkdir "#{prefix}/jar"
    system "cp -r Jar/* #{prefix}/jar"

    # Install samples
    mkdir "#{prefix}/sample"
    system "cp -r Samples/* #{prefix}/sample"

    # Install docs
    doc.install Dir['Documentation']

    ohai 'Please setup manually:
  $ sudo mkdir /var/lib/ni
  $ sudo niReg -r /usr/local/lib/libnim*.dylib'
    
  end

end
