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

    :downloads        => { :type => :integer, :store => true },
    :plus_one_count   => { :type => :integer },
    :comment_count    => { :type => :integer },
    :ratings_count    => { :type => :integer },
    :one_star_count   => { :type => :integer },
    :two_star_count   => { :type => :integer },
    :three_star_count => { :type => :integer },
    :four_star_count  => { :type => :integer },
    :five_star_count  => { :type => :integer },
    :star_rating      => { :type => :float },

    :image => { :properties => {
      :type => { :type => :integer },
      :url  => { :type => :string, :index => :no },
    }},
  })
end
