{Repo} = Meteor.require 'git'

stripCommit = (it) ->
	id: it.id
	author: it.author
	date: it.committed_date
	message: it.message

fetchCommits = (info, cb) ->
	opts = {is_bare: true}
	new Repo info.dir, opts, (err, repo) ->
		return cb(err, null) if err
		repo.commits 'master', 100, 0, (err, commits) ->
			cb(err, (commits || []).map stripCommit)

# web api
Meteor.methods
	# gets list of commits for given repo
	commits: (name) ->
		info = Meteor.Repos.findOne {name: name}
		if not info
			console.error "unknown repo #{name}"
			return []
		payload = Meteor.sync (cb) -> fetchCommits info, cb
		if payload.error
			console.error payload.error
			return []
		console.log "fetched commits", JSON.stringify payload.result, null, 2
		return payload.result
