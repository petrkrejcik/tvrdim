React = require 'react'
ReactDOM = require 'react-dom'
reducer = require './rootReducer'
{createStore, applyMiddleware, compose} = require 'redux'
{Provider} = require 'react-redux'
thunk = require('redux-thunk').default
appView = React.createFactory require './src/app/components/app'
{getRoot} = require('./src/statements/actions')

store = createStore reducer, window.__PRELOADED_STATE__, compose(applyMiddleware(thunk), window.devToolsExtension && window.devToolsExtension())
store.dispatch getRoot()

provider =
	React.createElement Provider, {store},
		appView {}

ReactDOM.render provider, document.getElementById 'root'
