React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements: state.statements
	sortRoot: state.statementsTree.root
	tree: state.statementsTree
	opened: state.layout.statements.opened


list = React.createClass

	displayName: 'StatementList'


	getDefaultProps: ->
		statements: []
		nestedType: ''
		sortRoot: []
		tree: {}
		sortChildren: []
		opened: {}

	render: ->
		cssClasses = ['statement-list', 'root']
		cssClasses.push @props.nestedType if @props.nestedType

		React.DOM.div
			'className': cssClasses.join ' '
		, @_renderChildren 'root', 0

	_renderChildren: (parentId, depth, agree) ->
		key = if agree then 'agree' else 'disagree'
		children = []
		for id in @props.tree[parentId] or []
			continue if @props.statements[id].agree isnt agree and parentId isnt 'root'
			props =
				key: "statement-#{id}"
				depth: depth
			children.push statement Object.assign {}, @props.statements[id], props
			if id in @props.opened.disagree
				childrenRejecting = @_renderChildren id, depth + 1, no
				if childrenRejecting.length
					children.push React.DOM.div
						'key': "disagree-#{id}-#{depth}"
						'className': "statement-list disagree depth-#{depth}"
					, childrenRejecting
			if id in @props.opened.agree
				childrenApproving = @_renderChildren id, depth + 1, yes
				if childrenApproving.length
					children.push React.DOM.div
						'key': "agree-#{id}-#{depth}"
						'className': "statement-list agree depth-#{depth}"
					, childrenApproving
		children


module.exports = connect(appState) list
