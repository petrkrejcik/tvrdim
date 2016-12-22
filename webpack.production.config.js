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
		'./src/app/components/app.scss',
		'./client'
	],
	'output': {
		path: path.resolve('./public'),
		filename: 'bundle.js'
	},
	plugins: [
		new webpack.DefinePlugin({
			'process.env': {
				NODE_ENV: JSON.stringify('production')
			}
		}),
		new webpack.optimize.UglifyJsPlugin(),
		new OfflinePlugin({,
			externals: [
				'https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react.min.js',
				'https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react-dom.min.js',
				'https://fonts.googleapis.com/icon?family=Material+Icons',
				'manifest.json',
				'index.html'
			],
			safeToUseOptionalCaches: true,
			AppCache: null
		})
	],
	externals: {
		'react': 'React' // require => window.
	},
	resolve: {
		extensions: [".coffee", ".js", ""]
	}
}