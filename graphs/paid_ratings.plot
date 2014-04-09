set terminal pdf dashed size 5,2
set output "paid_ratings.pdf"

# set title "Free/Paid Rating (free apps)"
set key invert reverse Left horizontal

set ylabel "Avg/min/max rating" offset +2, 0
set xlabel "Number of downloads" offset 0,+0.2
set xtics rotate by -20 offset -1.1,0
set grid y
set yrange [0.8:5.7]

set ytics 0.5
set ytics (1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5)

set style data histograms
set style histogram errorbars lw 3 gap 1
set bars front
set style fill solid border -1
set boxwidth 1

plot 'paid_ratings.dat' using ($2):($4):($5):xtic(1) lt 1 lc 1 fs solid 0.5 t "Free", \
                     '' using ($6):($8):($9):xtic(1) lt 1 lc 2 fs solid 0.5 t "Paid"
