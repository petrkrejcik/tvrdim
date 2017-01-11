db = require '../src/lib/db'
fs = require 'fs'
path = require 'path'
hook = require './before'

before (done) ->
	hook().then done
	return
