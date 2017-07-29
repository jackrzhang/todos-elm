# todos-elm

Todo app, built with Elm 0.18 and Express.

<p align="center">
  <a href="https://todos-elm.now.sh" target="_blank">
    <img src="https://user-images.githubusercontent.com/12771126/28741088-c71bb0b0-73c3-11e7-961a-6918a7cd9e97.png" width="700px">
    <br>
    Live Demo
  </a>
</p>

This implementation demonstrates an easy way to decouple State from
Views, via an intermediary function referred to as a `Connector`. Connectors
serve a similar purpose to container components from React-Redux, and communicate with
view functions via an `Interface`.

#### Build Instructions
Run `npm run prod`. Then open `localhost:3000` in your browser.
