require('dotenv').config()

module.exports = do ->
	switch process.env.NODE_ENV
		when 'production'
			dbName = 'tvrdim'
			isProduction = yes
		when 'test'
			dbName = 'tvrdim_dev_test'
			isProduction = no
		else
			dbName = 'tvrdim_dev'
			isProduction = no

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
	isProduction: isProduction
	debug: process.env.DEBUG or no
	env: process.env.NODE_ENV