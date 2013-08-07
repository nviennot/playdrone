FIGS = native_libs native_libs_ratings paid_ratings new_apps resource_blacklist \
			 dup_threshold dup_min_count dup_cluster dev_free_paid app_categories \
			 obfuscation ads_marketshare perf_market

PDF_FILES = $(FIGS:=.pdf)
DAT_FILES = $(FIGS:=.dat)

.SECONDARY:

all: $(PDF_FILES)

dup_%.dat: dup_all.rb
	./dup_all.rb dup_$*.dat

dup_%.pdf: dup_%.dat dup_%.plot
	gnuplot dup_$*.plot

%.dat: %.rb
	./$*.rb $*.dat

%.pdf: %.dat %.plot
	gnuplot $*.plot

clean:
	@rm -f $(PDF_FILES) $(DAT_FILES)
