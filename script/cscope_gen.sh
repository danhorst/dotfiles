#!/bin/sh
# based on http://stackoverflow.com/questions/934233/cscope-or-ctags-why-choose-one-over-the-other
find . -name '*.rb' \
-o -name '*.erb' \
> cscope.files

# -b: just build
# -q: create inverted index
cscope -b -q
