Template.commit.css = ->
	c = Meteor.Repo.selected_commit()
	return 'selected' if c == this.id
	return ''

Template.commit.events
	'click .commit': (event, tpl) ->
		Meteor.Repo.selectCommit(tpl.data.id)
