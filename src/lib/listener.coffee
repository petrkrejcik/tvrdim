module.exports = (service) -> ({dispatch, getState}) -> (next) -> (action) ->
	next action
	service dispatch, action, getState()
