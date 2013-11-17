#!../script/rails runner

require 'stretcher'
require 'multi_json'
require 'pry'

def save_to_file(results, filename)
  File.open(filename, 'w') do |f|
    f.write(MultiJson.dump(results, :pretty => true))
  end
end

def app_id_match?(id1, id2)
  if id1.length < id2.length
    return id2.include? id1
  else
    return id1.include? id2
  end
end

def calc_junk(facets, months)
  junk = 0
  for i in 0 .. (facets.length - (1 + months))
    junk += facets[i][1]
  end 
  junk
end

server = Stretcher::Server.new('http://ed:yay!!!@home.viennot.biz:8000/')
"
res = server.index('live').search(
  size: 0,
  query: {
    match_all: {} 
  },
  facets: {
    wow_facet: {
      query: {
        term: { 
          developer_name: 'DMZ' 
        }
      }
    }
  }
)
"

res = server.index('2013-06-22').search(from: 0, size: 1, 
			      query: {match_all: {} })

puts "total apps found = #{res.total}"
"
res = server.index('2013-06-22').search(
    :size => 10, 
    :query => { :match_all => {} },
    :facets => {
      :junk => {
        :date_histogram => {
          :key_field => :uploaded_at,
          :interval => :month
        }
      },
    }
  )
"
res = server.index("2013-06-22").search(
    size: 10, 
    facets: {
      junk: {
        date_histogram: {
          key_field: "uploaded_at",
#	  value_script: "(doc['downloads'].value <= 100) && (doc['star_rating'].value < 2.5) ? 1 : 0",
	   value_script: "(doc['downloads'].value <= 100) ? 1 : 0",
          interval: "month"
        }
      },
    }
  )



#puts res

#apps = res.results
#apps.sort!{|x,y| y._id <=> x._id}
#puts "total apps found = "#{apps.count}"
#apps.map { |app|
#  printf "%-20s %-8s %-30s %-30s\n", app.developer_name, app.free, app.title, app._id


#puts res

#apps = res.results
#apps.sort!{|x,y| y._id <=> x._id}
#puts "total apps found = "#{apps.count}"
#apps.map { |app|
#  printf "%-20s %-8s %-30s %-30s\n", app.developer_name, app.free, app.title, app._id
#}
puts "---------------------------------------------\n"
#puts res.facets.free['entries'].size
puts res.facets.junk['entries'].size

facets = Array.new
total_count = 0
junk_count = 0 
res.facets.junk['entries'].each{ |interval|
	facets.push( [Time.at(interval['time']/1000), interval['total'].to_i, interval['count']])  
	total_count += interval['count']
	junk_count += interval['total'].to_i
}

puts "junk at 12 months #{calc_junk(facets, 12)}"
puts "junk at 11 months #{calc_junk(facets, 11)}"
puts "junk at 10 months #{calc_junk(facets, 10)}"
puts "junk at 9 months #{calc_junk(facets, 9)}"
puts "junk at 6 months #{calc_junk(facets, 6)}"
puts "junk at 3 months #{calc_junk(facets, 3)}"
puts "junk at 1 months #{calc_junk(facets, 1)}"
puts "junk at 0 months #{calc_junk(facets, 0)}"

binding.pry
#save_to_file(dups,'test_dups')
