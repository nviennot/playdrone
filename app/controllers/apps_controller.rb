class AppsController < ApplicationController
  def index
    user_query = params[:query]
    per_page   = (params[:per_page] || 25).to_i
    page       = (params[:page] || 1).to_i
    from       = (page-1) * per_page

    query = {
      :from => from,
      :size => per_page,

      :sort => { :downloads => :desc },

      :query => [
        { :match_all => {} },
        { :query_string => {
            :fields => [:title],
            :query  => user_query,
          }
        }
      ][user_query.blank? ? 0 : 1],

      :filter => {
        :and => [
          { :terms => { :currency        => params[:currency]        } },
          { :terms => { :downloads       => params[:downloads]       } },
          { :terms => { :app_type        => params[:app_type]        } },
          { :terms => { :category        => params[:category]        } },
          { :term  => { :free            => params[:free]            } },
          { :term  => { :top_developer   => params[:top_developer]   } },
          { :term  => { :editors_choice  => params[:editors_choice]  } },
          { :term  => { :apk_updated     => params[:apk_updated]     } },
          { :term  => { :market_removed  => params[:market_removed]  } },
          { :term  => { :has_native_libs => params[:has_native_libs] } },
        ].select { |h| h.values[0].values[0].present? }.compact,
      }.select { |_, v| v.present? },

      :facets => {
        :currency        => { :terms => { :field => :currency,  :size => 1000 } },
        :downloads       => { :terms => { :field => :downloads, :size => 1000 } },
        :app_type        => { :terms => { :field => :app_type,  :size => 1000 } },
        :category        => { :terms => { :field => :category,  :size => 1000 } },
        :free            => { :terms => { :field => :free } },
        :top_developer   => { :terms => { :field => :top_developer} },
        :editors_choice  => { :terms => { :field => :editors_choice} },
        :apk_updated     => { :terms => { :field => :apk_updated} },
        :market_removed  => { :terms => { :field => :market_removed} },
        :has_native_libs => { :terms => { :field => :has_native_libs} },
      },

      :_source => [:app_id, :title, :downloads]
    }

    if params[:filter_filters]
      query[:query] = {
        :filtered => {
          :query  => query.delete(:query),
          :filter => query.delete(:filter)
        }.select { |_, v| v.present? }
      }
    end

    @results = App.index(:latest).search(query)
    @pagination = WillPaginate::Collection.new(page, per_page, @results.total)
  end

  def updated_apps_index
    @results = App.index("2013*").search(
      :size   => 0,
      :query  => { :term => { :apk_updated => true } },
      :facets => { :updates => { :terms => { :field => :_id, :size => 1000 } } }
    )
  end

  def show
    @app_id = params[:app_id]

    if Rails.env.production? && !Dir.exists?('/home/vagrant')
      node = Node.find_node_for_app(@app_id)
      return head :not_found unless node
      if node != Node.current_node
        return fetch_from_node(node, @app_id)
      end
    end

    @app = App.find(:latest, @app_id)
    @repo_path = "git://#{node}.playdrone.io/#{@app_id.gsub(/\./, '/')}.git"

    # Some apps don't have any permissions
    @app.permission ||= []

    if Rails.env.production?
      ENV['HOME'] = '/home/deploy' if Rails.env.production? # for the .gitconfig
      diff_src = params[:show_diff].try(:gsub, /[^a-zA-Z]/,'') # gsub for bash injection
      git_cmd = diff_src ? "git log --color -p `git rev-list --max-parents=0 src --`..src -- #{diff_src}" :
                           "git log --color --stat=160 `git rev-list --max-parents=0 src --`..src"
      @diff = `cd #{Repository.new(@app_id).path} && HOME=#{Dir.home} #{git_cmd} |
               #{Rails.root.join('script/ansi2html.sh')} --palette=linux` rescue nil
    end

    @results = Source.index(:src).search({
      :size    => 100000,
      :query   => { :term     => { :app_id => @app_id } },
      :sort    => { :filename => { :order  => :asc } },
      :_source => [:filename]
    })
  end

  private

  def fetch_from_node(node, app_id)
    r = Faraday.new(:url => "http://#{node}/") do |faraday|
      faraday.request :basic_auth, "playdrone", "itsshowtime" # really not nice, deal with it.
      faraday.adapter  Faraday.default_adapter
    end.get "/apps/#{app_id}", params.reject { |k,v| k.to_sym.in? request.path_parameters.keys }

    render :text => r.body, :status => r.status
  end
end
