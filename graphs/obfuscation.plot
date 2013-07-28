set terminal pdf dashed size 6,3
set output "obfuscation.pdf"

#set title "App categories"
set key horizontal
set key top center
# set nokey

set ylabel "Obfuscation rate (%)" offset +1, 0
set xlabel "Day" offset 0,+0.2
set grid y

set xdata time
set timefmt "%m/%d/%y"
#set xrange [ "04/27/13":"05/07/13" ]

set timefmt "%s"
set format x "%a, %d %b"

set xtics nomirror rotate by -20
#set yrange [-5000:6000]

set xtics 604800
set ytics 5


#set style fill solid border -1
#set boxwidth 86400 absolute

#set ytics 1000

set xzeroaxis lw 5 lt -1

plot 'obfuscation.dat' using 1:2 title "All Market"   lt 1 lc 1 with lines, \
                    '' using 1:3 title "New Apps"     lt 1 lc 2 with lines, \
                    '' using 1:4 title "Updated Apps" lt 1 lc 3 with lines
