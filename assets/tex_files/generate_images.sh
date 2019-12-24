#!/bin/bash

# .--------------------------------.
# | Copyright (c) Leonardo Werneck |
# .--------------------------------.
#
# Usage       : ./generate_images
# Description : Loops over all .tex files and generates .svg images
#
# Reference(s): https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
#               https://stackoverflow.com/questions/4120567/convert-pdf-to-svg
#               https://stackoverflow.com/questions/12628327/how-to-show-and-update-echo-on-same-line

for i in *.tex; do
    basename="${i%.*}"
    echo -n "Converting ${basename}.tex to ${basename}.svg ... "
    pdflatex $i > /dev/null
    pdf2svg $basename.pdf $basename.svg all > /dev/null
    echo "done!"
done

rm -rf *.pdf *.aux *.log
