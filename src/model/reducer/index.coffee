{combineReducers} = require 'redux'
{statement} = require './statement'

module.exports = combineReducers
	statements: statement
