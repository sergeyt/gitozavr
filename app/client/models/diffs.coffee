# diffs helpers
Template.diffs.list = ->
	Meteor.Repo.diffs()

# diff helpers
Template.diff.expanded = ->
	@_expanded.get()

Template.diff.created = ->
	@data._expanded = new ReactiveProperty(false)
	return

Template.diff.events =
	'click .btn-expand': (event, tpl) ->
		val = tpl.data._expanded.get()
		tpl.data._expanded.set(!val)
