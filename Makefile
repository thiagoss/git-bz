include Makefile.inc
VPATH=$(srcdir)

ifeq ($(enable_documentation),yes)
docs = git-bz.html git-bz.1
else
docs =
endif

all: $(docs)

%.xml: %.txt
	asciidoc -f $(srcdir)/asciidoc.conf -d manpage -b docbook -o $@ $<

%.html: %.txt
	asciidoc -f $(srcdir)/asciidoc.conf -d manpage -o $@ $<

%.1: %.xml
	xmlto man $<

upload-html: git-bz.html
	DEST=`git config local.upload-html-dest` ; \
	if [ $$? = 0 ] ; then : ; else echo "upload location not configured" ; exit 1 ; fi ; \
	scp $< $$DEST

clean:
	rm -f git-bz.xml git-bz.html git-bz.1

install: install-bin $(if $(findstring yes,$(enable_documentation)),install-doc)

install-bin:
	mkdir -p $(DESTDIR)$(bindir)
	install -m 0755 $(srcdir)/git-bz $(DESTDIR)$(bindir)

install-doc:
	mkdir -p $(DESTDIR)$(mandir)/man1
	install -m 0644 git-bz.1 $(DESTDIR)$(mandir)/man1
