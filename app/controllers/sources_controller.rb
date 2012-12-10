class SourcesController < ApplicationController
  def show
    @apk_eid  = apk_eid  = params[:apk_eid]
    @apk_path = apk_path = params[:apk_path]

    @results = Source.tire.search :size => 1 do
      query do
        boolean do
          must { term :apk_eid,  apk_eid  }
          must { term :path,     apk_path }
        end
      end
      fields :lines
    end
  end

  def search
    return unless user_query = params[:query]

    @results = Source.tire.search :page => params[:page].to_i, :per_page => (params[:per_page] || 10).to_i do
      query do
        filtered do
          query { string user_query, :default_field => :lines, :default_operator => 'AND' }
          filter :not, :exists => {:field => :lib}
        end
      end

      highlight :lines => { :fragment_size => 300, :number_of_fragments => 100000 }, :options => { :tag => '' }
      fields :apk_eid, :path

      facet(:num_lines) { statistical :num_lines }
      facet(:size)      { statistical :size }
    end

    @regex = Regexp.new(params[:filter], Regexp::IGNORECASE) if params[:filter].present?
    @files = Source.filter_lines(@results, @regex)
  end
end
