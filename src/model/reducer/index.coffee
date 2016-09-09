{combineReducers} = require 'redux'
{statement} = require './statement'
{layout} = require './layout'

module.exports = combineReducers
	statements: statement
	layout: layout
