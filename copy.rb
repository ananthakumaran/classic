#!/usr/bin/env ruby

require 'fileutils'

current_dir = File.expand_path(File.dirname(__FILE__))
books_dir = File.join(current_dir, 'books')
site_dir = File.join(current_dir, 'site')
process_only = ARGV[0]
Dir.entries(books_dir).each do |file|
  if File.directory?(File.join(books_dir, file)) && !(file == "." || file == "..") && !(process_only && process_only != file)
    FileUtils.cp(File.join(books_dir, file, 'metadata.yaml'), File.join(site_dir, 'data', "#{file}.yaml"))
    FileUtils.cp(File.join(books_dir, file, 'cover_plain.svg'), File.join(site_dir, 'source', 'images', "#{file}.svg"))
    FileUtils.cp(File.join(books_dir, file, "#{file}.epub"), File.join(site_dir, 'source', 'books', "#{file}.epub"))
    FileUtils.cp(File.join(books_dir, file, "#{file}.mobi"), File.join(site_dir, 'source', 'books', "#{file}.mobi"))
    FileUtils.cp(File.join(books_dir, file, "#{file}.pdf"), File.join(site_dir, 'source', 'books', "#{file}.pdf"))
    FileUtils.cp(File.join(books_dir, file, "#{file}_kindle.pdf"), File.join(site_dir, 'source', 'books', "#{file}_kindle.pdf"))
  end
end

