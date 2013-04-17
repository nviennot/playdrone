class App
  mapping({
    :id                => { :type => :string, :index    => :not_analyzed },
    :title             => { :type => :string, :analyzer => :simple },
    :description       => { :type => :string, :analyzer => :simple },       # html
    :recent_changes    => { :type => :string, :index    => :not_analyzed }, # html
    :creator           => { :type => :string, :index    => :not_analyzed },
    :developer_email   => { :type => :string, :index    => :not_analyzed },
    :developer_website => { :type => :string, :index    => :not_analyzed },
    :top_developer     => { :type => :boolean },
    :editors_choice    => { :type => :boolean },
    :content_rating    => { :type => :integer },
    :app_type          => { :type => :string, :index    => :not_analyzed },

    :price    => { :type => :float }, # always in USD
    :currency => { :type => :string, :index => :not_analyzed },

    :available_if_owned => { :type => :boolean }, # what is this? I guess we'll find out

    :version_code      => { :type => :integer },
    :version_string    => { :type => :string, :index => :no },
    :installation_size => { :type => :integer },
    :permission        => { :type => :string, :index => :not_analyzed },

    :crawl_date  => { :type => :date, :store => true },
    :upload_date => { :type => :date, :store => true },

    :downloads     => { :type => :integer, :store => true },
    :star_rating   => { :type => :float },
    :ratings_count => { :type => :integer },
    :one_star      => { :type => :integer },
    :two_star      => { :type => :integer },
    :three_star    => { :type => :integer },
    :four_star     => { :type => :integer },
    :five_star     => { :type => :integer },
    :comment_count => { :type => :integer },

    :image => { :properties => {
      :type => { :type => :integer },
      :url  => { :type => :string, :index => :no },
    }},
  })
end
