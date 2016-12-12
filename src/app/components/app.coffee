React = require 'react'
statementList = React.createFactory require '../../statements/components/statementList'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
loginStatus = React.createFactory require '../../user/components/loginStatus'
header = React.createFactory require '../../header/components/header'
{connect} = require 'react-redux'


appState = (state) ->
	opened: state.layout.statements.opened
	tree: state.statementsTree


app = React.createClass

	getDefaultProps: ->
		user: null

	render: ->
		if @props.opened
			content = statementOpened()
		else
			content = [
				newStatement key: 'addStatement'
				statementList
					key: 'statementList'
					statementIds: @props.tree.root
					cssClasses: ['root']
			]

		React.DOM.div
			'className': 'app'
		, [
			# loginStatus {key: 'loginStatus'}
			header key: 'header'
			React.DOM.main 'className': 'content', 'key': 'content', content
		]


module.exports = connect(appState) app
