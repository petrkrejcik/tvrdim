webpack = require('webpack');
path = require('path');
consts = require('./src/util/consts')

module.exports = {
	module: {
		loaders: [
			{test: /\.coffee$/, loader: 'coffee-loader'},
			{test: /\.scss$/, loader: 'style!css!sass'},
			{test: /\.json$/, loader: 'json-loader'} // asi neni potreba
		]
	},
	'sassLoader': {
		data: "$statementOpenDuration: " + consts.ANIMATION_HIDE_DURATION / 1000 + "s;"
	},
	entry: [
		'webpack-hot-middleware/client?reload=true',
		'./src/app/components/app.scss',
		// 'webpack-hot-middleware/client?path=http://localhost:3000/__webpack_hmr',
		'./client'
	],
	'output': {
		path: path.resolve('./public'),
		// publicPath: path.resolve('./public/'), // tohle nechapu, nevim, co to dela
		filename: 'bundle.js'
	},
	plugins: [
		new webpack.optimize.OccurenceOrderPlugin(),
		new webpack.HotModuleReplacementPlugin(),
		new webpack.NoErrorsPlugin()
	],
	externals: {
		'react': 'React' // require => window.
	},
	resolve: {
		extensions: [".coffee", ".js", ""]
	}
}