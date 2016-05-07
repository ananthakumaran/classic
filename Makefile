build:
	./generate.rb
	./copy.rb

regenerate:
	cd site/build && bundle exec middleman build
	cd site/build && git diff
	cd site/build && git add .
	cd site/build && git commit -m "update"
