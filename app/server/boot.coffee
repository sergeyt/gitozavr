Fiber = Npm.require 'fibers'
fs = Npm.require 'fs'
path = Npm.require 'path'
walk = Meteor.require 'walk'

# expands env vars in given string
replaceEnvVars = (s) ->
	s.replace /\$([\w_])+/g, (match, name) ->
		process.env[name] || name

isRepoDir = (dir) -> fs.existsSync path.join dir, '.git'

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

# converts repo dir to repo info object
makeRepoItem = (dir) ->
	path = Npm.require 'path'
	return {
		dir: dir,
		name: path.basename dir
	}

# inserts repos
insertItems = (items) ->
	for item in items
		existing = Meteor.Repos.findOne {name: item.name}
		if not existing
			Meteor.Repos.insert item
			console.log "inserted #{item.name}"

# bootstrap script
Meteor.startup ->

	findDirs Meteor.settings.public.root, (dirs)->
		console.log "found repo dirs:", JSON.stringify dirs, null, 2
		items = dirs.map (dir) -> makeRepoItem dir
		# meteor requires fibers
		(Fiber -> insertItems items).run()
