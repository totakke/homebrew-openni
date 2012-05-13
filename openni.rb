require 'formula'

class Openni < Formula

  homepage 'https://github.com/totakke/openni-formula'
  url 'https://github.com/OpenNI/OpenNI/tarball/Stable-1.5.2.23'
  version '1.5.2.23'
  md5 '12389c56bf3685a741f6bcfa068585ff'

  @@redist_dir_name = 'OpenNI-Bin-Dev-MacOSX-v1.5.2.23'

  devel do
    url 'https://github.com/OpenNI/OpenNI/tarball/Unstable-1.5.2.23'
    version '1.5.2.23-unstable'
    md5 '0a74f9f5a8ac9af1318347ca8dbdc50d'

    @@redist_dir_name = 'OpenNI-Bin-Dev-MacOSX-v1.5.2.23'
  end

  depends_on 'libusb-freenect'
  depends_on 'doxygen'

  def install

    cd 'Platform/Linux/CreateRedist'

    # Build OpenNI
    system 'chmod u+x RedistMaker'
    system './RedistMaker'

    cd '../Redist/' + @@redist_dir_name

    # Install bins
    bin.install Dir['Bin/ni*']

    # Install libs
    lib.install Dir['Lib/*']

    # Install includes
    include.install Dir['Include/*']

=begin
    # NOTE: Need to create /var/lib/ni direcotry for registering modules.
    #       A user need to register them manually after installing.
    var.mkpath
    if !File.exist?("#{var}/lib") then
      mkdir "#{var}/lib"
    end
    ni_dir = "#{var}/lib/ni"
    if !File.exist?(ni_dir) then
      mkdir ni_dir
    end
    system "export DYLD_LIBRARY_PATH=#{lib}:$DYLD_LIBRARY_PATH"
    system "Bin/niReg -r #{lib}/libnimMockNodes.dylib " + ni_dir
    system "Bin/niReg -r #{lib}/libnimCodecs.dylib " + ni_dir
    system "Bin/niReg -r #{lib}/libnimRecorder.dylib " + ni_dir
=end

    # Install jar files
    share.mkpath
    jar_dir = "#{share}/java"
    mkdir jar_dir
    system 'cp -r Jar/* ' + jar_dir

    # Install samples
    mkdir "#{prefix}/sample"
    system "cp -r Samples/* #{prefix}/sample"

    # Install docs
    doc.install Dir['Documentation']

    # Manual setup instruction
    ohai 'Please setup manually:'
    if !File.exist?('/var/lib/ni') then
      ohai '  $ sudo mkdir -p /var/lib/ni'
    end
    ohai '  $ sudo niReg /usr/local/lib/libnimMockNodes.dylib'
    ohai '  $ sudo niReg /usr/local/lib/libnimCodecs.dylib'
    ohai '  $ sudo niReg /usr/local/lib/libnimRecorder.dylib'
    
  end

end
