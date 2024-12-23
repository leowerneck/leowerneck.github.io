targets = bdrycond_general_algorithm.gif

all: $(targets)

bdrycond_general_algorithm.gif: bdrycond_general_algorithm.gp
	gnuplot bdrycond_general_algorithm.gp 2> /dev/null
	gifsicle -i bdrycond_general_algorithm.gif -O3 --colors 256 -o bdrycond_general_algorithm.gif 2> /dev/null

clean:
	rm -rf $(targets)
