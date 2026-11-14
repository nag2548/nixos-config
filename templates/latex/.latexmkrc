# pdflatex; switch to 5 (xelatex) or 4 (lualatex) if the project needs it.
$pdf_mode = 1;
$out_dir = 'build';
# Let latexmk run biber/bibtex when a bibliography exists.
$bibtex_use = 2;
$interaction = 'nonstopmode';
@default_files = ('main.tex');
