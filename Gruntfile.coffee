module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src'
          src: '**/*.coffee'
          dest: 'target'
          ext: '.js'
        ]
    coffeelint:
      app: 'src/**/*.coffee'
      options:
        max_line_length:
          value: 120
    watch:
      files: ['Gruntfile.coffee', 'src/**/*.coffee']
      tasks: ['coffeelint', 'coffee']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']
