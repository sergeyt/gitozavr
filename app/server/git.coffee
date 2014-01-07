# creates git object for given repo
createGit = (repo) ->
	info = Meteor.Repos.findOne {name: repo}
	if not info
		console.error "unknown repo #{repo}"
		return null
	Meteor.require('git.js')(info.dir)

# returns node-style async func for given promise
async = (promise) ->
	(cb) ->
		promise
		.then (res) -> cb null, res
		.fail (err) -> cb err, null

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
		git = createGit(repo)
		return [] if not git
		sync git.log()
	# todo diffs
	# todo changes
