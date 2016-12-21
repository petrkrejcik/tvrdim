React = require 'react'
{connect} = require 'react-redux'
Statement = React.createFactory require './statement'
statementFilter = React.createFactory require '../containers/statementFilter'
newStatement = React.createFactory require './newStatement'


list = React.createClass

	displayName: 'StatementOpened'


	getDefaultProps: ->
		opened: {}

	render: ->
		cssClasses = ['statement-opened']
		children = React.DOM.div
			key: 'children'
			className: 'children'
		, [
			@_renderChildren @props.opened.id, no
			@_renderChildren @props.opened.id, yes
		]

		React.DOM.div
			key: 'statementOpened'
			className: cssClasses.join ' '
		, [
			Statement Object.assign {}, @props.opened,
				key: "statement-#{parent.id}-opened"
				isOpened: yes
			children
		]

	_renderChildren: (ancestor, agree) ->
		cssClass = if agree then 'agree' else 'disagree'
		emptyStatement = newStatement
			key: 'empty-statement'
			agree: agree
			ancestor: @props.opened.id

		React.DOM.div
			key: "children-#{ancestor}-#{cssClass}"
			className: "children-#{cssClass}"
		, [
			emptyStatement
			statementFilter
				key: "statementFilter-#{ancestor}"
				filters: [{ancestor}, {agree}]
				cssClasses: [cssClass]
		]


module.exports = list
