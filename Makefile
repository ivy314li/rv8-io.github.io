all: images

IMAGES = \
	images/rv8.svg \
	images/bintrans.svg \
	images/extend.svg \
	images/inlining.svg \
	images/operands.svg

images: $(IMAGES)

images/%.svg: tmp/%.pdf
	pdf2svg $< $@

tmp/%.pdf: tex/%.tex
	@mkdir -p $(@D)
	cd tmp && pdflatex ../$<
