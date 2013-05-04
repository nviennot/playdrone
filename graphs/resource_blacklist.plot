set terminal pdf dashed size 12,3
set output "resource_blacklist.pdf"

set title "Resource Blacklist"
set key invert reverse Left outside

set ylabel "Number of Resources Blacklisted" offset +1, 0
set xlabel "Blacklist Cutoff" offset 0,+0.2
set grid

set logscale xy
set grid xtics ytics

plot 'resource_blacklist.dat' using 1:2 lt 1 lc 0 lw 3 with lines notitle
