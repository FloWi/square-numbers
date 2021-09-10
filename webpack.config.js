'use strict'

const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const { CleanWebpackPlugin } = require("clean-webpack-plugin")
const webpack = require('webpack')
const isWebpackDevServer = process.argv.some(a => path.basename(a) === 'webpack-dev-server')
const isWatch = process.argv.some(a => a === '--watch')

const plugins =
  isWebpackDevServer || !isWatch ? [] : [
    function () {
      this.plugin('done', function (stats) {
        process.stderr.write(stats.toString('errors-only'))
      })
    }
  ]

module.exports = () => {
  return {
    devtool: 'eval-source-map',

    devServer: {
      contentBase: path.resolve(__dirname, 'dist'),
      port: 4008,
      stats: 'errors-only',
      allowedHosts: [
        'local.me',
        'localhost',
      ],
    },
    optimization: {
      minimize: false,
    },
    entry: './src/index.js',

    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: 'bundle.js'
    },

    module: {
      rules: [{
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
      },
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
              watch: isWebpackDevServer || isWatch,
              pscIde: true
            }
          }
        ]
      },
      {
        test: /\.(png|jpg|gif|svg)$/i,
        use: [
          {
            loader: 'url-loader',
          },
        ],
      }, {
        test: /\.m?js/,
        resolve: {
          fullySpecified: false
        }
      }, {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        include: path.resolve(__dirname, './node_modules/bootstrap-icons/font/fonts'),
        use: {
          loader: 'file-loader',
          options: {
            name: '[name].[ext]',
            outputPath: 'webfonts',
            publicPath: '../webfonts',
          },
        }
      }
      ]
    },

    resolve: {
      modules: ['node_modules'],
      extensions: ['.purs', '.js']
    },

    plugins: [
      new webpack.LoaderOptionsPlugin({
        debug: true
      }),
      new CleanWebpackPlugin(),
      new webpack.DefinePlugin({
      }),
      new HtmlWebpackPlugin({
        title: 'square-numbers',
        template: 'index.html',
        inject: false  // See stackoverflow.com/a/38292765/3067181
      })
    ].concat(plugins)
  }
}
