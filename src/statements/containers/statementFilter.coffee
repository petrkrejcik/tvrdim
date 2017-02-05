React = require 'react'
{connect} = require 'react-redux'
statementList = React.createFactory require '../components/statementList'
{getRoot} = require '../util'

filterByUser = (statements, user) ->
	switch user
		when 'notMine'
			# TODO: statements neni array
			return statements.filter (statement) -> !statement.isMine
		when 'mine'
			return statements.filter (statement) -> statement.isMine
		else
			return statements

filterByAgree = (statements, agree) ->
	statements.filter (statement) -> statement.agree is agree

filterByParentId = (statements, tree, ancestor) ->
	return [] unless parent = tree[ancestor]
	parent.map (id) -> statements[id]

mapStateToProps = (state, {cssClasses, filters}) ->
	statements = state.statements
	tree = state.statementsTree
	isChildren = no
	for filter in filters
		isChildren or= filter.ancestor and filter.ancestor isnt 'root'
		statements = \
		if filter.ancestor then filterByParentId statements, tree, filter.ancestor
		else if filter.agree? then filterByAgree statements, filter.agree
		else if filter.user then filterByUser statements, filter.user
		else statements
	rootId = null
	statements = statements.map (stateStatement) ->
		statement = {}
		Object.assign statement, stateStatement
		rootId or= getRoot statement.id, tree
		root = state.statements[rootId]
		isPrivate = root.isPrivate
		statement.isPrivate = yes if isPrivate
		statement
	{statements, cssClasses}


module.exports = connect(mapStateToProps) statementList
