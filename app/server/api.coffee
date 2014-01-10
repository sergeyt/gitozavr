fs = Npm.require 'fs'
path = Npm.require 'path'
marked = Meteor.require 'marked'

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

	api = _.extend methods...

	# resolves readme for given repository
	api.readme = (repoName) ->
		return [] if not repoName
		log.info "fetching readme for #{repoName}"
		repo = Meteor.Repos.findOne {name: repoName}
		if not repo
			console.error "unknown repo #{repoName}"
			return []
		# resolve readme files
		files = fs.readdirSync repo.dir
		files = files.filter (file) -> (/^readme.(md|markdown)$/i).test(file)
		return '' if not files.length
		file = path.join repo.dir, files[0]
		marked fs.readFileSync file, 'utf8'

	# expose web api
	Meteor.methods api
