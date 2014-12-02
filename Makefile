SCRBL=index.scrbl
CSS=assets/custom.css
ADD_HEAD=bin/add-to-head.rkt

.PHONY: local clean html html-single html-multi publish

local: html-single

html: html-single html-multi
	racket $(ADD_HEAD)

html-single: $(SCRBL)
	raco scribble \
		--html \
		--dest html \
		--dest-name all.html \
		++style $(CSS) \
		++main-xref-in \
		--redirect-main http://docs.racket-lang.org/ \
		\
		$(SCRBL)

html-multi: $(SCRBL)
	raco scribble \
		--htmls \
		--dest-name html \
		++style $(CSS) \
		++main-xref-in \
		--redirect-main http://docs.racket-lang.org/ \
		\
		$(SCRBL)

publish: html
	cd html; make; cd ../..