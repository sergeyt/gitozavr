Fiber = Npm.require 'fibers'
fs = Npm.require 'fs'
path = Npm.require 'path'
walk = Meteor.require 'walk'

# expands env vars in given string
replaceEnvVars = (s) ->
	s.replace /\$([\w_])+/g, (match, name) ->
		process.env[name] || name

dirExists = (dir) ->
	fs.existsSync(dir) and fs.lstatSync(dir).isDirectory()

isGitRepo = (dir) ->
	dirExists path.join dir, '.git'
isHgRepo = (dir) ->
	dirExists path.join dir, '.hg'
isRepoDir = (dir) ->
	isGitRepo dir or isHgRepo dir

# find repo dirs from given root dir
findDirs = (root, cb) ->
	root = replaceEnvVars root
	console.log "searching repos in #{root}"

	dirs = []
	opts = {}
	walker = walk.walk root, opts

	walker.on 'directories', (dir, stats, next)->
		dirs.push dir if isRepoDir dir
		next()

	walker.on 'end', -> cb dirs

repoType = (dir) ->
	switch
		when isGitRepo dir then 'git'
		when isHgRepo dir then 'hg'
		else 'unknown'

# converts repo dir to repo info object
makeRepoItem = (dir) ->
	return {
		type: repoType dir
		name: path.basename dir
		# todo url
		dir: dir
	}

# inserts repos
insertItems = (items) ->
	for item in items
		existing = Meteor.Repos.findOne {name: item.name}
		if not existing
			# TODO watch repo dir to get commit data
			Meteor.Repos.insert item
			console.log "inserted #{item.name}"

# bootstrap script
Meteor.startup ->

	# todo smart update of existing repositories
	Meteor.Repos.remove {}

	findDirs Meteor.settings.public.root, (dirs)->
		items = dirs.map (dir) -> makeRepoItem dir
		# meteor requires fibers
		(Fiber -> insertItems items).run()
