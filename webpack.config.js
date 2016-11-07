webpack = require('webpack');
path = require('path');

module.exports = {
	module: {
		loaders: [
			{test: /\.coffee$/, loader: 'coffee-loader'},
			{test: /\.json$/, loader: 'json-loader'} // asi neni potreba
		]
	},
	entry: [
		'webpack-hot-middleware/client?reload=true',
		// 'webpack-hot-middleware/client?path=http://localhost:3000/__webpack_hmr',
		'./client'
	],
	'output': {
		path: __dirname + '/build/js',
		publicPath: 'http://localhost:3000/', // tohle nechapu, nevim, co to dela
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
		extensions: [".coffee", ".js", ""],
		// extensions: [".coffee", ".webpack.js", ".web.js", ".js", ".json", ""],
	// 	// root: [path.resolve('./node_modules'), path.resolve('.')]
	//     modulesDirectories: [ // nevim....
	//       'src',
	//       'node_modules',
	//       path.resolve('./node_modules'),
	//       path.resolve('./src')
	//     ]
	},
	// resolveLoader: {
	// 	modulesDirectories: [
	// 		'src',
	// 		'node_modules',
	// 		path.resolve('./node_modules'),
	// 		path.resolve('./src')
	// 	]
	// }
	// ,
	// node: { // hleda to asi v adresari jmeno 'index.js'
	//     console: 'empty',
	//     module: 'empty',
	//     fs: 'empty',
	//     file: 'empty',
	//     net: 'empty',
	//     dns: 'empty',
	//     util: 'empty',
	//     tls: 'empty'
	// }
}