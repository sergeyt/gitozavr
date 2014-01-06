Template.commitform.changes = ->
	repo = Session.get 'repo'
	Meteor.call 'changes', repo, (err, res)->
		return if err
		return if EJSON.equals res, Session.get 'changes'
		Session.set 'changes', res
	return Session.get 'changes' || []

Template.commitform.events
	'click .commit-form': ->
		changes = Session.get 'changes' || []
		Session.set 'diffs', changes
		Session.set 'selected-commit', null
