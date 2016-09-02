webpack = require('webpack');

module.exports = {
	module: {
		loaders: [
			{test: /\.coffee$/, loader: 'coffee-loader'}
		]
	},
	entry: [
		'webpack-hot-middleware/client?path=http://localhost:3000/__webpack_hmr',
		'./client.coffee'
	],
	'output': {
		path: __dirname + '/build/js',
		publicPath: 'http://localhost:3000/', // tohle nechapu, nevim, co to dela
		filename: 'bundle.js'
	},
	plugins: [
		// Webpack 1.0
		new webpack.optimize.OccurenceOrderPlugin(),
		// Webpack 2.0 fixed this mispelling
		// new webpack.optimize.OccurrenceOrderPlugin(),
		new webpack.HotModuleReplacementPlugin(),
		new webpack.NoErrorsPlugin()
	],
	externals: {
		'react': 'React' // require => window.
	},
	resolve: {
		'extensions': ["", ".webpack.js", ".web.js", ".js", ".coffee"]
	}
}