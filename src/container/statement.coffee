{connect} = require 'react-redux'
statementList = require '../view/statement/statementList'

mapStateToProps = (state, ownProps) ->
	statements: state.statements

mapDispatchToProps = (dispatch, ownProps) ->
	onClick: ->
		dispatch setVisibilityFilter ownProps.filter


module.exports = connect(
	mapStateToProps,
	mapDispatchToProps
) statementList

