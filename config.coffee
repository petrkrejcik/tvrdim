require('dotenv').config()
{env, isProduction} = require './configClient'

module.exports = do ->
	switch env
		when 'production'
			dbName = 'tvrdim'
		when 'test'
			dbName = 'tvrdim_dev_test'
		else
			dbName = 'tvrdim_dev'

	port: process.env.PORT or 3000
	db:
		protocol: 'postgresql:'
		user: process.env.DB_USER
		password: process.env.DB_PASSWORD
		host: process.env.DB_HOST
		port: process.env.DB_PORT or 5432
		db: process.env.DB_NAME or dbName
		options: {}
	redis:
		port: 6379
	domain: process.env.DOMAIN ? "localhost:3000"
	httpProtocol: process.env.HTTP_PROTOCOL ? 'http'
	debug: process.env.DEBUG or no
	isProduction: isProduction
	env: env
