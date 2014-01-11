Template.repo.hasSelectedCommit = ->
	Meteor.Repo.selected_commit()?

Template.repo.commits = ->
	Meteor.Repo.commits.fetch()
