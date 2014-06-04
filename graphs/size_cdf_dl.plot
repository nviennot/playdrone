set terminal pdf dashed size 4.5,2
set output "size_cdf_dl.pdf"

set key invert

set ylabel "Installation size in bytes" offset +1, 0
set xlabel "% of applications" offset 0,+0.2
set grid y

set logscale y

set xrange[0:100]
set yrange[10000:1000000000]

plot 'size_cdf_dl.dat' using 1:2 with lines t '<10k downloads', \
                    '' using 1:3 with lines t '>=10k,<1M downloads', \
                    '' using 1:4 with lines t '>=1M downloads'
