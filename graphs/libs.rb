#!../script/rails runner

libs = {
  'Advertising Platform' =>
  [
    'Google Ads',
    'Google Analytics',
    'Millennial Media Ads',
    'LeadBolt',
    'Flurry',
    'MobFox',
    'InMobi',
    'RevMob',
    'AirPush',
    'Urban Airship Push',
    'Mobclix',
    'SendDroid',
    'Smaato',
    'Adfonic',
    'Jumptap',
    'HuntMads',
    'Umeng',
    'AppLovin',
    'TapIt',
    'MoPub',
    'TapJoy',
  ],
  'Social' =>
  [
    'Facebook SDK',
    'Twitter4J',
  ],
  'Cross-Platform Framework' =>
  [
    'PhoneGap',
    'Adobe Air',
    'Appcelerator Titanium',
  ],
  'Application Generator' =>
  [
    'App Inventor',
    'Bizness Apps',
    'Andromo',
    'Mobile by Conduit',
    'iBuildApp',
  ],
  'Bug Tracking' =>
  [
    'BugSense',
    'Acra',
  ],
  'Billing' =>
  [
    'Google InApp Billing',
    'Paypal',
    'Authorize.net',
    'Amazon In-App Purchasing',
  ],
  'Audtion/Graphics Engine' =>
  [
    'FMOD',
    'libGDX',
    'Unity3D',
    'AndEngine',
    'Corona SDK',
  ],
}

def get_libs_count(libs=nil, options={})
  libs = [*libs].map { |l| Stack::FindLibraries.matchers_for(l) }.flatten.uniq
  libs_clause = { :bool => { :should => libs.map { |l| { :term => { :library  => l } } },
                                        :minimum_should_match => 1 } }
  libs_clause = nil if libs.empty?

  App.index(:latest).search(
    :size => 0,

    :query => { :bool => { :must => (
      [{ :term =>  { :decompiled => true } }] +
      [libs_clause] +
      [options[:filter]]
    ).compact } },
  )
end

dl_ranges = [{:range => {:downloads => { :to   => 50_000, :include_upper => false } } },
             {:range => {:downloads => { :from => 50_000, :include_lower => true } } }]

$num_non_popular, $num_popular = dl_ranges.map do |download_range|
  get_libs_count(nil, :filter => download_range).total
end

$non_popular, $popular = dl_ranges.map do |download_range|
  results = {}

  libs.each do |category, in_cat_libs|
    results[category] ||= {}
    in_cat_libs.each do |lib|
      results[category][lib] = get_libs_count(lib, :filter => download_range).total
    end
    results[category]['Total'] = get_libs_count(in_cat_libs, :filter => download_range).total
  end

  results
end

libs.keys.each do |category|
  libs[category].sort_by! do |lib|
    -($non_popular[category][lib] + $popular[category][lib])
  end
end

def tex_row(category, lib, bold=false)
  "#{bold ? "\\bf " : ""}#{lib} & "+
  "#{$non_popular[category][lib]} \\hfill (#{"%2.2f" % [100 * $non_popular[category][lib] / $num_non_popular.to_f]}\\%) & " +
  "#{    $popular[category][lib]} \\hfill (#{"%2.2f" % [100 *     $popular[category][lib] /     $num_popular.to_f]}\\%) " +
  "\\\\ \\hline"
end

if ARGV[0].nil?
  # Latex generation
  puts ERB.new(<<-ERB.gsub(/^\s+<%/, '<%').gsub(/^ {4}/, ''), nil, '-').result(binding)
    \\begin{table}[t]
    \\small
    \\begin{tabular}{|l|l|l|}

    <% libs.keys.each do |category| -%>
    \\\multicolumn{3}{c}{} \\\\
    \\multicolumn{3}{c}{\\bf <%= category %>} \\\\ \\hline
    {\\bf Name} & {\\bf Non popular Apps} & {\\bf Popular Apps} \\\\ \\hline

    <% libs[category].each do |lib| -%>
      <%= tex_row(category, lib) %>
    <% end -%>
    <%= tex_row(category, "Total", true) %>

    <% end -%>

    \\end{tabular}
    \\caption{Library Breakdown for free apps}
    \\label{tab:libs}
    \\end{table}
  ERB
  exit
end
