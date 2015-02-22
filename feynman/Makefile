
MAIN=feynman_diagrams
MAINEXT=.pdf

all:
	rm -f aux/*
	pdflatex --output-directory=aux $(MAIN)
	@echo ""
	@echo " Splitting output diagrams"
	@echo " ========================="
	./split aux/$(MAIN)$(MAINEXT)
	mv aux/feynman_diagrams_1.pdf feynman_btosmumu_penguin.pdf
	mv aux/feynman_diagrams_2.pdf feynman_btosmumu_box.pdf


.PHONY : clean

clean :
	rm -f aux/* *.pdf
