var argv = require('yargs').argv;
var gulpif = require('gulp-if');
var rename = require('gulp-rename');
var gulp = require('gulp');
var gutil = require('gulp-util');
var plumber = require('gulp-plumber');
var postcss = require('gulp-postcss');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var coffee = require('gulp-coffee');
var autoprefixer = require('gulp-autoprefixer');
var replace = require('gulp-replace');
var uglify = require('gulp-uglify');

var paths = {
  style: './source/sass/style.scss',
  script: './source/coffee/script.coffee',
  sass: './source/sass/*.scss',
  coffee: './source/coffee/*.coffee',
}

var dest = {
  css: './assets/css/',
  js: './assets/js/',
  images: './assets/images/',
  fonts: './assets/fonts/'
}

gulp.task('compile-sass', function() {
  var sassOptions = {
    outputStyle: argv.prod ? 'compressed' : null
  };
  var apOptions = {
    browsers: ['> 0.5%', 'last 5 versions', 'Firefox ESR', 'not dead']
  };
  gulp.src(paths.style)
    .pipe(plumber())
    .pipe(gulpif(argv.prod, sourcemaps.init()))
    .pipe(sass(sassOptions).on('error', sass.logError))
    .pipe(autoprefixer(apOptions))
    .pipe(gulpif(argv.prod, rename({extname:'.min.css'})))
    .pipe(gulpif(argv.prod, sourcemaps.write('./')))
    .pipe(gulp.dest(dest.css))
  .on('end', function() {
    log('Sass done');
    if (argv.prod) log('CSS minified');
  });
});

gulp.task('compile-coffee', function() {
  gulp.src(paths.script)
    .pipe(coffee({bare: true}))
    .pipe(gulpif(argv.prod, uglify()))
    .pipe(gulpif(argv.prod, rename({extname:'.min.js'})))
    .pipe(gulp.dest(dest.js))
  .on('end', function() {
    log('Coffee done');
    if (argv.prod) log('JS minified');
  });
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['compile-sass']);
  gulp.watch(paths.coffee, ['compile-coffee']);
});

gulp.task('default', [
  'compile-sass',
  'compile-coffee',
  'watch'
]);

gulp.task('dev', [
  'compile-sass',
  'compile-coffee',
  'watch'
]);

gulp.task('prod', [
  'compile-sass',
  'compile-coffee'
]);

function log(message) {
  gutil.log(gutil.colors.bold.green(message));
}