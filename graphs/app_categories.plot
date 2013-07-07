set terminal pdf dashed size 6,4
set output "app_categories.pdf"

#set title "App categories"
set key horizontal
set key bottom center outside
# set nokey

set ylabel "Number of Apps" offset +1, 0
set xlabel "Day" offset 0,+0.2
#set grid y

set xdata time
set timefmt "%m/%d/%y"
#set xrange [ "04/27/13":"05/07/13" ]

set timefmt "%s"
set format x "%a, %d %b"

set xtics nomirror rotate by -20
#set yrange [-5000:6000]

set xtics 604800


#set style fill solid border -1
#set boxwidth 86400 absolute

#set ytics 1000

set xzeroaxis lw 5 lt -1

plot 'app_categories.dat' using 1:2        t 'Personalization'                          with lines, \
                       '' using 1:3        t 'Entertainment'                            with lines, \
                       '' using 1:4        t 'Lifestyle'                                with lines, \
                       '' using 1:5        t 'Tools'                                    with lines, \
                       '' using 1:6        t 'Education'                                with lines, \
                       '' using 1:7        t 'Books and Reference'                      with lines, \
                       '' using 1:8        t 'Brain'                                    with lines, \
                       '' using 1:9        t 'Business'                                 with lines, \
                       '' using 1:10       t 'Travel And Local'                         with lines, \
                       '' using 1:11       t 'Music and Audio'                          with lines, \
                       '' using 1:12       t 'Casual'                                   with lines, \
                       '' using 1:13       t 'Arcade'                                   with lines, \
                       '' using 1:14       t 'Sports'                                   with lines, \
                       '' using 1:15       t 'Productivity'                             with lines, \
                       '' using 1:16       t 'Health and Fitness'                       with lines, \
                       '' using 1:17       t 'News and Magazines'                       with lines, \
                       '' using 1:18       t 'Social'                                   with lines, \
                       '' using 1:19       t 'Finance'                                  with lines, \
                       '' using 1:20       t 'Communication'                            with lines, \
                       '' using 1:22       t 'Media and Video'                          with lines, \
                       '' using 1:23       t 'Shopping'                                 with lines, \
                       '' using 1:24       t 'Photography'                              with lines, \
                       '' using 1:25       t 'Medical'                                  with lines, \
                       '' using 1:26       t 'Transportation'                           with lines, \
                       '' using 1:27       t 'Cards'                                    with lines, \
                       '' using 1:28       t 'Comics'                                   with lines, \
                       '' using 1:29       t 'Sports Games'                             with lines, \
                       '' using 1:30       t 'Libraries and Demo'                       with lines, \
                       '' using 1:31       t 'Weather'                                  with lines, \
                       '' using 1:32       t 'Racing'                                   with lines
