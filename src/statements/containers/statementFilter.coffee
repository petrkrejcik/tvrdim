React = require 'react'
{connect} = require 'react-redux'
statementList = React.createFactory require '../components/statementList'

filterByUser = (statements, user) ->
	switch user
		when 'notMine'
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
	for filter in filters
		statements = \
		if filter.ancestor then filterByParentId statements, tree, filter.ancestor
		else if filter.agree? then filterByAgree statements, filter.agree
		else if filter.user then filterByUser statements, filter.user
		else statements
	{statements, cssClasses}


module.exports = connect(mapStateToProps) statementList
