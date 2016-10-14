{combineReducers} = require 'redux'
{statement} = require './src/statements/reducer'
{layout} = require './src/layout/reducer'

module.exports = combineReducers
	statements: statement
	layout: layout
