Template.commit.css = ->
	c = Session.get 'selected-commit'
	return 'selected' if c?.id == this.id
	return ''

Template.commit.events
	'click .commit': (event, tpl) ->
		Session.set 'selected-commit', tpl.data
