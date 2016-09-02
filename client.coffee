React = require 'react'
ReactDOM = require 'react-dom'
appView = require './src/view/app'
reducer = require './src/model/reducer/index'
{createStore} = require 'redux'
{Provider} = require 'react-redux'

store = createStore reducer, window.__PRELOADED_STATE__

provider =
	React.createElement Provider, {store},
		React.createElement appView

ReactDOM.render provider, document.getElementById 'root'
