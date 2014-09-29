class Stack::ReindexSourcesShim < Stack::Base
  def call(env)
    latest_version = Repository.new(env[:app_id]).tags
                       .map(&:name).select { |t| t =~ /src-/ }
                       .map { |t| t.gsub(/src-/, '').to_i }
                       .sort.last

    return unless latest_version

    env[:crawled_at] ||= Date.today
    env[:force_index_sources] = true
    env[:app] = App.new(:_id => env[:app_id],
                        :version_code => latest_version)

    @stack.call(env)
  end
end
