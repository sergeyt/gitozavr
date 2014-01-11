# creates hg object for given repo
create = (name) ->
	repo = Meteor.Repos.findOne {name: name}
	if not repo
		console.error "unknown repo #{name}"
		return null
	Meteor.require('hg.js')(repo.dir)

# todo move this to common separate module
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

# hg api
Meteor.Mercurial =
	# gets list of commits for given repo
	commits: (repo) ->
		hg = create(repo)
		return [] if not hg
		sync hg.log()
	# gets diffs of given commit
	diffs: (repo, id) ->
		hg = create(repo)
		return [] if not hg
		sync hg.diff([id])
	# gets list of uncommited changes
	changes: (repo) ->
		hg = create(repo)
		return [] if not hg
		sync hg.diff()
