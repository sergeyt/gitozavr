Template.diffs.list = ->
	commit = Session.get 'selected-commit'
	return Session.get 'diffs' || [] if not commit
	repo = Session.get 'repo'
	Meteor.call 'diffs', repo, commit.id, commit.parent, (err, diffs) ->
		return if EJSON.equals diffs, Session.get 'diffs'
		Session.set 'diffs', diffs
	return Session.get 'diffs' || []

collapseIcon = 'glyphicon-chevron-right'
expandIcon = 'glyphicon-chevron-down'

Template.diff.expanded = ->
	@_expanded.get()

Template.diff.created = ->
	@.data._expanded = new ReactiveProperty(false)
	return

Template.diff.events =
	'click .btn-expand': (event, tpl) ->
		val = tpl.data._expanded.get()
		tpl.data._expanded.set(!val)

