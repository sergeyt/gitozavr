{Repo, Commit, Status} = Meteor.require 'git'
git = Meteor.require 'git.js'

repopts = {is_bare: true}

sync = (fn) ->
	payload = Meteor.sync fn
	if payload.error
		console.error payload.error
		return []
	return payload.result || []

# commits impl
fetchCommits = (repo, cb) ->
	new Repo repo.dir, repopts, (err, repo) ->
		return cb(err, null) if err
		repo.commits 'master', 100, 0, (err, commits) ->
			cb(err, (commits||[]).map stripCommit)

stripCommit = (it) ->
	id: it.id
	parent: (it.parents||[])[0]?.id
	author: it.author
	date: it.committed_date
	message: it.message

# diffs impl
fetchDiffs = (repo, id, parent, cb) ->
	new Repo repo.dir, repopts, (err, repo) ->
		return cb(err, null) if err
		parents = if parent then [{id:parent}] else null
		c = new Commit(repo, id, parents)
		c.diffs (err, res) ->
			cb(err, (res||[]).map stripDiff)

stripDiff = (it) ->
	file: it.a_path
	content: it.diff
	isNew: it.new_file
	isDeleted: it.deleted_file

# changes impl
fetchChanges = (repo, cb) ->
	git(repo.dir).status()
		.then (files) ->
			cb null, files
		.fail (err) ->
			cb err, null

# web api
Meteor.methods
	# gets list of commits for given repo
	commits: (repo) ->
		console.log "fetching commits: #{repo}"
		info = Meteor.Repos.findOne {name: repo}
		if not info
			console.error "unknown repo #{repo}"
			return []
		return sync (cb) -> fetchCommits info, cb

	# gets diffs of given commit
	diffs: (repo, id, parent) ->
		console.log "fetching diffs: #{repo}, #{id}"
		info = Meteor.Repos.findOne {name: repo}
		if not info
			console.error "unknown repo #{repo}"
			return []
		return sync (cb) -> fetchDiffs info, id, parent, cb

	# gets list of uncommited changes
	changes: (repo) ->
		console.log "fetching changes: #{repo}"
		info = Meteor.Repos.findOne {name: repo}
		if not info
			console.error "unknown repo #{repo}"
			return []
		return sync (cb) -> fetchChanges info, cb
