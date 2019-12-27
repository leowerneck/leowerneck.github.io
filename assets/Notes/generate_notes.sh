#!/bin/bash

# .--------------------------------.
# | Copyright (c) Leonardo Werneck |
# .--------------------------------.
#
# Usage       : ./generate_notes.sh
# Description : Loops over all .tex files and generates .pdf files
#
# Reference(s): https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
#               https://stackoverflow.com/questions/12628327/how-to-show-and-update-echo-on-same-line

for i in *.tex; do
    basename="${i%.*}"
    echo -n "Converting ${basename}.tex to ${basename}.pdf ... "
    pdflatex $i > /dev/null
    pdflatex $i > /dev/null
    pdflatex $i > /dev/null
    echo "done!"
done

rm -rf *.aux *.log *.out *.toc
