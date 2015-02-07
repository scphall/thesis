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
SOURCES = $(wildcard */*.tex)
BIBSOURCES = $(wildcard $(BIBSOURCES)/*.bib)

all: $(TARGETS)

$(PDFDIR)/%.pdf: %/*.tex %/figs
	sed 's/XXX/$*/g' thesis/template.tex > $(OUTDIR)/$*.tex
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	bibtex $(OUTDIR)/$*
	xindy -L english -C utf8 -I xindy -M \
		$(OUTDIR)/$* -t $(OUTDIR)/$*.glg \
		-o $(OUTDIR)/$*.gls $(OUTDIR)/$*.glo
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$*
	mv -f $(OUTDIR)/$*.pdf $(PDFDIR)/.


.PHONY: info clean
info:
	@echo $(TARGETS)

clean:
	rm -f $(OUTDIR)/* $(PDFDIR)/*.pdf

