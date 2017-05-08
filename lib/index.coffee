class ActionBuffer
	@timeoutDefault = 1e3
	@buffers = []
	
	constructor: (callback, timeout)->
		return new ActionBuffer(callback, timeout) if @constructor isnt ActionBuffer
		@timeout = timeout or ActionBuffer.timeoutDefault
		@_buffer = []
		
		if typeof callback is 'function'
			@callback = callback
		else
			throw new Error "Invalid callback provided '#{String @callback}'"


	push: (data)-> unless @stopped
		@_buffer.push data
		@start() if @_buffer.length is 1

	run: ()-> if @_buffer.length
		buffer = @_buffer.slice()
		@_buffer.length = 0

		@callback(buffer)

	start: ()-> unless @timer or @stopped
		@timer = setTimeout ()=>
			@run()
			delete @timer
		, @timeout

	stop: ()-> unless @stopped
		@stopped = true
		@_buffer.length = 0 
		clearTimeout(@timer)
		delete @timer
		delete @callback
		ActionBuffer.buffers.splice ActionBuffer.buffers.indexOf(@), -1
		return





module.exports = ActionBuffer