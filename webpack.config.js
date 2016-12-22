var isProduction = process.env.NODE_ENV === 'production';

if (isProduction) {
	 config = require('./webpack.production.config.js');
} else {
	 config = require('./webpack.dev.config.js');
}

module.exports = config;
