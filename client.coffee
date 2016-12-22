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

store = createStore reducer, window.__PRELOADED_STATE__, compose(
	applyMiddleware(thunk),
	applyMiddleware(listener sync),
	window.devToolsExtension && window.devToolsExtension()
)

provider =
	React.createElement Provider, {store},
		appView {}

ReactDOM.render provider, document.getElementById 'root'
