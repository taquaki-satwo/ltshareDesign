#
# gulpfile.coffee
#

sources =
  jade  : './src/jade/**/*.jade'
  scss  : './src/scss/**/*.scss'
  dist  : './dist/'


autoprefixer   = require 'gulp-autoprefixer'
browserify     = require 'browserify'
debowerify     = require 'debowerify'
concat         = require 'gulp-concat'
cssmin         = require 'gulp-cssmin'
gulp           = require 'gulp'
jade           = require 'gulp-jade'
less           = require 'gulp-less'
plumber        = require 'gulp-plumber'
scss           = require 'gulp-sass'
source         = require 'vinyl-source-stream'
webserver      = require 'gulp-webserver'


#
# task
#

# default
gulp.task 'default', ['build']
gulp.task 'build', [
  'build:jade',
  'build:css',
  'build:js',
  'build:watch',
  'build:webserver'
]


# watch
gulp.task 'build:watch', ->
  gulp.watch sources.jade,  ['build:jade']
  gulp.watch sources.js,    ['build:js']
  gulp.watch sources.scss,  ['build:css']


# html
gulp.task 'build:jade', ->
  gulp.src ['./src/jade/**/*.jade', '!./src/jade/**/_*.jade']
      .pipe plumber()
      .pipe jade { pretty: true }
      .pipe gulp.dest sources.dist


# css
gulp.task 'build:css', ->
  gulp.src sources.scss
      .pipe plumber()
      .pipe scss()
      .pipe autoprefixer()
      .pipe concat 'style.css'
      # .pipe cssmin()
      .pipe gulp.dest sources.dist + 'css/'


# js
gulp.task 'build:js', ->
  browserify
    entries: ['./src/js/main.js']
    transform: ['babelify', 'debowerify']
  .bundle()
  .pipe source 'bundle.js'
  .pipe gulp.dest sources.dist + 'js/'


# web server
gulp.task 'build:webserver', ->
  gulp.src sources.dist
      .pipe webserver { host: '127.0.0.1', livereload: true }
