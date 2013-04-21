class AppsController < ApplicationController
  def show
    @app_id = params[:app_id]
    @app = App.find(:live, @app_id)

    diff_src = params[:show_diff].try(:gsub, /[^a-zA-Z]/,'') # gsub for bash injection
    git_cmd = diff_src ? "git log --color -p `git rev-list --max-parents=0 src`..src -- #{diff_src}" :
                         "git log --color --stat=160 `git rev-list --max-parents=0 src`..src"
    @diff = `cd #{Repository.new(@app_id).path} && #{git_cmd} |
             #{Rails.root.join('script/ansi2html.sh')} --palette=linux` rescue nil

    @results = Source.index(:live).search({
      :size   => 100000,
      :query  => { :term     => { :app_id => @app_id } },
      :sort   => { :filename => { :order  => :asc } },
      :fields => [:filename]
    })
  end
end
