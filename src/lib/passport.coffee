express = require 'express'
router = express.Router()
passport = require 'passport'
fbStrategy = require('passport-facebook').Strategy
googleStrategy = require('passport-google-oauth20').Strategy
config = require '../../config'
users = require '../user/repo'

module.exports = do ->

	passport.use new fbStrategy
		clientID: process.env.FB_APP_ID,
		clientSecret: process.env.FB_SECRET,
		callbackURL: "#{config.httpProtocol}://#{config.domain}/login/facebook/return"
	,	(accessToken, refreshToken, profile, cb) ->
		users.selectOrInsert socialId: profile.id, socialNetwork: 'facebook'
		.then (userId) ->
			user =
				id: userId
				providerId: profile.id
				displayName: profile.displayName
				provider: 'facebook'
			return cb null, user
		.catch (err) -> console.info 'google error', err
		return

	passport.use new googleStrategy
		clientID: process.env.GOOGLE_APP_ID,
		clientSecret: process.env.GOOGLE_SECRET,
		callbackURL: "#{config.httpProtocol}://#{config.domain}/login/google/return"
	,	(accessToken, refreshToken, profile, cb) ->
		users.selectOrInsert socialId: profile.id, socialNetwork: 'google'
		.then (userId) ->
			user =
				id: userId
				providerId: profile.id
				displayName: profile.displayName
				provider: 'google'
			return cb null, user
		.catch (err) -> console.info 'google error', err
		return

	passport.serializeUser (user, cb) ->
		cb null, user

	passport.deserializeUser (obj, cb) ->
		cb null, obj

	# on each request; store id into req.user
	router.use passport.initialize()
	router.use passport.session()

	# router.use require('morgan')('combined')
	router.get '/logout', (req, res, next) ->
		req.session.destroy()
		req.logout()
		res.sendStatus 200

	# router.use (req, res, next) ->
	# 	console.info 'req.session', req.session
	# 	next()
	# 	return

	router.get '/login/facebook', passport.authenticate 'facebook'
	router.get '/login/google', passport.authenticate 'google', scope: ['profile']
	router.get(
		'/login/facebook/return',
		passport.authenticate('facebook', failureRedirect: '/login'),
		(req, res) ->
			res.cookie 'user', req.user
			res.cookie 'refreshState', '1'
			res.redirect '/?refreshState=1'
	)
	router.get(
		'/login/google/return',
		passport.authenticate('google', failureRedirect: '/login'),
		(req, res) ->
			res.cookie 'user', req.user
			res.cookie 'refreshState', '1'
			res.redirect '/?refreshState=1'
	)
