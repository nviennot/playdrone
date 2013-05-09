set terminal pdf dashed size 4,4
set output "dev_free_paid.pdf"

#set title "free apps vs paid apps per developer"
#unset colorbox
set pal gray negative gamma 0.3
#set palette model XYZ positive

set ylabel "Number of paid apps"
set xlabel "Number of free apps"

set xrange[1:50]
set yrange[1:50]

set pm3d map at st

#set lmargin at screen 0.12
#set tmargin at screen 0.95
#set rmargin at screen 0.83
#set bmargin at screen 0.1

splot 'dev_free_paid.dat' notitle
