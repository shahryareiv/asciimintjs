#
# Two testsuites are available: Testsuite for MathML 1.0 (1) and 
# Testsuite for MathML 2.0 (2).
# The default testsuite used is MathML 2.0, that can be compiled step by step
# (for debug purpose) or in a single step.
#
TOP = ../..
PWD = $(shell pwd)
TEXIN = $(shell echo ${TEXINPUTS})
TSTFILE = mmltest
TSTBASE = .
OPT =

all: full2

full%: $(TSTFILE)%.xml
	$(TOP)/scripts/dblatex $<

test1: $(TSTFILE)1.tex $(TSTFILE)1.dvi $(TSTFILE)1.xml
test2: $(TSTFILE)2.tex $(TSTFILE)2.dvi $(TSTFILE)2.xml

# FORCE to let compile several times
%.pdf: %.tex FORCE
	TEXINPUTS=:$(PWD)/$(TOP)/latex//:$(TEXIN) pdflatex $<

%.dvi: %.tex
	TEXINPUTS=:$(PWD)/$(TOP)/latex//:$(TEXIN) latex $<

%.tex: %.xml
	$(TOP)/scripts/dblatex -t tex -o $@ $<

%1.xml:
	./build/make_testmml $(OPT) --exclude excluded1 $(TSTBASE)/suite1/testsuite/ > $@

%2.xml:
	./build/make_testmml $(OPT) --exclude excluded2 $(TSTBASE)/suite2/testsuite/ > $@

FORCE:
