React = require 'react'
ReactDOM = require 'react-dom'
reducer = require './rootReducer'
{createStore, applyMiddleware, compose} = require 'redux'
{Provider} = require 'react-redux'
thunk = require('redux-thunk').default
appView = React.createFactory require './src/app/components/app'
listener = require './src/lib/listener'
{sync} = require './src/sync/syncTask'
require('offline-plugin/runtime').install()

middleware = [
	applyMiddleware(thunk)
	applyMiddleware(listener sync)
]
middleware.push window.devToolsExtension() if window.devToolsExtension
store = createStore reducer, window.__PRELOADED_STATE__, compose(middleware...)

provider =
	React.createElement Provider, {store},
		appView {}

ReactDOM.render provider, document.getElementById 'root'
