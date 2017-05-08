class ActionBuffer
	@timeoutDefault = 2e3
	@buffers = []
	
	constructor: (@callback, timeout)->
		@timeout = timeout or ActionBuffer.timeoutDefault
		@buffer = []
		if typeof @callback isnt 'function'
			throw new Error "Invalid callback provided '#{String @callback}'"

	push: (data)-> unless @stopped
		@buffer.push data
		@start() if @buffer.length is 1

	run: ()-> if @buffer.length
		buffer = @buffer.slice()
		@buffer.length = 0

		@callback(buffer)

	start: ()-> unless @timer
		@timer = setTimeout ()=>
			@run()
			delete @timer
		, @timeout

	stop: ()-> unless @stopped
		@stopped = true
		@buffer.length = 0 
		clearTimeout(@timer)
		delete @timer
		ActionBuffer.buffers.splice ActionBuffer.buffers.indexOf(@), -1
		return





module.exports = ActionBuffer