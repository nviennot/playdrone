es_url = 'http://localhost:9200' if Rails.env.production? && Dir.exists?('/usr/local/var/run/elasticsearch')
es_url ||= YAML.load_file(Rails.root.join("config", "elasticsearch.yml"))[Rails.env]['url']
ENV['ELASTICSEARCH_URL'] ||= es_url
