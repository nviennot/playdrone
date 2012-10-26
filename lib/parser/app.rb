class Parser::App < Parser::Base
  def num_apps
    response['entriesCount'].to_i
  end

  def apps
    (response['app'] || []).map do |app|
      appi = app['ExtendedInfo']
      {
        :app_id               => app['id'],
        :title                => app['title'],
        :app_type             => app['appType'].downcase.to_sym,
        :creator              => app['creator'],
        :version              => app['version'],
        :rating               => app['rating'],
        :rating_count         => app['ratingsCount'],
        :description          => appi['description'],
        :permissions          => appi['permissionId'],
        :install_size         => appi['installSize'],
        :category             => appi['category'],
        :contact_email        => appi['contactEmail'],
        :downloads_count_text => appi['downloadsCountText'],
        :contact_phone        => appi['contactPhone'],
        :contact_website      => appi['contactWebsite'],
        :screenshots_count    => appi['screenshotsCount'],
        :promo_text           => appi['promoText'],
        :recent_changes       => appi['recentChanges'],
        :promo_video          => appi['promotionalVideo'],
        :package_name         => app['packageName'],
        :version_code         => app['versionCode'],
        :price_currency       => app['priceCurrency'],
        :price                => app['priceMicros'].try(:/, 1000000.0),
      }
    end
  end
end
