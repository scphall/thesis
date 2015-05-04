LATEX = pdflatex -halt-on-error -file-line-error

BIBDIR = bib
OUTDIR = aux
PDFDIR = pdfs
PREAMBLEDIR = preamble
META = Thesis/metadata
THESISMAIN = Thesis/main.tex

MAINS = $(wildcard */main.tex)
MAINS := $(filter-out $(THESISMAIN),$(MAINS)) $(THESISMAIN)
TARGETS = $(addsuffix .pdf,$(addprefix $(PDFDIR)/,$(subst /main.tex,,$(MAINS))))
BIBSOURCES = $(wildcard $(BIBSOURCES)/*.bib)

MAINS2 = $(filter-out Thesis,$(subst /main.tex,,$(wildcard */main.tex))) Thesis

UNAME := $(shell uname)
OPEN = open $(PDFDIR)/recent.pdf
ifeq ($(UNAME),Linux)
	OPEN=evince $(PDFDIR)/recent.pdf &
endif


all: $(TARGETS)
#all: $(MAINS2)



$(PDFDIR)/%.pdf: %/*.tex
	sed 's/XXX/$*/g' Thesis/template.tex > $(OUTDIR)/$*.tex
	$(LATEX) --output-directory=$(OUTDIR) -draftmode $(OUTDIR)/$*
	bibtex $(OUTDIR)/$*
	xindy -L english -C utf8 -I xindy -M \
		$(OUTDIR)/$* -t $(OUTDIR)/$*.glg \
		-o $(OUTDIR)/$*.gls $(OUTDIR)/$*.glo
	$(LATEX) --output-directory=$(OUTDIR) -draftmode $(OUTDIR)/$*
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	cp -f $(OUTDIR)/$*.pdf $(PDFDIR)/.
	mv -f $(OUTDIR)/$*.pdf $(PDFDIR)/recent.pdf

#%: %/*.tex
	#sed 's/XXX/$*/g' Thesis/template.tex > $(OUTDIR)/$*.tex
	#$(LATEX) --output-directory=$(OUTDIR) -draftmode $(OUTDIR)/$*
	#bibtex $(OUTDIR)/$*
	#xindy -L english -C utf8 -I xindy -M \
		#$(OUTDIR)/$* -t $(OUTDIR)/$*.glg \
		#-o $(OUTDIR)/$*.gls $(OUTDIR)/$*.glo
	#$(LATEX) --output-directory=$(OUTDIR) -draftmode $(OUTDIR)/$*
	#$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	#cp -f $(OUTDIR)/$*.pdf $(PDFDIR)/.
	#mv -f $(OUTDIR)/$*.pdf $(PDFDIR)/recent.pdf


open:
	@$(OPEN)


.PHONY: info clean count
info:
	@echo $(TARGETS)
	@echo $(MAINS)
	@echo $(MAINS2)

clean:
	rm -f $(OUTDIR)/* $(PDFDIR)/*.pdf

count:
	@echo "thesis\n======\nBackup of the ol' thesis." > README.md
	@echo '\n$(shell date "+%a %d %b") | Total\n---|---' >> README.md
	@date "+%m-%d-%Y" >> $(META)
	@texcount -inc -total Thesis/main.tex | tee -a $(META)
	@texcount -inc -total Thesis/main.tex | tr : "|" | grep -v Total >> README.md


