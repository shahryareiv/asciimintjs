/*
This Gulp does these things
	Creates different output formats by just one run
	Converts or compiles all different figure
	Copyright Shahryar Eivazzadeh 2016
*/

/*
This Gulp needs following libraries to work
	brew install imagemagick
	brew install graphicsmagick
	gem install asciidoctor
	gem install asciidoctor-bib
	gem install asciidoctor-mathematical
	gem install activesupport (for unicode)
	dblatex
	latexmk (and latex/xelatex)
*/

/*
This Gulp assumes this directory structure and files

In the base directory:
	- gulpfile.js (HERE I AM!)
	- *.adoc.txt => Source files in asciidoc (they may include each other)
	- *.bib => bib files
	- *.tex => Extra source files in Tex (e.g a glossary file in tex that cannot be created in asciidoc)
	- [figures] => expects all figures to be here, they can be .png .pdf .tikz.tex .jpg .svg)
In the [output] directory:
	- [output] => will put all outputs here, or in subfolders if needed
		-[html_images] => will put html images(.png, .jpg, .svg) here
		-[html_libs] => will put css and js files here
		-[pdf_images] => will put all images as pdf here	
In the Asciimint directory:	
	- [build] => will do every dirty compiling here
	- [styles] => style things for different formats
		-[html] => all css and js files plus docinfo.html (to be inserted in header) and docinfo-footer.html (to be inserted in footer)
		-[tex] => x_article.tex and x_book.tex as templates, where they specify some placeholder location within themselve by using MAGICPLACEHOLDERXXX where XXX is GLS, SRC, or BIB
				all required extra tex packages, or other files (eg. image files, config files) required by the templates or the packages
		-[pdf] => some-theme.yml for theme file of pdf direct
			-[pdf-fonts] => fonts (according to some-theme.yml)
	- [node_modules] => all Node modules (managed by NPM) that this AsciiMintgulp is depending on
	- [other_modules] => Other libs and files needed by this AsciiMint gulp (don't touch them!)
*/

/*
Conventional file names
*/
const ASCIIDOCTOR_VER = '1.5.5';
// const ASCIIDOCTOR_VER_RUBY = ` _${ASCIIDOCTOR_VER}_ `;
const ASCIIDOCTOR_VER_RUBY = ``;

/*
How to configure all these
	- Config variables section in this file
	- Styles directory
	- Command line (to be developed)
	- Config file (to be developed)
*/

/*
Naming Convention:
	copy_to_base_folder_T: copy and gather source files into the source folder
	copy_to_build_folder_T: all original files in the build folder
	xxx_T : xxx task that gets/creates xxx format files in the build folder from the original files
	XXX_T: XXX task that creates XXX format files and all other related required formats in the output folder
	xxx_f_yyy_T: The task to get xxx from yyy
	xxx_f_yyy_3_zzz_T: Same as xxx_f_yyy but it specifies it should happen through zzz
	xxx_4_yyy_T: The task to get xxx from the originals but with consideration of being converted to yyy later
	xxx_prep_4_yyy_T: The task to prepare xxx for conversion to yyy
	xxx_prep_something_4_yyy_T: The task to prepare "something" that is needed in conversion of xxx to yyy
*/

"use strict";

/*
Libraries
*/
const 
	gulp = require('gulp'),
	FwdRef = require('undertaker-forward-reference'),
	// gasciidoctor =require('gulp-asciidoctor'),
	asciidoctor = require('asciidoctor.js')(),
	tap = require('gulp-tap'),
	run = require('gulp-run'),
	gexec = require('gulp-exec'),
	gcheerio=require('gulp-cheerio'),
	runSequence = require('run-sequence'),
	grename=require('gulp-rename'),
	flatten = require('gulp-flatten'),
	greplace = require('gulp-replace'),
	vfs = require('vinyl-fs'),
	Saxon = require('saxon-stream'),
	cheerio=require('cheerio'),
	execSync = require('child_process').execSync,
	fs=require('fs-extra'),//graceful-fs-extra
	newer = require('gulp-newer'),
	cache = require('gulp-cached'),	
	merge = require('merge-stream'),
	streamqueue = require('streamqueue'),
	watch = require('gulp-watch'),
	gutil = require('gulp-util'),
	debug = require('gulp-debug'),
	path=require('path'),
	tracercon=require('tracer').colorConsole(),
	appRoot = require('app-root-path'),
	reqlib = require('app-root-path').require,//var myModule = reqlib('/lib/my-module.js')
	isUtf8 = require('is-utf8'),
	// logger = require('winston'),
	gm = require('gulp-gm'),
	pandoc = require('node-pandoc'),
	sanitizeHtml = require('sanitize-html')
;
gulp.registry(FwdRef()); // or gulp.registry(new FwdRef()

// const logger = require(`./logger.js`);
// var logger = new (winston.Logger)({
// transports: [
//   new (winston.transports.Console)(),
//   new (winston.transports.File)({ filename: 'somefile.log' })
// ]
// });
var logger = require('winston');
logger.level = 'debug';
const cfg = require(`./cfg.js`);
function get_funcs_from_strings(the_strings){
	var result = the_strings.map(x => global[x]);
	return result;
}
var tasks_functions_from_cfg = get_funcs_from_strings(cfg.tasks);
const adocFarsiPreprocess = require(`./farsi_preprocess.js`);//${appRoot}/lib/asciimintjs/
const adocAbbreviationsPreprocess4Html = require(`./abbreviation_preprocess_4html.js`);
const adocAbbreviationsPreprocess4Tex = require(`./abbreviation_preprocess_4tex.js`);
const adocCitationPreprocess = require(`./citation_preprocess.js`);
const util = require(`./util.js`);



var isCfgRead=false;
cfg.read_and_update();
isCfgRead=true;


//['ADOC','html_f_adoc','pdf_f_adoc','docbook_f_adoc','html_2_latex','pdffig_figures','tex_f_docbook','pdftex_f_tex'];
var tasks_all=[
	'ADOC',
	'HTML',
	'DOCX',
	'PRESENTATION',
	'pdf_f_adoc',
	'docbook_f_adoc',
	'html_2_latex',
	'pdffig_figures',
	'tex_f_docbook',
	'tex_f_adoc',
	'pdftex_f_tex',
	'PDF_DIRECT',
	'PDF_FOPUB',
];


var asciidoctor_lang_atr = (cfg.lang===undefined) ? '':' -a lang='+cfg.lang+' ';





var pdf_fonts_dir="./pdf-fonts";



// Load asciidoctor.js + asciidoctor-reveal.js
// var asciidoctor = require('asciidoctor.js')();
// var processor = asciidoctor.Asciidoctor();
// var opal = asciidoctor.Opal;
// require('asciidoctor-reveal.js'); ERROR!







/*==================================
 Format based tasks
==================================*/




/*==================================
 ADOC conversions
==================================*/
function adocRLPreprocess(the_content){
	logger.debug(`\n\n Begin adocRLPreprocess`);
	//
	const _LTR_CHAR_RANGE=`a-zA-Z0-9\\x7f-\xff`;
	const _RTL_CHAR_RANGE=`\\u{600}-\\u{6FF}`;
	const LTR_WORD_BEGIN=`[${_LTR_CHAR_RANGE}]`;//   \\{
	const LTR_WORD=`${LTR_WORD_BEGIN}+(?:${LTR_WORD_BEGIN}|_|-)*`;
	const RTL_WORD_BEGIN=`[${_RTL_CHAR_RANGE}]`;
	const RTL_WORD=`${RTL_WORD_BEGIN}+(?:${RTL_WORD_BEGIN}|_|-)*`;
	const INTER_WORD=`[^${_LTR_CHAR_RANGE}${_RTL_CHAR_RANGE}]`;//  (?:\\s|,|-|\\(|\\)|_)*
}



//Convert original asciidoc to asciidoc output (some preprocessing are involved)
var ADOC_T=function(){gulp.task('ADOC', gulp.series(adoc_4_adoc,function() {

	logger.debug(`\n\n Begin ADOC`);			
	return gulp
		.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
		.pipe(newer(cfg.outfolder))
		.pipe(gulp.dest(cfg.outfolder))
	;	
	
}));
}();
function adoc_4_adoc(){gulp.task('adoc_4_adoc', gulp.series('adoc_4_all',function() {

	logger.debug(`\n\n Begin adoc_4_all`);		
	logger.debug('Trying to find:'+cfg.buildfolder+'/*.adoc.txt');
	var gulpresult=gulp		
		.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
		// .pipe(newer(cfg.buildfolder)) // IT DOES sense to compare with oneself
		.pipe(tap(function(file, t) {
			var cmd=
				'ruby '+
				` "${appRoot}/lib/asciidoc-to-asciidoc/asciidoc-coalescer.rb" `+
				`"`+
				// ` -a doctype=${cfg.doctype} `+
				` --output ${cfg.buildfolder}/${path.basename(file.path)}.resolv.adoc ` +
				path.basename(file.path)+
				`"`
			;
			logger.debug("This command "+cmd+" will be used for ADOC");
			execSync(cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
			    	logger.debug('stdout: ' + stdout);
			    	logger.debug('stderr: ' + stderr);
			    	if (error !== null) {
			        	logger.debug('execSync error: ' + error);
			    	}
			    }
			)
		}))
		.pipe(gulp.dest(cfg.buildfolder,{mode:"0777"}));	
	;
	return gulpresult;	
}));
}

//Convert original asciidoc to asciidoc with preprocess for all
// These preprocessing are considered for all:
//	- Language conversions (currently Farsi to English) if needed
var adoc_4_all_T=function(){gulp.task('adoc_4_all', gulp.series(init_copy_tasks,function() {

	logger.debug(`\n\n Begin adoc_4_all`);		
	logger.debug('Trying to find:'+cfg.buildfolder+'/*.adoc.txt');
	var gulpresult=gulp		
		.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
		// .pipe(newer(cfg.buildfolder)) // IT DOES sense to compare with oneself
		.pipe(tap(function(file, t) {

			var file_contents_string=file.contents.toString();

			// Farsi conversion
			if (cfg.lang=='fa'){
				file_contents_string=adocFarsiPreprocess(file_contents_string);
			}


			file.contents=Buffer.from(file_contents_string);		
		}))
		.pipe(gulp.dest(cfg.buildfolder,{mode:"0777"}));	
	;
	return gulpresult;	
}));
}();

//Convert original asciidoc to asciidoc but to be passed to DocBook convertor
// These preprocessing are considered for DocBook:
//	- Citations
var adoc_4_docbook_T=function(){gulp.task('adoc_4_docbook', gulp.series('adoc_4_all',function() {

	logger.debug(`\n\n Begin adoc_4_docbook`);	
	var gulpresult=gulp		
		.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
		// .pipe(newer(cfg.buildfolder)) // IT DOES sense to compare with oneself
		.pipe(tap(function(file, t) {
			var file_contents_string=file.contents.toString();


			//Abbreviation management
			file_contents_string=adocAbbreviationsPreprocess4Html(file_contents_string);

			// Citation conversion
			file_contents_string=adocCitationPreprocess(file_contents_string,'docbook');
			file.contents=Buffer.from(file_contents_string);		
		}))
		.pipe(grename(function(path){
			logger.debug(`For ${path.basename}, ${path.extname} will be changed to .4docbook `);
			path.extname = ".4docbook";
		}))
		.pipe(gulp.dest(cfg.buildfolder));	
	;
	return gulpresult;	
}));
}();

//Convert original asciidoc to asciidoc but to be passed to docbook and then passed to tex convertor
var adoc_4_docbooktex_T=function(){gulp.task('adoc_4_docbooktex', gulp.series('adoc_4_all',function() {

	logger.debug(`

		Begin adoc_4_docbooktex
	`);

	var res=gulp		
		.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
		// .pipe(newer(cfg.buildfolder)) // IT DOES sense to compare with oneself
		.pipe(tap(function(file, t) {
			var file_contents_string=file.contents.toString();

			logger.debug(`adoc_4_docbook: I could read the file`);	

			// Abbreviation tex_glossary.tex creation
			file_contents_string=adocAbbreviationsPreprocess4Tex(file_contents_string);
			logger.debug(`adoc_4_docbook: I could do abbreviation preprocess`);	

			//Citation conversion
			file_contents_string=adocCitationPreprocess(file_contents_string,'tex');
			logger.debug(`adoc_4_docbook: I could do abbreviation preprocess`);	

			file.contents=Buffer.from(file_contents_string);		
		}))
		.pipe(grename(function(path){
			logger.debug(`For ${path.filename}, ${path.extname} will be changed to .4docbooktex `);
			path.extname = ".4docbooktex";
		}))		
		.pipe(gulp.dest(cfg.buildfolder));	
	;
	return res;	
}));
}();

//Convert original asciidoc to asciidoc but to be passed to html convertor
var adoc_4_html_T=function(){gulp.task('adoc_4_html', gulp.series('adoc_4_all',function() {
	logger.debug(`verbose`,`adoc_4_html`);

	var gulpresult=gulp		
		.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
		// .pipe(newer(cfg.buildfolder)) // IT DOES sense to compare with oneself
		.pipe(tap(function(file, t) {

			var file_contents_string=file.contents.toString();
			var filename=path.basename(file.path);

			// Remove sidenotes if required
			if (cfg.remove_sidebar_text){
				// file_contents_string=util.replaceAll(file_contents_string,`^\\*{4}\\n([^\\n]*\\n)*?^\\*{4}$`,``);
				logger.debug(`Removing sidebars in ${filename}`);
				const SIDEBAR_PAT = `^\\*{4}\\n([^\\n]*\\n)*?^\\*{4}$`;
				file_contents_string=file_contents_string.replace(new RegExp(SIDEBAR_PAT,'gmiu'),function(the_match){
					//empty string means remove
					var res='';
					logger.debug(`Removed  the --${the_match}-- `)
					return res;
				});				
			}

			// Replace the first abbreviation with its extended form
			file_contents_string=adocAbbreviationsPreprocess4Html(file_contents_string);


			file.contents=Buffer.from(file_contents_string);		
		}))
		.pipe(grename(function(path){
			logger.debug(`For ${path.filename}, ${path.extname} will be changed to .4docbooktex `);
			path.extname = ".4html.txt";
		}))		
		.pipe(gulp.dest(cfg.buildfolder,{mode:"0777"}));	
	;
	return gulpresult;	


	// return gulp;	
}));
}();


//Convert original asciidoc to asciidoc but to be passed to html convertor
var adoc_4_docx_T=function(){gulp.task('adoc_4_docx', gulp.series('adoc_4_all',function() {
	logger.debug(`verbose`,`adoc_4_docx`);

	var gulpresult=gulp		
		.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
		// .pipe(newer(cfg.buildfolder)) // IT DOES sense to compare with oneself
		.pipe(tap(function(file, t) {

			var file_contents_string=file.contents.toString();
			var filename=path.basename(file.path);

			// Remove sidenotes if required
				// file_contents_string=util.replaceAll(file_contents_string,`^\\*{4}\\n([^\\n]*\\n)*?^\\*{4}$`,``);
				logger.debug(`Removing sidebars in ${filename}`);
				const SIDEBAR_PAT = `^\\*{4}\\n([^\\n]*\\n)*?^\\*{4}$`;
				file_contents_string=file_contents_string.replace(new RegExp(SIDEBAR_PAT,'gmiu'),function(the_match){
					//empty string means remove
					var res='';
					logger.debug(`Removed  the --${the_match}-- `)
					return res;
				});				

			// Replace the first abbreviation with its extended form
			file_contents_string=adocAbbreviationsPreprocess4Html(file_contents_string);


			file.contents=Buffer.from(file_contents_string);		
		}))
		.pipe(grename(function(path){
			logger.debug(`For ${path.filename}, ${path.extname} will be changed to .4docx.txt `);
			path.extname = ".4docx.txt";
		}))				
		.pipe(gulp.dest(cfg.buildfolder,{mode:"0777"}));	
	;
	return gulpresult;	


	// return gulp;	
}));
}();

//Convert original asciidoc to asciidoc but to be passed to pdf (direct) convertor
var adoc_4_pdf_T=function(){gulp.task('adoc_4_pdf', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`adoc_4_pdf`);

	// Replace the first abbreviation with its extended form
	file_contents_string=adocAbbreviationsPreprocess4Html(file_contents_string);

	return gulp;	
}));
}();


// var asciidoc_bib_T=function(){gulp.task('asciidoc_bib', function() {
// 	var cmd_asciidocbib=""
// 	var gulpresult= gulp
// 		.src(['*.adoc.txt'],{cwd:cfg.buildfolder})//,{cwd:cfg.buildfolder}
// 		.pipe(tap(function(file, t) {
// 			execSync(cmd_asciidocbib+' "'+file.path+'"', {cwd:cfg.buildfolder},function(error, stdout, stderr) {
// 			    // logger.debug('stdout: ' + stdout);
// 			    // logger.debug('stderr: ' + stderr);
// 		    	if (error !== null) {
// 		        	logger.debug('execSync error: ' + error);
// 		    	}else{
// 		    		// fs.Synccopy(filename,'../output/'+filename+'.pdf');
// 		    	}
// 		    // logger.debug('Done! '+file.path);
// 			});		
// 			// var old_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.tikz.pdf');//path.basename(file.path,'.tikz.tex')+'.tikz.pdf';
// 			// var new_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.pdf');//path.basename(file.path,'.tikz.pdf')+'.pdf';			
// 	 }))	
// 	;	
// 	return gulpresult;});
// }();


/*
DOCX
*/
// DOCX: HTML stuffs should be in output dir first!
var DOCX_T=function(){gulp.task('DOCX',gulp.series(docx_f_adoc,function(){ //
	logger.debug(`verbose`,`DOCX`);

 	return gulp;	
}));
}();

//Get DOCX doc from asciidoc
function docx_f_adoc(){gulp.task('docx_f_adoc', gulp.series(adoc_4_docx,html_f_adoc,function(){
	logger.debug(`verbose`,`docx_f_adoc`);
	var in_ext='.adoc.4docx.txt';
	var out_ext='.adoc.4docx.html';
	var out_ext_2='.adoc.pan.docx';

	var to_toc=(cfg.doctype==='book') ? '-a toc':'';
	var bib_option=cfg.html_bib_option;//(cfg.bib_file==undefined || cfg.bib_file=='')? ``:` --require "${appRoot}/lib/asciidoctor-bibtex-cite-in-prose/lib/asciidoctor-bibtex.rb"  -a bibtex-file=${cfg.bib_file} -a bibtex-style=${cfg.csl_style} -a bibtex-order=appearance -a bibtex-format=asciidoc`;


	return gulp
			.src([cfg.buildfolder+'/'+cfg.src_name+in_ext],{nocase:cfg.nocase,base:cfg.buildfolder})
			.pipe(newer(cfg.buildfolder+'/'+cfg.src_name+out_ext))  			
			.pipe(tap(function(file, t) {

				var file_contents_string=file.contents.toString();
				var filename=path.basename(file.path);
				var filedir=path.dirname(file.path);				

				// --destination-dir ../output --require asciidoctor-mathematical
				var cmd =
					' asciidoctor '+
					ASCIIDOCTOR_VER_RUBY+
					bib_option+
					' --backend html5 '+
					// ' -r asciidoctor-html5s --backend html5s'+ //needed to install gem install --pre asciidoctor-html5s as in https://github.com/jirutka/asciidoctor-html5s
					' -a imagesdir=html_images '+
					' -a stylesheet='+cfg.css_file_final+' '+
					' -a stylesdir=html_libs '+
					to_toc+
					' -a linkcss '+
					' -a docinfo1 '+
					' -a pagenums '+
					' -a nofooter '+
					asciidoctor_lang_atr+
					' --doctype '+cfg.doctype+
					' "'+file.path+
					'" --out-file="'+filedir+'/'+cfg.src_name+out_ext+'"';
				if (cfg.rtl){
					cmd=cmd+
						``					
					;
				}
				logger.debug("This command "+cmd+" will be used for docx_f_adoc");
				execSync(cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
				    	logger.debug('stdout: ' + stdout);
				    	logger.debug('stderr: ' + stderr);
				    	if (error !== null) {
				        	logger.debug('execSync error: ' + error);
				    	}
				    }
				)

				// Sanitize
				var docxhtml_file_path = filedir + '/' + cfg.src_name + out_ext;

				var docxhtml_content = fs.readFileSync(docxhtml_file_path);
				docxhtml_content = sanitizeHtml(
					docxhtml_content,
					{
						allowedTags: false,
						allowedAttributes: false,
					    exclusiveFilter: function(frame) {
					        return frame.tag === 'remark';
					    }
			  		}					
				);
				fs.writeFileSync(docxhtml_file_path, docxhtml_content);


				//Pandoc convert
				var pandoc_cmd = 
					'pandoc '+
					'--from html --to docx '+
					'--standalone '+
					` -o "${filedir}/${cfg.src_name}${out_ext_2}" `+
					` -i "${docxhtml_file_path}"`
				logger.debug("This command "+pandoc_cmd+" will be used for docx_f_adoc (pandoc)");
				execSync(pandoc_cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
				    	logger.debug('stdout: ' + stdout);
				    	logger.debug('stderr: ' + stderr);
				    	if (error !== null) {
				        	logger.debug('execSync error: ' + error);
				    	}
				    }
				)



			}))
			.pipe(tap(function(file, t){
				var new_filename = path.basename(file.path, in_ext) + out_ext;
				var new_filename_pandoc = path.basename(file.path, in_ext) + out_ext_2;
				fs.copySync(cfg.buildfolder+'/'+new_filename,cfg.outfolder+'/'+new_filename);
				fs.copySync(cfg.buildfolder+'/'+new_filename_pandoc,cfg.outfolder+'/'+new_filename_pandoc);
			}))			
			;


}));
}





/*
H T M L
*/

//Get all HTML things (document, images, css, ...) 
var HTML_T=function(){gulp.task('HTML',gulp.series(html_f_adoc,function(){ //
	logger.debug(`verbose`,`HTML`);

  	var html = gulp
  		.src(cfg.buildfolder+'/*.adoc.html',{nocase:cfg.nocase,base:cfg.buildfolder})//
  	  	// .pipe(newer(cfg.outfolder))
    	.pipe(gulp.dest(cfg.outfolder));

  	var css_js = gulp
  		.src([cfg.buildfolder+'/*.css',cfg.buildfolder+'/*.js'],{nocase:cfg.nocase,base:cfg.buildfolder})//,{nocase:cfg.nocase,base:cfg.buildfolder}
  		// .pipe(newer(cfg.outfolder+'/html_libs'))	
    	.pipe(gulp.dest(cfg.outfolder+'/html_libs'));

  	var images = gulp
  		.src([cfg.buildfolder+'/*.jpg',cfg.buildfolder+'/*.png',cfg.buildfolder+'/*.svg'],{nocase:cfg.nocase,base:cfg.buildfolder})//,{nocase:cfg.nocase,base:cfg.buildfolder}
  		// .pipe(newer(cfg.outfolder+'/html_images'))
    	.pipe(gulp.dest(cfg.outfolder+'/html_images'));


    var the_merged=merge(html, css_js).add(images);
 	return the_merged;	
}));
}();


//Get HTML doc from asciidoc
function html_f_adoc(){gulp.task('html_f_adoc', gulp.series('html_file','html_figures','html_css','html_js',function(){
	logger.debug(`verbose`,`html_f_adoc`);

	return gulp
	;
}));
}

//Get 
var html_file_T=function(){gulp.task('html_file', gulp.series(init_copy_tasks,'adoc_4_html',function() {
	logger.debug(`verbose`,`html_file`);

	var in_ext='.adoc.4html.txt';
	var tmp_ext='.adoc-ref.txt';
	var out_ext='.adoc.html';

	var to_toc=(cfg.doctype==='book') ? '-a toc':'';
	var bib_option=cfg.html_bib_option;//(cfg.bib_file==undefined || cfg.bib_file=='')? ``:` --require "${appRoot}/lib/asciidoctor-bibtex-cite-in-prose/lib/asciidoctor-bibtex.rb"  -a bibtex-file=${cfg.bib_file} -a bibtex-style=${cfg.csl_style} -a bibtex-order=appearance -a bibtex-format=asciidoc`;


	// var bibthings=gulp
	// 		.src([cfg.buildfolder+'/'+cfg.src_name+in_ext],{nocase:cfg.nocase,base:cfg.buildfolder})
 //  			// .pipe(newer(cfg.buildfolder+'/'+cfg.src_name+out_ext))
	// 		.pipe(tap(function(file, t){ //BibTex
	// 			var filename=path.basename(file.path);
	// 			var filedir=path.dirname(file.path);//
	// 			//var cmd_core='export LANG=en_US.UTF-8  && ruby ./lib/asciidoctor-bibtex-cite-in-prose/lib/asciidoctor-bib.rb';// 'asciidoc-bibtex'

	// 			// var cmd_core='asciidoc-bibtex';// export LANG=en_US.UTF-8  && 'asciidoc-bibtex'
	// 			var cmd_core='export LANG=en_US.UTF-8  && asciidoctor-bibtex';// 'asciidoc-bibtex' --output-style=asciidoc
	// 			var cmd=cmd_core+' --bibfile='+cfg.bib_file+'   --style='+cfg.bib_style+' "'+file.path+'"';				
	// 			logger.debug(cmd);				
	// 			execSync(cmd,  function(error, stdout, stderr) {//{cwd:cfg.buildfolder},
	// 		    	logger.debug('stdout: ' + stdout);
	// 		    	logger.debug('stderr: ' + stderr);
	// 		    	if (error !== null) {
	// 		        	logger.debug('execSync error: ' + error);
	// 		    	}else{
	// 		    	}
	// 			})

	// 		}));

	var htmlthings=gulp
			.src([cfg.buildfolder+'/'+cfg.src_name+in_ext],{nocase:cfg.nocase,base:cfg.buildfolder})
			.pipe(newer(cfg.buildfolder+'/'+cfg.src_name+out_ext))
			.pipe(tap(function(file, t){
				var filename=path.basename(file.path);
				var filedir=path.dirname(file.path);				
				// --destination-dir ../output  --require asciidoctor-bibtex -a bibtex-file='+cfg.bib_file+' -a bibtex-format=asciidoc -a bibtex-style='+cfg.bib_style+'
				var cmd=
					' asciidoctor '+
					ASCIIDOCTOR_VER_RUBY+ //stupid because of bibtex current situation. change any time you can
					bib_option+
					' --backend html5 '+
					' -a imagesdir=html_images '+
					' -a stylesheet='+cfg.css_file_final+' '+
					' -a stylesdir=html_libs '+
					to_toc+
					' -a linkcss '+
					' -a docinfo1 '+
					' -a pagenums '+
					' -a nofooter '+
					asciidoctor_lang_atr+
					' --doctype '+cfg.doctype+
					' "'+file.path+
					'" --out-file="'+filedir+'/'+cfg.src_name+out_ext+'"';
				logger.debug(cmd);
				execSync(cmd, function(error, stdout, stderr) {//, {cwd:cfg.buildfolder}
				    	logger.debug('stdout: ' + stdout);
				    	logger.debug('stderr: ' + stderr);
				    	if (error !== null) {
				        	logger.debug('execSync error: ' + error);
				    	}else{
				    	}
				})
			}))
			;

    // var the_streamed=streamqueue({ objectMode: true },bibthings, htmlthings);
    var the_streamed=htmlthings;
 	return the_streamed;				
		// .pipe(asciidoctor({ header_footer: false, attributes: ['showtitle'] }))
		//,stylesheet=$(css)-a imagesdir=$(images_4html_outdir) -b html5 $< -o $@   ,data-uri:true
		// .pipe(asciidoctor({linkcss:true, imagesdir:'html_images',stylesdir:['html_libs'], toc:true,docinfo1:true ,doctype:cfg.doctype,pagenums:true,nofooter:true }))	
	  	// .pipe(gulp.dest(cfg.outfolder));
}));
}();

//Get HTML-CSS
var html_css_T=function(){gulp.task('html_css', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`html_css`);

	return gulp;	
}));
}();

//Get HTML-JS
var html_js_T=function(){gulp.task('html_js', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`html_js`);

	return gulp;	
}));
}();

// Get HTML figures (PNG, JPG, SVG)
var html_figures_T=function(){gulp.task('html_figures', gulp.series(pngfigs,jpgfigs,svgfigs,function() {
	logger.debug(`verbose`,`html_figures`);

	return gulp
		.src([cfg.buildfolder+'/*.jpg',cfg.buildfolder+'/*.png'],{nocase:cfg.nocase,base:cfg.buildfolder})
		.pipe(newer(cfg.outfolder+'/html_images'))
		.pipe(gulp.dest(cfg.buildfolder+'/html_images'))
		.pipe(gulp.dest(cfg.outfolder+'/html_images'));		
}));
}();


/*
PRESENATION: HTML presentations, such as Reveal.js and Bespoke.js
*/
var PRESENTATION_T=function(){gulp.task('PRESENTATION', gulp.series(pres_f_adoc,function() {
	logger.debug(`verbose`,`PRESENATION`);

	var in_ext='.adoc.pres.html';
	var out_ext='.adoc.pres.html';

	logger.debug(`verbose`,`HTML`);

  	var pres = gulp
  		.src(cfg.buildfolder+'/*.adoc.pres.html',{nocase:cfg.nocase,base:cfg.buildfolder})//
		.pipe(newer(cfg.outfolder))
		.pipe(gulp.dest(cfg.outfolder));

	//I think we should take anything (*.*), because both css and js may include some other stuffs
  	var css_js = gulp
  		.src([cfg.buildfolder+'/pres_libs/*.*'],{nocase:cfg.nocase,base:cfg.buildfolder})//,{nocase:cfg.nocase,base:cfg.buildfolder}
  		.pipe(newer(cfg.outfolder+'/pres_libs'))	
    	.pipe(gulp.dest(cfg.outfolder+'/pres_libs'));

  	var images = gulp
  		.src([cfg.buildfolder+'/*.jpg',cfg.buildfolder+'/*.png',cfg.buildfolder+'/*.svg'],{nocase:cfg.nocase,base:cfg.buildfolder})//,{nocase:cfg.nocase,base:cfg.buildfolder}
  		.pipe(newer(cfg.outfolder+'/pres_images'))
    	.pipe(gulp.dest(cfg.outfolder+'/pres_images'));


    var the_merged=merge(pres, css_js).add(images);
 	return the_merged;	

}));
}();

//Get PRES doc from asciidoc
function pres_f_adoc(){gulp.task('pres_f_adoc', gulp.series('pres_file','pres_figures','pres_css','pres_js',function(){
	logger.debug(`verbose`,`pres_f_adoc`);

	return gulp
	;
}));
}


var pres_file_T=function(){gulp.task('pres_file', gulp.series(init_copy_tasks,'adoc_4_html',function() {
	logger.debug(`verbose`,`pres_f_html`);

	// IF IT WAS ONLY BASED ON NORMAL HTML
	// var in_ext='.adoc.html';
	// var out_ext='.adoc.pres.html';	
	// return gulp
	// 	.src(cfg.buildfolder+'/*.adoc.html',{nocase:cfg.nocase,base:cfg.buildfolder})//
	// 	.pipe(grename(function(path){
	// 		 path.extname = out_ext;
	// 	}))	
	// 	//.pipe(newer(cfg.buildfolder))
	// 	.pipe(gulp.dest(cfg.buildfolder));
	// return gulp;



	var in_ext='.adoc.txt';
	var tmp_ext='.adoc-ref.txt';
	var out_ext='.adoc.pres.html';	

	var to_toc=(cfg.doctype==='book') ? '-a toc':'';

	// var bibthings=gulp
	// 		.src([cfg.buildfolder+'/'+cfg.src_name+in_ext],{nocase:cfg.nocase,base:cfg.buildfolder})
 //  			// .pipe(newer(cfg.buildfolder+'/'+cfg.src_name+out_ext))
	// 		.pipe(tap(function(file, t){ //BibTex
	// 			var filename=path.basename(file.path);
	// 			var filedir=path.dirname(file.path);//
	// 			//var cmd_core='export LANG=en_US.UTF-8  && ruby ./lib/asciidoctor-bibtex-cite-in-prose/lib/asciidoctor-bib.rb';// 'asciidoc-bibtex'

	// 			// var cmd_core='asciidoc-bibtex';// export LANG=en_US.UTF-8  && 'asciidoc-bibtex'
	// 			var cmd_core='export LANG=en_US.UTF-8  && asciidoctor-bibtex';// 'asciidoc-bibtex' --output-style=asciidoc
	// 			var cmd=cmd_core+' --bibfile='+cfg.bib_file+'   --style='+cfg.bib_style+' "'+file.path+'"';				
	// 			logger.debug(cmd);				
	// 			execSync(cmd,  function(error, stdout, stderr) {//{cwd:cfg.buildfolder},
	// 		    	logger.debug('stdout: ' + stdout);
	// 		    	logger.debug('stderr: ' + stderr);
	// 		    	if (error !== null) {
	// 		        	logger.debug('execSync error: ' + error);
	// 		    	}else{
	// 		    	}
	// 			})

	// 		}));

	var pres_things=gulp
			.src([cfg.buildfolder+'/'+cfg.src_name+in_ext],{nocase:cfg.nocase,base:cfg.buildfolder})
			.pipe(newer(cfg.buildfolder+'/'+cfg.src_name+out_ext))
			.pipe(tap(function(file, t){
				var filename=path.basename(file.path);
				var filedir=path.dirname(file.path);				
				// --destination-dir ../output  --require asciidoctor-bibtex -a bibtex-file='+cfg.bib_file+' -a bibtex-format=asciidoc -a bibtex-style='+cfg.bib_style+'
				var cmd=
					' asciidoctor '+
					ASCIIDOCTOR_VER_RUBY+
					` --require "${appRoot}/lib/asciidoctor-bibtex-cite-in-prose/lib/asciidoctor-bibtex.rb" ` +
					' -a bibtex-file='+cfg.bib_file+
					' -a bibtex-format=asciidoc '+
					' -a bibtex-style='+cfg.csl_style+
					' --backend html5 '+
					' -a imagesdir=pres_images '+
					' -a stylesheet='+cfg.pres_css+' '+
					' -a stylesdir=pres_libs '+
					to_toc+
					' -a linkcss '+
					' -a docinfo1 '+
					' -a pagenums '+
					' -a nofooter '+
					asciidoctor_lang_atr+
					' --doctype '+cfg.doctype+
					' "'+file.path+
					'" --out-file="'+filedir+'/'+cfg.src_name+out_ext+'"';
				logger.debug(cmd);
				execSync(cmd, function(error, stdout, stderr) {//, {cwd:cfg.buildfolder}
				    	logger.debug('stdout: ' + stdout);
				    	logger.debug('stderr: ' + stderr);
				    	if (error !== null) {
				        	logger.debug('execSync error: ' + error);
				    	}else{
				    	}
				})
			}))
	;

    // var the_streamed=streamqueue({ objectMode: true },bibthings, pres_things);
    var the_streamed=pres_things;
 	return the_streamed;				


}));
}();


//Get PRES-CSS
var pres_css_T=function(){gulp.task('pres_css', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`pres_css`);

	return gulp;	
}));
}();

//Get PRES-JS
var pres_js_T=function(){gulp.task('pres_js', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`pres_js`);

	return gulp;	
}));
}();

// Get PRES figures (PNG, JPG, SVG)
var pres_figures_T=function(){gulp.task('pres_figures', gulp.series(pngfigs, jpgfigs, svgfigs, function() {
	logger.debug(`verbose`,`pres_figures`);

	return gulp
		.src([cfg.buildfolder+'/*.jpg',cfg.buildfolder+'/*.png'],{nocase:cfg.nocase,base:cfg.buildfolder})
		.pipe(newer(cfg.outfolder+'/pres_images'))
		.pipe(gulp.dest(cfg.outfolder+'/pres_images'));		
}));
}();

/*
Direct PDF
*/
var PDF_DIRECT_T=function(){gulp.task('PDF_DIRECT', gulp.series(pdf_f_adoc,function() {
	logger.debug(`verbose`,`PDF_DIRECT`);

	return gulp;
}));
}();

//Get direct PDF from adoc
function pdf_f_adoc(){gulp.task('pdf_f_adoc', gulp.series(init_copy_tasks, pngfigs, function() {
	logger.debug(`verbose`,`pdf_f_adoc`);

	return gulp
			.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'],{nocase:cfg.nocase,base:cfg.buildfolder})
			.pipe(tap(function(file, t) {
				// --destination-dir ../output --require asciidoctor-mathematical
				var cmd=
					'asciidoctor '+
					' --require asciidoctor-pdf '+
					' --require asciidoctor-bibtex '+
					' -a bibtex-file='+ cfg.bib_file + ' '+
					' -a bibtex-format=asciidoc '+
					' -a bibtex-style='+cfg.csl_style+ ' '+
					asciidoctor_lang_atr+
					' --backend pdf '+
					' --doctype '+cfg.doctype+' '+
					path.basename(file.path)
				;
				if (cfg.rtl){
					cmd=cmd+
						` -a pdf-stylesdir="${cfg.buildfolder}" `+
						' -a pdf-style='+cfg.pdf_style+' '+
						' -a pdf-fontsdir='+pdf_fonts_dir+' '
					;
				}
				logger.debug("This command "+cmd+" will be used for pdf_f_adoc");
				execSync(cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
				    	logger.debug('stdout: ' + stdout);
				    	logger.debug('stderr: ' + stderr);
				    	if (error !== null) {
				        	logger.debug('execSync error: ' + error);
				    	}
				    }
				)}))
			.pipe(tap(function(file, t){
				var new_filename=path.basename(file.path,'.txt')+'.pdf';
				fs.copySync(cfg.buildfolder+'/'+new_filename,cfg.outfolder+'/'+new_filename);
			}))			
			;
}));
}

function PDF_FOPUB(){gulp.task('PDF_FOPUB', gulp.series(pdffopub_f_adoc, function() {
	logger.debug(`verbose`,`PDF_FOPUB`);

	return gulp;
}));
}

function pdffopub_f_adoc(){gulp.task('pdffopub_f_adoc', gulp.series('docbook_f_adoc', pngfigs,function() {
	logger.debug(`verbose`,`pdffopub_f_adoc`);

	var file_things= gulp
			.src([cfg.buildfolder+'/*.adoc.xml'],{nocase:cfg.nocase,base:cfg.buildfolder})
			.pipe(grename(function(path){
				 path.extname = ".fop.xml";
			}))
			.pipe(gulp.dest(cfg.buildfolder+'/'));

	var fop_things= gulp
			.src([cfg.buildfolder+'/*.adoc.fop.xml'],{nocase:cfg.nocase,base:cfg.buildfolder})
			.pipe(tap(function(file, t) {
				var rtl_extra_cmd=(cfg.rtl)? ' -param l10n.gentext.default.language '+cfg.lang+' -param writing.mode rl ':'';
				var cmd=
					`${appRoot}/lib/asciidoctor-fopub/fopub `+
					` -t ${cfg.stylesfolder}/fopub `+
					path.basename(file.path)+
					rtl_extra_cmd
				;
				execSync(cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
				    	logger.debug('stdout: ' + stdout);
				    	logger.debug('stderr: ' + stderr);
				    	if (error !== null) {
				        	logger.debug('execSync error: ' + error);
				    	}
				    }
				)}))
			.pipe(tap(function(file, t){
				var new_filename=path.basename(file.path,'.xml')+'.pdf';
				fs.copySync(cfg.buildfolder+'/'+new_filename,cfg.outfolder+'/'+new_filename);
			}))			
			;
    
    var the_streamed=streamqueue({ objectMode: true },file_things, fop_things);
    return the_streamed;

}));
}


/*
Docbook
*/

//Get Docbook things
var DOCBOOK_T=function(){gulp.task('DOCBOOK', gulp.series(docbook_f_adoc,function() {

	logger.debug(`\n\n Begin docbook`);			

	return gulp
		.src([cfg.buildfolder+'/*.adoc.xml'],{nocase:cfg.nocase,base:cfg.buildfolder})
		.pipe(gulp.dest(cfg.outfolder));
	;
}));
}();

//Get Docbook file from asciidoc
function docbook_f_adoc(){gulp.task('docbook_f_adoc', gulp.series('adoc_4_docbook',function() {
	
	logger.debug(`\n\n Begin docbook_f_adoc`);
	const 
		IN_EXT='.adoc.4docbook',
		MID_EXT='.adoc.4docbook.xml',
		OUT_EXT='.adoc.xml'
	;

	return gulp
		.src([cfg.buildfolder+`/*${IN_EXT}`,'!'+cfg.buildfolder+`/_*${IN_EXT}`],{nocase:cfg.nocase,base:cfg.buildfolder})
		.pipe(tap(function(file, t) {
			// --destination-dir ../output  
			var asciidoctor_cmd=
				'asciidoctor'+
				' --backend docbook5 '+
				asciidoctor_lang_atr+				
				' --require asciidoctor-bibtex '+
				' --doctype '+cfg.doctype+' '+
				` "${path.basename(file.path)}" ` +
				` --out-file "${cfg.buildfolder}/${cfg.target}${MID_EXT}" `
			;
			logger.debug('This command: '+asciidoctor_cmd+' will be used for docbook_f_adoc');
			execSync(asciidoctor_cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
		    	logger.debug('stdout: ' + stdout);
		    	logger.debug('stderr: ' + stderr);
		    	if (error !== null) {
		        	logger.debug('execSync error: ' + error);
		    	}
			})
		}))
		//Send a copy to output
		.pipe(tap(function(file, t){
			//The converted file has this name
			// var new_filename=path.basename(file.path,'.txt')+'.xml';
			//Make a copy to output folder
			// fs.copySync(cfg.buildfolder+'/'+new_filename,cfg.outfolder+'/'+new_filename);
			fs.copySync(cfg.buildfolder+`/${cfg.target}${MID_EXT}`,cfg.outfolder+`/${cfg.target}${OUT_EXT}`);
		}))			
	;
}));
}

//Get Docbook file from asciidoc but we need it to be passed to Tex and PDF(tex) later
var docbook_f_adoc_4_tex_4_pdftex_T=function(){gulp.task('docbook_f_adoc_4_tex_4_pdftex', gulp.series('adoc_4_docbooktex',function() {
	logger.debug(`

		Begin docbook_f_adoc_4_tex_4_pdftex
	`);

	const 
		IN_EXT='.adoc.4docbooktex',
		MID_EXT='.adoc.4docbook.xml',
		OUT_EXT='.adoc.xml.4tex'
	;	

	return gulp
		//get the adoc files
		.src([cfg.buildfolder+`/*${IN_EXT}`,'!'+cfg.buildfolder+`/_*${IN_EXT}`],{nocase:cfg.nocase,base:cfg.buildfolder})
		//convert them to docbook format
		.pipe(tap(function(file, t) {
			// --destination-dir ../output  --require asciidoctor-bibtex
			var out_filename=path.basename(file.path,IN_EXT)+OUT_EXT;
			var asciidoctor_cmd=
				'asciidoctor '+
				asciidoctor_lang_atr+
				' --backend docbook5  ' +
				' --doctype '+ cfg.doctype +' '+
				' -o '+	out_filename +' '+
				path.basename(file.path)
			;
			logger.debug('This command: '+asciidoctor_cmd+' will be used for docbook_f_adoc_4_tex_4_pdftex');			
			execSync(asciidoctor_cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
		    	logger.debug('stdout: ' + stdout);
		    	logger.debug('stderr: ' + stderr);
		    	if (error !== null) {
		        	logger.debug('execSync error: ' + error);
		    	}
			})
		}))		
	;
}));
}();


var dockbook_prep_4_tex_T=function(){gulp.task('dockbook_prep_4_tex', gulp.series('docbook_f_adoc_4_tex_4_pdftex',function() {
	logger.debug(`verbose`,`

		dockbook_prep_4_tex
	`);
	const 
		IN_EXT='.adoc.xml.4tex',
		// MID_EXT='.adoc.xml.4tex',
		OUT_EXT='.adoc.xml.4tex'
	;	


	logger.debug(`\n\n Begin dockbook_prep_4_tex`);

	var gulpresult= gulp
		.src([cfg.buildfolder+`/*${IN_EXT}`],{nocase:cfg.nocase,base:cfg.buildfolder})
		.pipe(tap(function(file, t) {
			var file_contents_string=file.contents.toString();
			file_contents_string=file_contents_string
				.replace(/(<imagedata\W+fileref=")(\w*).png("\W*>)/gmi, '$1$2$3')
				// .replace(/ö/gmi, '<![CDATA[{\"o}]]>')							
				// .replace(new RegExp(CITATION_ALL), '$1$2$3');
			;

			file.contents=Buffer.from(file_contents_string);
		}))
		.pipe(gulp.dest(cfg.buildfolder))
	;
	return gulpresult;
}));
}();


// var tex_f_docbook_T=function(){gulp.task('tex_f_docbook', ['docbook_f_adoc'],function() {
// 	return gulp
// 			.src([cfg.buildfolder+'/*.adoc.txt','!'+cfg.buildfolder+'/_*.adoc.txt'])
// 			.pipe(tap(function(file, t) {
// 				var cmd='asciidoctor'+' --backend docbook5  --require asciidoctor-bibtex --destination-dir ../output '+' --doctype '+cfg.doctype+' '+path.basename(file.path);
// 				logger.debug(cmd);
// 				execSync(cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
// 				    	logger.debug('stdout: ' + stdout);
// 				    	logger.debug('stderr: ' + stderr);
// 				    	if (error !== null) {
// 				        	logger.debug('execSync error: ' + error);
// 				    	}
// 				    }
// 				)}));
// });
// }();




/*--------------------------------------------
Figures
--------------------------------------------*/


var PDFFIGS_T=function(){gulp.task('pdffigs', gulp.series(pdffig_figures,function() {
	logger.debug(`verbose`,`pdffigs`);

	return gulp;		
}));
}();

function pdffig_figures(){gulp.task('pdffig_figures', gulp.series('pdffigs_all',function() {
	logger.debug(`verbose`,`pdffig_figures`);

	return gulp
		.src([cfg.buildfolder+'/*.pdf'],{nocase:cfg.nocase,base:cfg.buildfolder})
		.pipe(gulp.dest(cfg.outfolder+'/pdf_images'));		
}));
}

var pdffigs_all_T=function(){gulp.task('pdffigs_all', gulp.series(pdffig_f_svg, pdffig_f_tikz,function() {
	logger.debug('Begin all_pdf');
	return gulp
	;	
}));
}();


function pdffig_f_svg(){gulp.task('pdffig_f_svg', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`pdffig_f_svg`);

	return gulp
	.src([cfg.buildfolder+'/*.svg','!'+cfg.buildfolder+'/*.tikz.svg'],{nocase:cfg.nocase,base:cfg.buildfolder})//AVOID loop tikz-> svg -> pdf, it should be only tikz -> pdf
  	.pipe(gm(function (gmfile) {
  		    return gmfile.setFormat('pdf');
  	}))
  	.pipe(gulp.dest(cfg.buildfolder));		
}));
}

function pdffig_f_tikz(){gulp.task('pdffig_f_tikz', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`pdffig_f_tikz`);

	var gulpresult= gulp
	.src('./*.tikz.tex',{cwd:cfg.buildfolder,nocase:cfg.nocase})//,{cwd:cfg.buildfolder}
	// .pipe(debug({title: 'tikz before:'}))
	.pipe(newer({
		dest:'.',
		map:function(src_path){
			var compare=src_path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.pdf');
			return compare;
		}
	}))	
	// .pipe(debug({title: 'tikz after:'}))
	.pipe(tap(function(file, t) {
	    // logger.debug('Run! '+cfg.cmd_latexmk+' "'+file.path+'"');

	    //If the tikz file is very big use another latexmk
	    const BIG_TIKZ_SIZE=1700000;
	    var filename=path.basename(file.path);
	    var filesize=fs.statSync(file.path)["size"];
	    var the_latexmk_tikz;
		the_latexmk_tikz=cfg.cmd_latexmk_tikz;
		
	    if (filesize>BIG_TIKZ_SIZE){
	    	logger.debug(`Oh! Oh! the tikz file ${filename} size is big:${filesize}, I would use ${the_latexmk_tikz} take care.`);
	    }else{
	    	logger.debug(`For tikz ${filename} , I would use ${the_latexmk_tikz}`);
		}
		
		execSync(the_latexmk_tikz+' "'+file.path+'"', {cwd:cfg.buildfolder},function(error, stdout, stderr) {
		    // logger.debug('stdout: ' + stdout);
		    // logger.debug('stderr: ' + stderr);
		    if (error !== null) {
		        logger.debug('execSync error: ' + error);
		    }
	    // logger.debug('Done! '+file.path);
		});		
		var old_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.tikz.pdf');//path.basename(file.path,'.tikz.tex')+'.tikz.pdf';
		var new_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.pdf');//path.basename(file.path,'.tikz.pdf')+'.pdf';
		fs.renameSync(old_path,new_path);
	 }))	
	;	
 //  	// .pipe(run(cfg.cmd_latexmk).execSync())
 //  	.pipe(run('ls').execSync())
 //  	.pipe(gulp.dest('ls_result.txt'));
	// process.chdir('../');  	
  	return gulpresult;
}));
}


// 'png_f_pdffig',
function pngfigs(){gulp.task('pngfigs', gulp.series(init_copy_tasks,'png_f_svg','png_f_pdffig',function() {
	logger.debug(`verbose`,`pngfigs`);

	return gulp
	;
}));
}

function jpgfigs(){gulp.task('jpgfigs', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`jpgfigs`);

	return gulp;		
}));
}

var png_f_pdffig_T=function(){gulp.task('png_f_pdffig', gulp.series(init_copy_tasks, pdffig_f_tikz, pdffig_f_svg ,function() {
	logger.debug(`verbose`,`png_f_pdffig`);

	return gulp
	.src(cfg.buildfolder+'/*.pdf',{nocase:cfg.nocase,base:cfg.buildfolder})
	// .pipe(debug({title: 'unicorn:'}))
	.pipe(newer({dest:cfg.buildfolder,ext:'.png'}))
  	.pipe(gm(function (gmfile) {
  		    return gmfile.density(150,150).setFormat('png');
  	}))
  	.pipe(gulp.dest(cfg.buildfolder));		
}));
}();

// var png_2_pdf_T=function(){gulp.task('png_2_pdf', [init_copy_tasks],function() {
// 	//directly from figures, so we do not make pdf->png->pdf->...
// 	return gulp.src('./figures/*.png')
//   	.pipe(gm(function (gmfile) {
//   		    return gmfile.density(150,150).setFormat('pdf');
//   	}))
//   	.pipe(gulp.dest(cfg.buildfolder));		
// });
// }();

// var png_f_tikz=function(){gulp.task('png_f_tikz', [init_copy_tasks,'pdffig_f_tikz','png_f_pdffig'],function() {
// 	return gulp;
// 	// return gulp.src(cfg.buildfolder+'/*.pdf')
//  //  	.pipe(gm(function (gmfile) {
//  //  		    return gmfile.setFormat('png');
//  //  	}))
//  //  	.pipe(gulp.dest(cfg.buildfolder));		
// });
// }();

var png_f_svg_T=function(){gulp.task('png_f_svg', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`png_f_svg`);

	return gulp
	.src(cfg.buildfolder+'/*.svg',{nocase:cfg.nocase,base:cfg.buildfolder})
	.pipe(newer({dest:cfg.buildfolder,ext:'.png'}))
  	.pipe(gm(function (gmfile) {
  		    return gmfile.setFormat('png');
  	}))
  	.pipe(gulp.dest(cfg.buildfolder));			
}));
}();

//Directly get Tex from Asciidoc
var tex_f_adoc_T=function(){gulp.task('tex_f_adoc', gulp.series(init_copy_tasks,function() {

	logger.debug(`verbose`,`tex_f_adoc`);

	return gulp
		.src([cfg.buildfolder+'/'+cfg.src_name+'.adoc.txt'],{nocase:cfg.nocase,base:cfg.buildfolder})
		// .pipe(newer(cfg.buildfolder+'/'+cfg.src_name+'.adoc.tex'))			
		.pipe(tap(function(file, t){
			var filename=path.basename(file.path);
			// --destination-dir ../output --require asciidoctor-bibtex -a bibtex-file='+cfg.bib_file+' -a bibtex-style='+cfg.csl_style+' -a bibtex-format=asciidoc -
			var cmd=
			'asciidoctor-latex '+
			' -a header=no '+
			' --require asciidoctor-bibtex '+
			' -a bibtex-file='+cfg.bib_file+' '
			asciidoctor_lang_atr+			
			' -a bibtex-style='+cfg.csl_style+
			' "'+file.path+'"';
			logger.debug(cmd);
			execSync(cmd, {cwd:cfg.buildfolder}, function(error, stdout, stderr) {
			    	logger.debug('stdout: ' + stdout);
			    	logger.debug('stderr: ' + stderr);
			    	if (error !== null) {
			        	logger.debug('execSync error: ' + error);
			    	}
			})
		}))
		;
}));
}();

//Get Tex from Docbook
var tex_f_docbook_T=function(){gulp.task('tex_f_docbook', gulp.series(tex_f_docbook_3_dblatex,function() {
	logger.debug(`verbose`,`tex_f_docbook`);

	return gulp;

	// var gulpresult= gulp
	// 	.src(cfg.buildfolder+'/*.adoc.xml.4tex_tmp',{nocase:cfg.nocase,base:cfg.buildfolder})
	//  	.pipe(tap(function(file, t) {
	// 		// var src_filename=path.basename(file.path,'.txt');
	// 		// var book_template='x_book.pdf',article_template='x_article.pdf';
	// 		// var book_filename
	// 		// =path.basename(file.path,'.txt')+'.html';

	// 		// !!!!! what was that?
	// 		// var tmp_filename=path.basename(file.path,'tex')+'.pdf';
	// 		// var new_filename=cfg.target+'_'+path.basename(file.path)+'.pdf';
	// 		// fs.copySync(cfg.buildfolder+'/'+tmp_filename,cfg.outfolder+'/'+new_filename);
	//  	}))
	// ;		
 //  	return gulpresult;
}));
}();

function tex_f_docbook_3_dblatex(){gulp.task('tex_f_docbook_3_dblatex', gulp.series('dockbook_prep_4_tex',function() {
	logger.debug(`verbose`,`tex_f_docbook_3_dblatex`);

	const 
		IN_EXT='.adoc.xml.4tex',
		MID_EXT='.adoc.xml.4tex.tex',
		OUT_EXT='.adoc.xml.tex'
	;	


	var gulpresult= gulp
	.src(`./*${IN_EXT}`,{cwd:cfg.buildfolder,nocase:cfg.nocase})//,{cwd:cfg.buildfolder}
	.pipe(tap(function(file, t) {

		// var dblatex_out_path=file.path.toString().replace(/\.adoc\.xml\.4tex_tmp(?![\s\S]*\.adoc\.xml\.4tex_tmp)/, '.adoc.xml.4tex_tmp.tex')
		// var fin_path=file.path.toString().replace(/\.adoc\.xml\.4tex_tmp(?![\s\S]*\.adoc\.xml\.4tex_tmp)/, '.adoc.tex')


		// xml.pipe(saxon.xslt('./lib/dblatex/xsl/latex_book_fast.xsl')) .pipe(writable);
		//--bib-path=$(builddir)/$(bib)
		var cmd_dblatex;
		var dblatex_option_bib= (cfg.bib_file!=undefined)? ` --bib-path=${cfg.bib_file} `:``;
		if (cfg.rtl || (cfg.tex_engine=='xelatex')){
			//--bib-path=$(builddir)/$(bib)
			cmd_dblatex=`dblatex   ${dblatex_option_bib} --verbose -b xetex  -P latex.encoding=utf8,latex.unicode.use=1 -p my_docbooklatex.xsl  -t tex `;
		}
		else{
			// --texstyle=my_tufte_book_v3.sty
			//NOTE: I changed -b pdftex to -b xetex to trick dblatex not to convert unicodes (I will take care myself)
			cmd_dblatex=`dblatex   ${dblatex_option_bib} --verbose -b xetex   -P latex.encoding=utf8,latex.unicode.use=1   -p my_docbooklatex.xsl   -t tex `;
		}
		logger.debug(`This DBLatex command : ${cmd_dblatex}`);

		execSync(cmd_dblatex+' "'+file.path+'"', {cwd:cfg.buildfolder},function(error, stdout, stderr) {
		    if (error !== null) {
		        logger.debug('execSync error: ' + error);
		    }
		});

		var dblatex_out = `${cfg.buildfolder}/${cfg.target}${MID_EXT}`;
		var desired_out = `${cfg.buildfolder}/${cfg.target}${OUT_EXT}`;
		
		//I need to make sure the tex file is in utf8
		if (cfg.tex_engine == 'pdflatex'){
			// TEST which is the right way
			// util.convFileUTF8(dblatex_out, desired_out);
			fs.copySync(dblatex_out, desired_out, {encoding:"utf8"});
		}else{
			fs.copySync(dblatex_out, desired_out, {encoding:"utf8"});
		}

	 }))	
	;		
  	return gulpresult;
}));
}

var tex_f_docbook_3_saxon_T=function(){gulp.task('tex_f_docbook_3_saxon', gulp.series('dockbook_prep_4_tex',function() {
	logger.debug(`verbose`,`tex_f_docbook_3_saxon`);

	var saxon = new Saxon('./lib/saxon/saxon9he.jar');
	saxon.on('error',function(err){ logger.debug(err) });

	var gulpresult= gulp
	.src('./*.adoc.xml.4tex_tmp',{cwd:cfg.buildfolder,nocase:cfg.nocase})//,{cwd:cfg.buildfolder}
	// .pipe(saxon.xslt('./lib/dblatex/xsl/latex_book_fast.xsl'));
	// .pipe(gulp.dest(cfg.outfolder));
	.pipe(tap(function(file, t) {

		// var docbook_path=file.path.toString().replace(/\.adoc\.xml(?![\s\S]*\.adoc\.xml)/, '.adoc.pdf');//path.basename(file.path,'.adoc.tex')+'.adoc.pdf';
		var tex_path=file.path.toString().replace(/\.adoc\.xml(?![\s\S]*\.adoc\.xml)/, '.adoc.tex');//path.basename(file.path,'.adoc.pdf')+'.pdf';

		var xml = fs.createReadStream(file.path);
		var writable = fs.createWriteStream(tex_path);
		logger.debug(tex_path);
		// xml.pipe(writable);
		xml.pipe(saxon.xslt('./lib/dblatex/xsl/latex_book_fast.xsl')) .pipe(writable);

		// execSync(cfg.cmd_latexmk+' "'+file.path+'"', {cwd:cfg.buildfolder},function(error, stdout, stderr) {
		//     // logger.debug('stdout: ' + stdout);
		//     // logger.debug('stderr: ' + stderr);
		//     if (error !== null) {
		//         logger.debug('execSync error: ' + error);
		//     }
	 //    // logger.debug('Done! '+file.path);
		// });		
		// var old_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.tikz.pdf');//path.basename(file.path,'.tikz.tex')+'.tikz.pdf';
		// var new_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.pdf');//path.basename(file.path,'.tikz.pdf')+'.pdf';
		// fs.renameSync(old_path,new_path);
	 }))	
	;		
  	return gulpresult;
}));
}();
var tex_prep_templates_4_pdf_T=function(){gulp.task('tex_prep_templates_4_pdf', gulp.series(init_copy_tasks,function() {
	logger.debug(`verbose`,`tex_prep_templates_4_pdf`);

	var subs=[
		['SRC',cfg.src_name,cfg.src_name+'.adoc.xml.tex'],
		['BIB',cfg.bib_file,(cfg._is_biblatex)? cfg.bib_file:path.basename(cfg.bib_file,'.bib')],//use full name for biblatex and remove ".bib" for bibtex
		['BIS',cfg.bib_style,cfg.bib_style],
		['GLS',cfg.tex_glossary,cfg.tex_glossary],
		['AUT',cfg.author,cfg.author],
		['DAT',cfg.date,cfg.date],
		['TTL',cfg.title,cfg.title],
		['XTL',cfg.tex_title,cfg.tex_title]
	];
	var 
		magic_word='MAGIC',
		placehoder_word='PLACEHOLDER',
		beginsec_word='BEGIN',
		endsec_word='END'
	;
	var gulpresult= gulp
		.src(cfg.tex_template,{cwd:cfg.buildfolder,nocase:cfg.nocase})
		.pipe(tap(function(file, t) {
			var file_contents_string=file.contents.toString();
			subs.forEach((item,i)=>{
				var 
					case_name=item[0],
					case_exists=(item[1]==undefined || item[1]=='' )? false:true,
					case_value=item[2];

				if (case_exists){
					file_contents_string=util.replaceAll(file_contents_string,magic_word+placehoder_word+case_name, case_value);
					logger.debug(`Replacing in the Tex template: ${magic_word}${placehoder_word}${case_name} was replaced with ${case_value}`);

				}else{
					var regex_str=`(%${magic_word}${beginsec_word}${case_name})([\\s\\S]*)(%${magic_word}${endsec_word}${case_name})`;
					// file_contents_string=file_contents_string.replace(new RegExp(regex_str,'gmi'), `%No ${case_name} was found.`);
					file_contents_string=util.replaceAll(file_contents_string,regex_str, `%No ${case_name} was found.`);
				}

			});
			// file_contents_string=file_contents_string.replace('MAGICPLACEHOLDERSRC', cfg.src_name+'.adoc.tex');
			// file_contents_string=file_contents_string.replace('MAGICPLACEHOLDERBIB', path.basename(cfg.bib_file,'.bib'));
			// file_contents_string=file_contents_string.replace('MAGICPLACEHOLDERGLS', cfg.tex_glossary);
			// file_contents_string=file_contents_string.replace('MAGICPLACEHOLDERAUT', cfg.author);
			// file_contents_string=file_contents_string.replace('MAGICPLACEHOLDERTTL', cfg.title);
			file.contents=Buffer.from(file_contents_string);
		}))
		 // .pipe(greplace('MAGICPLACEHOLDER', 'foo'))
		// .pipe(tap(function(file, t) {
		// 	var filename=path.basename(file.path);
		// 	if (filename=='x_book.tex'){
	 // 			file.contents= file.contents.replace('MAGICPLACEHOLDER','\\input{'+src_file+'}');
		// 	}			
		// }))
		.pipe(gulp.dest(cfg.buildfolder))
	;
	return gulpresult;
}));
}();


//Get Docbook things
function PDFTEX(){gulp.task('PDFTEX', gulp.series(pdftex_f_tex,function() {
	logger.debug(`verbose`,`PDFTEX`);

	return gulp
	;
}));
}

//Also tex_f_html
function pdftex_f_tex(){gulp.task('pdftex_f_tex', gulp.series('tex_f_docbook','tex_prep_templates_4_pdf', pdffig_figures ,function() {
	logger.debug(`verbose`,`pdftex_f_tex`);

	var gulpresult= gulp
		.src([cfg.tex_template],{cwd:cfg.buildfolder,nocase:cfg.nocase})//,{cwd:cfg.buildfolder}
		.pipe(tap(function(file, t) {
			var filename=path.basename(file.path);
			var the_cmd=cfg.cmd_latexmk+' "'+file.path+'"';
			var stdout='';
			try{
				stdout=execSync(the_cmd, {cwd:cfg.buildfolder}
				// 	,function(error, stdout, stderr) {
				//     logger.debug('stdout: ' + stdout);
				//     logger.debug('stderr: ' + stderr);
			 //    	if (error !== null) {
			 //        	logger.debug('execSync error: ' + error);
			 //        	logger.debug('Anyway, I will continue to copy ..');
			 //    	}else{
			 //    	}
			 //    // logger.debug('Done! '+file.path);
				// }
				);						
			}catch(err){
				logger.debug(`Problem in running latexmk: ${err}`);
			}
			logger.debug('stdout: ' + stdout+'\n');
		    fs.copySync(file.path,cfg.outfolder+'/'+filename+'.pdf');//../output
			// var old_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.tikz.pdf');//path.basename(file.path,'.tikz.tex')+'.tikz.pdf';
			// var new_path=file.path.toString().replace(/\.tikz\.tex(?![\s\S]*\.tikz\.tex)/, '.pdf');//path.basename(file.path,'.tikz.pdf')+'.pdf';			
	 	}))
	 	.pipe(tap(function(file, t) {
			// var src_filename=path.basename(file.path,'.txt');
			// var book_template='x_book.pdf',article_template='x_article.pdf';
			// var book_filename
			// =path.basename(file.path,'.txt')+'.html';
			var tmp_filename=path.basename(file.path,'.tex')+'.pdf';
			var new_filename=cfg.target+'_'+path.basename(file.path)+'.pdf';
			logger.debug(`Converted ${cfg.outfolder}/${new_filename}`);				    		
			fs.copySync(cfg.buildfolder+'/'+tmp_filename,cfg.outfolder+'/'+new_filename);
	 	}))
	;	
	return gulpresult;
}));
}

function svgfigs(){gulp.task('svgfigs', gulp.series(init_copy_tasks,'copy_to_figures_folder',function() {
	logger.debug(`verbose`,`svgfigs`);

	return gulp;
}));
}

var tex_f_html_T=function(){gulp.task('tex_f_html', gulp.series('html_file',function () {
	logger.debug(`verbose`,`tex_f_html`);

	return gulp
		.src([cfg.buildfolder+'/*.adoc.html'],{nocase:cfg.nocase,base:cfg.buildfolder})
		.pipe(gcheerio({
			parserOptions: {
				// Options here
				decodeEntities: false
			},			
			run:function ($, file) {//, done
				// The only difference here is the inclusion of a `done` parameter. 
				// Call `done` when everything is finished. `done` accepts an error if applicable. 
				//$('html').html($('body').html({ decodeEntities: false }));//replace HTML content with BODY content

				//Initial Cleaning
				$.root().html($('body').html());
				$('script').remove();//remove any script

				// var conv=[{el:'h1',prefix:'\\section{',profix:'}'}];
				// for(var i=0;i<conv.length;i++){
				// 	$('h1').each(function () {
				// 		var el = $(this);
				// 		var new_content='\\section{'+el.html()+'}';
				// 		el.replaceWith(new_content);
				// 	})
				// }
				// P should be simple paragraphs
				$('p').each(function () {
					var el = $(this);
					var new_content=''+el.html()+'\n';
					el.replaceWith(new_content);
				})

				$('div.paragraph').filter('.newthought').each(function (){
					var el = $(this);
					// String arr[] = el.html().toString().split(" ", 2);
					var theOriginal=el.html().toString();
					var  i = theOriginal.indexOf(' ');
					var j=theOriginal.indexOf('\n');
					var k=0;
					if (j>i) k=0;
					if (j==0) k=1;
					if (j==-1) k=0;
					var firstWord = theOriginal.substring(k, i);
					var theRest = theOriginal.substring(i);				
					// String firstWord = arr[0];  
					// String theRest = arr[1];    				
					var new_content='\n\\newthought{'+firstWord+'}'+theRest;
					el.replaceWith(new_content);
				})

				// div.paragraph if it does not have any thing else
				// $('div.paragraph').each(function () {
				// 	var el = $(this);
				// 	var new_content=''+el.html()+'\n';
				// 	// el.replaceWith(new_content);
				// })
				var el_map=[
					[0,'re',"br","\\newline{}"],
					[1,'re',"p","\\p{","}","."],
					[1,'rc',"div.paragraph newthought","\\p{","}","."],
					[1,'re',".paragraph","\\p{","}","."],
					[1,'re',"h1","\\section{","}"],
					[4,'re',"quoteblock","\\section{","}"],
				].map(function(item){
					var the_object={};
					the_object.type=item[0];
					the_object.behavior=item[1];
					the_object.selector=item[2];
					switch (the_object.type){
						case 0:
							switch (the_object.behavior){
								case 're':
								the_object.content=function(){return item[3]};
								break;
							}
						break;
						case 1:
							the_object.pre=item[3];
							the_object.post=item[4];
							the_object.content=function(el){return item[3]+el.html()+item[4]};
						break;
						case 1:
							the_object.pre=item[2];
							the_object.post=item[3];
						break;
					}
					return the_object;
				});
				el_map.forEach(function(rule){
					$(rule.selector).each(function (){//div.paragraph
						var el = $(this);
						switch (rule.type){
							case 0:
								el.replaceWith(rule.replace);
							break;
							case 1:
								el.replaceWith(rule.pre+rule.content(el)+rule.post);
							break;
						}				
					});
				});

	      		// done();
      		}
      	}))
		// .pipe(tap(function(file, t) {

		// 	var file_contents_string=file.contents.toString();
		// 	// Farsi conversion

		// 	file.contents=Buffer.from(file_contents_string);		
		// 	logger.debug('-----------------------------'+file.contents)
		// }))		
		.pipe(grename(function (path) {
			path.extname = ".html.tex";
    	}))
    	.pipe(gulp.dest(cfg.outfolder));
	}));
}();








/*==================================
 General tasks
==================================*/	

// Default: 

exports.default = gulp.task('default', gulp.series(final_tasks,function(done) {
	logger.debug("Finished!");
	done();
  	
}));

// Reads tasks from cfg.tasks
var main_tasks_T=function(){gulp.task('main_tasks', gulp.series(init_copy_tasks,...cfg.tasks,function() {
	logger.debug(`Main Tasks (${cfg.tasks}) Finished!`);
	return gulp
  ;  	
}));
}();

function final_tasks(){gulp.task('final_tasks', gulp.series('main_tasks',function() {
  logger.debug('\n\n Begin final_tasks');			

	logger.debug("Final Tasks Done!");
	return gulp
  ;  	
}));
}


var read_config_T=function(){gulp.task('read_config',function() {
  
  logger.debug(`

  Begin read_config Task
  `);			


  //If Cfg was read then just return
  if (isCfgRead){
	  logger.debug(`Gulp was read before`);
	  return gulp;
  } else{
	  cfg.update();
	  logger.debug(`Gulp is now read`);
	  return;
  }
});
}();


var watch_T=function(){gulp.task('watch',gulp.series('read_config', function(){
  logger.debug(`

	  It is now watching ${cfg.all_sources_globs}
  `);			

  return gulp.watch(cfg.all_sources_globs, cfg.tasks);
}));
}();

function init_copy_tasks(){
  gulp.task(init_copy_tasks,function(callback){//copy_to_build_folder and read_config would be called by others first 
	  runSequence('read_config',['copy_to_figures_folder','copy_to_base_folder'],'copy_to_build_folder','copy_custome_styles_to_build_folder',callback);
		logger.debug("\n\nInit Tasks (copy_to_figures_folder,copy_to_base_folder,copy_to_build_folder,read_config) Done!");
		logger.debug(`We are going to run ${cfg.tasks}\n\n`);
		return gulp;  	
  });
}

// Copy files (eg. bib files) from some sources to the working directory
var copy_to_base_folder_T=function(){gulp.task('copy_to_base_folder',gulp.series('read_config',function() {
  logger.debug(`\n\n Begin copy_to_base_folder`);			

  if (cfg.all_src_to_copy==undefined || cfg.all_src_to_copy==""){
	  logger.debug(`No file was specified to copy to base `);
	  return gulp;
  }
  else{
	  logger.debug(`Files: ${cfg.all_src_to_copy} will be copied to base folder (${cfg.basefolder})`);
  }

  var the_src_stream= gulp
	  .src(cfg.all_src_to_copy)
	  .pipe(newer(cfg.basefolder))
	  .pipe(gulp.dest(cfg.basefolder));		
  logger.debug(`Copy_to_base_folder done!`);			
  return the_src_stream;
}));
}();

// Copy figures from some sources to the figure directory
var copy_to_figures_folder_T=function(){gulp.task('copy_to_figures_folder',gulp.series('read_config',function() {
  logger.debug(`\n\n Begin copy_to_figures_folder`);			

  if (cfg.files_to_copy_to_figures==undefined || cfg.files_to_copy_to_figures==""){
	  logger.debug(`No folder was specified to copy Figures from`);
	  return gulp;
  }
  else{
	  logger.debug(`Figures from ${cfg.files_to_copy_to_figures} will be copied to figures folder (${cfg.figuresfolder})`);
  }
  var the_src_stream= gulp
	  .src(cfg.files_to_copy_to_figures)//+'/*.*'
	  .pipe(newer(cfg.figuresfolder))
	  .pipe(gulp.dest(cfg.figuresfolder));		
  return the_src_stream;
}));
}();

// // Copy styles from app default style to the style directory
// var copy_to_styles_folder_T=function(){gulp.task('copy_to_styles_folder',['read_config'],function() {
// 	logger.debug(`\n\n Begin copy_to_styles_folder`);			

// 	if (cfg.stylesfolder==undefined || cfg.stylesfolder==""){
// 		logger.debug(`No folder was specified to copy styles to`);
// 		return gulp;
// 	}
// 	else{
// 		logger.debug(`Styles from ${cfg.orig_stylesfolder} will be copied to figures folder (${cfg.stylesfolder}), but no overwrite happens`);
// 	}
// 	var the_src_stream= vfs//IMPORTANT! I used vfs instead of gulp. Vinyl vfs supports 'overwrite: false'
// 		.src(cfg.orig_stylesfolder+'/**/*')//+'/*.*'
// 		.pipe(vfs.dest(cfg.stylesfolder, {overwrite: false}));		
// 	return the_src_stream;
// });
// }();

//Copy source file(s) to build directory
var copy_to_build_folder_T = function(){
  gulp.task('copy_to_build_folder',gulp.series('copy_to_base_folder','copy_to_figures_folder' ,function() {

	  logger.debug(`\n\n Begin copy_to_build_folder`);			
	  logger.debug('Find '+cfg.all_sources_globs+' and copy to => '+cfg.buildfolder);

	  var the_originals_stream= gulp
		  .src(cfg.all_sources_globs)
		  .pipe(newer(cfg.buildfolder))
		  .pipe(gulp.dest(cfg.buildfolder));

	  return the_originals_stream;

  }));
}();


//Copy custom styles file(s) to build directory (and overwrite the original ones)
var copy_custome_styles_to_build_folder_T = function(){
  gulp.task('copy_custome_styles_to_build_folder',gulp.series('copy_to_build_folder' ,function() {

	  logger.debug(`\n\n Begin copy_custome_styles_to_build_folder`);			
	  logger.debug('Find '+cfg.stylesfolder+'/**/*'+' and copy to (overwrite) '+cfg.buildfolder);

	  var the_stream= gulp
		  .src(cfg.stylesfolder+'/**/*')
		  .pipe(tap(function(file, t) {logger.debug('This custome style exists: '+file.path)}))
		  .pipe(flatten()) // ignore directory structure
		  // .pipe(tap(function(file, t) {logger.debug('This custome style is going to buildfolder: '+file.contents.toString())}))
		  .pipe(gulp.dest(cfg.buildfolder));

	  return the_stream;
  }));
}();

