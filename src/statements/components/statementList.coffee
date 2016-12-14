React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'
{ANIMATION_START, ANIMATION_END} = require '../../util/consts'

appState = (state) ->
	statements: state.statements
	animationOpen: state.layout.statements.animationOpen


list = React.createClass

	displayName: 'StatementList'


	getDefaultProps: ->
		statementIds: []
		cssClasses: []
		isEntering: no

	render: ->
		cssClasses = @props.cssClasses.concat ['statement-list']
		children = @props.statementIds.map (id) =>
			statement Object.assign {}, @props.statements[id], key: "statement-#{id}"

		if @props.animationOpen is ANIMATION_START and !@props.isEntering
			cssClasses.push 'leave'

		React.DOM.div
			key: 'statement-list'
			className: cssClasses.join ' '
		, children



module.exports = connect(appState) list
