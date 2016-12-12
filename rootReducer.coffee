{combineReducers} = require 'redux'
{statement} = require './src/statements/reducer'
{statementsTree} = require './src/statementsTree/reducer'
{layout} = require './src/layout/reducer'
{user} = require './src/user/reducer'

module.exports = combineReducers
	statements: statement
	statementsTree: statementsTree
	layout: layout
	user: user
