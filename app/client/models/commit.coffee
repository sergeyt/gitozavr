Template.commit.css = ->
	c = Meteor.Repo.selected_commit.get()
	return 'selected' if c == this.id
	return ''

Template.commit.events
	'click .commit': (event, tpl) ->
		Meteor.Repo.select_commit(tpl.data.id)
