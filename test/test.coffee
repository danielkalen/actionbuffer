path = require 'path'
mocha = require 'mocha'
chai = require 'chai'
expect = chai.expect
ActionBuffer = require('../lib')


suite "actionbuffer", ()->
	suiteSetup ()-> ActionBuffer.buffers.slice().forEach (buffer)-> buffer.stop()
	
	test "constructor must be invoked with a callback argument", ()->
		expect ()-> new ActionBuffer()
			.to.throw()
		
		expect ()-> new ActionBuffer ()-> 
			.not.to.throw()


	test "the constructor can be invoked without the new keyword", ()->
		buffer = ActionBuffer ()->
		expect(buffer.constructor).to.equal ActionBuffer


	test "the second argument passed to the constructor sets the timeout delay", ()->
		bufferA = new ActionBuffer (->), 12
		bufferB = new ActionBuffer (->), 94

		expect(bufferA.timeout).to.equal 12
		expect(bufferB.timeout).to.equal 94


	test "data can be pushed into the buffer and after a timeout the buffer items will be passed to the provided callback", (done)->
		result = null
		buffer = new ActionBuffer (items)->
			result = items.reduce ((a,b)-> a+b), 0
		, 10

		expect(buffer._buffer.length).to.equal(0)
		expect(result).to.equal(null)
		
		buffer.push 3
		expect(buffer._buffer.length).to.equal(1)
		expect(result).to.equal(null)
		
		buffer.push 8
		expect(buffer._buffer.length).to.equal(2)
		expect(result).to.equal(null)

		setTimeout ()->
			buffer.push 9
			expect(buffer._buffer.length).to.equal(3)
			expect(result).to.equal(null)
			
			setTimeout ()->
				expect(buffer._buffer.length).to.equal(0)
				expect(result).to.equal(20)
				done()
			, 15
		, 4


	test "the timer will start only when it starts receiving data", (done)->
		buffer = new ActionBuffer (->), 10

		expect(buffer._buffer.length).to.equal(0)
		expect(typeof buffer.timer is 'undefined').to.be.true

		buffer.push 3
		expect(buffer._buffer.length).to.equal(1)
		expect(typeof buffer.timer is 'undefined').to.be.false
		
		buffer.push 8
		expect(buffer._buffer.length).to.equal(2)
		expect(typeof buffer.timer is 'undefined').to.be.false

		setTimeout ()->
			expect(buffer._buffer.length).to.equal(0)
			expect(typeof buffer.timer is 'undefined').to.be.true
			done()
		, 11


	test "buffer can be halted using buffer.stop() and data will no longer be able to get pushed into the buffer", (done)->
		result = null
		buffer = new ActionBuffer (items)->
			result = items.length
		, 5
		
		buffer.push 8
		expect(buffer._buffer.length).to.equal(1)
		expect(result).to.equal(null)
		expect(typeof buffer.callback).to.equal('function')
		expect(typeof buffer.timer is 'undefined').to.be.false
		
		buffer.stop()
		expect(buffer._buffer.length).to.equal(0)
		expect(result).to.equal(null)
		expect(typeof buffer.callback).to.equal('undefined')
		expect(typeof buffer.timer is 'undefined').to.be.true
		
		buffer.push 12
		expect(buffer._buffer.length).to.equal(0)
		expect(result).to.equal(null)
		expect(typeof buffer.callback).to.equal('undefined')
		expect(typeof buffer.timer is 'undefined').to.be.true
		buffer.start()
		buffer.run()

		setTimeout ()->
			expect(buffer._buffer.length).to.equal(0)
			expect(result).to.equal(null)
			expect(typeof buffer.callback).to.equal('undefined')
			expect(typeof buffer.timer is 'undefined').to.be.true
			
			buffer.stop()
			expect(buffer._buffer.length).to.equal(0)
			expect(result).to.equal(null)
			expect(typeof buffer.callback).to.equal('undefined')
			expect(typeof buffer.timer is 'undefined').to.be.true
			done()
		, 2




