TABLES = $(wildcard table-eg*)
CHANGES = $(wildcard changes/*.xml)
VERSION = devel
OPTS =
XSLTPROC = xsltproc
XSLDBK = /usr/share/xml/docbook/stylesheet/docbook-xsl
XSLPROF = $(XSLDBK)/profiling/profile.xsl
XSLMAN = $(XSLDBK)/manpages/docbook.xsl
XSLHTML = $(XSLDBK)/xhtml/chunk.xsl
XSLPROFH = $(XSLDBK)/xhtml/profile-chunk.xsl
XSLOLINK = $(XSLDBK)/xhtml/docbook.xsl
HTMLDIRUM = xhtml/manual/
HTMLDIRRN = xhtml/release-notes/
CP = cp
HERE = $(shell pwd)

HTML_PARAMS = --param ignore.image.scaling "'1'" \
	      --param graphic.default.extension "'png'" \
	      --param use.id.as.filename "1" \
	      --param refentry.generate.name "0" \
	      --param refentry.generate.title "1" \
	      --param profile.attribute "'output'" \
              --param profile.value "'manual;html'" \
	      --param othercredit.like.author.enabled "1" \
	      --param generate.section.toc.level "3" \
	      --param html.stylesheet "'manual.css'"

# Where to find the manual and the release notes
vpath %.xml . changes

# Main targets
all: olink manpagegz allpdf allhtml

allpdf: manual.pdf release-notes.pdf

allhtml: $(HTMLDIRUM)/index.html $(HTMLDIRRN)/index.html

allstyle: all native db2latex simple

olink: manual.db release-notes.db

# Build and zip the Manpage
manpagegz: version.xml
	@$(MAKE) -C manpage -f ../Makefile dblatex.1.gz

# Build the HTML version of the documentation
$(HTMLDIRUM)/index.html: manual.xml
	@$(XSLTPROC) --xinclude --param base.dir "'$(HTMLDIRUM)'" \
			  $(HTML_PARAMS) \
			  $(XSLPROFH) $<
	convert -trim -rotate 90 processus.fig $(HTMLDIRUM)/processus.png
	convert -trim pagesetup2.fig $(HTMLDIRUM)/pagesetup2.png
	$(CP) *.png tables/*.png $(HTMLDIRUM)/.
	$(CP) -r math/figures $(HTMLDIRUM)/.
	$(CP) -r $(XSLDBK)/images $(HTMLDIRUM)/.
	$(CP) manual.css $(HTMLDIRUM)/.

$(HTMLDIRRN)/index.html: release-notes.xml
	@$(XSLTPROC) --xinclude --param base.dir "'$(HTMLDIRRN)'" \
			  $(HTML_PARAMS) \
			  $(XSLPROFH) $<
	$(CP) manual.css $(HTMLDIRRN)/.

clean:
	$(RM) manual.pdf release-notes.pdf *.db
	$(RM) $(FIGURES) manpage/dblatex.1.gz
	$(RM) -r $(HTMLDIRUM)
	$(RM) -r $(HTMLDIRRN)

native db2latex simple: version.xml
	$(XSLTPROC) --xinclude \
	            --param profile.attribute "'output'" \
                    --param profile.value "'manual;pdf'" \
		    $(XSLPROF) manual.xml | \
	../scripts/dblatex -P target.database.document=$(HERE)/olinkdb.xml \
	                   -P current.docid=usermanual \
                           -T $@ -o manual-$@.pdf -

# Use the PDF image because the PNG from .fig is ugly
pagesetup2.pdf: pagesetup2.fig
	fig2dev -L pdf $< $@

# Build the Olink database
%.db: %.xml
	$(XSLTPROC) --xinclude --stringparam  collect.xref.targets "only" \
	            $(XSLOLINK) $<
	mv target.db $@

# Build the PDF
%.pdf: %.xml version.xml $(TABLES) $(CHANGES) pagesetup2.pdf
	@$(XSLTPROC) --xinclude \
	            --param profile.attribute "'output'" \
                    --param profile.value "'manual;pdf'" $(XSLPROF) $< | \
	../scripts/dblatex -P target.database.document=$(HERE)/olinkdb.xml \
	                   -c manual.conf $(OPTS) -o $@ - 

# Build the manpage
%.1.gz: %.1
	gzip -f $<

%.1: %.1.xml
	$(XSLTPROC) --param profile.attribute "'output'" \
                    --param profile.value "'manpage'" \
                    --xinclude $(XSLPROF) $< | \
        $(XSLTPROC) $(XSLMAN) - 

# Actual version of the release
version.xml: FORCE
	echo "<emphasis>$(VERSION)</emphasis>" > $@

FORCE:
