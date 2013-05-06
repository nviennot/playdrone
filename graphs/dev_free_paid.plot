set terminal pdf dashed size 7,7
set output "dev_free_paid.pdf"

set title "free apps vs paid apps per developer"
unset colorbox

set ylabel "Number of paid apps"
set xlabel "Number of free apps"


set xrange[1:50]
set yrange[1:50]

set pm3d map at st

splot 'dev_free_paid.dat' notitle
