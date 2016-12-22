webpack = require('webpack');
path = require('path');
OfflinePlugin = require('offline-plugin');

module.exports = {
	module: {
		loaders: [
			{test: /\.js$/, exclude: /(node_modules)/, loader: 'babel-loader?presets[]=es2015'},
			{test: /\.coffee$/, loader: 'coffee-loader'},
			{test: /\.scss$/, loader: 'style!css!sass'},
			{test: /\.json$/, loader: 'json-loader'} // asi neni potreba
		]
	},
	entry: [
		'webpack-hot-middleware/client?reload=true',
		'./src/app/components/app.scss',
		// 'webpack-hot-middleware/client?path=http://localhost:3000/__webpack_hmr',
		'./client'
	],
	'output': {
		path: path.resolve('./public'),
		// publicPath: '/',
		filename: 'bundle.js'
	},
	plugins: [
		new webpack.optimize.OccurenceOrderPlugin(),
		new webpack.HotModuleReplacementPlugin(),
		new webpack.NoErrorsPlugin(),
		// new OfflinePlugin({
		// 	externals: [
		// 		'https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react.js',
		// 		'https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react-dom.js',
		// 		'https://fonts.googleapis.com/icon?family=Material+Icons',
		// 		'manifest.json',
		// 		'index.html'
		// 	],
		// 	safeToUseOptionalCaches: true,
		// 	AppCache: null
		// })
	],
	externals: {
		'react': 'React' // require => window.
	},
	resolve: {
		extensions: [".coffee", ".js", ""]
	}
}