// Gulp Requires
var gulp = require('gulp'),
    gutil = require('gulp-util'),
    browserify = require('browserify'),
    rimraf = require('rimraf'),
    coffee = require('gulp-coffee'),
    coffeelint = require('gulp-coffeelint'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    jshint = require('gulp-jshint'),
    notify = require('gulp-notify'),
    plumber = require('gulp-plumber'),
    autoprefixer = require('gulp-autoprefixer'),
    sass = require('gulp-ruby-sass'),
    minifycss = require('gulp-minify-css'),
    rename = require('gulp-rename'),
    livereload = require('gulp-livereload'),
    lr = require('tiny-lr'),
    html = require('html-browserify'),
    server = lr(),
    source = require('vinyl-source-stream'),
    streamify = require('gulp-streamify');

// Node requires for exec and sys
var exec = require('child_process').exec,
    sys = require('sys');

// Directories
var SRC = './app/',
    DIST = './dist/',
    NODE = './node_modules/',
    BOWER = './bower_components/',
    BUILD = './build/';

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
        .pipe(gulp.dest(DIST + 'css'))
        .pipe(notify({message: 'CSS Complete.'}))
        .pipe(livereload(server));

});

// Vendor CSS
// gulp.task('vendorcss', function () {
//     return gulp.src([
//         NODE + 'normalize.css/normalize.css',
//         NODE + 'animate.css/animate.css',
//         NODE + 'angular-loading-bar/src/loading-bar.css',
//         SRC + 'packages/tipped-4.1.6/css/tipped/tipped.css',
//         BOWER + 'videogular-themes-default/videogular.css'
//     ])
//         .pipe(concat('vendor.css'))
//         .pipe(gulp.dest(BUILD + '/css/'));
// });


/**
 * Javascript
 */
gulp.task('js', ['coffee-lint'], function () {
    return browserify({
        entries: [ SRC + 'coffee/app.coffee' ]
    })
    .bundle()
    .pipe(source('app.min.js'))
    //.pipe(streamify(uglify({ mangle: false })))
    .pipe(gulp.dest(DIST + 'js'))
    .pipe(notify({message: 'JS Complete.'}))
    .pipe(livereload(server));
});

gulp.task('coffee-lint', function () {
    return gulp.src([
            SRC + 'coffee/**/*.coffee'
        ])
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffee({bare: true}).on('error', gutil.log));
});



/**
 * Watch
 */

// Do the creep, ahhhhhhh!
gulp.task('watch', function () {
    // Listen on port 35729
    server.listen(35729, function (err) {
        if (err) {
            return console.log(err);
        }
    });

    // Watch .scss files
    gulp.watch([
        SRC + 'scss/**/*.scss',
    ], ['scss']);

    // Watch .coffee files
    gulp.watch(SRC + 'coffee/**/*.coffee', ['js']);

    // Watch index.html file
    gulp.watch(SRC + 'index.html', ['build']);

});

/**
 * Master Tasks
 */
gulp.task('build', ['js', 'scss', 'html']);
gulp.task('default', ['build', 'watch']);