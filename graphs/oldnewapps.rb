#!../script/rails runner

def money_stats(es_connection, index)
  Thread.current[:es_connection] = nil
  ENV['ELASTICSEARCH_URL'] = es_connection

  result = App.index(:latest).search({
    :size => 0,
    :query => {:term => { :free => false }},
    :facets => {
      :min_money => {
        :statistical => {
          :script => "doc['price'].value + doc['downloads'].value"
        }
      },
      :max_money => {
        :statistical => {
          :script => "doc['price'].value + doc['downloads_max'].value"
        }
      }
    }
  })

  { :min_money => result[:facets][:min_money][:total],
    :max_money => result[:facets][:max_money][:total] }
end

def __lookup_app_stats(es_connection, index, query)
  Thread.current[:es_connection] = nil
  ENV['ELASTICSEARCH_URL'] = es_connection

  result = App.index(:latest).search({
    :size => 0,
    :query => query,
    :facets => {
      :min_dl => {
        :statistical => { :field => :downloads },
      },
      :max_dl => {
        :statistical => { :field => :downloads_max },
      },
    }
  })

  { :count  => result[:facets][:min_dl][:count],
    :min_dl => result[:facets][:min_dl][:total],
    :max_dl => result[:facets][:max_dl][:total] }
end

def _lookup_app_stats(es_connection, index)
  r = {
    :free => __lookup_app_stats(es_connection, index, {:term => { :free => true }}),
    :paid => __lookup_app_stats(es_connection, index, {:term => { :free => false }})
  }
  r.merge!({
    :total => Hash[r[:free].keys.zip(r[:free].values.zip(r[:paid].values).map(&:sum))]
  })
  r[:paid].merge!(money_stats(es_connection, index))
  r
end

def lookup_app_stats
  {
    :old => _lookup_app_stats(ENV['ELASTICSEARCH_URL_OLD'], '2013-06-22'),
    :new => _lookup_app_stats(ENV['ELASTICSEARCH_URL_NEW'], :latest)
  }
end

def dl(dl)
  dl = dl.to_i
  return "#{dl}" if dl < 1_000
  dl /= 1000
  return "#{dl}k" if dl < 1_000
  dl /= 1000
  return "#{dl}M" if dl < 1_000
  dl /= 1000
  return "#{dl}G" if dl < 1_000
  dl /= 1000
  return "#{dl}T" if dl < 1_000
end

def p(old, new)
  sprintf('%.0f', 100*(new.to_f/old-1))
end

data = lookup_app_stats

# Latex generation
puts ERB.new(<<-ERB.gsub(/^\s+<%/, '<%').gsub(/^ {4}/, ''), nil, '-').result(binding)

\\begin{table}[t]
\\small
\\begin{tabular}{|l|l|l|} \\hline

                                           & June 22nd 2013               & Nov 30th 2013  \\\\ \\hline\\hline
Number of free apps                        & #{data[:old][:free][:count]} &
                                             #{data[:new][:free][:count]} \\hfill (+#{p(data[:old][:free][:count], data[:new][:free][:count])}\\%) \\\\ \\hline

Number of paid apps                        & #{data[:old][:paid][:count]} &
                                             #{data[:new][:paid][:count]} \\hfill (+#{p(data[:old][:paid][:count], data[:new][:paid][:count])}\\%) \\\\ \\hline

Total number of apps                       & #{data[:old][:total][:count]} &
                                             #{data[:new][:total][:count]} \\hfill (+#{p(data[:old][:total][:count], data[:new][:total][:count])}\\%) \\\\ \\hline

Cumulative downloads free apps (min-max)   & #{dl(data[:old][:free][:min_dl])}-#{dl(data[:old][:free][:max_dl])}   &
                                             #{dl(data[:new][:free][:min_dl])}-#{dl(data[:new][:free][:max_dl])}   \\hfill (+#{p(data[:old][:free][:min_dl], data[:new][:free][:min_dl])}\\%) \\\\ \\hline

Cumulative downloads paid apps (min-max)   & #{dl(data[:old][:paid][:min_dl])}-#{dl(data[:old][:paid][:max_dl])}   &
                                             #{dl(data[:new][:paid][:min_dl])}-#{dl(data[:new][:paid][:max_dl])}   \\hfill (+#{p(data[:old][:paid][:min_dl], data[:new][:paid][:min_dl])}\\%) \\\\ \\hline

Total cumulative downloads (min-max)       & #{dl(data[:old][:total][:min_dl])}-#{dl(data[:old][:total][:max_dl])} &
                                             #{dl(data[:new][:total][:min_dl])}-#{dl(data[:new][:total][:max_dl])} \\hfill (+#{p(data[:old][:total][:min_dl], data[:new][:total][:min_dl])}\\%) \\\\ \\hline

Google revenues (min-max)                  & #{dl(data[:old][:paid][:min_money]*0.3)}-#{dl(data[:old][:paid][:max_money]*0.3)} &
                                             #{dl(data[:new][:paid][:min_money]*0.3)}-#{dl(data[:new][:paid][:max_money]*0.3)} \\hfill (+#{p(data[:old][:paid][:min_money], data[:new][:paid][:min_money])}\\%) \\\\ \\hline

Developer revenues (min-max)               & #{dl(data[:old][:paid][:min_money]*0.7)}-#{dl(data[:old][:paid][:max_money]*0.7)} &
                                             #{dl(data[:new][:paid][:min_money]*0.7)}-#{dl(data[:new][:paid][:max_money]*0.7)} \\hfill (+#{p(data[:old][:paid][:min_money], data[:new][:paid][:min_money])}\\%) \\\\ \\hline

Paid apps total revenue (min-max)          & #{dl(data[:old][:paid][:min_money])}-#{dl(data[:old][:paid][:max_money])} &
                                             #{dl(data[:new][:paid][:min_money])}-#{dl(data[:new][:paid][:max_money])} \\hfill (+#{p(data[:old][:paid][:min_money], data[:new][:paid][:min_money])}\\%) \\\\ \\hline

\\end{tabular}
\\caption{Evolution of the market from June 22nd 2013 to Nov 30th 2013}
\\label{tab:freepaid}
\\end{table}
ERB
