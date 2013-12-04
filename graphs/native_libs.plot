set terminal pdf dashed size 5,2
set output "native_libs.pdf"

#set title "Native Libs Usage (free apps)"
#set key invert reverse Left horizontal
set nokey

set ylabel "% of applications using\n native libraries" offset +1, 0
set xlabel "Number of Downloads" offset 0,+0.2
set xtics rotate by -20 offset -1.1,0
set grid y


set ytics 10

set style data histograms
set style histogram rowstacked
set style fill solid border -1
set boxwidth 0.75

#plot 'native_libs.dat' using (100.*$2/($2+$3)):xtic(1) lt 1 lc 1 fs solid 0.5 t "Has Native Libs" , \
#                    '' using (100.*$3/($2+$3)):xtic(1) lt 1 lc 0 fs solid 0   t "No Native Libs",   \
#                    '' using 0:(100.*($2/2)/($2+$3)):2 with labels center notitle,                  \
#                    '' using 0:(100.*($2+$3/2)/($2+$3)):3 with labels center notitle

plot 'native_libs.dat' using (100.*$2/($2+$3)):xtic(1) lt 1 lc 1 fs solid 0.5 t "Has Native Libs"
