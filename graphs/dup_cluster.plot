set terminal pdf dashed size 12,3
set output "dup_cluster.pdf"

set title "Cluster Size repartition, Different Blacklist Cutoffs\n(min_count = 1, threshold = 0.8)"
set key reverse Left outside

set ylabel "Number of Clusters" offset +1, 0
set xlabel "Cluster Size (excluding original app)" offset 0,+0.2
set grid y

set logscale xy

set xrange[0.8:]
set yrange[0.5:]

plot 'dup_cluster.dat' using ($1-0.15):5 lt 1 lc 1 lw 3 with impulses t "Cutoff 3000", \
                    '' using ($1-0.05):4 lt 1 lc 2 lw 3 with impulses t "Cutoff 1000", \
                    '' using ($1+0.05):3 lt 1 lc 3 lw 3 with impulses t "Cutoff 300", \
                    '' using ($1+0.15):2 lt 1 lc 4 lw 3 with impulses t "Cutoff 100"
