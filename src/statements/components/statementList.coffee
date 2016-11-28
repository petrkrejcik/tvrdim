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

	_renderChildren: (parentId, depth, isApproving) ->
		key = if isApproving then 'approving' else 'rejecting'
		children = []
		for id in @props.tree[parentId]
			continue if @props.statements[id].isApproving isnt isApproving and parentId isnt 'root'
			props =
				key: "statement-#{id}"
				depth: depth
			children.push statement Object.assign {}, @props.statements[id], props
			if id in @props.opened.rejecting
				childrenRejecting = @_renderChildren id, depth + 1, no
				if childrenRejecting.length
					children.push React.DOM.div
						'key': "reject-#{id}-#{depth}"
						'className': "statement-list reject depth-#{depth}"
					, childrenRejecting
			if id in @props.opened.approving
				childrenApproving = @_renderChildren id, depth + 1, yes
				if childrenApproving.length
					children.push React.DOM.div
						'key': "approve-#{id}-#{depth}"
						'className': "statement-list approve depth-#{depth}"
					, childrenApproving
		children


module.exports = connect(appState) list
