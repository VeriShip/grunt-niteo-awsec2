Q = require 'q'
should = require 'should'
S = require 'string'
niteo = require 'niteoaws'
sinon = require 'sinon'

grunt = null
thisPointer = null
ec2ProviderFactoryStub = null
ec2ProviderStub = null

getGruntStub = ->
	log:
		writeln: sinon.stub() 
		ok: sinon.stub()  #console.log
		error: sinon.stub() 
	verbose:
		writeln: sinon.stub() 
		ok: sinon.stub() 
	fail:
		warn: sinon.stub() 
		fatal: sinon.stub() 
	fatal: sinon.stub() 
	warn: sinon.stub() 
	_options: { }
	option: (key, value) ->
		if value?
			@_options[key] = value
		else
			@_options[key]
	registerTask: sinon.stub() 
	registerMultiTask: sinon.stub() 
	task:
		run: sinon.stub() 
		clearQueue: sinon.stub() 
	template:
		process: sinon.stub() 
	file:
		read: sinon.stub() 

getThisPointer = ->
	data: { }
	async: ->
		return ->

loadGrunt = (grunt) ->

	(require '../awsec2.js')(grunt, niteo)

beforeEachMethod = ->

	#	Setup the grunt stub.
	grunt = getGruntStub()
	loadGrunt(grunt)

	thisPointer = 
		data: { }
		async: ->
			return ->

	ec2ProviderStub = 
		createKeyPair: sinon.stub().returns Q(true)
		deleteKeyPair: sinon.stub().returns Q(true)

	ec2ProviderFactoryStub?.restore()
	ec2ProviderFactoryStub = sinon.stub(niteo.ec2KeyPairsProvider, "factory")
	ec2ProviderFactoryStub.returns ec2ProviderStub

describe 'grunt', ->

	beforeEach beforeEachMethod
	
	describe 'niteo', ->

		it 'should define the grunt.niteo namespace when it does not already exist.', ->

			grunt.niteo.should.be.ok

		it 'should not overwrite the grunt.niteo namespace if it is already defined.', ->

			grunt = getGruntStub()
			grunt.niteo = 
				SomeOtherObject: { }

			loadGrunt(grunt)

			grunt.niteo.should.be.ok
			grunt.niteo.SomeOtherObject.should.be.ok

		describe 'aws', ->

			it 'should define the grunt.niteo.aws namespace when it does not already exist.', ->

				grunt.niteo.aws.should.be.ok

			it 'should not overwrite the grunt.niteo.aws namespace if it is already defined.', ->

				grunt = getGruntStub()
				grunt.niteo = 
					aws:
						SomeOtherObject: { }

				loadGrunt(grunt)

				grunt.niteo.aws.should.be.ok
				grunt.niteo.aws.SomeOtherObject.should.be.ok

			describe 'ec2', ->

				it 'should define the grunt.niteo.aws.ec2 namespace when it does not already exist.', ->

					grunt.niteo.aws.ec2.should.be.ok

				it 'should not overwrite the grunt.niteo.aws namespace if it is already defined.', ->

					grunt = getGruntStub()
					grunt.niteo = 
						aws: 
							ec2:
								SomeOtherObject: { }

					loadGrunt(grunt)

					grunt.niteo.aws.ec2.should.be.ok
					grunt.niteo.aws.ec2.SomeOtherObject.should.be.ok

				describe 'createKeyPair', ->

					it 'should throw call grunt.fail.fatal if @data.region is undefined.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.name = ""

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)

					it 'should throw call grunt.fail.fatal if @data.region is null.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.name = ""
						thisPointer.data.region = null

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)
						
					it 'should throw call grunt.fail.fatal if @data.name is undefined.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.region = ""

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)
						
					it 'should throw call grunt.fail.fatal if @data.name is null.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.name = null
						thisPointer.data.region = ""

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)
						
					it 'should throw call grunt.fail.fatal if @data.outputKey is undefined.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.name = ""
						thisPointer.data.region = ""

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)
						
					it 'should throw call grunt.fail.fatal if @data.outputKey is null.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.outputKey = null
						thisPointer.data.name = ""
						thisPointer.data.region = ""

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)

					it 'should create new ec2KeyPairsProvider with @data.region.', (done) ->

						thisPointer.async = -> 
							return ->
								ec2ProviderFactoryStub.calledOnce.should.be.true
								ec2ProviderFactoryStub.alwaysCalledWithExactly "Some Region"
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.name = ""
						thisPointer.data.region = "Some Region"

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)

					it 'should call createKeyPair on ec2KeyPairsProvider with @data.name.', (done) ->

						thisPointer.async = -> 
							return ->
								ec2ProviderStub.createKeyPair.calledOnce.should.be.true
								ec2ProviderStub.createKeyPair.alwaysCalledWithExactly "Some Name"
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.name = "Some Name"
						thisPointer.data.region = "Some Region"

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)

					it 'should call grunt.fail.fatal if an exception is encountered.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.name = "Some Name"
						thisPointer.data.region = "Some Region"

						ec2ProviderStub.createKeyPair.throws("Some Error")

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)
						
					it 'should call resolved if it is defined with the metadata from the created key pair.', (done) ->

						thisPointer.async = -> 
							return ->
								thisPointer.data.resolved.calledOnce.should.be.true
								thisPointer.data.resolved.alwaysCalledWithExactly "Some Metadata"
								done()

						thisPointer.data.outputKey = ""
						thisPointer.data.name = "Some Name"
						thisPointer.data.region = "Some Region"
						thisPointer.data.resolved = sinon.stub()

						ec2ProviderStub.createKeyPair.returns Q("Some Metadata")

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)

					it 'should place the metadata of the created key pair into grunt.option(@data.outputKey).', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.option("key").should.equal "Some Metadata"
								done()

						thisPointer.data.outputKey = "key"
						thisPointer.data.name = "Some Name"
						thisPointer.data.region = "Some Region"
						thisPointer.data.resolved = sinon.stub()

						ec2ProviderStub.createKeyPair.returns Q("Some Metadata")

						grunt.niteo.aws.ec2.createKeyPair.call(thisPointer)
						

				describe 'deleteKeyPair', ->

					it 'should throw call grunt.fail.fatal if @data.region is undefined.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.name = ""

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)

					it 'should throw call grunt.fail.fatal if @data.region is null.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.name = ""
						thisPointer.data.region = null

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)
						
					it 'should throw call grunt.fail.fatal if @data.name is undefined.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.region = ""

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)
						
					it 'should throw call grunt.fail.fatal if @data.name is null.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.name = null
						thisPointer.data.region = ""

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)

					it 'should create new ec2KeyPairsProvider with @data.region.', (done) ->

						thisPointer.async = -> 
							return ->
								ec2ProviderFactoryStub.calledOnce.should.be.true
								ec2ProviderFactoryStub.alwaysCalledWithExactly "Some Region"
								done()

						thisPointer.data.name = ""
						thisPointer.data.region = "Some Region"

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)

					it 'should call deleteKeyPair on ec2KeyPairsProvider with @data.name.', (done) ->

						thisPointer.async = -> 
							return ->
								ec2ProviderStub.deleteKeyPair.calledOnce.should.be.true
								ec2ProviderStub.deleteKeyPair.alwaysCalledWithExactly "Some Name"
								done()

						thisPointer.data.name = "Some Name"
						thisPointer.data.region = "Some Region"

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)

					it 'should call grunt.fail.fatal if an exception is encountered.', (done) ->

						thisPointer.async = -> 
							return ->
								grunt.fail.fatal.calledOnce.should.be.true
								done()

						thisPointer.data.name = "Some Name"
						thisPointer.data.region = "Some Region"

						ec2ProviderStub.deleteKeyPair.throws("Some Error")

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)
						
					it 'should call resolved if it is defined with the metadata from the created key pair.', (done) ->

						thisPointer.async = -> 
							return ->
								thisPointer.data.resolved.calledOnce.should.be.true
								done()

						thisPointer.data.name = "Some Name"
						thisPointer.data.region = "Some Region"
						thisPointer.data.resolved = sinon.stub()

						ec2ProviderStub.deleteKeyPair.returns Q()

						grunt.niteo.aws.ec2.deleteKeyPair.call(thisPointer)
