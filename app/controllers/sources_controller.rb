require 'will_paginate/collection'

class SourcesController < ApplicationController
  def show
    @app_id = params[:app_id]
    @path = params[:filename]

    @results = Source.index(:src).search({
      :size => 1,

      :filter => {
        :bool => {
          :must => [
            { :term => { :app_id  => @app_id } },
            { :term => { :path    => @path } }
          ]
        }
      },

      :_source => [:lines]
    })

    @extension = extension_for(@path)
  end

  def search
    user_query = params[:query]
    per_page   = (params[:per_page] || 10).to_i
    page       = (params[:page] || 1).to_i
    from       = (page-1) * per_page
    regex      = Regexp.new(params[:filter], Regexp::IGNORECASE) if params[:filter].present?
    return unless user_query.present?

    @results = Source.index(:src).search({
      :from => from,
      :size => per_page,

      :query => {
        :filtered => {
          :query => {
            :query_string => {
              :query            => user_query,
              :default_field    => :lines,
              :default_operator => 'AND'
            }
          }
        }
      },

      :_source => [:app_id, :path],

      :highlight => {
        :pre_tags  => [''],
        :post_tags => [''],
        :fields    => { :lines => { :fragment_size => 300, :number_of_fragments => 100000 } }
      }
    })

    @files = @results.results.map do |source|
      next unless source._highlight
      matched_lines = source._highlight.lines
      matched_lines = matched_lines.grep(regex) if regex
      next if matched_lines.empty?

      {:app_id    => source.app_id,
       :path      => source.path,
       :extension => extension_for(source.path),
       :filename  => filename_for(source.path),
       :lines     => matched_lines}
    end.compact

    @pagination = WillPaginate::Collection.new(page, per_page, @results.total)
  end

  private

  def extension_for(path)
    ext = path.split('.').last.to_sym
    ext == :js ? :java_script : ext # for coderay
  end

  def filename_for(path)
    path.split('/').last
  end
end
