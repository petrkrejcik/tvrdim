React = require 'react'
ReactDOM = require 'react-dom'
reducer = require './rootReducer'
{createStore} = require 'redux'
{Provider} = require 'react-redux'
appView = React.createFactory require './src/app/components/app'

store = createStore reducer, window.__PRELOADED_STATE__, window.devToolsExtension && window.devToolsExtension()

provider =
	React.createElement Provider, {store},
		appView {}

ReactDOM.render provider, document.getElementById 'root'
