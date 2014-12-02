DATE=$(shell date)
CHECK=\033[32m✔\033[39m
DONE="\n${CHECK} Done.\n"

deploy:
	@echo "Deploy the blog to github pages."
	git add --all .
	git commit -a -m "Deploy to github pages on $(DATE)."
	git push
	@echo $(DONE)
