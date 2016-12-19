React = require 'react'
{connect} = require 'react-redux'
{ANIMATION_INIT, ANIMATION_START, ANIMATION_END} = require '../../util/consts'
statement = React.createFactory require './statement'

appState = (state) ->
	statements: state.statements
	openingStatementId: state.layout.statements.openingId
	animationOpenChild: state.layout.statements.animationOpenChild
	animationOpenParent: state.layout.statements.animationOpenParent



list = React.createClass

	displayName: 'StatementList'


	getDefaultProps: ->
		statementIds: []
		cssClasses: []
		isEntering: no
		storeTopOffset: no

	render: ->
		cssClasses = @props.cssClasses.concat ['statement-list']
		children = @props.statementIds.map (id, i) =>
			props = key: "statement-#{id}"
			props.storeTopOffset = yes if @props.storeTopOffset and i is 0
			statement Object.assign props, @props.statements[id]

		React.DOM.div
			key: 'statement-list'
			className: cssClasses.join ' '
		, children



module.exports = connect(appState) list
