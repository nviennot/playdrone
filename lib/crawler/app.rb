class Crawler::App < Crawler::Base
  PER_PAGE = 10
  MAX_START = 500

  def crawl(start=0)
    options[:start]    ||= start
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

    resp = session.queryApp(req.build)
    # go figure
    raise if resp.size != 1
    resp[0].to_ruby
  end

  def crawl_and_process(start=0)
    apps = crawl(start)['app']
    apps.each { |a| process a } if apps
  end

  def process(app)
    appi = app['ExtendedInfo']
    a = ::App.new
    a.searched_category_id = options[:category_id] if options[:category_id]

    a.app_id        = app['id'].to_i
    a.title         = app['title']
    a.app_type      = app['appType'].downcase.to_sym
    a.creator       = app['creator']
    a.version       = app['version']
    a.rating        = app['rating']
    a.rating_count  = app['ratingsCount']
    a.description   = appi['description']
    a.permissions   = appi['permissionId']
    a.install_size  = appi['installSize']
    a.category      = appi['category']
    a.contact_email = appi['contactEmail']
    a.downloads_count_text = appi['downloadsCountText']
    a.contact_phone     = appi['contactPhone']
    a.contact_website   = appi['contactWebsite']
    a.screenshots_count = appi['screenshotsCount']
    a.promo_text        = appi['promoText']
    a.recent_changes    = appi['recentChanges']
    a.promo_video       = appi['promotionalVideo']
    a.package_name      = app['packageName']
    a.version_code      = app['versionCode']
    a.price_currency    = app['priceCurrency']
    a.price             = app['priceMicros'].try(:/, 1000000.0)

    a.upsert
  end

  def num_apps
    crawl(0)['entriesCount']
  end
end
