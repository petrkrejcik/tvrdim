var webpack = require('webpack');
var path = require('path');
var SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin');
var stateFromIdb = require('./src/sw/stateFirst');
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
	module: {
		loaders: [
			{test: /\.js$/, exclude: /(node_modules)/, loader: 'babel-loader?presets[]=es2015'},
			{test: /\.coffee$/, loader: 'coffee-loader'},
			{test: /\.scss$/, loader: ExtractTextPlugin.extract('style', 'css!sass')},
			{test: /\.json$/, loader: 'json-loader'} // asi neni potreba
		]
	},
	entry: [
		// 'webpack-hot-middleware/client?reload=true',
		'./src/app/components/app.scss',
		// 'webpack-hot-middleware/client?path=http://localhost:3000/__webpack_hmr',
		'./client'
	],
	'output': {
		path: path.resolve('./public'),
		// publicPath: '/',
		filename: 'bundle.js',
		library: 'tvr',
		libraryTarget: 'var'
	},
	plugins: [
		// new webpack.optimize.OccurenceOrderPlugin(),
		// new webpack.HotModuleReplacementPlugin(),
		// new webpack.NoErrorsPlugin(),
		new ExtractTextPlugin('styles.css'),
		new SWPrecacheWebpackPlugin({
			cacheId: 'tvrdim',
			filename: 'sw.js',
			stripPrefix: 'public/',
			importScripts: [
				'https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react.js',
				'https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.js',
				'https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom-server.js',
				'bundle.js'
			],
			staticFileGlobs: [
				'public/bundle.js',
				'public/styles.css',
				'public/manifest.json',
				'public/assets/**',
			],
			// maximumFileSizeToCacheInBytes: 4194304,
			runtimeCaching: [
			{
				urlPattern: '/',
				handler: stateFromIdb,
			},
			{
				urlPattern: /^https:\/\/cdnjs.cloudflare.com\/ajax\/libs\/react\/15.4.2\/react.js/,
				handler: 'cacheFirst',
			},
			{
				urlPattern: /^https:\/\/cdnjs.cloudflare.com\/ajax\/libs\/react\/15.4.2\/react-dom.js/,
				handler: 'cacheFirst',
			},
			{
				urlPattern: /^https:\/\/cdnjs.cloudflare.com\/ajax\/libs\/react\/15.4.2\/react-dom-server.js/,
				handler: 'cacheFirst',
			},
			{
				urlPattern: /^https:\/\/fonts.googleapis.com\/icon\?family=Material\+Icons/,
				handler: 'cacheFirst',
			}
			]
		})
	],
	externals: {
		'react': 'React', // require => window.
		'react-dom': 'ReactDOM',
		'react-dom/server': 'ReactDOMServer',
	},
	resolve: {
		extensions: ['.coffee', '.js', '']
	}
}