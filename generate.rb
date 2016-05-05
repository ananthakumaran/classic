#!/usr/bin/env ruby

require 'yaml';

def full_path(path)
  current_dir = File.expand_path(File.dirname(__FILE__))
  File.expand_path(File.join(current_dir, path))
end

def epub_css(metadata)
  full_path("../../epub/#{metadata['lang']}.css")
end

def html_css(metadata)
  full_path("../../html/#{metadata['lang']}.css")
end

def font(metadata)
  fonts = {ta: 'Lohit-Tamil.ttf'}
  lang = metadata['lang']
  full_path(File.join('../../fonts', fonts[lang.to_sym]))
end

def general_options(metadata)
  "metadata.yaml"
end

def generateEPUB(metadata)
  `pandoc #{general_options(metadata)} --epub-embed-font=#{font(metadata)} --epub-stylesheet=#{epub_css(metadata)} --from #{metadata['sourceFormat']} --to epub #{metadata['source']} --output #{metadata['filename']}.epub`
end

def generateHTML(metadata)
  `pandoc #{general_options(metadata)} --css=#{full_path("../../html/base.css")} --css=#{html_css(metadata)} --from #{metadata['sourceFormat']} --to html #{metadata['source']} --self-contained --output #{metadata['filename']}.html`
end

def generatePDF(metadata)
  `pandoc #{general_options(metadata)} --css=#{full_path("../../html/base.css")} --css=#{html_css(metadata)} --from #{metadata['sourceFormat']} --to pdf #{metadata['source']}  -t html --output #{metadata['filename']}.pdf`
end

def generate(dir)
  puts "generate #{dir}"
  Dir.chdir(dir)
  metadata = YAML.load(IO.read(File.join(dir, 'metadata.yaml')))
  generateEPUB(metadata)
  generateHTML(metadata)
  generatePDF(metadata)
end


current_dir = File.expand_path(File.dirname(__FILE__))
books_dir = File.join(current_dir, 'books')
Dir.entries(books_dir).each do |file|
  if File.directory?(File.join(books_dir, file)) && !(file == "." || file == "..")
    generate(File.join(books_dir, file))
  end
end
