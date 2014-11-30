// Gulp Requires
var gulp = require('gulp'),
    gutil = require('gulp-util'),
    browserify = require('browserify'),
    coffee = require('gulp-coffee'),
    coffeelint = require('gulp-coffeelint'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    notify = require('gulp-notify'),
    plumber = require('gulp-plumber'),
    autoprefixer = require('gulp-autoprefixer'),
    sass = require('gulp-ruby-sass'),
    minifycss = require('gulp-minify-css'),
    rename = require('gulp-rename'),
    html = require('html-browserify'),
    connect = require('gulp-connect'),
    source = require('vinyl-source-stream'),
    streamify = require('gulp-streamify'),
    subtree = require('gulp-subtree'),
    clean = require('gulp-clean');

// Node requires for exec and sys
var exec = require('child_process').exec,
    sys = require('sys');

// Directories
var SRC = './app/',
    TEMP = './temp/',
    DIST = './dist/',
    NODE = './node_modules/',
    BOWER = './bower_components/';

var onError = function (err) {
    gutil.beep();
};


gulp.task('html', function () {
    return gulp.src(SRC + 'index.html')
        .pipe(gulp.dest(DIST))
});

/**
 * CSS
 */

// SCSS Compiling and Minification
gulp.task('scss', function () {
    return gulp.src([
        SRC + 'scss/app.scss'
    ])
        .pipe(plumber({
            errorHandler: onError
        }))
        .pipe(sass({
            loadPath: [SRC],
            debugInfo: false,
            lineNumbers: false
        }))
        .pipe(autoprefixer('last 3 version'))
        .pipe(minifycss())
        .pipe(rename('app.min.css'))
        .pipe(gulp.dest(DIST + '/css'))
        .pipe(connect.reload())
        .pipe(notify({message: 'CSS Complete.'}));

});


/**
 * Javascript
 */
gulp.task('js', function () {
    return browserify({
        entries: [ SRC + 'react/app.cjsx' ]
    })
    .bundle()
    .pipe(source('app.min.js'))
    //.pipe(streamify(uglify({ mangle: false })))
    .pipe(gulp.dest(DIST + 'js'))
    .pipe(notify({message: 'JS Complete.'}))
    .pipe(connect.reload());
});


/**
 * Watch
 */

//Do the creep, ahhhhhhh!
gulp.task('watch', function () {
    // Watch .scss files
    gulp.watch([
        SRC + 'scss/**/*.scss',
    ], ['scss']);

    // Watch .coffee files
    gulp.watch(SRC + 'react/**/*.cjsx', ['js']);

    // Watch index.html file
    gulp.watch(SRC + 'index.html', ['build']);

});

gulp.task('connect', function() {
    connect.server({
        root: 'dist',
        port: 1337,
        livereload: true
    });
});

/**
 * Master Tasks
 */
gulp.task('build', ['js', 'scss', 'html']);
gulp.task('default', ['build', 'watch', 'connect']);

// Deploy to gh-pages
gulp.task('temp', function() {
    return gulp.src(DIST + '/**/*')
        .pipe(gulp.dest(TEMP));
});

gulp.task('deploy', ['temp'], function() {
    return gulp.src(TEMP)
        .pipe(subtree())
        .pipe(clean());
});