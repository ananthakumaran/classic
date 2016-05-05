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
  fonts = {ta: 'Lohit-Tamil.ttf', hi: 'Lohit-Devanagari.ttf'}
  lang = metadata['lang']
  full_path(File.join('../../fonts', fonts[lang.to_sym]))
end

def general_options(metadata)
  "metadata.yaml --verbose"
end

def generateEPUB(metadata)
  `pandoc #{general_options(metadata)} --epub-embed-font=#{font(metadata)} --epub-stylesheet=#{epub_css(metadata)} --epub-cover-image=#{full_path('cover.png')} --from #{metadata['sourceFormat']} --to epub #{metadata['source']} --output #{metadata['filename']}.epub`
end

def generateHTML(metadata)
  `pandoc #{general_options(metadata)} --css=#{full_path("../../html/base.css")} --css=#{html_css(metadata)} --from #{metadata['sourceFormat']} --to html5 --section-divs #{metadata['source']} --self-contained --output #{metadata['filename']}.html`
end

def generatePDF(metadata)
  `electron-pdf #{metadata['filename']}.html #{metadata['filename']}.pdf`
end

def generateMOBI(metadata)
  `kindlegen #{metadata['filename']}.epub -verbose -c1 -o #{metadata['filename']}.mobi`
end

def generate_cover(metadata)
  cover_path = File.join(File.expand_path(File.dirname(__FILE__)), '../../cover.js')
  `node #{cover_path} '#{metadata['title']}' '#{metadata['titleFontSize']}' '#{metadata['authors']}' '#{metadata['authorsFontSize']}' cover.svg`
  `rm cover.png`
  `node ../../node_modules/svg2png/bin/svg2png-cli.js cover.svg`
end

def generate(dir)
  puts "generate #{dir}"
  Dir.chdir(dir)
  metadata = YAML.load(IO.read(File.join(dir, 'metadata.yaml')))
  generate_cover(metadata)
  generateEPUB(metadata)
  generateHTML(metadata)
  generatePDF(metadata)
  generateMOBI(metadata)
end


current_dir = File.expand_path(File.dirname(__FILE__))
books_dir = File.join(current_dir, 'books')
Dir.entries(books_dir).each do |file|
  if File.directory?(File.join(books_dir, file)) && !(file == "." || file == "..")
    generate(File.join(books_dir, file))
  end
end
