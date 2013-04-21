class AppsController < ApplicationController
  def show
    @app_id = params[:app_id]
    @app = App.find(:live, @app_id)

    @diff = `cd #{Repository.new(@app_id).path} && git log --color --stat src -- src | #{Rails.root.join('script/ansi2html.sh')}` rescue nil

    @results = Source.index(:live).search({
      :size   => 100000,
      :query  => { :term     => { :app_id => @app_id } },
      :sort   => { :filename => { :order  => :asc } },
      :fields => [:filename]
    })
  end
end
