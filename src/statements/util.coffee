module.exports =

	countScore: (entities) ->

		result = {}
		structure = []
		roots = []
		for id, entity of entities
			result[id] = id: id
			result[id].text = entity.text if entity.text?
			result[id].ancestor = entity.ancestor if entity.ancestor
			result[id].agree = entity.agree if entity.agree?
			result[id].isMine = yes if entity.isMine
			roots.push id unless entity.ancestor

		# make array of levels in tree
		_makeRelations = (_entities, parentIds, depth) ->
			return unless Object.keys(_entities).length
			remaining = {}
			for id, row of _entities
				unless row.ancestor
					# root
					structure[0] ?= []
					structure[0].push id
				else if row.ancestor in parentIds or []
					structure[depth] ?= []
					structure[depth].push id
				else
					remaining[id] = row
			_makeRelations remaining, structure[depth], depth + 1

		_makeRelations entities, roots, 1

		# count scores
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

