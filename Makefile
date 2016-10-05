#
# Makefile for pdfs
#
TEXINPUTS:=.//:$(TEXINPUTS)

ifeq ($(shell echo -e x), -e x)
ECHO = echo
else
ECHO = echo -e
endif

TEX = thesis.tex
BIB = #literature.bib
BLG = $(BIB:%.aux=%.blg)
PDF = $(TEX:%.tex=%.pdf)

all: $(PDF)

$(PDF): *.tex $(BIB)
@$(ECHO) " *\n * pdflatex: $(TEX) > $@ \n *"; \
( \
TEXINPUTS=$(TEXINPUTS) pdflatex -shell-escape $(TEX); \
if grep -q "There were undefined references." $(TEX:.tex=.log); \
then \
bibtex $(TEX:.tex=); \
TEXINPUTS=$(TEXINPUTS) pdflatex -shell-escape $(TEX); \
fi ; \
if grep -q "There were undefined references." $(TEX:.tex=.log); \
then \
TEXINPUTS=$(TEXINPUTS) pdflatex -shell-escape $(TEX); \
fi ; \
while grep -q "Rerun to get cross-references right." $(TEX:.tex=.log); \
do \
TEXINPUTS=$(TEXINPUTS) pdflatex -shell-escape $(TEX); \
done; \
$(ECHO) "\n\n *******************************************************************************"; \
$(ECHO) " *                                                                            *"; \
$(ECHO) " *  WARNING SUMMARY                                                          *"; \
$(ECHO) " *                                                                            *"; \
grep -i "Warning" $(TEX:.tex=.log); \
$(ECHO) " *                                                                            *"; \
$(ECHO) " *******************************************************************************\n"; \
)

.PHONY: clean
clean:
@$(ECHO) " ** Remove automatically generated files " ;\
rm -f *.out *.bbl *.blg *.tpt *.toc *.log *.aux *.idx *.nav *.snm *.vrb *.backup *~ *.table *.gnuplot;

distclean: clean
@rm -f $(PDF);
