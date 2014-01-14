Meteor.Repo = {}

Meteor.SetRepo = (name) ->
	repo = Meteor.Repos.findOne {name: name}
	repo = {name: name} if not repo

	# list of commits
	repo.commits = new Meteor.Utils.ItemList 'commits', [name]

	# id of selected commit
	repo.selected_commit = new ReactiveProperty null

	# list of diffs for selected commit
	diff_args =  ->
		id = repo.selected_commit.get()
		return [] if not id
		[name, id]
	diffs = new Meteor.Utils.ItemList 'diffs', diff_args, {polling: false}

	repo.diffs = ->
		id = repo.selected_commit.get()
		if id then diffs.fetch() else repo.changes.fetch()

	repo.select_commit = (id) ->
		repo.selected_commit.set id
		diffs.update()

	# list of recent changes
	repo.changes = new Meteor.Utils.ItemList 'changes', [name]
	repo.show_changes = ->
		repo.selected_commit.set null

	repo.commit = (opts, cb) ->
		Meteor.call 'commit', name, opts, (err) ->
			return cb(err) if err
			repo.selected_commit.set null
			repo.changes.update()
			cb null, 'ok'

	Meteor.Repo = repo
	repo
