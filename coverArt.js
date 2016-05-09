var trianglify = require('trianglify');
var seedrandom = require('seedrandom');

module.exports = function (title) {
  var rng = seedrandom(title);

  function random(start, end) {
    return start + rng() * (end - start);
  }
  var width = 1563;
  var height = 2500;

  var pattern = trianglify({width: width, height: height, seed: title, variance: random(0.5, 1), cell_size: random(260, 300)});

  var svg = pattern.svg();
  svg.setAttribute('viewBox', '0 0 ' + width + ' ' + height);
  svg.setAttribute('xmlns','http://www.w3.org/2000/svg');
  return {svg: svg, height: height, width: width};
};
