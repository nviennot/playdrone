set terminal pdf dashed size 12,3
set output "new_apps.pdf"

set title "Apps Released and Removed on the Market"
set key invert reverse Left outside

set ylabel "Number of Apps" offset +1, 0
set xlabel "Day" offset 0,+0.2
set grid y

set xdata time
set timefmt "%s"
set format x "%a, %d %b"

set xtics 86400

set style fill solid border -1
set boxwidth 32400 absolute

set ytics 500

set xzeroaxis lw 5 lt -1

plot 'new_apps.dat' using 1:(-$3)   lt 1 lc 1 with boxes fs solid 0.7 t "Removed", \
                 '' using 1:($2)    lt 1 lc 2 with boxes fs solid 0.7 t "Added", \
                 '' using 1:($2-$3) lt 1 lc 3 lw 3 with lines t "Net Added", \
                 '' using 1:($4)    lt 1 lc 4 lw 3 with lines t "Updated"
