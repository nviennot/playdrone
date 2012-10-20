module Decompiler
  unless File.exists?(Rails.root.join 'vendor', 'libjd-intellij.so')
    raise "Please install libjd-intellij.so in ./vendor.\n" +
           "It can be found at https://bitbucket.org/bric3/jd-intellij"
  end
  require Rails.root.join 'vendor', 'jd-core-java-1.0.jar'

  mattr_accessor :instance
  self.instance = Java::JdCore::Decompiler

  def self.decompile(jar)
    instance.new.decompile(jar)
  end
end
