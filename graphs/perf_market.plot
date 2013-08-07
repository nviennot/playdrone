set terminal pdf dashed size 4,3
set output "perf_market.pdf"

set grid y

set xdata time
set timefmt "%m/%d/%y %H:%M"
set xrange [ "05/21/13 04:00":"05/21/13 20:00" ]

set timefmt "%s"
set format x "%H:%M"

set xtics nomirror rotate by -20

set datafile missing

set noxtics

#set style fill solid border -1
#set boxwidth 86400 absolute

#set ytics 1000

#set xzeroaxis lw 5 lt -1

set multiplot layout 2,1

set key horizontal
set key top center outside

set ylabel "Throughput (req/s)" offset +1, 0
set yrange [0:300]


plot 'perf_market.dat' using 1:($2) t 'Search'    lt 1 lc 1 with lines, \
                    '' using 1:($3) t 'Details'   lt 1 lc 3 with lines, \
                    '' using 1:($4) t 'Purchase'  lt 1 lc 2 with lines

set nokey
set xtics 7200
set yrange [0:10]
set ylabel "Latency (s)" offset 0, 0

set xlabel "Time" offset 0,+0.2

plot 'perf_market.dat' using 1:($5) t 'Search'   lt 1 lc 1 with lines, \
                    '' using 1:($6) t 'Details'  lt 1 lc 3 with lines, \
                    '' using 1:($7) t 'Purchase' lt 1 lc 2 with lines
