React = require 'react'
statementFilter = React.createFactory require '../containers/statementFilter'
newStatement = React.createFactory require './newStatement'
{connect} = require 'react-redux'
AddNewButton = React.createFactory require './addNewButton'
Button = React.createFactory require '../../elements/button'

appState = (state) ->
	isStatementsLoading: state.layout.statements.isLoading


allStatements = React.createClass

	displayName: 'All Statements'

	getChildContext: -> push: @props.push
	childContextTypes: push: React.PropTypes.func


	render: ->
		loading = null
		if @props.isStatementsLoading
			loading = 'Loading....'
		content = [
			React.DOM.h3
				key: 'sectionMine'
				className: 'section'
			, 'My statements'

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
			Button
				key: 'addNewButton'
				cssClasses: ['button-fab', 'button-colored', 'button-cornered']
				text: '+'
				handleClick: => @props.push '/create'
		]

		React.DOM.div 'key': 'allStatements', content

module.exports = connect(appState) allStatements
