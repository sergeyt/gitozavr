verbose = true

# todo separate facility
log =
	error: (msg) ->
		console.error msg
	info: (msg) ->
		verbose && console.log msg

# returns impl function for given method
dispatch = (method) ->
	(repoName, rest...) ->
		return [] if not repoName
		log.info "fetching #{method}"
		repo = Meteor.Repos.findOne {name: repoName}
		if not repo
			console.error "unknown repo #{repoName}"
			return []
		git = -> Meteor.Git[method].call(null, repoName, rest...)
		switch repo.type
			when 'git' then git()
			when 'hg'
				log.error 'mercurial repos are not supported yet'
				return []
			else git()

Meteor.startup ->
	methods = ['commits', 'diffs', 'changes'].map (method) ->
		slot = {}
		slot[method] = dispatch(method)
		return slot

	# expose web api
	Meteor.methods _.extend methods...
