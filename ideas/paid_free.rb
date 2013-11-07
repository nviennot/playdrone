require 'stretcher'
require 'multi_json'
require 'text'

LEVEN_THRESHOLD = 0.25

def connect_to_server()
  server = Stretcher::Server.new('http://ed:yay!!!@home.viennot.biz:8000/')
  server
end

def save_to_file(results, filename)
  File.open(filename, 'w') do |f|
    f.write(MultiJson.dump(results, :pretty => true))
  end
end

def app_leven_match?(app1, app2)
  id_leven = Text::Levenshtein.distance(app1._id, app2._id)
  title_leven = Text::Levenshtein.distance(app1.title, app2.title)
  id_length = app1._id.length < app2._id.length ? app2._id.length : app1._id.length
  title_length = app1.title.length < app2.title.length ? app2.title.length : app1.title.length
  if title_leven.fdiv(title_length) < LEVEN_THRESHOLD and id_leven.fdiv(id_length) < LEVEN_THRESHOLD
    return true
  else
    return false
  end
end

def app_titles_match?(title1, title2)
  title1_freq = tokenizeTitle(title1)
  title2_freq = tokenizeTitle(title2)

  common_count = 0
  threshold = (title2_freq.length/2)
  title2_freq.keys.each{ |word|
    if title1_freq.has_key?(word)
      common_count += 1
      #if more than half the words are common, return true 
      if common_count > threshold
        return true
      end
    end
  }

  return false
end

def tokenizeTitle(title)
  words = title.downcase.split(" ")
  freqs = Hash.new(0)
  words.each { |word| freqs[word] += 1 }
  freqs
end

def app_str_match?(id1, id2)
  if id1.length < id2.length
    return id2.downcase.include?(id1.downcase)
  else
    return id1.downcase.include?(id2.downcase)
  end
end

def best_id_match(possible_dups)
  best_match = possible_dups[0]
  possible_dups.each{ |dup|
    if dup.length >  best_match.length
      best_match = dup
    end
  }
  best_match
end

def print_dup_array(dup_arr)
  puts "======================================"
  dup_arr.map{ |pair|
    pair.map {|app| printf "%-20s free?=%-8s %-30s %-30s\n", app.developer_name, app.free, app.title, app._id}
  puts "--------------------------------------"
  }
end

def print_author_app(auth_app)
  auth_app.each_value{ |arr|
    puts "===" + arr[0].developer_name
    arr.sort!{|x,y| y.title <=> x.title}
    arr.each{ |app|
      puts "\t---" + app.free.to_s + " " + app.title
    }
  }
end

t1= Time.now
server = connect_to_server() 

#get all the paid apps => price > 0

paid_apps = []
author_app = {}
app_res_size = 1000
app_index = 0
search_count = 0

#make a list of application clusters with 1 paid app
res = server.index('latest').search(from: app_index, size: 1, filter: {range: {price:{ gt: 0} }})

#gets list of unique apps
for i in 1..(res.total/app_res_size) do
#for i in 1..4 do
  res = server.index('latest').search(from: app_index, size: app_res_size,
                                    filter: {range: {price:{ gt: 0} }})
  paid_apps.concat(res.results)
  app_index = app_index + app_res_size
  search_count += 1
end


puts "total apps found = #{res.total}"
puts "total apps downloaded = #{paid_apps.length}"

save_to_file(paid_apps, "paid_apps.json")

auth_total = 0
# finds developers with paid apps and matches them to an array of all their apps
paid_apps.each do |app|

  if author_app.has_key?(app.developer_name)
    next
  end
  
  res = server.index('latest').search(size: 10000, query: {term: {developer_name: app.developer_name }})
#  res = server.index('live').search(size: 10000, filter:
#                                   {developer_name: app.developer_name })
  apps_by_author_array = []

  #for each paid application search to find other applications by same author
  res.results.each do |app_by_author|
#    if app_by_author.developer_name == app.developer_name
      apps_by_author_array.push(app_by_author)
#    end

  end

  auth_total += res.total
  search_count += 1
  #creates a hash with author name and the array of app objects
  author_app[app.developer_name] = apps_by_author_array
end

free_paid_dups_id = []
free_paid_dups_title = []
free_paid_dups_leven = []

total_apps = 0
dups = Hash.new(0) 
#  app_arr.map { |app| 
#    printf "%20s %8s %30s %30s\n", app.developer_name, app.free, app.title, app._id
#    #puts "#{app.developer_name} #{app.free} #{app.title}" 
#  }
#    puts "---------------------------------------------\n"
#  total_apps = total_apps + app_arr.count
#}
"
author_app.each_value { |app_arr|
  del_hash = Hash.new(0)
  total_apps = total_apps + app_arr.count

  app_arr.sort!{|x,y| y._id <=> x._id}
  for i in 0 .. (app_arr.length-1)
    for k in (i+1) .. (app_arr.length-1)
      if app_arr[k].free == app_arr[i].free
      #we are only interested in matches where one app is free and the other
      #is paid
      next
      elsif app_str_match?(app_arr[i]._id, app_arr[k]._id) and
              app_titles_match?(app_arr[i].title, app_arr[k].title)
        free_paid_dups_id.push([app_arr[i], app_arr[k]])
        dups[app_arr[i]] += 1
        dups[app_arr[k]] += 1
        del_hash[app_arr[i]] += 1
        del_hash[app_arr[k]] += 1
        break
      end
    end
  end

  del_hash.each_key {|key| app_arr.delete(key) }
  del_hash.clear

  app_arr.sort!{|x,y| y.title <=> x.title}
  for i in 0 .. (app_arr.length-1)
    for k in (i+1) .. (app_arr.length-1)
      if app_arr[k].free == app_arr[i].free
      #we are only interested in matches where one app is free and the other
      #is paid
      next
      elsif app_str_match?(app_arr[i].title, app_arr[k].title)
        free_paid_dups_title.push([app_arr[i], app_arr[k]])
        dups[app_arr[i]] += 1
        dups[app_arr[k]] += 1
        del_hash[app_arr[i]] += 1
        del_hash[app_arr[k]] += 1
        break
      end
    end
  end

  del_hash.each_key {|key| app_arr.delete(key) }
  del_hash.clear

  app_arr.sort!{|x,y| y._id <=> x._id}
  for i in 0 .. (app_arr.length-1)
    for k in (i+1) .. (app_arr.length-1)
      if app_arr[k].free == app_arr[i].free
      #we are only interested in matches where one app is free and the other
      #is paid
      next
      elsif app_leven_match?(app_arr[i], app_arr[k])
        free_paid_dups_leven.push([app_arr[i], app_arr[k]])
        dups[app_arr[i]] += 1
        dups[app_arr[k]] += 1
        break
      end
    end
  end

}
"
#print_author_app(author_app)
#print_dup_array(free_paid_dups_id)
#print_dup_array(free_paid_dups_title)
#print_dup_array(free_paid_dups_leven)
#save_to_file(free_paid_dups, "free_paid_dups.json")
save_to_file(author_app, "paid_auth_apps.json")

puts "total different authors = " + author_app.count.to_s
puts "total dups = " + (free_paid_dups_id.count + free_paid_dups_title.count + free_paid_dups_leven.count).to_s
puts "total unique dups = " + dups.count.to_s
puts "total apps = " + total_apps.to_s
puts "total res apps = " + auth_total.to_s
puts "search count = " + search_count.to_s
puts "dups form id analysis = " + free_paid_dups_id.count.to_s
puts "dups form title analysis = " + free_paid_dups_title.count.to_s
puts "dups form leven analysis = " + free_paid_dups_leven.count.to_s
puts "levenshtein threshold = " + LEVEN_THRESHOLD.to_s

t2 = Time.now
time = t2 - t1
puts "Time elapsed: #{time}"
puts "#{time/total_apps} seconds per app"

#save_to_file(paid_apps, "paid_apps.json")
