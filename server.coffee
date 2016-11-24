express = require 'express'
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

reducer = require './rootReducer'

compiler = webpack webpackConfig
app = express()

handleRender = (req, res) ->
	store = createStore reducer, applyMiddleware thunk
	state = store.getState()
	body = renderToString \
		React.createElement Provider, {store},
			appView {}
	res.send renderHtml body, state
	return

renderHtml = (body, state) ->
				# <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
	"""
		<!doctype html>
		<html>
			<head>
				<title>Tvrdim</title>
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


# called always when server receives a request
app.use webpackDevMiddleware compiler,
	'noInfo': true
	'publicPath': webpackConfig.output.publicPath
app.use webpackHotMiddleware compiler
app.use '/api/0', require './src/statements/api'
app.use handleRender


port = 3000


app.listen port, ->
	console.log "Server started at port #{port}"
