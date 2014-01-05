# Handlebars helpers
return if (typeof Handlebars == 'undefined')

Handlebars.registerHelper "timeago", (date) ->
	return 'some time ago' if not date
	dateObj = new Date(date)
	return moment(dateObj).fromNow().replace(/\ /g, '\u00a0')

Handlebars.registerHelper "gravatar", (email, size) ->
	Gravatar.imageUrl(email, {s: size})
