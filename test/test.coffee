Promise = require 'bluebird'
path = require 'path'
mocha = require 'mocha'
chai = require 'chai'
expect = chai.expect
ActionBuffer = require('../')


suite "actionbuffer", ()->
	suiteSetup ()-> ActionBuffer.buffers.slice().forEach (buffer)-> buffer.stop()
	
	test "constructor must be invoked with a callback argument", ()->
		expect ()-> new ActionBuffer()
			.to.throw()
		
		expect ()-> new ActionBuffer ()-> 
			.not.to.throw()


	test ""




