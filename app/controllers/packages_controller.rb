class PackagesController < ApplicationController
  def show
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
end
