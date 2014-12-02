DATE=$(shell date)
DONE="Done."

deploy:
	@echo "Deploy the blog to github pages."
	git add --all .
	git commit -a -m "Deploy to github pages on $(DATE)."
	git push
	@echo $(DONE)
