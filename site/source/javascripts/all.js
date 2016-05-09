var $ = window.jQuery = require("../../bower_components/jquery/dist/jquery.js");
require("../../bower_components/bootstrap/dist/js/umd/dropdown.js");
window.Tether = require('tether');
require("../../bower_components/bootstrap/dist/js/umd/tooltip.js");

$(function () {
  $('[data-toggle="tooltip"]').tooltip();
});
