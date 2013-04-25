class AppsController < ApplicationController
  def show
    @app_id = params[:app_id]

    if Rails.env.production? && !Dir.exists?('/home/vagrant')
      node = Node.find_node_for_app(@app_id)
      return head :not_found unless node
      if node != Node.current_node
        return fetch_from_node(node, @app_id)
      end
    end

    @app = App.find(:live, @app_id)

    # Some apps don't have any permissions
    @app.permission ||= []

    ENV['HOME'] = '/home/deploy' if Rails.env.production? # for the .gitconfig
    diff_src = params[:show_diff].try(:gsub, /[^a-zA-Z]/,'') # gsub for bash injection
    git_cmd = diff_src ? "git log --color -p `git rev-list --max-parents=0 src --`..src -- #{diff_src}" :
                         "git log --color --stat=160 `git rev-list --max-parents=0 src --`..src"
    @diff = `cd #{Repository.new(@app_id).path} && HOME=#{Dir.home} #{git_cmd} |
             #{Rails.root.join('script/ansi2html.sh')} --palette=linux` rescue nil

    @results = Source.index(:live).search({
      :size   => 100000,
      :query  => { :term     => { :app_id => @app_id } },
      :sort   => { :filename => { :order  => :asc } },
      :fields => [:filename]
    })
  end

  def fetch_from_node(node, app_id)
    r = Faraday.new(:url => "http://#{node}/") do |faraday|
      faraday.request :basic_auth, "bien", "jacobien" # really not nice, deal with it.
      faraday.adapter  Faraday.default_adapter
    end.get "/apps/#{app_id}", params.reject { |k,v| k.to_sym.in? request.path_parameters.keys }

    render :text => r.body, :status => r.status
  end
end
