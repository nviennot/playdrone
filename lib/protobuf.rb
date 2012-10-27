module Protobuf
  require Rails.root.join 'vendor', 'protobuf-java-2.4.1.jar'
  require Rails.root.join 'vendor', 'protobuf-java-format-1.2.jar'

  module Parser
    JSONFormatter = com.googlecode.protobuf.format.JsonFormat
    def to_json
      JSONFormatter.printToString(self)
    end

    def to_ruby
      JSON.parse(to_json)
    end
  end

  def self.load_glue
    com.google.protobuf.GeneratedMessage.__send__(:include, Parser)
  end
end
