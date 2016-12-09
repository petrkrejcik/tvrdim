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

reducer = require './rootReducer'

compiler = webpack webpackConfig
app = express()

handleRender = (req, res) ->
	store = createStore reducer, applyMiddleware thunk
	state = store.getState()
	body = renderToString \
		React.createElement Provider, {store},
			appView user: req.user
	res.send renderHtml body, state
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
	# console.info 'accessToken', accessToken
	# console.info 'refreshToken', refreshToken
	# console.info 'profile', profile
	users.selectOrInsert socialId: profile.id, socialNetwork: 'facebook'
	return cb null, profile

passport.serializeUser (user, cb) ->
	cb null, user

passport.deserializeUser (obj, cb) ->
	cb null, obj

# app.use require('morgan')('combined')
app.use require('cookie-parser')()
app.use require('body-parser').urlencoded extended: true
app.use require('express-session')(secret: 'sdfuiasj83ljfa203fsdlkj', resave: true, saveUninitialized: true)

# on each request; store id into req.user
app.use passport.initialize()
app.use passport.session()

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
