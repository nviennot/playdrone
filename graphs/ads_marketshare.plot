set terminal pdf dashed size 6,4
set output "ads_marketshare.pdf"

#set title "App categories"
set key horizontal
set key bottom center outside
# set nokey

set ylabel "Adoption (%)" offset +1, 0
set xlabel "Day" offset 0,+0.2
set grid y

# set xdata time
# set timefmt "%m/%d/%y"
# #set xrange [ "04/27/13":"05/07/13" ]

# set timefmt "%s"
# set format x "%a, %d %b"

set xtics 5
set xrange [0:57]

# set xtics nomirror rotate by -20
#set yrange [-5000:6000]

# set xtics 604800


#set style fill solid border -1
#set boxwidth 86400 absolute

#set ytics 1000

set xzeroaxis lw 5 lt -1

plot 'ads_marketshare.dat' using 1:2        t  'Google Ads'                             with lines, \
                        '' using 1:3        t  'Google Analytics'                       with lines, \
                        '' using 1:4        t  'Flurry'                                 with lines, \
                        '' using 1:5        t  'Millennial Media Ads'                   with lines, \
                        '' using 1:6        t  'MobFox'                                 with lines, \
                        '' using 1:7        t  'InMobi'                                 with lines, \
                        '' using 1:8        t  'RevMob'                                 with lines, \
                        '' using 1:9        t  'Urban Airship Push'                     with lines, \
                        '' using 1:10       t  'Mobclix'                                with lines, \
                        '' using 1:11       t  'Smaato'                                 with lines, \
                        '' using 1:12       t  'AirPush'                                with lines, \
                        '' using 1:13       t  'SendDroid'                              with lines, \
                        '' using 1:14       t  'Adfonic'                                with lines, \
                        '' using 1:15       t  'Jumptap'                                with lines, \
                        '' using 1:16       t  'HuntMads'                               with lines, \
                        '' using 1:17       t  'TapIt'                                  with lines, \
                        '' using 1:18       t  'Umeng'                                  with lines, \
                        '' using 1:19       t  'TapJoy'                                 with lines, \
                        '' using 1:20       t  'AppLovin'                               with lines, \
                        '' using 1:21       t  'MoPub'                                  with lines, \
                        '' using 1:22       t  'LeadBolt'                               with lines
