require 'formula'

class Nite < Formula

  homepage 'https://github.com/totakke/openni-formula'
  url 'http://www.openni.org/downloads/nite-bin-macosx-v1.5.2.21.tar.bz2'
  version '1.5.2.21'
  md5 '059d9a2315a0244dc86fea9ad03e0fcf'

  devel do
    url 'http://www.openni.org/downloads/nite-bin-macosx-v1.5.2.21.tar.bz2'
    version '1.5.2.21-unstable'
    md5 '059d9a2315a0244dc86fea9ad03e0fcf'
  end

  depends_on 'openni'

  def install

    # Install libs
    lib.install Dir['Bin/libXnVNite*.dylib']
    lib.install Dir['Bin/libXnVCNITE*.dylib']
    lib.install Dir['Bin/libXnVNITE.jni*.dylib']

    # Install includes
    include.install Dir['Include/*']

    # Install jar
    jar_dir = "#{share}/java"
    mkpath jar_dir
    cp 'Bin/com.primesense.NITE.jar', jar_dir

    # Install features modules
    Dir.glob('Features*').each do |fdir|
      cd fdir
      dst_fdir = "#{etc}/primesense/" + File.basename(fdir)
      if !File.exist?(dst_fdir) then
        mkpath dst_fdir
      end
      cp_r Dir['Data/*'], dst_fdir, {:remove_destination => true}
      Dir.glob('Bin/lib*.dylib').each do |dlib|
        lib.install dlib
      end
      Dir.glob('Bin/XnVSceneServer*').each do |xvss|
        chmod 0755, xvss
        bin.install xvss
      end
      cd '..'
    end

    # Install hands modules
    Dir.glob('Hands*').each do |hdir|
      cd hdir
      dst_hdir = "#{etc}/primesense/" + File.basename(hdir)
      if !File.exist?(dst_hdir) then
        mkpath dst_hdir
      end
      cp_r Dir['Data/*'], dst_hdir, {:remove_destination => true}
      Dir.glob('Bin/lib*.dylib').each do |dlib|
        lib.install dlib
      end
      cd '..'
    end

    # TODO: .NET

    # Add license
    # NOTE: require sudo
#    system 'niLicense PrimeSense 0KOIk2JeIBYClPWVnMoRKn5cdY4='

    # Run make
    if File.exist?('Makefile') then
      system 'make'
    end

    # TODO: Manual setup instruction
    ohai 'Please setup manually:'
    if !File.exist?('/var/lib/ni') then
      ohai '  $ sudo mkdir -p /var/lib/ni'
    end
    ohai '  $ sudo niReg /usr/local/lib/libXnVFeatures_1_5_2.dylib /usr/etc/primesense/Features_1_5_2'
    ohai '  $ sudo niReg /usr/local/lib/libXnVHandGenerator_1_5_2.dylib /usr/etc/primesense/Hands_1_5_2'
    ohai '  $ sudo niLicense PrimeSense 0KOIk2JeIBYClPWVnMoRKn5cdY4='

  end

end
