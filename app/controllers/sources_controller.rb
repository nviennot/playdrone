class SourcesController < ApplicationController
  def search
    params[:per_page] ||= 50
    if params[:query]
      @results = Source.search(params[:query],
                               :page => params[:page].to_i,
                               :per_page => (params[:per_page] || 10).to_i)

      if params[:filter].present?
        @regex = Regexp.new(params[:filter], Regexp::IGNORECASE)
      end

      @files = Source.filter_lines(@results, @regex)
    end

    render :partial => 'sources/results' if request.xhr?
  end
end
