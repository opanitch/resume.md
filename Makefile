.PHONY: resume watch clean

all: curriculum-vitae.pdf curriculum-vitae.html resume.pdf resume.html

cv: curriculum-vitae.pdf curriculum-vitae.html

resume: resume.pdf resume.html

watch:
	ls *.md *.css | entr make resume

name := $(shell grep "^\#" resume.md | head -1 | sed -e 's/^\#[[:space:]]*//' | xargs)

curriculum-vitae.html: preamble-cv.html resume.md postamble.html
	cat preamble-cv.html | sed -e 's/___NAME___/$(name)/' > $@
	python -m markdown -x smarty resume.md >> $@
	cat postamble.html >> $@

curriculum-vitae.pdf: curriculum-vitae.html resume.css
	weasyprint curriculum-vitae.html curriculum-vitae.pdf

resume.html: preamble.html resume.md postamble.html
	cat preamble.html | sed -e 's/___NAME___/$(name)/' > $@
	python -m markdown -x smarty resume.md >> $@
	cat postamble.html >> $@

resume.pdf: resume.html resume.css
	weasyprint resume.html resume.pdf

clean:
	rm -f resume.html resume.pdf
