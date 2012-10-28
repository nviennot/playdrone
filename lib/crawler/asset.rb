class Crawler::Asset < Crawler::Base
  def crawl
    resp = query_get_asset_request(options[:asset_id])
    Parser::Asset.new(resp.to_ruby)
  end
end
