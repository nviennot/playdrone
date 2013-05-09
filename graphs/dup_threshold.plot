set terminal pdf dashed size 4.5,2
set output "dup_threshold.pdf"

#set title "Similar Apps vs Score Threshold\n(min_count = 3, cutoff = 300)"
#set key reverse Left outside

set ylabel "Number of Applications" offset +1, 0
set xlabel "Score Threshold" offset 0,+0.2
set grid y
#set yrange [0:5.5]

#set ytics 0.5
set yrange [0:]

set style data histograms
set style histogram gap 1
set bars front
set style fill solid border -1
set boxwidth 1

plot 'dup_threshold.dat' using 3:xtic(1) lt 1 lc 1 fs solid 0.5 t "Asset Hashes", \
                      '' using 5:xtic(1) lt 1 lc 2 fs solid 0.5 t "Resource Names", \
                      '' using 7:xtic(1) lt 1 lc 3 fs solid 0.5 t "Both"
