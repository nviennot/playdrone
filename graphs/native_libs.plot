set terminal pdf dashed size 5,2
set output "native_libs.pdf"

#set title "Native Libs Usage (free apps)"
set key reverse Left horizontal at 13.8,111 width 3
# set nokey

set ylabel "% of applications using\n native libraries" offset +1, 0
set xlabel "Number of downloads" offset 0,+0.2
set xtics rotate by -20 offset -1.1,0
set grid y

set ytics 10

set style data histograms
set style histogram rowstacked
set style fill solid border -1
set boxwidth 0.75

plot 'native_libs.dat' using (100.*$2/($2+$3)):xtic(1) lt 1 lc 1 fs solid 0.5 t "With native libraries" , \
                    '' using (100.*$3/($2+$3)):xtic(1) lt 1 lc 0 fs solid 0   t "Without native libraries", \
                    '' using 0:(4):2      with labels rotate left notitle, \
                    '' using 0:(96):3     with labels rotate right notitle

# plot 'native_libs.dat' using (100.*$2/($2+$3)):xtic(1) lt 1 lc 1 fs solid 0.5 t "Has Native Libs"
