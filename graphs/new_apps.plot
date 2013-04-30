set terminal pdf dashed size 12,3
set output "new_apps.pdf"

set title "Apps Released and Removed on the Market"
set key invert reverse Left outside

set ylabel "Number of Apps" offset +1, 0
set xlabel "Day" offset 0,+0.2
set grid y

set xdata time
set timefmt "%s"
set format x "%d/%m/%y"

set xtics 86400

set style fill solid border -1
set boxwidth 32400 absolute

set xzeroaxis lw 5 lt -1

plot 'new_apps.dat' using 1:(-$3) lt 1 lc 1 with boxes fs solid 0.7 t "Removed", \
                 '' using 1:($2)  lt 1 lc 2 with boxes fs solid 0.7 t "Added"
