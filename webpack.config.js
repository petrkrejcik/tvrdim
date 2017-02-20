var configClient = require('./configClient');

if (configClient.isProduction) {
	 config = require('./webpack.production.config.js');
} else {
	 config = require('./webpack.dev.config.js');
}

module.exports = config;
