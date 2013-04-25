class AppsController < ApplicationController
  def show
    @app_id = params[:app_id]

    if Rails.env.production? && !Dir.exists?('/home/vagrant')
      node = Node.find_node_for_app(@app_id)
      return head :not_found unless node
      if node != Node.current_node
        return head :not_found if params[:no_redirect]
        return fetch_from_node(node, @app_id)
      end

      @app = App.find('2013-04-23', @app_id)
    else
      @app = App.find(:live, @app_id)
    end

    diff_src = params[:show_diff].try(:gsub, /[^a-zA-Z]/,'') # gsub for bash injection
    git_cmd = diff_src ? "git log --color -p `git rev-list --max-parents=0 src`..src -- #{diff_src}" :
                         "git log --color --stat=160 `git rev-list --max-parents=0 src`..src"
    @diff = `cd #{Repository.new(@app_id).path} && #{git_cmd} |
             #{Rails.root.join('script/ansi2html.sh')} --palette=linux` rescue nil

    @results = Source.index(:live).search({
      :size   => 100000,
      :query  => { :term     => { :app_id => @app_id } },
      :sort   => { :filename => { :order  => :asc } },
      :fields => [:filename]
    })
  end

  def fetch_from_node(node, app_id)
    original_params = params.reject { |k,v| k.to_sym.in? request.path_parameters.keys }
    r = Faraday.new(:url => "http://#{node}/") do |faraday|
      faraday.request :basic_auth, "bien", "jacobien" # really not nice, deal with it.
      faraday.adapter  Faraday.default_adapter
    end.get "/apps/#{app_id}", original_params.merge(:no_redirect => true)

    render :text => r.body, :status => r.status
  end
end
