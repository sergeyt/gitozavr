Template.citool.changes = ->
	Meteor.Repo.changes.fetch()

Template.citool.events
	'click .commit-form': ->
		Meteor.Repo.show_changes()
	'click .btn-commit': ->
		opts =
			message: $('#commit-message').val()
			description: $('#commit-desciption').val()
			# todo commit only selected changes
			all: true
		Meteor.Repo.commit opts, (err) ->
			# todo use bootstrap alert like bootbox
			return alert(err) if err
			$('#commit-message').val('')
			$('#commit-desciption').val('')
