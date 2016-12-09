express = require 'express'
router = express.Router()
passport = require 'passport'
strategy = require('passport-facebook').Strategy

passport.use new Strategy
	clientID: process.env.CLIENT_ID,
	clientSecret: process.env.FB_SECRET,
	callbackURL: 'http://localhost:3000/login/facebook/return'
,	(accessToken, refreshToken, profile, cb) ->
	return cb null, profile

passport.serializeUser (user, cb) ->
	cb null, user

passport.deserializeUser (obj, cb) ->
	cb null, obj

router.get '/login/facebook', passport.authenticate 'facebook'

module.exports = router