SCRBL=index.scrbl
ASSETS=assets
HL_CSS=$(ASSETS)/highlight/github.css
CUST_CSS=$(ASSETS)/custom.css
HL_JS=$(ASSETS)/highlight/highlight.pack.js
ADD_HEAD=bin/add-to-head.rkt

.PHONY: local clean html html-single html-multi publish

local: html

html: html-multi
	racket $(ADD_HEAD)

html-single: $(SCRBL)
	raco scribble \
		--html \
		--dest html \
		--dest-name all.html \
		++style $(HL_CSS) \
		++extra $(HL_JS) \
		++style $(CUST_CSS) \
		++main-xref-in \
		--redirect-main http://docs.racket-lang.org/ \
		\
		$(SCRBL)

html-multi: $(SCRBL)
	raco scribble \
		--htmls \
		--dest-name html \
		++style $(HL_CSS) \
		++extra $(HL_JS) \
		++style $(CUST_CSS) \
		++main-xref-in \
		--redirect-main http://docs.racket-lang.org/ \
		\
		$(SCRBL)

deploy:
	cd html; make; cd ../..

publish: html deploy
	cd html; make; cd ../..
