React = require 'react'
{connect} = require 'react-redux'
Statement = React.createFactory require './statement'
statementFilter = React.createFactory require '../containers/statementFilter'
newStatement = React.createFactory require './newStatement'


appState = (state, {match}) ->
	{id} = match.params
	tree = state.statementsTree
	childrenCount: tree[id]?.length ? 0
	opened: state.statements[id]


list = React.createClass

	displayName: 'StatementOpened'

	propTypes:
		opened: React.PropTypes.object.isRequired

	getDefaultProps: ->
		childrenCount: 0

	render: ->
		cssClasses = ['statement-opened']
		children = React.DOM.div
			key: 'children'
			className: 'children'
		, [
			@_renderChildren @props.opened.id, yes
			@_renderChildren @props.opened.id, no
		]

		React.DOM.div
			key: 'statementOpened'
			className: cssClasses.join ' '
		, [
			Statement Object.assign {}, @props.opened,
				key: "statement-#{parent.id}-opened"
				isOpened: yes
				childrenCount: @props.childrenCount
			children
		]

	_renderChildren: (ancestor, agree) ->
		cssClass = if agree then 'agree' else 'disagree'
		emptyStatement = newStatement
			key: 'empty-statement'
			agree: agree
			ancestor: @props.opened.id
			isPrivate: @props.opened.isPrivate
		if agree
			sectionText = 'Yes, that\'s true, because...'
		else
			sectionText = 'No, that\'s not true, because...'

		React.DOM.div
			key: "children-#{ancestor}-#{cssClass}"
			className: "children-#{cssClass}"
		, [
			React.DOM.h3
				key: 'sectionMine'
				className: 'section'
			, sectionText
			emptyStatement
			statementFilter
				key: "statementFilter-#{ancestor}"
				filters: [{ancestor}, {agree}]
				cssClasses: [cssClass]
		]


module.exports = connect(appState) list
