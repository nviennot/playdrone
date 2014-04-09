set terminal pdf dashed size 5.5,2.75
set output "new_apps.pdf"

#set title "Apps Released and Removed on the Market"
set key left

set ylabel "Number of applications" offset +1, 0
set xlabel "Day" offset 0,+0.8
set grid y
set xtics rotate by -30 offset -0.5,0

# set xdata time
# set timefmt "%m/%d/%y"
# set xrange [ "04/26/13":"06/22/13" ]
#set xrange [ "04/27/13":"05/07/13" ]

# set timefmt "%s"
# set format x "%a, %d %b"

# set xtics nomirror rotate by -10
set yrange [-5000:10000]

set xtics 5
set xrange [0:72]


set style fill solid border -1
set boxwidth 1 absolute

set ytics 1000

set xzeroaxis lw 5 lt -1

set datafile missing


set arrow from 57,8500 to 62,3000 nohead ls 5 lc 0 lw 3
set arrow from 62,3000 to 58,-2000 nohead ls 5 lc 0 lw 3
set arrow from 58,-2000 to 62,-6000 nohead ls 5 lc 0 lw 3

set arrow from 58,8500 to 63,3000 nohead ls 5 lc 0 lw 3
set arrow from 63,3000 to 59,-2000 nohead ls 5 lc 0 lw 3
set arrow from 59,-2000 to 63,-6000 nohead ls 5 lc 0 lw 3

# set arrow from 62,-6000 to 62,9500 nohead ls 5 lc 0 lw 3


plot 'new_apps.dat' using 1:($3)                 lt 1 lc 2 with boxes fs solid 0.6 t "Added", \
                 '' using 1:(-$4)                lt 1 lc 1 with boxes fs solid 0.6 t "Removed", \
                 '' using 1:($5)                 lt 1 lc 13 lw 5 with lines t "Updated", \
                 '' using 1:($3-$4):xticlabel(2) lt 1 lc 3 lw 5 with lines t "Net added"
