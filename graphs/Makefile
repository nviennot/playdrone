FIGS = native_libs native_libs_ratings paid_ratings new_apps resource_blacklist

PDF_FILES = $(FIGS:=.pdf)
DAT_FILES = $(FIGS:=.dat)

all: $(PDF_FILES)

%.pdf: %.plot %.rb
	./$*.rb $*.dat
	gnuplot $*.plot

clean:
	@rm -f $(PDF_FILES) $(DAT_FILES)
