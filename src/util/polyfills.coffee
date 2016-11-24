if typeof Object.assign != 'function'
	do ->
		Object.assign = (target) ->
			'use strict';
			unless target
				throw new TypeError 'Cannot convert undefined or null to object'

			output = Object target
			for index in [1...arguments.length]
				source = arguments[index]
				if source?
					for nextKey, _ of source
							output[nextKey] = source[nextKey]
			output
