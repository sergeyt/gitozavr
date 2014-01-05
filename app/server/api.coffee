{Repo, Commit} = Meteor.require 'git'

sync = (fn) ->
	payload = Meteor.sync fn
	if payload.error
		console.error payload.error
		return []
	return payload.result

# commits impl
fetchCommits = (repo, cb) ->
	opts = {is_bare: true}
	new Repo repo.dir, opts, (err, repo) ->
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
	opts = {is_bare: true}
	new Repo repo.dir, opts, (err, repo) ->
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

# web api
Meteor.methods
	# gets list of commits for given repo
	commits: (repo) ->
		info = Meteor.Repos.findOne {name: repo}
		if not info
			console.error "unknown repo #{repo}"
			return []
		return sync (cb) -> fetchCommits info, cb

	# gets diffs of given commit
	diffs: (repo, id, parent) ->
		info = Meteor.Repos.findOne {name: repo}
		if not info
			console.error "unknown repo #{repo}"
			return []
		res = sync (cb) -> fetchDiffs info, id, parent, cb
		return res


