'use strict'

const path = require("path")
const HtmlWebpackPlugin = require("html-webpack-plugin")
const { CleanWebpackPlugin } = require("clean-webpack-plugin")
const webpack = require("webpack")


module.exports = {
  module: {
    rules: [{
      test: /\.css$/,
      include: /node_modules/,
      use: ['style-loader', 'css-loader']
    },
    {
      test: /\.s[ac]ss$/i,
      use: [
        // Creates `style` nodes from JS strings
        'style-loader',
        // Translates CSS into CommonJS
        'css-loader',
        // Compiles Sass to CSS
        'sass-loader',
      ],
    }
    ],
  },
  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    }),
    // This plugin deletes (cleans) the output folder
    // `./dist` in our case

    new CleanWebpackPlugin(),
    new webpack.DefinePlugin({
    }),
    new HtmlWebpackPlugin({
      title: 'square-numbers',
      template: 'index.html',
      inject: false  // See stackoverflow.com/a/38292765/3067181
    })
  ]
}

