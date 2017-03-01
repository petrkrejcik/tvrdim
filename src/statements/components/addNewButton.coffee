React = require 'react'
Button = React.createFactory require '../../elements/button'
ButtonOpenable = React.createFactory require '../../elements/buttonOpenable'

module.exports = React.createClass

	displayName: 'Add new statement button'

	propTypes:
		id: React.PropTypes.string.isRequired

	contextTypes: push: React.PropTypes.func

	render: ->
		uri = '/add/' + @props.id

		ButtonOpenable
			key: 'addNew'
			text: '+'
			cssClasses: ['button-cornered']
		, [
			Button
				key: 'addNewAgree'
				cssClasses: ['button-fab', 'button-colored']
				handleClick: => @context.push uri, agree: yes
			, 'Yes'
			Button
				key: 'addNewDisagree'
				cssClasses: ['button-fab', 'button-colored']
				handleClick: => @context.push uri, agree: no
			, 'No'
		]
