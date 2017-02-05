idb = do ->
	dbName = 'tvrdim'
	db = null
	keyPath = 'state'
	open = ->
		return new Promise (resolve, reject) ->
			return resolve() if db
			request = indexedDB.open dbName
			request.onsuccess = ->
				console.info 'connected to idb' if no
				db = request.result
				resolve()
				return

			request.onupgradeneeded = (e) ->
				console.info 'idb onupgradeneeded'
				db = e.target.result
				objectStore = db.createObjectStore keyPath
				return

			return

	select = (key) ->
		return new Promise (resolve, reject) ->
			open().then ->
				transaction = db.transaction [key], 'readwrite'
				transaction.onerror = ->
					reject transaction.error
					return
				objectStore = transaction.objectStore key
				request = objectStore.get keyPath
				request.onsuccess = ->
					resolve request.result
					return
				request.onerror = ->
					reject request.error
					return
				return
			return


	insert = (key, value) ->
		return new Promise (resolve, reject) ->
			open().then ->
				transaction = db.transaction [key], 'readwrite'
				transaction.onerror = ->
					reject transaction.error
					return
				objectStore = transaction.objectStore key
				request = objectStore.put value, key
				request.onsuccess = resolve
				request.onerror = ->
					reject request.error
					return
				return
			return

	{open, select, insert}

module.exports = idb