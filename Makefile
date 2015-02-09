LATEX = pdflatex -halt-on-error -file-line-error

BIBDIR = bib
OUTDIR = aux
PDFDIR = pdfs
PREAMBLEDIR = preamble
CHAPTERS = $(filter-out \
					 $(PDFDIR)/ \
					 $(PREAMBLEDIR)/ \
					 $(BIBDIR)/ \
					 $(OUTDIR)/,$(wildcard */))

MAINS = $(wildcard */main.tex)
TARGETS = $(addsuffix .pdf,$(addprefix $(PDFDIR)/,$(subst /main.tex,,$(MAINS))))
BIBSOURCES = $(wildcard $(BIBSOURCES)/*.bib)

all: $(TARGETS)

$(PDFDIR)/%.pdf: %/*.tex
	sed 's/XXX/$*/g' thesis/template.tex > $(OUTDIR)/$*.tex
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	bibtex $(OUTDIR)/$*
	xindy -L english -C utf8 -I xindy -M \
		$(OUTDIR)/$* -t $(OUTDIR)/$*.glg \
		-o $(OUTDIR)/$*.gls $(OUTDIR)/$*.glo
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	cp -f $(OUTDIR)/$*.pdf $(PDFDIR)/.
	mv -f $(OUTDIR)/$*.pdf $(PDFDIR)/recent.pdf

open:
	open $(PDFDIR)/recent.pdf

.PHONY: info clean count
info:
	@echo $(TARGETS)

clean:
	rm -f $(OUTDIR)/* $(PDFDIR)/*.pdf

count:
	@echo "thesis\n======\nBackup of the ol' thesis." > README.md
	@echo '\n$(shell date "+%a %d %b") | Total\n---|---' >> README.md
	@texcount -inc -total Thesis/main.tex
	@texcount -inc -total Thesis/main.tex | tr : "|" | grep -v Total >> README.md
