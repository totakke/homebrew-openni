require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Openni < Formula
  homepage ''
  url 'https://github.com/OpenNI/OpenNI/tarball/master'
  version 'master'
  md5 '12389c56bf3685a741f6bcfa068585ff'

  depends_on 'libusb-freenect'
  depends_on 'doxygen'

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

#    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
#    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
#    system "make install" # if this fails, try separate make/make install steps

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
    
  end

end
