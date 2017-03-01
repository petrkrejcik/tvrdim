React = require 'react'
{connect} = require 'react-redux'
Statement = React.createFactory require './statement'
statementFilter = React.createFactory require '../containers/statementFilter'
AddNewButton = React.createFactory require './addNewButton'


appState = (state, {match}) ->
	{id} = match.params
	id: id


list = React.createClass

	displayName: 'StatementOpened'

	propTypes:
		id: React.PropTypes.string.isRequired

	getChildContext: -> push: @props.push
	childContextTypes: push: React.PropTypes.func

	render: ->
		cssClasses = ['statement-opened']
		children = React.DOM.div
			key: 'children'
			className: 'children'
		, [
			@_renderChildren @props.id, yes
			@_renderChildren @props.id, no
			AddNewButton id: @props.id, key: 'addNewButton'
		]

		React.DOM.div
			key: 'statementOpened'
			className: cssClasses.join ' '
		, [
			statementFilter
				key: 'statementFilterMine'
				cssClasses: ['root']
				filters: [
					id: @props.id
				]
				openedId: @props.id
			children
		]

	_renderChildren: (ancestor, agree) ->
		cssClass = if agree then 'agree' else 'disagree'
		if agree
			sectionText = 'Yes...'
		else
			sectionText = 'No...'

		React.DOM.div
			key: "children-#{ancestor}-#{cssClass}"
			className: "children-#{cssClass}"
		, [
			React.DOM.h3
				key: 'sectionMine'
				className: 'section'
			, sectionText
			statementFilter
				key: "statementFilter-#{ancestor}"
				filters: [{ancestor}, {agree}]
				cssClasses: [cssClass]
		]


module.exports = connect(appState) list
