update = require 'react-addons-update'
# mock = require './mock'
t = require './actionTypes'

localStorage = require '../../localStorage'
try
	stored = localStorage.load('petrk')
	defaultState = localStorage.load('petrk').statements ? {}
catch e
	defaultState = {}


module.exports =

	statement: (state = defaultState, action) ->
		switch action.type
			when t.ADD_REQUEST
				console.info 'action', t.ADD_REQUEST, action
				key = if action.isPos then 'childrenPos' else 'childrenNeg'

				{text, isPos} = action
				newStatement = {text, isPos}
				newState = update state, $merge: newStatement
				newState

			when 'DECREMENT'
				state--
			else
				state

