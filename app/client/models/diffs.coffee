Template.diffs.list = ->
	commit = Session.get 'selected-commit'
	return [] if not commit
	repo = Session.get 'repo'
	Meteor.call 'diffs', repo, commit.id, commit.parent, (err, diffs) ->
		return if EJSON.equals diffs, Session.get 'diffs'
		Session.set 'diffs', diffs
	return Session.get 'diffs'