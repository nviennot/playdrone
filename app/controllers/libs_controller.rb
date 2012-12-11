class LibsController < ApplicationController
  def index
    @num_apks = Apk.decompiled.count
    @libs = Lib.all.to_a
    @libs_categorized = @libs.group_by(&:category)
    @ranking = params[:ranking].try(:to_sym)
  end
end
