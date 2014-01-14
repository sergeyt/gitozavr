# creates git object for given repo
create = (name) ->
	repo = Meteor.Repos.findOne {name: name}
	if not repo
		console.error "unknown repo #{name}"
		return null
	git = Meteor.require 'git.js'
	git repo.dir, {verbose: true}

# returns node-style async func for given promise
async = (promise) ->
	(cb) ->
		promise
		.then (res) ->
			cb null, res
		.fail (err) ->
			cb err, null

sync = (promise) ->
	payload = Meteor.sync async promise
	if payload.error
		console.error payload.error
		return []
	return payload.result || []

# git api
Meteor.Git =
	# gets list of commits for given repo
	commits: (repo) ->
		git = create(repo)
		return [] if not git
		sync git.log()
	# gets diffs of given commit
	diffs: (repo, id) ->
		git = create(repo)
		return [] if not git
		sync git.show.diff(id)
	# gets list of uncommited changes
	changes: (repo) ->
		git = create(repo)
		return [] if not git
		sync git.diff()
	# commit changes
	commit: (repo, opts) ->
		git = create(repo)
		return [] if not git
		sync git.commit(opts)
