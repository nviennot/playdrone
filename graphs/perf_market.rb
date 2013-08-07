#!/usr/bin/env ruby

require 'uri'
require 'json'
require 'net/http'

uri = URI([
  "http://monitor.googleplaywith.me/render?",
  "from=00%3A00_20130521",
  "until=17%3A00_20130521",

  "target=stats.market.search",
  "target=stats.market.details",
  "target=stats.market.purchase",

  "target=scale(stats.timers.market.search.mean%2C0.001)",
  "target=scale(stats.timers.market.details.mean%2C0.001)",
  "target=scale(stats.timers.market.purchase.mean%2C0.001)",

  # "target=alias(scale(derivative(sumSeries(collectd.node*.cpu-*.cpu-system.value))%2C0.001)%2C%20%22system%22)",
  # "target=alias(scale(derivative(sumSeries(collectd.node*.cpu-*.cpu-user.value))%2C0.001)%2C%20%22user%22)",
  # "target=alias(scale(derivative(sumSeries(collectd.node*.cpu-*.cpu-wait.value))%2C0.001)%2C%22iowait%22)",
  # "target=alias(scale(derivative(sumSeries(collectd.node*.cpu-*.cpu-nice.value))%2C0.001)%2C%22nice%22)",

  "format=json",
].join("&"))

req = Net::HTTP::Get.new(uri.request_uri)
req.basic_auth(*ENV['AUTH'].split(':'))
res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
result = JSON.parse(res.body)

data = {}
result.each_with_index do |r, label|
  r['datapoints'].each do |value, time|
    data[time] ||= {}
    data[time][label] = value.nil? ? "?" : value
  end
end

File.open(ARGV[0], 'w') do |f|
  data.each do |time, val|
    points = val.values
    f.puts [time, val.values].flatten.join(" ")
  end
end
