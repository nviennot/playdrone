module Market
  Protobuf.load_glue
  require Rails.root.join 'vendor', 'AndroidMarketApi.jar'

  Session = com.gc.android.market.api.MarketSession
  API     = com.gc.android.market.api.model.Market

  def self.get_type_value(kind, what)
    return nil if what.nil?
    kind.value_of(kind.const_get("#{what.to_s.upcase}_VALUE"))
  end
end
