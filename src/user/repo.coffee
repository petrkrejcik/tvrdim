db = require '../lib/db'

repo = ->

	select = (socialId) -> new Promise (resolve, reject) ->
		db.queryOne '
			SELECT id
			FROM users
			WHERE
				social_id = $1
		', [socialId], (err, row) ->
			return reject err if err
			return resolve null unless row
			resolve row.id
		return

	insert = ({socialId, socialNetwork}) -> new Promise (resolve, reject) ->
		db.insert 'users', {social_id: socialId, social_network: socialNetwork}, (err, rows) ->
			return reject err if err
			resolve rows[0].id
		return

	selectOrInsert = ({socialId, socialNetwork}) -> new Promise (resolve, reject) ->
		select socialId
		.then (id) ->
			return resolve id if id
			insert {socialId, socialNetwork}
			.then (id) -> resolve id
		.catch reject
		return

	{select, insert, selectOrInsert}



module.exports = repo()
