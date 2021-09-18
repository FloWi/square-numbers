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

      test: /\.css$/i,
      //include: path.resolve(__dirname, 'src'),
      use: ["style-loader", "css-loader"],
    }, {
      test: /\.(scss)$/,
      use: [{
        // inject CSS to page
        loader: 'style-loader'
      }, {
        // translates CSS into CommonJS modules
        loader: 'css-loader'
      }, {
        // Run postcss actions
        loader: 'postcss-loader',
        options: {
          // `postcssOptions` is needed for postcss 8.x;
          // if you use postcss 7.x skip the key
          postcssOptions: {
            // postcss plugins, can be exported to postcss.config.js
            plugins: function () {
              return [
                require('autoprefixer')
              ]
            }
          }
        }
      }, {
        // compiles Sass to CSS
        loader: 'sass-loader'
      }]

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

