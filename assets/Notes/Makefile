all: Wave_equation.pdf Finite_differences.pdf

Wave_equation.pdf: Wave_equation.tex
	pdflatex Wave_equation.tex > /dev/null
	pdflatex Wave_equation.tex > /dev/null
	pdflatex Wave_equation.tex > /dev/null
	rm -rf Wave_equation.log Wave_equation.aux Wave_equation.out Wave_equation.toc Wave_equation.lof

Finite_differences.pdf: Finite_differences.tex
	pdflatex Finite_differences.tex > /dev/null
	pdflatex Finite_differences.tex > /dev/null
	pdflatex Finite_differences.tex > /dev/null
	rm -rf Finite_differences.log Finite_differences.aux Finite_differences.out Finite_differences.toc Finite_differences.lof

clean:
	rm -rf Wave_equation.pdf Finite_differences.pdf
