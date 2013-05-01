set terminal pdf dashed size 12,3
set output "native_libs.pdf"

set title "Native Libs Usage (free apps)"
set key invert reverse Left outside

set ylabel "% of total" offset +2, 0
set xlabel "Number of Downloads" offset 0,+0.2
set grid y

set ytics 10

set style data histograms
set style histogram rowstacked
set style fill solid border -1
set boxwidth 0.75

plot 'native_libs.dat' using (100.*$2/($2+$3)):xtic(1) lt 1 lc 1 fs solid 0.5 t "Has Native Libs" , \
                    '' using (100.*$3/($2+$3)):xtic(1) lt 1 lc 0 fs solid 0   t "No Native Libs",   \
                    '' using 0:(100.*($2/2)/($2+$3)):2 with labels center notitle,                  \
                    '' using 0:(100.*($2+$3/2)/($2+$3)):3 with labels center notitle
