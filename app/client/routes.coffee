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
			console.log 'route.repo.data'
			name = @params.name
			Meteor.SetRepo name
		load: ->
			Session.set 'repo', @params.name
