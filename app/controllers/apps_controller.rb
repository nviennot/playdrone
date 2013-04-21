class AppsController < ApplicationController
  def show
    @app_id = params[:app_id]
    @app = App.find(:live, @app_id)

    @results = Source.index(:live).search({
      :size   => 100000,
      :query  => { :term     => { :app_id => @app_id } },
      :sort   => { :filename => { :order  => :asc } },
      :fields => [:filename]
    })
  end
end
