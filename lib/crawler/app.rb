class Crawler::App < Crawler::Base
  PER_PAGE = 10
  MAX_START = 500

  def crawl
    options[:start]    ||= 0
    options[:per_page] ||= PER_PAGE
    options[:order]    ||= :popular

    options[:app_type] = Market.get_type_value(Market::API::AppType,                options[:app_type])
    options[:order]    = Market.get_type_value(Market::API::AppsRequest::OrderType, options[:order])
    options[:view]     = Market.get_type_value(Market::API::AppsRequest::ViewType,  options[:view])

    req = Market::API::AppsRequest.newBuilder()
    req.setWithExtendedInfo true

    req.setAppType      options[:app_type]    if options[:app_type]
    req.setQuery        options[:query]       if options[:query]
    req.setCategoryId   options[:category_id] if options[:category_id]
    req.setAppId        options[:app_id]      if options[:app_id]
    req.setOrderType    options[:order]
    req.setStartIndex   options[:start]
    req.setEntriesCount options[:per_page]
    req.setViewType     options[:view]        if options[:view]

    resp = query_app(req.build)
    raise if resp.count != 1 # go figure why we obtain an array of array
    Parser::App.new(resp[0].to_ruby)
  end
end
