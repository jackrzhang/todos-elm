const express = require('express');
const morgan = require('morgan');
const jsonServer = require('json-server');
const httpProxy = require('http-proxy');
const exphbs = require('express-handlebars');
const path = require('path');

const server = express();


if (process.env.NODE_ENV === 'development') {
  server.use(morgan('dev'));
}

// JSON API

server.use('/api', jsonServer.defaults());
const router = jsonServer.router('db.json')
server.use('/api', router);


// STATIC ASSETS

if (process.env.NODE_ENV === 'development') {
  const proxy = httpProxy.createProxyServer();

  // /assets -> Webpack Dev Server
  server.all('/assets/*', (req, res) => {
    req.url = req.url.replace('/assets', '/dist/frontend')

    proxy.web(req, res, {
      target: 'http://localhost:4568'
    });
  });

  proxy.on('error', (err) => {
    console.error('Proxy server error', err);
  });
} else {
  const staticAssetsPath = path.join(__dirname, './../../dist/frontend');
  server.use('/assets', express.static(staticAssetsPath));
}


// VIEW ENGINE
const hbs = exphbs.create({
  extname: '.hbs',
  defaultLayout: 'main',
  layoutsDir: path.join(__dirname, './views/layouts')
});

server.engine('.hbs', hbs.engine);
server.set('view engine', '.hbs');
server.set('views', path.join(__dirname, './views'));

// serve main elm app
server.get('/*', (req, res) => {
  res.render('main');
});


server.listen(3000, () => {
  console.log('Server listening at at port 3000.');
});
