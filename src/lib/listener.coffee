module.exports = (service) -> ({dispatch, getState}) -> (next) -> (action) ->
	service dispatch, action, getState()
	next action
