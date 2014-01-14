Template.repo.hasSelectedCommit = ->
	Meteor.Repo.selected_commit.get()?

Template.repo.commits = ->
	Meteor.Repo.commits.fetch()
