LATEX             = pdflatex
BIBTEX            = bibtex

MAIN              = master
BIB               = bib/kilder.bib
TEXFILES          = $(wildcard *.tex) $(wildcard **/*.tex)
FIGPDFFILES       = $(patsubst %.fig, %.pdf, $(wildcard images/*.fig))
DOTPDFFILES       = $(patsubst %.dot, %.pdf, $(wildcard images/*.dot))
OCTAVEPDFFILES    = $(patsubst %.m, %.pdf, $(wildcard images/*.m))

all : pdf

pdf : $(MAIN).pdf 

$(MAIN).pdf : $(TEXFILES) $(FIGPDFFILES) $(DOTPDFFILES) $(OCTAVEPDFFILES)
	$(LATEX) ${MAIN}
	@if egrep -c "No file.*\.bbl|Citation.*undefined" $(MAIN).log;then\
		echo "** Running BibTeX **";\
		$(BIBTEX) $(MAIN).aux;\
		else echo "** No need to run BibTeX **";\
		fi
	@while ( grep "Rerun to get cross-references" 	\
		${MAIN}.log > /dev/null ); do		\
		echo '** Re-running LaTeX **';		\
		$(LATEX) ${MAIN};				\
		done

clean :
	rm -f *.aux
	rm -f *.log
	rm -f *.bbl
	rm -f *.out
	rm -f *.bak
	rm -f *.blg
	rm -f images/*.bak

# XFIG
%.pdf : %.fig
	fig2dev -L pdf $*.fig > $*.pdf

# DOT
%.pdf : %.dot
	dot $< -Tpdf -o $@

# OCTAVE
%.pdf : %.m
	octave --eval "run $<"
	pdfcrop $*.pdf $*.pdf
