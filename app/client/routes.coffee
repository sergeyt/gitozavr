Router.configure
	layoutTemplate: 'layout'

Router.map ->
	@route 'home',
		path: '/'
		template: 'home'

	@route 'repo',
		path: '/:name',
		template: 'repo',
		data: ->
			name = this.params.name
			return Meteor.Repos.findOne {name: name}
