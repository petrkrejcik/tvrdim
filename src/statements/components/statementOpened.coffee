React = require 'react'
{connect} = require 'react-redux'
{openDrawer} = require '../../layout/actions'
{ANIMATION_START, ANIMATION_END, ANIMATION_HIDE_DURATION} = require '../../util/consts'
statement = React.createFactory require './statement'


appState = (state) ->
	{}

list = React.createClass

	displayName: 'StatementOpened'

	getDefaultProps: ->
		statement: null
		style: {}
		cssClasses: []

	render: ->
		cssClasses = @props.cssClasses.concat ['opened']
		id = @props.statement.id

		props = Object.assign {}, style: @props.style, @props.statement,
			key: "statement-#{id}-opened"
			customClassNames: cssClasses

		statement props, key: "statement-#{id}-opened"


module.exports = connect(appState) list
