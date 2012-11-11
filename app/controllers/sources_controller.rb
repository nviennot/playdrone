class SourcesController < ApplicationController
  def search
    if params[:pattern]
      @results = Source.search(params[:pattern],
                               :page => params[:page].to_i,
                               :per_page => (params[:per_page] || 10).to_i)

      if params[:filter].present?
        @regex = Regexp.new(params[:filter], Regexp::IGNORECASE)
        @files = Source.filter_lines(@results, @regex)
      end
    end

    render :partial => 'sources/results' if request.xhr?
  end
end
