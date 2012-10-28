class Parser::Asset < Parser::Base
  def asset
    asset = response['InstallAsset'].first
    {
      :asset_size   => asset['assetSize'],
      :cookie_name  => asset['downloadAuthCookieName'],
      :cookie_value => asset['downloadAuthCookieValue'],
      :url          => asset['blobUrl'],
      :secured      => asset['secured'],
    }
  end
end
