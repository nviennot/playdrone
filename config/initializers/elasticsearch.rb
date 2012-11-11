ENV['ELASTICSEARCH_URL'] = YAML.load_file(Rails.root.join("config", "elasticsearch.yml"))[Rails.env]['url']
