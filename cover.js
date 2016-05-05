var trianglify = require('trianglify');
var fs = require('fs');
var seedrandom = require('seedrandom');

var title = process.argv[2];
var titleFontSize = process.argv[3];
var author = process.argv[4];
var authorFontSize = process.argv[5];
var output = process.argv[6];
var rng = seedrandom(title);

function random(start, end) {
  return start + rng() * (end - start);
}
var width = 1563;
var height = 2500;

var pattern = trianglify({width: width, height: height, seed: title, variance: random(0.5, 1), cell_size: random(250, 300)});

var svg = pattern.svg();
svg.setAttribute('xmlns','http://www.w3.org/2000/svg');
var doc = svg.ownerDocument;

var text = doc.createElementNS("http://www.w3.org/2000/svg", 'text');
text.setAttribute("fill", 'white');
text.textContent = title;
text.setAttribute("font-size", titleFontSize);
text.setAttribute("x", width / 2);
text.setAttribute("y", height / 4);
text.style.textAnchor = 'middle';
svg.appendChild(text);

text = doc.createElementNS("http://www.w3.org/2000/svg", 'text');
text.setAttribute("fill", 'white');
text.setAttribute("stroke", 'none');
text.textContent = author;
text.setAttribute("font-size", authorFontSize);
text.setAttribute("x", width / 2);
text.setAttribute("y", (height / 6) * 5);
text.style.textAnchor = 'middle';
svg.appendChild(text);

var serializeDocument = require("jsdom").serializeDocument;
fs.writeFileSync(output, serializeDocument(svg), 'utf-8');


