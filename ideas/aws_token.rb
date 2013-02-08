def get_aws_tokens
  aws = {}

  results = Source.tire.search(:per_page => 100000) do
    query     { string 'AKIA*', :default_field => :lines, :default_operator => 'AND' }
    fields    :apk_eid, :path, :lines
  end

  results.each do |source|
    source.lines.each do |line|
      matched = false
      if line =~ /"([^",() ]{40,45})"/
        secret = $1
        if secret =~ /[0-9]/ && secret =~ /([A-Z].*){4}/ && secret =~ /([a-z].*){4}/
          aws[source.apk_eid] ||= {}
          aws[source.apk_eid][:secret] = secret
          matched = true
        end
      end

      if line =~ /"[^"]*(AKIA[^"]{16}).*"/
        aws[source.apk_eid] ||= {}
        aws[source.apk_eid][:key] = $1
        matched = true
      end

      if matched
        aws[source.apk_eid][:file] = source.path

        #app = Apk.find_by_eid(source.apk_eid).app
        #aws[source.apk_eid][:download_count] = app.downloads_count_text
        #aws[source.apk_eid][:rating] = app.rating
      end

    end
  end
  aws
end
