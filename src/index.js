"use strict";

import "./styles.scss";

require("./Main.purs").main();

if (module.hot) {
  module.hot.accept();
}

console.log("app starting");
