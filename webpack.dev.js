"use strict"

const path = require("path")
const { merge } = require('webpack-merge')
const common = require('./webpack.common.js')
const ReactRefreshWebpackPlugin = require("@pmmmwh/react-refresh-webpack-plugin")
const webpack = require("webpack")

module.exports = merge(common, {
  module: {
    rules: [
      {
        test: /\.purs$/,
        use: [
          {
            loader: 'purs-loader',
            options: {
              src: [
                'src/**/*.purs'
              ],
              spago: true,
              watch: true,
              pscIde: true
            }
          }
        ]
      }
    ]
  },

  mode: 'development',

  // The JavaScript file to be injected into the HTML file
  entry: path.resolve(__dirname, "index.dev.js"),

  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js",
  },

  devtool: 'inline-source-map',

  // This plugin updates React components without losing their state
  plugins: [
    new ReactRefreshWebpackPlugin(),
    new webpack.IgnorePlugin(
      /^\.\/locale$/,
      /moment$/
    )
  ],

  resolve: {
    modules: ['node_modules'],
    extensions: ['.purs', '.js']
  },

  optimization: {
    minimize: false,
  },

  devServer: {
    contentBase: path.join(__dirname, 'dist'),
    compress: true,
    port: 9000,
    hotOnly: true,
    hot: true,
    allowedHosts: [
      'local.me',
      'localhost',
    ],
  }

})
