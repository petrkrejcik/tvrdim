React = require 'react'
statementFilter = React.createFactory require '../containers/statementFilter'
newStatement = React.createFactory require './newStatement'
{connect} = require 'react-redux'
{BrowserRouter, Match, browserHistory, Route} = require 'react-router-dom'

appState = (state) ->
	isStatementsLoading: state.layout.statements.isLoading


allStatements = React.createClass

	displayName: 'All Statements'

	render: ->
		loading = null
		if @props.isStatementsLoading
			loading = 'Loading....'
		content = [
			React.DOM.h3
				key: 'sectionMine'
				className: 'section'
			, 'My statements'
			newStatement key: 'addStatement'
			loading ? statementFilter
				key: 'statementFilterMine'
				cssClasses: ['root']
				filters: [
					ancestor: 'root'
				,	user: 'mine'
				]
			React.DOM.h3
				key: 'sectionOthers'
				className: 'section'
			, 'Other\'s statements'
			loading ? statementFilter
				key: 'statementFilterAll'
				cssClasses: ['root']
				filters: [
					ancestor: 'root'
				,	user: 'notMine'
				]
		]

		React.DOM.main 'className': 'content', 'key': 'content', content

module.exports = connect(appState) allStatements
