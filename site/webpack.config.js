var path = require('path');

module.exports = {
  entry: {
    all: [
      './source/javascripts/all.js'
    ]
  },

  resolve: {
    modulesDirectories: ['bower_components', 'node_modules', '../node_modules'],
    extensions: ["", ".webpack.js", ".web.js", ".ts", ".js", ".json"],
    root: [path.join(__dirname, 'source/javascripts')]
  },

  output: {
    path: __dirname + '/.tmp/dist',
    filename: 'javascripts/[name].js'
  }
};
