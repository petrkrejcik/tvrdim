React = require 'react'
statementList = React.createFactory require '../../statements/components/statementList'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
loginStatus = React.createFactory require '../../user/components/loginStatus'
header = React.createFactory require '../../header/components/header'
drawer = React.createFactory require '../../drawer/components/drawer'
drawerOverlay = React.createFactory require '../../drawer/components/drawerOverlay'
{connect} = require 'react-redux'


appState = (state) ->
	opened: state.layout.statements.opened
	drawer: state.layout.drawer
	tree: state.statementsTree


app = React.createClass

	getDefaultProps: ->
		user: null

	render: ->
		if @props.opened
			content = statementOpened()
		else
			content = [
				# newStatement key: 'addStatement'
				statementList
					key: 'statementList'
					statementIds: @props.tree.root
					cssClasses: ['root']
			]

		React.DOM.div
			'className': 'app'
		, [
			header key: 'header'
			drawer key: 'drawer' if @props.drawer.isOpened
			React.DOM.main 'className': 'content', 'key': 'content', content
			drawerOverlay key: 'drawerOverlay'
		]


module.exports = connect(appState) app
