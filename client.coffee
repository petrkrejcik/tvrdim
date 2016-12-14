React = require 'react'
ReactDOM = require 'react-dom'
reducer = require './rootReducer'
{createStore, applyMiddleware, compose} = require 'redux'
{Provider} = require 'react-redux'
thunk = require('redux-thunk').default
appView = React.createFactory require './src/app/components/app'
{getAll, getMine} = require './src/statements/actions'

store = createStore reducer, window.__PRELOADED_STATE__, compose(applyMiddleware(thunk), window.devToolsExtension && window.devToolsExtension())
# if userId = store.getState().user.id
# 	store.dispatch getMine userId

provider =
	React.createElement Provider, {store},
		appView {}

ReactDOM.render provider, document.getElementById 'root'
