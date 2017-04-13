CC=gnatmake
LATEXC=pdflatex
DOCC=doxygen
CFLAGS=-g -Wall 

REFDIR=.
SRCDIR=src
BINDIR=$(REFDIR)/bin
DOCDIR=$(REFDIR)/doc
REPORTDIR=$(REFDIR)/rapport

LATEXSOURCE=$(wildcard $(REPORTDIR)/*.tex)
CSOURCE=$(wildcard $(SRCDIR)/main.adb)
PDF=$(LATEXSOURCE:.tex=.pdf)


all: compileBST

%.pdf: $(LATEXSOURCE)
	$(LATEXC) -ou	tput-directory $(REPORTDIR) $^ 

$(DOCDIR)/index.html: $(SRCDIR)/Doxyfile $(CSOURCE) 
	$(DOCC) $(SRCDIR)/Doxyfile

binary:	src/main.adb
	gnatmake src/main.adb -o bin/compileBST
		

report: $(PDF) 

doc: $(DOCDIR)/index.html

clean:
	rm -rf $(DOCDIR) $(BINDIR)/* $(REPORTDIR)/*.aux $(REPORTDIR)/*.log  $(REPORTDIR)/rapport.pdf 


.PHONY: all doc binary report 
