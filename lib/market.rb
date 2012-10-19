module Market
  require Rails.root.join 'vendor', 'protobuf-java-2.4.1.jar'
  require Rails.root.join 'vendor', 'AndroidMarketApi.jar'
  include_package 'com.gc.android.market.api'
end
