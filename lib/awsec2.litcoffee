awscloudformation.litcoffee
===========================

*Note:* Any code blocks preceeded by a **Implementation** is actual code and not code examples.

**Implementation**

	Q = require 'q'
	_ = require 'lodash'
	colors = require 'colors'
	S = require 'string'
	path = require 'path'
	moment = require 'moment'

	module.exports = (grunt, niteoaws) ->

In order to test the interaction with the [`niteoaws.cloudFormationProvider`](https://github.com/NiteoSoftware/niteoaws), we need to be abstract the object.  Therefore we need to allow that abstraction to be passed into the module.

**Implementation**

		if not niteoaws?
			niteoaws = require 'niteoaws'

We clear up namespaces here.

**Implementation**

		if not grunt.niteo?
			grunt.niteo = { }
		if not grunt.niteo.aws?
			grunt.niteo.aws = { }
		if not grunt.niteo.aws.ec2?
			grunt.niteo.aws.ec2 = { }

createKeyPair
-------------

You can use this method to create key pairs within your [AWS](http://aws.amazon.com/) infrastructure.

- *region* (Required) The region to create the key pair in.
- *name* (Required) The name of the key pair.
- *outputKey* (Required) The key name to use when placing the resulting metadata into [`grunt.option()`](http://gruntjs.com/api/grunt.option).
- *resolved* (Optional) An optional callback that will be called when the key pair metadata is resolved.  It's signature is: `function(metadata) { ... }`

```javascript

niteoaws = require('niteoaws');

grunt.initConfig({
	createKeyPair:
		default:
			region: 'us-east-1',
			name: 'SomeKeyName',
			outputKey: 'SomeKeyPairMetadataKey'
			resolved: function(metadata) { console.log metadata; }
})
```

In the above example we're creating a key pair with name `SomeKeyName` in the `us-east-1` region.  When the key pair is resolved, we run the metadata through the `resolve` callback then place the metadata into `grunt.option(@data.outputKey)`

**Implementation**

		grunt.niteo.aws.ec2.createKeyPair = ->

			done = @async()

			Q.try =>

				if not @data.region?
					throw "You must define a region."

				if not @data.name?
					throw "You must define a region."

				if not @data.outputKey?
					throw "You must define an outputKey."

				provider = new niteoaws.ec2KeyPairsProvider.factory @data.region
				provider.createKeyPair @data.name

			.then (result) =>
				if @data.resolved?
					@data.resolved result
				grunt.option(@data.outputKey, result)
			.catch (err) ->
				grunt.fail.fatal err
			.done ->
				done()

		# We register the task with grunt here.
		grunt.registerMultiTask 'createKeyPair', grunt.niteo.aws.ec2.createKeyPair

deleteKeyPair
-------------

You can use this method to delete key pairs from within your [AWS](http://aws.amazon.com/) infrastructure.

- *region* (Required) The region to create the key pair in.
- *name* (Required) The name of the key pair.
- *resolved* (Optional) An optional callback that will be called when the key pair is deleted.  It's signature is: `function() { ... }`

```javascript

niteoaws = require('niteoaws');

grunt.initConfig({
	deleteKeyPair:
		default:
			region: 'us-east-1',
			name: 'SomeKeyName',
			resolved: function() { console.log "Deleted..."; }
})
```

In the above example we're deleting a key pair with name `SomeKeyName` from the `us-east-1` region.  When the key pair is deleted, we call the `resolve` callback which simply prints "Deleted..." into the console.

**Implementation**


		grunt.niteo.aws.ec2.deleteKeyPair = ->

			done = @async()

			Q.try =>

				if not @data.region?
					throw "You must define a region."

				if not @data.name?
					throw "You must define a region."

				provider = new niteoaws.ec2KeyPairsProvider.factory @data.region
				provider.deleteKeyPair @data.name

			.then =>
				if @data.resolved?
					@data.resolved()
			.catch (err) ->
				grunt.fail.fatal err
			.done ->
				done()

		# We register the grunt task here.
		grunt.registerMultiTask 'deleteKeyPair', grunt.niteo.aws.ec2.deleteKeyPair