class Parser::Asset < Parser::Base
  def asset
    asset = response['InstallAsset'].try(:first)
    return nil if asset.nil?

    {
      :asset_size   => asset['assetSize'],
      :cookie_name  => asset['downloadAuthCookieName'],
      :cookie_value => asset['downloadAuthCookieValue'],
      :url          => asset['blobUrl'],
      :secured      => asset['secured'],
    }
  end
end
