niteoaws = require 'niteoaws'

module.exports = (grunt) ->

	grunt.initConfig
		createKeyPair:
			default:
				region: 'us-east-1'
				name: 'someKeyPair'
				outputKey: 'somekey'
				resolved: (metadata) ->
					console.log metadata
		deleteKeyPair:
			default:
				region: 'us-east-1'
				name: 'someKeyPair'
				resolved: () ->
					console.log "Deleted..."

	grunt.loadTasks 'tasks'

	grunt.registerTask 'default', [ 'createKeyPair', 'deleteKeyPair' ]