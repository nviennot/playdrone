class SourcesController < ApplicationController
  def show_package
    @apk_eid = apk_eid = params[:apk_eid]
    @apk = Apk.find_by_eid(@apk_eid)
    @app = @apk.app

    @results = Source.tire.search :per_page => 100000 do
      query { term :apk_eid, apk_eid }
      sort { by :path, :asc }
      fields :path

      facet(:num_lines) { statistical :num_lines }
      facet(:size)      { statistical :size }
    end
  end

  def search
    return unless user_query = params[:query]

    @results = Source.tire.search :page => params[:page].to_i, :per_page => (params[:per_page] || 10).to_i do
      query { string user_query, :default_field => :lines, :default_operator => 'AND' }
      highlight :lines => { :fragment_size => 300, :number_of_fragments => 100000 }, :options => { :tag => '' }
      fields :apk_eid, :path

      facet(:num_lines) { statistical :num_lines }
      facet(:size)      { statistical :size }
    end

    @regex = Regexp.new(params[:filter], Regexp::IGNORECASE) if params[:filter].present?
    @files = Source.filter_lines(@results, @regex)
  end
end
