# $Id: Makefile 49563 2014-02-26 14:13:00Z shall $
# ===============================================================================
# Purpose: simple Makefile to streamline processing latex document (just say "make all" to execute)
# Author: Tomasz Skwarnicki
# Created on: 2010-09-24
# ===============================================================================

# name of the main latex files (do not include .tex)
MAIN = main


# name of command to perform Latex (either pdflatex or latex)
LATEX = pdflatex
OUTDIR = aux
DOCDIR = pdfs
SRCDIR = latex
FILE = thesis

FIGEXT = .pdf
MAINEXT= .pdf
#BUILDCOMMAND=rm -f $(MAIN).aux && $(LATEX) $(MAIN) && bibtex $(MAIN) && $(LATEX) $(MAIN) && $(LATEX) $(MAIN)
BUILDCOMMAND=rm -f $(OUTDIR)/$(MAIN).aux
BUILDCOMMAND+= && $(LATEX) --output-directory=$(OUTDIR) $(SRCDIR)/$(MAIN)
BUILDCOMMAND+= && bibtex $(OUTDIR)/$(MAIN)
BUILDCOMMAND+= && xindy -L english -C utf8 -I xindy -M \
							 $(OUTDIR)/$(MAIN) -t $(OUTDIR)/$(MAIN).glg \
							 -o $(OUTDIR)/$(MAIN).gls $(OUTDIR)/$(MAIN).glo
BUILDCOMMAND+= && $(LATEX) --output-directory=$(OUTDIR) $(SRCDIR)/$(MAIN)
BUILDCOMMAND+= && $(LATEX) --output-directory=$(OUTDIR) $(SRCDIR)/$(MAIN)
BUILDCOMMAND+= && mv -f $(OUTDIR)/$(MAIN).pdf $(DOCDIR)/$(FILE)$(MAINEXT)

# list of all source files
TEXSOURCES = $(wildcard */*.tex) $(wildcard *.bib)
FIGSOURCES = $(wildcard */figs/*$(FIGEXT))
SOURCES    = $(TEXSOURCES) $(FIGSOURCES)


# define output (could be making .ps instead)
OUTPUT = $(MAIN)$(MAINEXT)

# prescription how to make output (your favorite commands to process latex)
# do latex twice to make sure that all cross-references are updated
$(OUTPUT): $(SOURCES)
	$(BUILDCOMMAND)

#theory: theory/theory.tex
#theory lhcb: theory/theory.tex lhcb/lhcb.tex
theory lhcb: $(TEXSOURCES)
	sed 's/XXX/$@/g' latex/template.tex > $(OUTDIR)/$@.tex
	rm -f $(OUTDIR)/$@.aux
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$@
	bibtex $(OUTDIR)/$@
	xindy -L english -C utf8 -I xindy -M \
								 $(OUTDIR)/$@ -t $(OUTDIR)/$@.glg \
								 -o $(OUTDIR)/$@.gls $(OUTDIR)/$@.glo
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$@
	$(LATEX) --output-directory=$(OUTDIR) $(OUTDIR)/$@
	cp -f $(OUTDIR)/$@.pdf $(DOCDIR)/$@$(MAINEXT)

# just so we can say "make all" without knowing the output name
all: $(OUTPUT)

open:
	open $(DOCDIR)/$(FILE)$(MAINEXT)

# remove temporary files (good idea to say "make clean" before putting things back into repository)
.PHONY : clean
clean:
	rm -f $(OUTDIR)/* $(DOCDIR)/*.pdf

