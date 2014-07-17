
# A makefile for markdown to latex to compile to run
# The filename is the first argument
FILE=README.pdc

#PDFVIEW=acroread
PDFVIEW=evince

BROWSER=firefox
#BROWSER=opera
#BROWSER=konqueror
OPTIONS="-N --toc -S"
#OPTIONS="-A footer.txt -B header.txt -C custom_head.txt -H include_in_header.txt"


all: markdown html 
#all: s5

markdown:
	echo "This file is *auto generated* from README.pdc via the Makefile\n\n" > README.markdown
	tail -n+4 ${FILE} >> README.markdown

html: compile_html run_html
# latex: compile_pdf run_pdf
# s5: compile_s5 run_s5


compile_html:
	pandoc `echo ${OPTIONS}` -s -o www/index.html --css=pandoc.css ${FILE}

run_html:
	${BROWSER} www/index.html


# compile_pdf: 
# 	# rst2newlatex ${FILE} output.tex
# 	pandoc `echo ${OPTIONS}` -s -o output.tex ${FILE}
# 	latex output.tex
# 	dvipdf output.dvi
# 
# run_pdf: 
# 	${PDFVIEW} output.pdf
# 	
# compile_s5:
# 	pandoc `echo ${OPTIONS}` -w s5 -s ${FILE} -o output_s5.html
# 
# run_s5:
# 	${BROWSER} output_s5.html
#     
