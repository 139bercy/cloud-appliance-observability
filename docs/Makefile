###############################################################################

DATE	= $(shell git log -n 1 --date=short \
		| awk '/^Date:/ {print $$2}')

CLASSOPTION = 	-V classoption=oneside \
		-V classoption=idxtotoc \
		-V classoption=halfparskip \
		-V classoption=chapterprefix

GEOMETRY = 	-V geometry=portrait \
		-V geometry=hoffset=5pt \
		-V geometry=voffset=5pt \
		-V geometry=textheight=700pt \
		-V geometry=textwidth=520pt \
		-V graphics \
		-V papersize=a4

TITLE =		Documentation projet
SUBTITLE =	Observabilité

AUTHOR =	-V author="Mathieu GRZYBEK" \
		-V equipe="DGFiP / SI-1A / DMOD" \
		-V date=$(DATE)

LAYOUT =	-V fontsize=12pt \
		-V documentclass=report \
		-V lang=fr \
		--number-sections

OUTPUT_NAME = $(TITLE) - $(SUBTITLE)

MARKDOWN_FILES =	"description.md" \
			"architecture_applicative.md" \
			"architecture_technique.md" \
			"interfaces.md" \
			"technologies.md" \
			"capacité.md" \
			"calendrier.md" \
			"exigences.md" \
			"exploitabilité.md" \
			"risques.md" \
			"récap.md"

LATEX_OPTS = 	--to=latex \
		--output="$(OUTPUT_NAME)".tex

EPUB_OPTS =	--toc \
		--metadata title="$(TITLE)" \
		--metadata lang="fr" \
		--metadata date=$(DATE) \
		--output="$(OUTPUT_NAME).epub"

PDF_OPTS =	--template dgfip \
		--toc \
		--output="$(OUTPUT_NAME).pdf"

ODT_OPTS =	--output="$(OUTPUT_NAME).odt"

DRAWIO_OPTS =	--border=1 \
		--scale=2 \
		--export \
		diagrammes.drawio

PANDOC_OPTS =	-V title="$(TITLE)" \
		-V subtitle="$(SUBTITLE)" \
		$(AUTHOR) \
		$(CLASSOPTION) \
		$(GEOMETRY) \
		$(LAYOUT)

###############################################################################

.PHONY: help # This help message
help:
	@grep '^.PHONY: .* #' Makefile \
		| sed 's/\.PHONY: \(.*\) # \(.*\)/\1\t\2/' \
		| expand -t20 \
		| sort

.PHONY: clean # Delete the temporary files
clean:
	@rm -f *.dvi *.tex *.log *.jpg *.jpg.*
	
.PHONY: dist-clean # Delete the documents and temporary files
dist-clean: clean
	@rm -f *.pdf *.epub *.odt

.PHONY: test
test:
	@which pandoc > /dev/null
	@which wget > /dev/null
	@which drawio > /dev/null

images: dgfip_logo.jpg placement.png briques.png

dgfip_logo.jpg:
	@wget --quiet --output-document=dgfip_logo.jpg \
			https://www.economie.gouv.fr/files/dgfip_logo.jpg

.PHONY: placement.png
placement.png:
	@drawio \
		--output placement.png \
		--page-index=1 \
		$(DRAWIO_OPTS)

.PHONY: briques.png
briques.png:
	@drawio \
		--output briques.png \
		--page-index=2 \
		$(DRAWIO_OPTS)

.PHONY: latex
latex:
	@pandoc $(PANDOC_OPTS) $(LATEX_OPTS) $(MARKDOWN_FILES)

.PHONY: epub # Generate epub document
epub: images latex
	@pandoc $(PANDOC_OPTS) $(EPUB_OPTS) "$(OUTPUT_NAME).tex"

.PHONY: pdf # Generate PDF document
pdf: images
	@pandoc $(PANDOC_OPTS) $(PDF_OPTS) $(MARKDOWN_FILES)

.PHONY: odt # Generate ODT document
odt: images
	@pandoc $(PANDOC_OPTS) $(ODT_OPTS) $(MARKDOWN_FILES)

all: test pdf epub
