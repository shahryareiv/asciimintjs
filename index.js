"use strict";

const
	execSync = require('child_process').execSync,
	gulp = require('gulp'),
	appRoot = require('app-root-path')
;
require(`${appRoot}/lib/asciimintjs/gulpfile.js`);// import the gulp file
// const result = gulp.task('default')();

if (gulp.tasks.default) { 
    console.log('gulpfile contains task!');
    gulp.start('default');
}
