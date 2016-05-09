var $ = window.jQuery = require("jquery/dist/jquery.js");
require("bootstrap/dist/js/umd/dropdown.js");
window.Tether = require('tether');
require("bootstrap/dist/js/umd/tooltip.js");
var coverArt = require('../../../coverArt');

$(function () {
  $('[data-toggle="tooltip"]').tooltip();
  $('.card .card-img-top').each(function () {
    var $this = $(this);
    setTimeout(function () {
      var title = $this.data('title');
      var svg = coverArt(title).svg;
      svg.setAttribute('height', '100%');
      svg.setAttribute('width', '100%');
      $this.find('svg').replaceWith(svg);
    }, 0);
  });
});
