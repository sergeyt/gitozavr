Template.repo.commits = ->
	Meteor.call 'commits', @name, (err, res)->
		return if err
		return if EJSON.equals res, Session.get('commits')
		Session.set('commits', res)
	return Session.get('commits') || []
