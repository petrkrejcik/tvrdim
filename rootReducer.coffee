{combineReducers} = require 'redux'
{statement} = require './src/statements/reducer'
{statementsTree} = require './src/statementsTree/reducer'
{layout} = require './src/layout/reducer'

module.exports = combineReducers
	statements: statement
	statementsTree: statementsTree
	layout: layout
