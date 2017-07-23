'use strict';

require('./style.scss');
var Elm = require('./Main.elm');

var mountNode = document.getElementById('main');
var main = Elm.Main.embed(mountNode);