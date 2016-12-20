express = require 'express'
favicon = require 'serve-favicon'
React = require 'react'
webpack = require 'webpack'
webpackConfig = require './webpack.config'
webpackDevMiddleware = require 'webpack-dev-middleware'
webpackHotMiddleware = require 'webpack-hot-middleware'
{renderToString} = require 'react-dom/server'
{Provider} = require 'react-redux'
{createStore, applyMiddleware} = require 'redux'
thunk = require('redux-thunk').default
appView = React.createFactory require './src/app/components/app'
config = require('cson-config').load 'config.cson'
users = require './src/user/repo'
statementsRepo = require './src/statements/repo'

reducer = require './rootReducer'

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

renderHtml = (body, state) ->
	"""
		<!doctype html>
		<html>
			<head>
				<title>Tvrdim</title>
				<script>if (window.location.hash && window.location.hash == '#_=_') {
					if (window.history && history.pushState) {
						window.history.pushState("", document.title, window.location.pathname);
					} else {
						// Prevent scrolling by storing the page's current scroll offset
						var scroll = {
							top: document.body.scrollTop,
							left: document.body.scrollLeft
						};
						window.location.hash = '';
						// Restore the scroll offset, should be flicker free
						document.body.scrollTop = scroll.top;
						document.body.scrollLeft = scroll.left;
					}
				}</script>
				<script>window.__PRELOADED_STATE__ = #{JSON.stringify(state)}</script>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react.js"></script>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react-dom.js"></script>
				<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
			</head>
			<body>
				<div id="root">#{body}</div>
				<script src="/bundle.js"></script>
			</body>
		</html>
	"""


# app.use (req, res, next) ->
# 	console.info 'req', req
# 	next()
# 	return




app.use favicon './public/favicon.ico'
app.use express.static 'public'




############### PASSPORT #################
passport = require 'passport'
fbStrategy = require('passport-facebook').Strategy

passport.use new fbStrategy
	clientID: process.env.FB_APP_ID,
	clientSecret: process.env.FB_SECRET,
	callbackURL: 'http://localhost:3000/login/facebook/return'
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
app.use handleRender


app.listen config.port, ->
	console.log "Server started at port #{config.port}"
