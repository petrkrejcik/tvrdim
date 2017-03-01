React = require 'react'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
header = React.createFactory require '../../header/components/header'
drawer = React.createFactory require '../../drawer/components/drawer'
drawerOverlay = React.createFactory require '../../drawer/components/drawerOverlay'
allStatements = React.createFactory require '../../statements/components/allStatements'
{connect} = require 'react-redux'
{Route, BrowserRouter, StaticRouter} = require 'react-router-dom'
Route = React.createFactory Route

if window?
	Router = React.createFactory BrowserRouter
	routerParams = {}
else
	Router = React.createFactory StaticRouter
	routerParams = context: {}


appState = (state) ->
	drawer: state.layout.drawer


app = React.createClass

	displayName: 'App'

	propTypes:
		location: React.PropTypes.string

	getDefaultProps: ->
		location: null

	render: ->
		routerParams.location = @props.location if @props.location # For server rendering

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
