def get_aws_tokens
  aws = {}

  results = Source.tire.search(:per_page => 100000) do
    query     { string 'AKIA*', :default_field => :lines, :default_operator => 'AND' }
    fields    :apk_eid, :path, :lines
  end

  results.each do |source|
    matched = false
    source.lines.each do |line|
      if line =~ /"([^",() ]{40})"/
        secret = $1
        if secret =~ /[0-9]/ && secret =~ /([A-Z].*){4}/ && secret =~ /([a-z].*){4}/
          aws[source.apk_eid] ||= {}
          aws[source.apk_eid][source.path] ||= {}
          aws[source.apk_eid][source.path][:secret] ||= Set.new
          aws[source.apk_eid][source.path][:secret] << secret
          matched = true
        end
      end

      if line =~ /\b(AKIA[^"]{16})\b/
        aws[source.apk_eid] ||= {}
        aws[source.apk_eid][source.path] ||= {}
        aws[source.apk_eid][source.path][:key] ||= Set.new
        aws[source.apk_eid][source.path][:key] << $1
        matched = true
      end

      if line =~ /([0-9a-z\-\.]*\.amazon(aws)?\.com)/
        aws[source.apk_eid] ||= {}
        aws[source.apk_eid][source.path] ||= {}
        aws[source.apk_eid][source.path][:site] ||= []
        aws[source.apk_eid][source.path][:site] << $1
      end
    end

    #if matched
      #aws[source.apk_eid][:files] ||= []
      #aws[source.apk_eid][:files] << source.path

      #app = Apk.find_by_eid(source.apk_eid).app
      #aws[source.apk_eid][:download_count] = app.downloads_count_text
      #aws[source.apk_eid][:rating] = app.rating
    #end
  end

  aws
end

def popular? (apk)
  apk.downloads >= 50000
end

# aggregate by package
def consolidate (aws = nil)
  if aws.nil?
    aws = get_aws_tokens
  end
  result = {}
  aws.each do |pkg,v|
    v.each do |file,v2|
      result[pkg] ||= {}
      result[pkg][:keys] ||= Set.new
      result[pkg][:secrets] ||= Set.new
      result[pkg][:keys] += v2[:key] unless v2[:key].nil?
      result[pkg][:secrets] += v2[:secret] unless v2[:secret].nil?
    end
  end
  result
end

#check if we missed some keys
##c = consolidate
#c.select { |k,v| v[:secrets].count < v[:keys].count }

# range of the issue
#apps = aws.keys.map { |x| Apk.find_by_eid(x).app }
#apps.reduce(0) { |total,app| dl += total.downloads }
#=> 12965200

# apps that do or don't use com.amazonaws library
def get_stats (aws = nil)
  if aws.nil?
    aws = get_aws_tokens
  end
  result = [[],[],[]]

  result[0] << Apk.where(:lib_names => "com.amazonaws").where(:eid.in => aws.keys).count
  result[0] << Apk.where(:lib_names => "com.amazonaws").where(:eid.nin => aws.keys).count
  result[0] << Apk.where(:lib_names => "com.amazonaws").count
  result[1] << Apk.where(:lib_names.ne => "com.amazonaws").where(:eid.in => aws.keys).count
  result[1] << Apk.where(:lib_names.ne => "com.amazonaws").where(:eid.nin => aws.keys).count
  result[1] << Apk.where(:lib_names.ne => "com.amazonaws").count
  result[2] << Apk.where(:eid.in => aws.keys).count
  result[2] << Apk.where(:eid.nin => aws.keys).count
  result[2] << Apk.count

  result
end

def old_get_apps_by_token
  aws = {}

  results = Source.tire.search(:per_page => 100000) do
    query     { string 'AKIA*', :default_field => :lines, :default_operator => 'AND' }
    fields    :apk_eid, :path, :lines
  end

  results.each do |source|
    source.lines.each do |line|
      if line =~ /\b(AKIA[0-9A-Z]{16})\b/
        aws[$1] ||= {}
        aws[$1][source.apk_eid] ||= {}
        aws[$1][source.apk_eid][source.path] ||= 0
        aws[$1][source.apk_eid][source.path] += 1
      end
    end
  end
  aws
  #  aws.sort_by { |k,v| v.count }.reverse
end


def get_apps_by_token
  aws = {}

  results = Source.tire.search(:per_page => 100000) do
    query     { string 'AKIA*', :default_field => :lines, :default_operator => 'AND' }
    fields    :apk_eid, :path, :lines
  end

  results.each do |source|
    key = nil
    secret = nil
    source.lines.each do |line|
      if line =~ /\b(AKIA[0-9A-Z]{16})\b/
        key = $1
        aws[key] ||= {}
        aws[key][:key] = $1
        aws[key][:apps] ||= {}
        aws[key][:apps][source.apk_eid] = true
      end
      if line =~ /"([^",() ]{40})"/
        s = $1
        if s =~ /[0-9]/ && s =~ /([A-Z].*){4}/ && s =~ /([a-z].*){4}/
          secret = s
        end
      end
    end
    unless key.nil?
      aws[key][:secret] = secret
    end
  end
  aws.each do |k,v|
    aws[k][:popular]              = 0
    aws[k][:nonpopular]           = 0
    aws[k][:popular_downloads]    = 0
    aws[k][:nonpopular_downloads] = 0
    aws[k][:total]                = 0
    aws[k][:total_downloads]      = 0
    v[:apps].keys.each do |apk_eid|
      downloads = Apk.find_by_eid(apk_eid).downloads
      if downloads >= 50000
        aws[k][:popular] += 1
        aws[k][:popular_downloads] += downloads
      else
        aws[k][:nonpopular] += 1
        aws[k][:nonpopular_downloads] += downloads
      end
      aws[k][:total] += 1
      aws[k][:total_downloads] += downloads
    end
  end
  #  aws.sort_by { |k,v| v.count }.reverse
  aws
end

# http://googleplaywith.me/packages/com.spdreality.SpeedReality-5/t.java
#
 #abt = get_apps_by_token
 #aws.select { |k,v| v[:key] == abt[0][0] }
 #aws.select { |k,v| v[:key] == abt[1][0] }
 #etc..


require 'aws-sdk'

def test_aws_keys (key, secret)

  creds = {
    :access_key_id     => key,
    :secret_access_key => secret
  }

  result = {
    :access_key_id     => key,
    :secret_access_key => secret,
    :valid             => false,
    :s3_active         => false,
    :ec2_active        => false,
    :s3_buckets        => nil,
    :ec2_instances     => nil,
    :s3_error          => nil,
    :ec2_error         => nil,
  }

  begin
    result[:s3_buckets] = AWS::S3.new(creds).buckets.count
    result[:s3_active] = true
    result[:valid] = true
  rescue AWS::S3::Errors::InvalidAccessKeyId => e
    result[:s3_error] = e.to_s
  rescue AWS::S3::Errors::SignatureDoesNotMatch => e
    result[:s3_error] = e.to_s
  rescue AWS::S3::Errors::AccessDenied => e
    result[:s3_error] = e.to_s
    result[:valid] = true
  rescue AWS::S3::Errors::NotSignedUp => e
    result[:s3_error] = e.to_s
    result[:valid] = true
  end

  begin
    result[:ec2_instances] = AWS::EC2.new(creds).instances.count
    result[:ec2_active] = true
    result[:valid] = true
  rescue AWS::EC2::Errors::AuthFailure => e
    result[:ec2_error] = e.to_s
  rescue AWS::EC2::Errors::InvalidAccessKeyId => e
    result[:ec2_error] = e.to_s
  rescue AWS::EC2::Errors::SignatureDoesNotMatch => e
    result[:ec2_error] = e.to_s
  rescue AWS::EC2::Errors::UnauthorizedOperation => e
    result[:ec2_error] = e.to_s
    result[:valid] = true
  rescue AWS::EC2::Errors::OptInRequired => e
    result[:ec2_error] = e.to_s
    result[:valid] = true
  end
  result
end

def get_key_info (abt = nil)
  if abt.nil?
    abt = get_apps_by_token
  end
  abt.select { |k,v| v[:secret] }.map { |k,v| test_aws_keys k, v[:secret] }
end

# livenation
# com.mobileroadie.RSOfficial-4710
# AKIAIJPLZTZM5WGAXGCA
# ILZln8gl4rNLmkm8jEwWlINDs2RiWlfgzfL5WjIb
# 87 S3 buckets, 48 EC2 instances

require 'csv'

def keysout (keyinfo = nil)
  if keyinfo.nil?
    keyinfo = get_key_info
  end
  CSV.open("awskeys.csv", "wb") do |csv|
    keyinfo.each do |x|
      csv << x.values
    end
  end
end

def csvout
  CSV.open("aws.csv", "wb") do |csv|
    aws = get_aws_tokens
    aws.each do |k,v|
      csv << [ v[:key], v[:secret], k, v[:file] ]
    end
  end
end

def table_to_csv (filename, table_array)
  CSV.open(filename, "wb") do |csv|
    table_array.each do |row|
      csv << row
    end
  end
end
                                      #(without / with duplicate tokens)
                               #popular apps | non popular apps | entire market
#AWS tokens with no secret      9    /     9 | 21     /      26 | 28    /    35
#AWS tokens with the secret     38   /    83 | 179    /     455 | 207   /   538

def table1 (abt = nil)
  if abt.nil?
    abt = get_apps_by_token
  end
  nosecret = abt.select { |k,v| v[:secret].nil? }
  secret   = abt.reject { |k,v| v[:secret].nil? }

  puts "\t\t\tpopular apps | non popular apps | entire market"

  print "AWS tokens with no secret\t"

  # number of tokens without a secret used by popular apps
  print nosecret.select { |k,v| v[:popular] > 0 }.count
  print " / "
  # number of popular apps using a token without a secret
  print nosecret.reduce(0) { |total,kv| total += kv.last[:popular] }

  print "\t\t"

  # number of tokens without a secret used by nonpopular apps
  print nosecret.select { |k,v| v[:nonpopular] > 0 }.count
  print " / "
  # number of nonpopular apps using a token without a secret
  print nosecret.reduce(0) { |total,kv| total += kv.last[:nonpopular] }

  print "\t\t"

  # number of tokens without a secret used by entire market
  print nosecret.select { |k,v| v[:total] > 0 }.count
  print " / "
  # number of apps using a token without a secret
  print nosecret.reduce(0) { |total,kv| total += kv.last[:total] }

  puts
  print "AWS tokens with the secret\t"

  # number of tokens with a secret used by popular apps
  print secret.select { |k,v| v[:popular] > 0 }.count
  print " / "
  # number of popular apps using a token with a secret
  print secret.reduce(0) { |total,kv| total += kv.last[:popular] }

  print "\t\t"

  # number of tokens with a secret used by nonpopular apps
  print secret.select { |k,v| v[:nonpopular] > 0 }.count
  print " / "
  # number of nonpopular apps using a token with a secret
  print secret.reduce(0) { |total,kv| total += kv.last[:nonpopular] }

  print "\t\t"

  # number of tokens with a secret used by entire market
  print secret.select { |k,v| v[:total] > 0 }.count
  print " / "
  # number of apps using a token with a secret
  print secret.reduce(0) { |total,kv| total += kv.last[:total] }

  puts
end

def table_helper_2 (array, rows, cols, unique)
  result = []
  rows.each do |row|
    result << []
    cols.each do |col|
      if unique
        result.last << array.select { |x| x[row] and x[col] > 0 }.count
      else
        result.last << array.select { |x| x[row] }.reduce(0) { |total,x| total += x[col] }
      end
    end
  end
  result
end

def table_helper (keyinfo, unique = false)

  rowheaders = ["valid tokens", "with S3", "with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]

  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      if unique
        result.last << keyinfo.select { |x| x[status] and x[popcount] > 0 }.count
      else
        result.last << keyinfo.select { |x| x[status] }.reduce(0) { |total,x| total += x[popcount] }
      end
    end
  end

  result
end

def load_key_info (abt = nil)
  keyinfo = nil
  File.open "awskeys.yaml" do |file|
    keyinfo = YAML::load(file)
  end
  if abt.nil?
    abt = get_apps_by_token
  end
  keyinfo.each do |x|
    [:popular, :nonpopular, :total, :popular_downloads, :nonpopular_downloads, :total_downloads].each do |field|
      x[field] = abt[x[:access_key_id]][field]
    end
  end
  keyinfo
end

def do_tables (keyinfo = nil, abt = nil)
  if keyinfo.nil?
    File.open "awskeys.yaml" do |file|
      keyinfo = YAML::load(file)
    end
  end
  if abt.nil?
    abt = get_apps_by_token
  end
  keyinfo.each do |x|
    [:popular, :nonpopular, :total, :popular_downloads, :nonpopular_downloads, :total_downloads].each do |field|

      x[field] = abt[x[:access_key_id]][field]
      #x[:popular]    = abt[x[:access_key_id]][:popular]
      #x[:nonpopular] = abt[x[:access_key_id]][:nonpopular]
      #x[:total]      = abt[x[:access_key_id]][:total]
      #x[:popular]    = abt[x[:access_key_id]][:popular]
      #x[:nonpopular] = abt[x[:access_key_id]][:nonpopular]
      #x[:total]      = abt[x[:access_key_id]][:total]
    end
  end

  result = table_helper keyinfo, false
  table_to_csv "table_aws_tokens.csv", result

  result = table_helper keyinfo, true
  table_to_csv "table_aws_tokens_unique.csv", result

  without_top5 = keyinfo.sort_by { |x| x[:total] }.reverse.slice(5 .. -1)

  result = table_helper without_top5, false
  table_to_csv "table_aws_tokens_without_top5.csv", result

  result = table_helper without_top5, true
  table_to_csv "table_aws_tokens_without_top5_unique.csv", result

  without_top5_most_downloads = keyinfo.sort_by { |x| x[:total_downloads] }.reverse.slice(5 .. -1)

  result = table_helper without_top5_most_downloads, false
  table_to_csv "table_aws_tokens_without_most_downloads_top5.csv", result

  result = table_helper without_top5_most_downloads, true
  table_to_csv "table_aws_tokens_without_most_downloads_top5_unique.csv", result

  result = table_helper_2 keyinfo, [:valid, :s3_active, :ec2_active], [:nonpopular_downloads, :popular_downloads, :total_downloads], false
  table_to_csv "table_aws_download_counts.csv", result
end


def old_stuff

                               #popular apps | non popular apps | entire market
#AWS tokens
#AWS tokens with S3
#AWS tokens with EC2

  rowheaders = ["AWS tokens (valid)", "AWS tokens with S3", "AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << keyinfo.select { |x| x[status] }.reduce(0) { |total,x| total += x[popcount] }
    end
  end
  table_to_csv "table_aws_tokens.csv", result

                               #popular apps | non popular apps | entire market
#unique AWS tokens (valid)
#unique AWS tokens with S3
#unique AWS tokens with EC2

  rowheaders = ["Unique AWS tokens (valid)", "Unique AWS tokens with S3", "Unique AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << keyinfo.select { |x| x[status] and x[popcount] > 0 }.count
    end
  end
  table_to_csv "table_aws_unique_tokens.csv", result

  # EXCLUDE TOP 5 AWS TOKENS (by # of apps using that token)
                               #popular apps | non popular apps | entire market
#unique excluding top 5 AWS tokens
#unique excluding top 5 AWS tokens with S3
#unique excluding top 5 AWS tokens with EC2
  topn = 5
  without_topn = keyinfo.sort_by{ |x| x[:total] }.reverse.slice(topn..-1)

  rowheaders = ["AWS tokens (valid)", "AWS tokens with S3", "AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << without_topn.select { |x| x[status] }.reduce(0) { |total,x| total += x[popcount] }
    end
  end
  table_to_csv "table_aws_tokens_without_top5.csv", result
  
  rowheaders = ["Unique AWS tokens (valid)", "Unique AWS tokens with S3", "Unique AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << without_topn.select { |x| x[status] and x[popcount] > 0 }.count
    end
  end
  table_to_csv "table_aws_unique_tokens_without_top5.csv", result
 
  # EXCLUDE TOP 5 AWS TOKENS (by number of downloads of apps using that token)
                               #popular apps | non popular apps | entire market
#unique excluding top 5 AWS tokens
#unique excluding top 5 AWS tokens with S3
#unique excluding top 5 AWS tokens with EC2
  topn = 5
  without_topn_by_downloads = keyinfo.sort_by{ |x| x[:total_downloads] }.reverse.slice(topn..-1)

  rowheaders = ["AWS tokens (valid)", "AWS tokens with S3", "AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << without_topn_by_downloads.select { |x| x[status] }.reduce(0) { |total,x| total += x[popcount] }
    end
  end
  table_to_csv "table_aws_tokens_without_top5_by_downloads.csv", result
  
  rowheaders = ["Unique AWS tokens (valid)", "Unique AWS tokens with S3", "Unique AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << without_topn_by_downloads.select { |x| x[status] and x[popcount] > 0 }.count
    end
  end
  table_to_csv "table_aws_unique_tokens_without_top5_by_downloads.csv", result


  # TOP 5 ONLY
                               #popular apps | non popular apps | entire market
#unique excluding top 5 AWS tokens
#unique excluding top 5 AWS tokens with S3
#unique excluding top 5 AWS tokens with EC2
  only_topn = keyinfo.sort_by{ |x| x[:total] }.reverse.slice(0..topn-1)

  rowheaders = ["AWS tokens (valid)", "AWS tokens with S3", "AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << only_topn.select { |x| x[status] }.reduce(0) { |total,x| total += x[popcount] }
    end
  end
  table_to_csv "table_aws_tokens_only_top5.csv", result

  rowheaders = ["Unique AWS tokens (valid)", "Unique AWS tokens with S3", "Unique AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << only_topn.select { |x| x[status] and x[popcount] > 0 }.count
    end
  end
  table_to_csv "table_aws_unique_tokens_only_top5.csv", result

  # exposed amazon resources
  rowheaders = ["S3 buckets", "EC2 instances"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:s3_buckets, :ec2_instances].each do |resource|
    result << rowheaders.slice!(0..0)
    [:nonpopular, :popular, :total].each do |popcount|
      result.last << keyinfo.select { |x| x[resource] and x[popcount] > 0 }.reduce(0) { |total,x| total += x[resource] }
    end
  end
  table_to_csv "aws_resources_table.csv", result

  # range of the issue - total downloads
  rowheaders = ["AWS tokens (valid)", "AWS tokens with S3", "AWS tokens with EC2"]
  result = []
  result << [nil, "Non-popular Apps", "Popular Apps", "Entire Market"]
  [:valid, :s3_active, :ec2_active].each do |status|
    result << rowheaders.slice!(0..0)
    [:nonpopular_downloads, :popular_downloads, :total_downloads].each do |downloads|
      result.last << keyinfo.select { |x| x[status] }.reduce(0) { |total,x| total += x[downloads] }
    end
  end
  table_to_csv "aws_tokens_downloaded_table.csv", result

  only_topn
end

#(top5):
#Token Name | number of tokens
#socialgame | 120
#...



