require 'stretcher'
require 'multi_json'
require 'redis'

def connect_to_server()
  server = Stretcher::Server.new('http://ed:yay!!!@home.viennot.biz:8000/')
  server
end

def load_from_file(filename)
  MultiJson.load(File.open(filename), :symbolize_keys => true)
end

def save_to_file(results, filename)
  File.open(filename, 'w') do |f|
	f.write(MultiJson.dump(results, :pretty => true))
  end
end

def create_hash(prefix, similar, r)
  pairs = Hash.new(0)
  similar.each_key{|victim|
    apps = r.hget(prefix, victim.to_s, 0, -1)
    if !apps.empty?
      pairs[victim] = apps
    end
  }
  pairs
end

es = connect_to_server
r = Redis.new
similar = load_from_file("/home/Eddy/playdrone/google-play-crawler/ideas/merged_300_0.8_10")
count = 0

similar.each_pair{|victim, dups|

  if r.hexists("rebranded", victim) or r.hexists("cloned", victim)
    next
  end

  res = es.index('latest').search(size: 1, filter: {query: {term: {_id: victim}}})
  if res.total > 0
    rebranded_temp = []
    cloned_temp = []
    victim_metadata = res.results[0]
    dups.each {|dup|
      res = es.index('latest').search(size: 1, filter: {query: {term: {_id: dup}}})
      if res.total > 0
        dup_metadata = res.results[0]
        if victim_metadata[:developer_name] == dup_metadata[:developer_name]
          rebranded_temp.push(dup)
        else
          cloned_temp.push(dup)
        end
      end
    }
    if !rebranded_temp.empty?
      r.hset("rebranded", victim, rebranded_temp.to_json)
    end

    if !cloned_temp.empty?
      r.hset("cloned", victim, cloned_temp.to_json)
    end

  end
  count += 1
  
#  if count > 0
#    break
#  end
}

puts "total processed = " + count.to_s

cloned = r.hgetall("cloned")
rebranded = r.hgetall("rebranded")


save_to_file(cloned, "cloned.json")
save_to_file(rebranded, "rebranded.json")
