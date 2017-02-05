module.exports = do ->

	countScore = (entities) ->
		result = {}
		for id, entity of entities
			result[id] = {}
			for key, value of entity
				continue if key in ['score']
				result[id][key] = value if value?

		structure = makeStructure entities

		for ids in structure.reverse()
			for id in ids
				entity = result[id]
				isRoot = !entity.ancestor
				parent = result[entity.ancestor] ? entity
				parent.score ?= 0

				continue if isRoot
				continue if entity.score? and entity.score < 0

				diff = if entity.agree then 1 else -1
				parent.score += diff
		result

	# make array of levels in tree
	# loops over all entities and if an entity doesn't have an ancestor it's ID is pushed into array at index 0
	# if it has ancestor and it's ID in the array of current parents, it is pushed into array at index of current level
	# structure is like this:
	# [ [ '2' ], [ '3', '4', '5' ], ['6'] ]
	# '2' is root, '3', '4', '5' are 1st level children, '6' is 2nd level child
	makeStructure = (entities, parentIds = null, depth = 1, structure = []) ->
		return structure unless Object.keys(entities).length
		remaining = {}
		parentIds or= []
		for id, entity of entities
			parentIds.push id unless entity.ancestor
		for id, row of entities
			unless row.ancestor
				# root
				structure[0] ?= []
				structure[0].push id
			else if row.ancestor in (parentIds or [])
				structure[depth] ?= []
				structure[depth].push id
			else
				remaining[id] = row
		makeStructure remaining, structure[depth], depth + 1, structure


	# findPrivate = (entities, structure) ->
	# 	privateIds = []
	# 	for ids, level in structure when level > 0 # skip root
	# 		for id in ids
	# 			ancestorId = entities[id].ancestor
	# 			ancestor = entities[ancestorId]
	# 			isPrivate = ancestor.isPrivate or ancestor.id in privateIds
	# 			privateIds.push id if isPrivate
	# 	privateIds

	getRoot = (childId, statementsTree) ->
		return childId if childId in statementsTree.root
		for id, childIds of statementsTree when childId isnt id
			if childId in childIds
				return getRoot id, statementsTree

	{countScore, makeStructure, getRoot}
