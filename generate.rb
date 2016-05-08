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

def kindle_font_size(metadata)
  {ta: '8pt', hi: '10pt'}[metadata['lang']]
end

def font_size(metadata)
  {ta: '10pt', hi: '12pt'}[metadata['lang']]
end

def general_options(metadata)
  "metadata.yaml --verbose"
end

def generateEPUB(metadata)
  `pandoc #{general_options(metadata)} --epub-embed-font=#{font(metadata)} --epub-stylesheet=#{epub_css(metadata)} --epub-cover-image=#{full_path('cover.png')} --from #{metadata['sourceFormat']} --to epub #{metadata['source']} --output #{metadata['filename']}.epub`
end

def generateHTML(metadata)
  `pandoc #{general_options(metadata)} #{metadata['generateTOC'] && '--toc'} --css=#{full_path("../../html/base.css")} --css=#{html_css(metadata)} --from #{metadata['sourceFormat']} --to html5 --section-divs #{metadata['source']} --self-contained --output #{metadata['filename']}.html`
end

def general_pdf_options()
  "--variable=documentclass:book"
end

def generate_kindlePDF(metadata)
  `pandoc #{general_options(metadata)} #{general_pdf_options()} --variable=geometry:margin=2mm,paperwidth=85mm,paperheight=114mm --variable=fontsize:#{kindle_font_size(metadata)} --template=#{full_path("../../template.tex")} --from #{metadata['sourceFormat']} --to pdf -t latex --latex-engine=xelatex #{metadata['source']} --output #{metadata['filename']}_kindle.pdf`
end

def generatePDF(metadata)
  `pandoc #{general_options(metadata)} #{general_pdf_options()} --variable=geometry:margin=0.5in,paperwidth=5.5in,paperheight=8.5in --variable=fontsize:#{font_size(metadata)} --template=#{full_path("../../template.tex")} --from #{metadata['sourceFormat']} --to pdf -t latex --latex-engine=xelatex #{metadata['source']} --output #{metadata['filename']}.pdf`
end

def generateMOBI(metadata)
  `pandoc #{general_options(metadata)} --epub-cover-image=#{full_path('cover.png')} --from #{metadata['sourceFormat']} --to epub #{metadata['source']} --output #{metadata['filename']}.kindle.epub`
  `kindlegen #{metadata['filename']}.kindle.epub -verbose -dont_append_source -c1 -o #{metadata['filename']}.mobi`
  `rm #{metadata['filename']}.kindle.epub`
end

def generate_cover(metadata)
  cover_path = File.join(File.expand_path(File.dirname(__FILE__)), '../../cover.js')
  `node #{cover_path} '#{metadata['title']}' '#{metadata['titleFontSize']}' '#{metadata['authors']}' '#{metadata['authorsFontSize']}' cover`
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
  generate_kindlePDF(metadata)
  generateMOBI(metadata)
end


current_dir = File.expand_path(File.dirname(__FILE__))
books_dir = File.join(current_dir, 'books')
process_only = ARGV[0]
Dir.entries(books_dir).each do |file|
  if File.directory?(File.join(books_dir, file)) && !(file == "." || file == "..") && !(process_only && process_only != file)
    generate(File.join(books_dir, file))
  end
end
