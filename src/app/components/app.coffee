React = require 'react'
statementFilter = React.createFactory require '../../statements/containers/statementFilter'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
header = React.createFactory require '../../header/components/header'
drawer = React.createFactory require '../../drawer/components/drawer'
drawerOverlay = React.createFactory require '../../drawer/components/drawerOverlay'
allStatements = React.createFactory require '../../statements/components/allStatements'
{connect} = require 'react-redux'
{getRoot} = require '../../statements/util'
createHistory = require('history').createBrowserHistory
{Route, Router} = require 'react-router-dom'
Router = React.createFactory Router
Route = React.createFactory Route

appState = (state) ->
	if openedId = state.layout.statements.opened
		opened = {}
		Object.assign opened, state.statements[openedId]
		rootId = getRoot openedId, state.statementsTree
		root = state.statements[rootId]
		isPrivate = root.isPrivate
		opened.isPrivate = yes if isPrivate
	opened: opened or null
	drawer: state.layout.drawer
	tree: state.statementsTree
	isStatementsLoading: state.layout.statements.isLoading


app = React.createClass

	displayName: 'App'

	getDefaultProps: ->
		user: null

	render: ->
		Router history: createHistory(),
			React.DOM.div
				className: 'app'
			, [
				header key: 'header'
				drawer key: 'drawer' if @props.drawer.isOpened
				drawerOverlay key: 'drawerOverlay'
				Route path: '/', exact: yes, component: allStatements, key: 'route-all'
				Route path: '/add', exact: yes, component: newStatement, key: 'route-add'
				Route path: '/that/:id', component: statementOpened, key: 'route-opened'
			]

module.exports = connect(appState) app
