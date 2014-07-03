module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffeelint:
      app: 'app.coffee'
      options:
        max_line_length:
          value: 120
    watch:
      files: ['Gruntfile.coffee', 'src/**/*.coffee']
      tasks: ['coffeelint']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']
