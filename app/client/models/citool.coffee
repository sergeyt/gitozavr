Template.citool.changes = ->
	Meteor.Repo.changes.fetch()

Template.citool.events
	'click .commit-form': ->
		Meteor.Repo.show_changes()
