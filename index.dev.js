"use strict";

require("./src/styles.scss")

require("./output/Main").main();

if (module.hot) {
  module.hot.accept();
}

console.log("app starting");
