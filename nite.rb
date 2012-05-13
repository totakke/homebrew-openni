require 'formula'

class Nite < Formula

  homepage 'https://github.com/totakke/openni-formula'
  url 'http://www.openni.org/downloads/nite-bin-macosx-v1.5.2.21.tar.bz2'
  version '1.5.2.21'
  md5 '' # TODO

  devel do
    url 'http://www.openni.org/downloads/nite-bin-macosx-v1.5.2.21.tar.bz2'
    version '1.5.2.21-unstable'
    md5 '' # TODO
  end

  depends_on 'openni'

  def install

    # Install libs
    lib.install Dir['Bin/libXnVNite*.dylib']
    lib.install Dir['Bin/LibXnVCNITE*.dylib']
    lib.install Dir['Bin/libXnVNITE.jni*.dylib']

    # Install includes
    include.install Dir['Include/*']

    # Install jar
    share.mkpath
    jar_dir = "#{share}/java"
    mkdir jar_dir
    system "cp Bin/com.primesense.NITE.jar " + jar_dir

    #
    primesense_dir = "#{etc}/primesense"
    if !File.exist?(primesense_dir) then
      mkdir primesense_dir
    end
    

    # Add license
    system 'niLicense PrimeSense 0KOIk2JeIBYClPWVnMoRKn5cdY4='

    # Run make
    if File.exist?('Makefile') then
      system 'make'
    end

  end

end
