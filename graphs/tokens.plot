set terminal pdf dashed size 6,4
set output "tokens.pdf"

#set title "App categories"
set key horizontal
set key bottom center outside
# set nokey

set ylabel "Number of Tokens" offset +1, 0
set xlabel "Day" offset 0,+0.2
#set grid y

set xdata time
set timefmt "%m/%d/%y"
set xrange [ "04/27/13":"06/22/13" ]

set timefmt "%s"
set format x "%a, %d %b"

set xtics nomirror rotate by -20
#set yrange [-5000:6000]

set xtics 604800
set yrange [-5:40]


#set style fill solid border -1
#set boxwidth 86400 absolute

#set ytics 1000

set xzeroaxis lw 5 lt -1

plot 'tokens.dat' using 1:2        t 'Amazon AWS'       with lines, \
               '' using 1:3        t 'Bitly'      with lines, \
               '' using 1:4        t 'Facebook'     with lines, \
               '' using 1:5        t 'Flickr'       with lines, \
               '' using 1:6        t 'Foursquare'   with lines, \
               '' using 1:7        t 'Google'       with lines, \
               '' using 1:8        t 'Google Oauth' with lines, \
               '' using 1:9        t 'Linkedin'     with lines, \
               '' using 1:10       t 'Twitter'      with lines, \
               '' using 1:11       t 'Titanium'     with lines
