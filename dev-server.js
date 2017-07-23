const express = require('express');
const morgan = require('morgan');
const webpack = require('webpack');
const webpackDevMiddleware = require('webpack-dev-middleware');
const webpackHotMiddleware = require('webpack-hot-middleware');
const config = require('./webpack.config');

const devServer = express();
devServer.use(morgan('dev'));

const compiler = webpack(config);

devServer.use(webpackDevMiddleware(compiler, {
  publicPath: config.output.publicPath,
  hot: true,
  stats: {
    colors: true,
    hash: false,
    timings: true,
    chunks: true,
    chunkModules: false,
    modules: false
  },
  headers: {
    'Access-Control-Allow-Origin': '*'
  }
}));

devServer.use(webpackHotMiddleware(compiler, {
  log: console.log
}));

devServer.listen(4568, 'localhost', () => {
  console.log(`Development server is listening on port 4568.`);
});
