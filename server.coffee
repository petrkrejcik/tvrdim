express = require 'express'
favicon = require 'serve-favicon'
React = require 'react'
{renderToString} = require 'react-dom/server'
{Provider} = require 'react-redux'
{createStore, applyMiddleware} = require 'redux'
thunk = require('redux-thunk').default
appView = React.createFactory require './src/app/components/app'
config = require('cson-config').load 'config.cson'
users = require './src/user/repo'
statementsRepo = require './src/statements/repo'
reducer = require './rootReducer'
{renderHtml} = require './index'

if isProduction = process.env.NODE_ENV is 'production'
	webpackConfig = require './webpack.production.config'
else
	webpackConfig = require './webpack.config'
webpack = require 'webpack'
webpackDevMiddleware = require 'webpack-dev-middleware'
webpackHotMiddleware = require 'webpack-hot-middleware'
compiler = webpack webpackConfig

app = express()

handleRender = (req, res) ->
	user = req.user
	{getAll} = require './src/statements/repo'
	query = {}
	query = loggedUserId: user.id if user
	queries = [getAll query]
	query.userId = user.id if user
	queries.push statementsRepo.filterBy query
	Promise.all queries
	.then (results) ->
		statements = {}
		statementsTree = {}
		for result in results
			# merge two result into one
			Object.assign statements, result.entities
			for parent, ids of result.tree
				if parent is 'root'
					if statementsTree.root
						statementsTree.root.concat ids
					else
						statementsTree.root = ids
				else
					statementsTree[parent] = ids

		store = createStore reducer, {statements, statementsTree, user}, applyMiddleware thunk
		state = store.getState()
		body = renderToString \
			React.createElement Provider, {store},
				appView()
		res.send renderHtml body, state
		return
	.catch (err) -> console.info 'error in app load', err
	return



# app.use (req, res, next) ->
# 	console.info 'req', req
# 	next()
# 	return




app.use favicon './public/assets/favicon.ico'
app.use express.static 'public'




############### PASSPORT #################
passport = require 'passport'
fbStrategy = require('passport-facebook').Strategy

passport.use new fbStrategy
	clientID: process.env.FB_APP_ID,
	clientSecret: process.env.FB_SECRET,
	callbackURL: "http://#{config.domain}/login/facebook/return"
,	(accessToken, refreshToken, profile, cb) ->
	users.selectOrInsert socialId: profile.id, socialNetwork: 'facebook'
	.then (userId) ->
		user =
			id: userId
			providerId: profile.id
			displayName: profile.displayName
			provider: profile.provider
		return cb null, user
	return

passport.serializeUser (user, cb) ->
	cb null, user

passport.deserializeUser (obj, cb) ->
	cb null, obj

app.use require('cookie-parser')()
app.use require('body-parser').urlencoded extended: true

session = require 'express-session'
redis = require('connect-redis')(session)
redisOpts = config.redis
app.use session secret: 'sdfuiasj83ljfa203fsdlkj', resave: true, saveUninitialized: true, store: new redis redisOpts

# on each request; store id into req.user
app.use passport.initialize()
app.use passport.session()

# app.use require('morgan')('combined')
app.get '/logout', (req, res, next) ->
	req.session.destroy()
	req.logout()
	res.sendStatus 200

# app.use (req, res, next) ->
# 	console.info 'req.session', req.session
# 	next()
# 	return

app.get '/login/facebook', passport.authenticate 'facebook'
app.get(
	'/login/facebook/return',
	passport.authenticate('facebook', failureRedirect: '/login'),
	(req, res) -> res.redirect '/'
)

############### PASSPORT #################



unless isProduction
	# called always when server receives a request
	app.use webpackDevMiddleware compiler,
		'noInfo': true
		'publicPath': webpackConfig.output.publicPath
	app.use webpackHotMiddleware compiler







app.use '/', (req, res, next) ->
	if req.user
		console.info 'logged'
	else console.info 'not logged'
	next()
	return
app.use '/api/0', require './src/statements/api'
app.use '/()', handleRender
app.use (req, res, next) ->
	res.status(404).send()


app.listen config.port, ->
	console.log "Server started at port #{config.port}"
