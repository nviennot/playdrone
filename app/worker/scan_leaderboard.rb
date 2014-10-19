class ScanLeaderboard
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :backtrace => true

  def perform_list(raw_url=nil)
    result = Market.list(:raw_url => raw_url)

    result.docs.each do |cat|
      if cat[:container_metadata].present?
        if cat[:container_metadata][:next_page_url]
          self.class.perform_async(:list, cat[:container_metadata][:next_page_url])
        end

        if cat[:container_metadata][:browse_url] && result.docs.size > 1
          self.class.perform_async(:browse, cat[:container_metadata][:browse_url])
        end
      end

      if cat[:child].present?
        app_ids = cat[:child].map { |c| c[:docid] }
        App.discovered_apps(app_ids)
      end
    end
  end

  def perform_browse(raw_url=nil)
    Timeout.timeout(30.seconds) do
      result = Market.browse(:raw_url => raw_url)

      if result.list_url.present?
        self.class.perform_async(:list, result.list_url)
      end

      if result.categories.present?
        result.categories.values.each do |cat|
          self.class.perform_async(:browse, cat)
        end
      end
    end
  end

  def perform(action, raw_url=nil)
    case action.to_sym
    when :list   then perform_list(raw_url)
    when :browse then perform_browse(raw_url)
    end
  end
end
