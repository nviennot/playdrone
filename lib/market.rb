class Market
  require Rails.root.join 'vendor', 'protobuf-java-2.4.1.jar'
  require Rails.root.join 'vendor', 'AndroidMarketApi.jar'
  require Rails.root.join 'vendor', 'protobuf-java-format-1.2.jar'

  Session = com.gc.android.market.api.MarketSession
  API     = com.gc.android.market.api.model.Market

  module Parser
    JSONFormatter = com.googlecode.protobuf.format.JsonFormat
    def to_json
      JSONFormatter.printToString(self)
    end

    def to_ruby
      JSON.parse(to_json)
    end
  end

  com.google.protobuf.GeneratedMessage.__send__(:include, Parser)
end
