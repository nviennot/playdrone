#!../script/rails runner
require 'json'
require 'pry'
require 'redis'

def save_to_file(results, filename)
  File.open(filename, 'w') do |f|
    f.write(MultiJson.dump(results, :pretty => true))
  end
end

def low_quality?(downloads, rating)
  return (downloads <= 100 and rating < 2.5)
  #return (downloads <= 100)
  #return (rating < 2.5)
end


def calc_avg_for_hash(apps, app_hash, desc) 

	rating_with_victim = []
	rating_wo_victim = []
	downloads_with_victim = []
	downloads_wo_victim = []
	not_found = 0
	low_quality = 0

	app_hash.each{|k, v|

	#	puts k
		if apps.has_key?(k) 
			if apps[k]['downloads'] >= 10000000
				puts k.to_s + " " + apps[k]['downloads'].to_s
			end
			
			if low_quality?(apps[k]['downloads'], apps[k]['star_rating'])	
				low_quality += 1
			end

			if k == v
				rating_with_victim.push(apps[k]['star_rating'])
				downloads_with_victim.push(apps[k]['downloads'])
			else
				rating_with_victim.push(apps[k]['star_rating'])
				downloads_with_victim.push(apps[k]['downloads'])
				rating_wo_victim.push(apps[k]['star_rating'])
				downloads_wo_victim.push(apps[k]['downloads'])
			end
		else
			not_found += 1
		end
	}

	calc_avg(desc.to_s + " rating_with_victim", rating_with_victim)
	calc_avg(desc.to_s + " rating_wo_victim", rating_wo_victim)
	calc_avg(desc.to_s + " downloads_with_victim", downloads_with_victim)
	calc_avg(desc.to_s + " downloads_wo_victim", downloads_wo_victim)
	puts desc.to_s + "not found = " + not_found.to_s
	puts desc.to_s + "low quality = " + low_quality.to_s + " " + (low_quality.to_f/rating_with_victim.count * 100).to_s + "%\n"
end

def calc_avg_for_all(apps, cloned, rebranded, desc) 

	rating_with_victim = []
	downloads_with_victim = []

	rating_other = []
	downloads_other = []
	all_low_quality = 0
	other_low_quality = 0

	apps.each{|k, v|
		rating_with_victim.push(apps[k]['star_rating'])
		downloads_with_victim.push(apps[k]['downloads'])
		
		if low_quality?(apps[k]['downloads'], apps[k]['star_rating'])	
			all_low_quality += 1
		end

		if !cloned.has_key?(k) and !rebranded.has_key?(k)
			rating_other.push(apps[k]['star_rating'])
			downloads_other.push(apps[k]['downloads'])
			if low_quality?(apps[k]['downloads'], apps[k]['star_rating'])	
				other_low_quality += 1
			end
		end	
	}

	calc_avg(desc.to_s + " star_rating", rating_with_victim)
	calc_avg(desc.to_s + " downloads", downloads_with_victim)
	
	puts "all low quality = " + all_low_quality.to_s + " " +  (all_low_quality.to_f/apps.count * 100).to_s +  "%\n"

	calc_avg("apps not cloned/rebranded star_rating", rating_other)
	calc_avg("apps not cloned/rebranded downloads", downloads_other)
	puts "others low quality = " + other_low_quality.to_s + " "  +  (other_low_quality.to_f/rating_with_victim.count * 100).to_s + "%\n"


binding.pry
end

def calc_avg(desc, arr)
	lowest = arr.min
	highest = arr.max
	total = arr.inject(:+)
	len = arr.length
	average = total.to_f / len # to_f so we don't get an integer result
	sorted = arr.sort
	median = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2
	puts "#{desc}"
	puts "\t lowest = #{lowest}"
	puts "\t highest = #{highest}"
	puts "\t average = #{average}"
	puts "\t median = #{median}"
	puts ""
end

def sort_by_downloads(apps, thresh, field)
	arr = apps.to_a
	arr.sort!{|x,y| y[1][field] <=> x[1][field]}
	download_frac = 0
	total_downloads = 0
	threshold = (thresh*arr.length)
	
	for i in 0 .. (arr.length - 1)
		if i < threshold
			download_frac += arr[i][1][field]
		end
		total_downloads += arr[i][1][field]
	end

	puts "top " + (thresh*100).to_s + "% of popular apps (" + threshold.to_i.to_s + ") account for " + (download_frac.to_f/total_downloads).to_s + "% of total downloads (" + download_frac.to_s + " / " + total_downloads.to_s + ")\n" 

end

#apps = JSON.parse( IO.read('apps_6_22') )
#apps = JSON.parse( IO.read('apps_11_30') )
apps = JSON.parse( IO.read('latest_apps') )
#cloned = JSON.parse( IO.read('cloned2.json') )
#rebranded = JSON.parse( IO.read('rebranded2.json') )

field = 'downloads'
sort_by_downloads(apps, 0.01, field)
sort_by_downloads(apps, 0.03, field)
sort_by_downloads(apps, 0.05, field)
sort_by_downloads(apps, 0.10, field)
sort_by_downloads(apps, 0.15, field)
sort_by_downloads(apps, 0.20, field)

#calc_avg_for_hash(apps, cloned, "cloned")
#calc_avg_for_hash(apps, rebranded, "rebranded")
#calc_avg_for_all(apps, cloned, rebranded, "all apps")

binding.pry
