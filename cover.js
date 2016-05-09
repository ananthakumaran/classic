var fs = require('fs');
var coverArt = require('./coverArt');

var title = process.argv[2];
var titleFontSize = process.argv[3];
var author = process.argv[4];
var authorFontSize = process.argv[5];
var output = process.argv[6];

var cover = coverArt(title);
var svg = cover.svg;
var doc = svg.ownerDocument;
var serializeDocument = require("jsdom").serializeDocument;

var text = doc.createElementNS("http://www.w3.org/2000/svg", 'text');
text.setAttribute("fill", '#333');
text.textContent = title;
text.setAttribute("font-size", titleFontSize);
text.setAttribute("x", cover.width / 2);
text.setAttribute("y", cover.height / 4);
text.style.textAnchor = 'middle';
svg.appendChild(text);

text = doc.createElementNS("http://www.w3.org/2000/svg", 'text');
text.setAttribute("fill", '#333');
text.setAttribute("stroke", 'none');
text.textContent = author;
text.setAttribute("font-size", authorFontSize);
text.setAttribute("x", cover.width / 2);
text.setAttribute("y", (cover.height / 6) * 5);
text.style.textAnchor = 'middle';
svg.appendChild(text);

fs.writeFileSync(output + '.svg', serializeDocument(svg), 'utf-8');


