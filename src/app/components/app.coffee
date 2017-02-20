React = require 'react'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
header = React.createFactory require '../../header/components/header'
drawer = React.createFactory require '../../drawer/components/drawer'
drawerOverlay = React.createFactory require '../../drawer/components/drawerOverlay'
allStatements = React.createFactory require '../../statements/components/allStatements'
{connect} = require 'react-redux'
{getRoot} = require '../../statements/util'
{Route, BrowserRouter, StaticRouter} = require 'react-router-dom'
Route = React.createFactory Route

if window?
	Router = React.createFactory BrowserRouter
	routerParams = {}
else
	Router = React.createFactory StaticRouter
	routerParams = context: {}


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

	render: ->
		Router routerParams,
			React.DOM.div
				className: 'app', [
					header key: 'header'
					drawer key: 'drawer' if @props.drawer.isOpened
					drawerOverlay key: 'drawerOverlay'
					React.DOM.main 'className': 'content', 'key': 'content', [
						Route path: '/', exact: yes, component: allStatements, key: 'route-all'
						Route path: '/create', exact: yes, component: newStatement, key: 'route-create' # TODO: remove, use optional
						Route path: '/add/:id', component: newStatement, key: 'route-add'
						Route path: '/that/:id', component: statementOpened, key: 'route-opened'
					]
				]

module.exports = connect(appState) app
