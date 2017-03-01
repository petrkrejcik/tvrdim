config = require './configClient'
min = ''
min = '.min' if config.isProduction

{createStore, applyMiddleware, compose} = require 'redux'
{Provider} = require 'react-redux'
thunk = require('redux-thunk').default
reducer = require('./rootReducer')
React = require('react')
App = React.createFactory require './src/app/components/app'
listener = require('./src/lib/listener')
{sync} = require('./src/sync/syncTask')

module.exports = do ->

	store = {}

	loadState = (preloadedState) ->
		middleware = [
			applyMiddleware(thunk)
			applyMiddleware(listener(sync))
		]
		if window? and window.devToolsExtension
			middleware.push window.devToolsExtension()

		store = createStore reducer, preloadedState, compose(middleware...)

	getApp = (props) ->
		React.createElement Provider, {store}, App props

	getHtml = (body) ->
		"""<!doctype html>
		<html>
			<head>
				<title>Tvrdim</title>
				<link rel="manifest" href="/manifest.json">
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<meta charset='UTF-8'>
				<script>if (window.location.hash && window.location.hash == '#_=_') {
					if (window.history && history.pushState) {
						window.history.pushState("", document.title, window.location.pathname);
					} else {
						var scroll = {
							top: document.body.scrollTop,
							left: document.body.scrollLeft
						};
						window.location.hash = '';
						document.body.scrollTop = scroll.top;
						document.body.scrollLeft = scroll.left;
					}
				}</script>
				<script>if (typeof window.tvr !== 'object') {window.tvr = {};} window.tvr.config = #{JSON.stringify(config)}</script>
				<script>window.__PRELOADED_STATE__ = #{JSON.stringify(store.getState())}</script>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react#{min}.js"></script>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom#{min}.js"></script>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom-server#{min}.js"></script>
				<link rel="stylesheet" href="/styles#{min}.css">
				<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
			</head>
			<body>
				<div id="root">#{body}</div>
				<script src="/bundle#{min}.js"></script>
			</body>
		</html>"""

	return {loadState, getApp, getHtml}
				# <script src="https://unpkg.com/history@4.5.1/umd/history#{min}.js"></script>
				# <script src="https://cdnjs.cloudflare.com/ajax/libs/react-router/4.0.0-beta.6/react-router#{min}.js"></script>
