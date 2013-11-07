require 'stretcher'

def connect_to_server()
  server = Stretcher::Server.new('http://ed:yay!!!@home.viennot.biz:8000/')
  server
end


server = Stretcher::Server.new('http://ed:yay!!!@home.viennot.biz:8000/')

res = server.index('live').search(size: 10, query: {term: {developer_name: "Wei Tool" }})

res.results.each do |app|
  puts "#{app._id} #{app.developer_name}"

end
