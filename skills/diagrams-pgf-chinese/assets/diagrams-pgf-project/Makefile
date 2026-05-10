.PHONY: all clean

all: build/diagram.pdf

build:
	mkdir -p build

build/diagram.pgf: diagram.hs | build
	runghc diagram.hs -o build/diagram.pgf -w 420

build/diagram.pdf: build/diagram.pgf wrapper.tex
	xelatex -halt-on-error -interaction=nonstopmode -output-directory build wrapper.tex
	mv build/wrapper.pdf build/diagram.pdf

clean:
	rm -rf build
