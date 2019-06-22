build:
	./generate.rb
	./copy.rb

regenerate:
	cd site && bundle exec middleman build
