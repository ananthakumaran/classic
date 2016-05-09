build:
	./generate.rb
	./copy.rb

regenerate:
	cd site/build && bundle exec middleman build
	cd site/build && git diff

deploy:
	cd site/build && git add .
	cd site/build && git commit -m "update"
	cd site/build && git push --force origin master

reset:
	cd site/build && git update-ref -d HEAD
	cd site/build && rm -rf *
	cd site/build && git add .
	./copy.rb

