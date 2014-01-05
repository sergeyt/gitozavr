Router.configure
	layoutTemplate: 'layout'

Router.map ->
	@route 'home',
		path: '/'
		template: 'home'

	@route 'repo',
		path: '/:name'
		template: 'repo'
		data: ->
			name = @params.name
			return Meteor.Repos.findOne {name: name}
		load: ->
			Session.set 'repo', @params.name
