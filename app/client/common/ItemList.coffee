# todo use reactive list
verbose = true
log = (msg) ->
	verbose && console.log msg

# simple list to load items from server with polling capability
class ItemList
	# public api
	constructor: (@method, @args, @opts = {polling:true}) ->
		@list = new ReactiveProperty([])
		@polling = false
		self = @
		if _.isFunction @args
			Deps.autorun ->
				log "#{self.method} deps changed"
				self.load()

	# returns array of items
	fetch: ->
		@poll()
		@list.get()

	update: ->
		@list.set([])
		@load()

	# private api
	# loads list
	load: ->
		args = @method_args()
		log "loading #{@method} #{JSON.stringify(args)}"
		handler = @on_load.bind(@)
		Meteor.apply @method, args, {wait: true}, handler

	method_args: ->
		return [] if not @args
		switch
			when _.isFunction @args then @args()
			else @args

	on_load: (err, arr) ->
		if err
			console.log err
			return
		arr = [] if not arr
		return if EJSON.equals @list.get(), arr
		log "#{@method} list changed #{arr.length}"
		@list.set(arr)

	poll: ->
		return if @polling
		@polling = true
		@poll_impl()

	poll_impl: ->
		@load()
		return if not @opts.polling
		pollFn = @poll_impl.bind(@)
		timeout = @opts.pollingTimeout || 30000
		setTimeout pollFn, timeout

# expose
Meteor.Utils = {} if not Meteor.Utils
Meteor.Utils.ItemList = ItemList
