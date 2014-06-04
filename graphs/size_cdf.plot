set terminal pdf dashed size 4.5,2
set output "size_cdf.pdf"

set key invert

set ylabel "Installation size in bytes" offset +1, 0
set xlabel "% of applications" offset 0,+0.2
set grid y

set logscale y

set xrange[0:100]
set yrange[10000:1000000000]

plot 'size_cdf.dat' using 1:2 with lines t 'CDF'
