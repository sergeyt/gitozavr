Template.home.list = ->
	Meteor.Repos.find {}

Template.home.readme = ->
	Session.get 'readme' || ''

Template.home.events =
	'click .repo-item': (event, tpl) ->
		$e = $(event.target)
		repo = $e.data 'name'
		console.log "click #{repo}"
		return if not repo
		Session.set 'readme', 'fetching...'
		Meteor.call 'readme', repo, (err, res) ->
			return if err
			return Session.set 'readme', 'no readme file' if not res
			Session.set 'readme', res
