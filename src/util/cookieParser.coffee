module.exports = (cookies) ->
	parts = cookies.split ';'
	result = {}
	for part in parts
		continue unless part
		[key, value] = part.split '='
		key = key.trim()
		value = value.trim()
		value = decodeURIComponent value
		if value.indexOf('j:') is 0
			value = value.substring 2
			try
				value = JSON.parse value
			catch e
		result[key] = value
	result
