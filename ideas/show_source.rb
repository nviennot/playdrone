def show_source_broken_ignores_app_id(app_id, filename)
  results = Source.index(:live).search({
    :size => 10,

    :filter => {
      :bool => {
        :must => [
          :term => { :app_id   => app_id },
          :term => { :filename => filename }
        ],
      }
    },

    :fields => [:app_id,:filename]
  })
end

def show_source_broken_ignores_filename(app_id, filename)
  results = Source.index(:live).search({
    :size => 10,

    :filter => {
      :bool => {
        :must => [
          :term => { :filename => filename },
          :term => { :app_id   => app_id }
        ],
      }
    },

    :fields => [:app_id,:filename]
  })
end

def show_source(app_id, filename)
  results = Source.index(:live).search({
    :size => 10,

    :filter => {
      :bool => {
        :should => {
          :term => { :app_id   => app_id },
        },
        :must => {
          :term => { :filename => filename },
        },
      }
    },

    :fields => [:app_id,:filename]
  })
end

show_source('Astral.SiteChecker','ActivityBase.java')
show_source_broken_ignores_app_id('Astral.SiteChecker','ActivityBase.java')
show_source_broken_ignores_filename('Astral.SiteChecker','ActivityBase.java')

