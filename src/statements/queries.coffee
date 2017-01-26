{select} = require './repo'
_ = require 'lodash'

module.exports = do ->
	loadUserState: (user) ->
		return new Promise (resolve, reject) ->
			query = {}
			query = loggedUserId: user.id if user
			queries = [select query]
			query.userId = user.id if user
			queries.push select query
			Promise.all queries
			.then (results) ->
				statements = {}
				statementsTree = {}
				for result in results
					# merge two result into one
					Object.assign statements, result.entities
					for parent, ids of result.tree
						if parent is 'root'
							if statementsTree.root
								statementsTree.root = _.uniq statementsTree.root.concat ids
							else
								statementsTree.root = ids
						else
							statementsTree[parent] = ids
				resolve {statements, statementsTree, user}
				return
			return
