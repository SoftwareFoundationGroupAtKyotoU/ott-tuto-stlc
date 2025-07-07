OTT_FLAGS := -tex_wrap false -signal_parse_errors true -show_defns false
OTT_PREFIX := language

main: main.pdf

.PHONY: clean

main.pdf: main.tex
	latexmk -pdf main

main.pdf: main.tex $(OTT_PREFIX).tex bibliography.bib
	latexmk -pdf $<

$(OTT_PREFIX).tex: $(OTT_PREFIX).ott
	opam exec -- ott $(OTT_FLAGS) \
	-tex_name_prefix $(OTT_PREFIX) \
	-i $< -o $@

# Tips with ott options:
#
# 1. We should avoid sysfiles. It is reported that
#    use of sysfiles leads to unexpected lexing issues.
# 2. We should avoid use of -o and -tex_filter at the same time.
#    It results in unintended multiple_parses errors even when
#    any parse results make the same tex output.
#
%.tex: %.otex $(OTT_PREFIX).ott
	opam exec -- ott $(OTT_FLAGS) \
	-tex_name_prefix $(OTT_PREFIX) \
	-i $(OTT_PREFIX).ott \
	-tex_filter $< $@

# Clean git-ignored files
clean:
	git clean -fX
