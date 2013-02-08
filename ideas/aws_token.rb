def get_aws_tokens
  aws = {}

  results = Source.tire.search(:per_page => 100000) do
    query     { string 'AKIA*', :default_field => :lines, :default_operator => 'AND' }
    fields    :apk_eid, :path, :lines
  end

  results.each do |source|
    matched = false
    source.lines.each do |line|
      if line =~ /"([^",() ]{40,45})"/
        secret = $1
        if secret =~ /[0-9]/ && secret =~ /([A-Z].*){4}/ && secret =~ /([a-z].*){4}/
          aws[source.apk_eid] ||= {}
          aws[source.apk_eid][:secret] = secret
          matched = true
        end
      end

#      if line =~ /"?[^"]*(AKIA[^"]{16})/
      if line =~ /(AKIA[^"]{16})/
        aws[source.apk_eid] ||= {}
        aws[source.apk_eid][:key] = $1
        matched = true
      end

      if line =~ /(.*amazon.*)/
        aws[source.apk_eid] ||= {}
        aws[source.apk_eid][:info] ||= $1
      end
    end

    if matched
      aws[source.apk_eid][:file] = source.path

      #app = Apk.find_by_eid(source.apk_eid).app
      #aws[source.apk_eid][:download_count] = app.downloads_count_text
      #aws[source.apk_eid][:rating] = app.rating
    end
  end
  aws
end

def get_apps_by_token
  aws = {}

  results = Source.tire.search(:per_page => 100000) do
    query     { string 'AKIA*', :default_field => :lines, :default_operator => 'AND' }
    fields    :apk_eid, :path, :lines
  end

  results.each do |source|
    source.lines.each do |line|
      if line =~ /"?[^"]*(AKIA[^"]{16})/
        aws[$1] ||= 0
        aws[$1] += 1
      end
    end
  end
  aws.sort_by { |k,v| v }.reverse
end

# aws = get_aws_token
# abt = get_apps_by_token
# aws.select { |k,v| v[:key] == abt[0][0] }
# aws.select { |k,v| v[:key] == abt[1][0] }
# etc..
# numbers don't really match ... why ?
# ~/crawler (production) > aws.select { |k,v| v[:key] == abt[0][0] }.count
# => 101
# ~/crawler (production) > aws.select { |k,v| v[:key] == abt[1][0] }.count
# => 68
# ~/crawler (production) > aws.select { |k,v| v[:key] == abt[2][0] }.count
# => 62
# ~/crawler (production) > aws.select { |k,v| v[:key] == abt[3][0] }.count
# => 15
#
#
#~/crawler (production) > abt[0][1]
#=> 101
#~/crawler (production) > abt[1][1]
#=> 68
#~/crawler (production) > abt[2][1]
#=> 62
#~/crawler (production) > abt[3][1]
#=> 28

require 'csv'

def csvout
  CSV.open("aws.csv", "wb") do |csv|
    aws = get_aws_tokens
    aws.each do |k,v|
      csv << [ v[:key], v[:secret], k, v[:file] ]
    end
  end
end

def missing_secret (aws)
  aws.select {|k,v| v[:secret].nil? }
end
