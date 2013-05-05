set terminal pdf dashed size 12,3
set output "dup_min_count.pdf"

set title "Similar Apps Ratio vs Min Count\n(score threshold = 0.8, cutoff = 300)"
set key reverse Left outside

set ylabel "Duplicated Apps / Considered Apps ratio (%)" offset +1, 0
set xlabel "Mininum Number of Resources to Consider an App" offset 0,+0.2
set grid y
#set yrange [0:5.5]

#set ytics 0.5
set yrange [0:]

set style data histograms
set style histogram gap 1
set bars front
set style fill solid border -1
set boxwidth 1

set xrange [-0.6:2.6]

plot 'dup_min_count.dat' using 3:xtic(1) lt 1 lc 1 fs solid 0.5 t "Asset Hashes", \
                      '' using 5:xtic(1) lt 1 lc 2 fs solid 0.5 t "Resource Names", \
                      '' using 7:xtic(1) lt 1 lc 3 fs solid 0.5 t "Both", \
                      '' using ($8-0.25):(($3+4)/2):2 with labels center notitle, \
                      '' using ($8     ):(($5+4)/2):4 with labels center notitle, \
                      '' using ($8+0.25):(($7+4)/2):6 with labels center notitle
