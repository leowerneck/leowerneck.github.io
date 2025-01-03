all: ghostzones.svg

ghostzones.svg:
	pdflatex ghostzones.tex > /dev/null
	pdf2svg ghostzones.pdf ghostzones.svg all > /dev/null	
	rm -rf ghostzones.pdf ghostzones.aux ghostzones.log

clean:
	rm -rf ghostzones.svg
