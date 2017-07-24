all: images

IMAGES = \
	images/bintrans.svg

images: $(IMAGES)

images/%.svg: tmp/%.pdf
	pdf2svg $< $@

tmp/%.pdf: tex/%.tex
	@mkdir -p $(@D)
	cd tmp && pdflatex ../$<
