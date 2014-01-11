Meteor.Repo = {}

Meteor.SetRepo = (name) ->
	console.log "initializing common repo model: #{name}"
	repo = Meteor.Repos.findOne {name: name}
	repo = {name: name} if not repo
	repo.commits = new Meteor.Utils.ItemList 'commits', [name]

	dep_commit = new Deps.Dependency
	selected_commit = null
	repo.selected_commit = ->
		dep_commit.depend()
		selected_commit

	diff_args =  ->
		return [] if not selected_commit
		[name, selected_commit]
	repo.diffs = new Meteor.Utils.ItemList 'diffs', diff_args, {polling: false}

	repo.selectCommit = (id) ->
		selected_commit = id
		dep_commit.changed()
		repo.diffs.update()

	Meteor.Repo = repo
	repo
