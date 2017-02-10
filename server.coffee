express = require 'express'
favicon = require 'serve-favicon'
{renderToString} = require 'react-dom/server'
index = require './index'
config = require './config'
if isProduction = process.env.NODE_ENV is 'production'
	webpackConfig = require './webpack.production.config'
else
	webpackConfig = require './webpack.config'
webpack = require 'webpack'
webpackDevMiddleware = require 'webpack-dev-middleware'
webpackHotMiddleware = require 'webpack-hot-middleware'
compiler = webpack webpackConfig
{loadUserState} = require './src/statements/queries'
passportRoutes = require './src/lib/passport'

app = express()

handleRender = (req, res) ->
	loadUserState req.user
	.then (preloadedState) ->
		index.loadState preloadedState
		body = renderToString index.getApp()
		res.send index.getHtml body
		return
	.catch (err) -> console.info 'error in app load', err
	return

app.use '/', (req, res, next) ->
	console.info 'BE request:', req.url
	if req.user
		console.info 'logged'
	else console.info 'not logged'
	next()
	return


app.use favicon './public/assets/favicon.ico'
app.use express.static 'public'
app.use require('cookie-parser')()
app.use require('body-parser').urlencoded extended: true

session = require 'express-session'
redis = require('connect-redis')(session)
redisOpts = config.redis
app.use session
	secret: 'sdfuiasj83ljfa203fsdlkj'
	resave: true
	saveUninitialized: true
	store: new redis redisOpts

app.use passportRoutes

unless isProduction
	# called always when server receives a request
	app.use webpackDevMiddleware compiler,
		'noInfo': true
		'publicPath': webpackConfig.output.publicPath
	app.use webpackHotMiddleware compiler


app.use '/api/0/state', (req, res, next) ->
	loadUserState req.user
	.then (resp) ->
		res.json resp
	return

app.use '/api/0', require './src/statements/api'
app.use '/()', handleRender
app.use '/add', handleRender
app.use '/ze/*', handleRender
app.use (req, res, next) ->
	res.redirect '/'


app.listen config.port, ->
	console.log "Server started at port #{config.port}"
