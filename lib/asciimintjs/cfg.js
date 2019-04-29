/*
I had to run this:
https://gist.github.com/abernix/a7619b07b687bb97ab573b0dc30928a0
*/
/*
Config variables
*/
const config_yaml_filename='config.yaml';

const	yaml = require('yamljs');
const fs = require('graceful-fs-extra');
const	path=require('path');
const appRoot = require('app-root-path');
const	reqlib = require('app-root-path').require;//var myModule = reqlib('/lib/my-module.js')

// const logger = require(`./logger.js`);
var logger=require('winston');

var cfg = module.exports ={
	active_properties : ['title', 'tex_title','subtitle', 'author', 'date' ,'basefolder', 
	'outfolder', 'buildfolder', 'figuresfolder', 'stylesfolder','tasks', //'orig_stylesfolder', 
	'src_name', 'target', 'files_to_copy_to_base', 'files_to_copy_to_figures', 
	'commands_to_run_before', 'bib_file', 'bib_style', 'csl_style', '_is_biblatex', 
	'glossary', 'tex_glossary', 'tex_template', 'css_file', 'css_file_rtl', 
	'pres_engine', 'pres_css_file', 'doctype', 'tex_engine', 'tikz_tex_engine', 'cmd_latexmk', 
	'cmd_latexmk_tikz', 'pdf_style', 'pdf_font', 'lang', 'rtl', 'remove_sidebar_text'],
	title : '',
	tex_title : '',
	subtitle : '',
	author : '',
	date :'',
	basefolder : process.cwd(),
	outfolder : process.cwd()+'/output',
	buildfolder:process.cwd()+'/build',
	figuresfolder:process.cwd()+'/figures',
	orig_stylesfolder:appRoot+'/styles',
	stylesfolder:appRoot+'/styles',
	// base :  '/Users/sei/Dropbox/Academics/_my_writings/phd',
	//'PDF_FOPUB','tex_f_html','HTML','PDF_DIRECT','PDFTEX', 'DOCX'
	tasks : ['tex_f_html','HTML','PDF_DIRECT','PDFTEX','DOCX'],
	src_name : '',//sanad_madar
	target : '',	//sanad_madar
	// #adoc_pdf adoc_tex_pdf adoc_docbook_tex_pdf adoc_docbooktex adoc_docbook4tex_tex adoc_docbook4tex_tex_pdf
	// #adoc_tex_pdf adoc_docbook4tex_tex adoc_docbook4tex_tex_pdf adoc_docbook4docx_docx
	// format : ['adoc_docbook4tex_tex_pdf', 'adoc_docbook4docx_docx', 'adoc_html'],
	files_to_copy_to_base :  [],
	files_to_copy_to_figures :  [],
	commands_to_run_before:[],
	get all_src_to_copy() {return this.files_to_copy_to_base;},
	bib_file :  '',//library.bib
	// chicago-author-date,apa,ieee
	bib_style : 'apa',
	html_bib_option :'',
	csl_style : 'apa',
	_is_biblatex: true,
	glossary :  '',//'_glossary.adoc.txt',
	tex_glossary : '',//'tex_glossary.tex',
	// #licentiate.docbooktemplate_tuft1.tex licentiate.docbooktemplate_mem1.tex
	tex_template : 'x_fa_article.tex',//x_article.tex,x_book.tex,x_fa_article.tex, x_fa_book.tex
	// #xelatex pdflatex,
	//tex_compiler : 'xelatex',
	css_file : 'my.css',
	css_file_rtl : 'my_rtl.css',
	pres_engine : 'reveal',
	pres_css_file : 'pres.css',
	doctype : 'article',
	tex_engine :'pdflatex',
	tikz_tex_engine: 'pdflatex',
	cmd_latexmk : '',
	cmd_latexmk_tikz : '',
	pdf_style : 'my-theme.yml',
	pdf_font : 'IRMitra',//IRFarnaz_p30download.com
	lang : 'fa',//en
	rtl : false, //automatically is set if lang is fa or ar
	remove_sidebar_text : false, //remove the sidebar text or not
	//The first part will be process in updateCofig to create the full globs by the second part
	sources_globs : [// Important! probably orig_styles_xxx should be before styles_xxx , so it would overwrite correctly
		['adocs','*.adoc.txt'],
		['bibs','*.bib'],
		['extra_texes','*.tex'],
		['figures','**/*'],//./figures/
		['orig_styles_tex','tex/**/*'],//./styles/
		['orig_styles_html','html/**/*'],//./styles/
		['orig_styles_pres','pres/**/*'],//./styles/
		['orig_styles_pdf','pdf/**/*'],//./styles/
		// ['styles_tex','tex/**/*'],//./styles/
		// ['styles_html','html/**/*'],//./styles/
		// ['styles_pres','pres/**/*'],//./styles/
		// ['styles_pdf','pdf/**/*'],//./styles/
		['lib','./lib/**/*']//
	],
	get nocase(){
		return false;
	},
	get all_sources_globs(){
		var sources=this.sources_globs.reduce(function(accumulator,currentValue,currentIndex,the_array){
			// if (accumulator==undefined) {accumulator=[]};
			// result=(accumulator==undefined)?[]:accumulator;
			accumulator.push(currentValue[1])
			return accumulator;
		},[]);//initially accumulator should be []
		logger.debug(`These sources will be used: ${sources}`);
		return sources;
	},
	read_and_update: function(){

		logger.debug(`Willl read config from ${this.basefolder}/${config_yaml_filename} >>>>`)

		var cfg_file=`${this.basefolder}/${config_yaml_filename}`;
		var file_contents_string = fs.readFileSync(cfg_file,'utf8');//file.contents.toString();//NOTE: it nags without utf8
		logger.debug(`I read this: ${file_contents_string}`);
		var cfg_yaml="";
		try{
			cfg_yaml=yaml.parse(file_contents_string);
		}catch(err){
			logger.debug(`Problem in reading configuation file: ${cfg_file}`);
			logger.debug(`The error was: ${err}`);
			logger.debug(`Process will exit.`);
			process.exit();
		}

		// for (var attrname in this.active_properties) {
		this.active_properties.forEach((attrname)=>{
			var replace_val=undefined;
			if (cfg_yaml[attrname]!=undefined){
				switch(attrname){
					//if it is about folders
					case 'all_src_to_copy':
						logger.debug(`You cannot change ${attrname}!`);
						break;
					case 'basefolder':
						// use absolute path if defined, otherwise add the relative path to the current working directory
						replace_val= (path.isAbsolute(cfg_yaml['basefolder']))? cfg_yaml['basefolder']:process.cwd()+'/'+cfg_yaml['basefolder'];
						try{
							fs.accessSync(replace_val,fs.constants.W_OK)
						}
						catch(err){
							logger.debug("The base folder you specified does not exist or you don't have permission! Program will exit.");
							process.exit();
						}
						break;
					case 'buildfolder':
					case 'outfolder':
					case 'figuresfolder':
					case 'stylesfolder':
						// use absolute path if defined, otherwise add the relative path to the basefolder
						replace_val= (path.isAbsolute(cfg_yaml[attrname]))? cfg_yaml[attrname]:this.basefolder+'/'+cfg_yaml[attrname];
						fs.ensureDirSync(replace_val, (err)=>{
							if (err){
								logger.debug(`It seems folder ${replace_val} could not be created!`);
								logger.debug(`The process will exist.`);
								process.exit();
							}
							else{
								logger.debug(`Folder ${replace_val} exists, or is created.`);									
							}

						});
						break;
					//for those arrays of paths each should be checked if it is absolute or relative	
					case 'files_to_copy_to_base':
					case 'files_to_copy_to_figures':
					case 'commands_to_run_before':
						replace_val=[];
						for (var i=0; i<cfg_yaml[attrname].length;i++){
							item=cfg_yaml[attrname][i];
							if (item==undefined) continue;
							replace_val.push( (path.isAbsolute(item))? item:process.cwd()+'/'+item);
						}
						break;
					default:
						// In general, choose the config file values 
						replace_val=cfg_yaml[attrname]; 
				}
			}else{//if undefined
				//Just use the current default value
				replace_val = this[attrname]; 
			}
			logger.debug(`For ${attrname} the value (${replace_val}) will be used.`);
			this[attrname] = replace_val;
		})

		//Calculate RTL things
		this.rtl = (this.lang=='fa' | this.lang=='ar') ? true :false;
		logger.debug("RTL would be considered "+this.rtl);

		//Calculate HTML bib option
		// this.html_bib_option = (this.bib_file==undefined || this.bib_file=='')? ``:` --require asciidoctor-bibtex  -a bibtex-file=${this.bib_file} -a bibtex-style=${this.csl_style} -a bibtex-order=appearance -a bibtex-format=asciidoc`;
		this.html_bib_option = (this.bib_file==undefined || this.bib_file=='')? ``:` --require "${appRoot}/lib/asciidoctor-bibtex-cite-in-prose/lib/asciidoctor-bibtex.rb"  -a bibtex-file=${this.bib_file} -a bibtex-style=${this.csl_style} -a bibtex-order=appearance -a bibtex-format=asciidoc`;
		// this.html_bib_option = (this.bib_file==undefined || this.bib_file=='')? ``:` -a bibliography-database=${this.bib_file}@ -a bibliography-style=${this.csl_style}@ --require asciidoctor-bibliography  `;
		logger.debug("HTML bib options would be  " + this.html_bib_option);


		this.css_file_final= (this.rtl)? this.css_file_rtl:this.css_file;
		logger.debug("The  css file would be  "+this.css_file_final);

		//Some time it needs for cleaning biber cache
		//rm -rf `biber --cache`
		//ps2pdf -dPDFSETTINGS=/prepress -dAutoRotatePages=/None -dEmbedAllFonts=true -dSubsetFonts=true old.pdf new.pdf
		var latexmk_bib_option=(this.bib_file!=undefined && this.bib_file!='')?` -bibtex `:` -bibtex- `;
		if (this.rtl || (this.tex_engine=='xelatex')){
		// if (this.tex_engine=='xelatex'){
				// this.cmd_latexmk= 'latexmk -cd -f -pdf -quiet -silent -pdflatex="xelatex --shell-escape --enable-write18 -interaction=nonstopmode -synctex=1 -file-line-error %S %O " > latexmd.log';
			this.cmd_latexmk= `latexmk ${latexmk_bib_option}  -norc -r latexmkrc -cd -f -pdfxe -quiet -silent -xelatex -pdflatex="xelatex --shell-escape --enable-write18 -interaction=nonstopmode -synctex=1 -file-line-error %S %O " > latexmd.log`;
		}else if(this.tex_engine=='lualatex'){
			this.cmd_latexmk= `latexmk ${latexmk_bib_option} -norc -r latexmkrc -cd -f -pdflua -quiet -silent -lualatex -pdflatex="lualatex --shell-escape --enable-write18 -interaction=nonstopmode -synctex=1 -file-line-error %S %O " > latexmd.log`;
		}else{//normaly means pdflatex
			this.cmd_latexmk= `latexmk ${latexmk_bib_option} -norc -r latexmkrc -cd -f -pdf -quiet -silent -pdflatex="pdflatex --shell-escape --enable-write18 -interaction=nonstopmode -synctex=1 -file-line-error %S %O " > latexmd.log`;
		}

		if (this.rtl || (this.tikz_tex_engine=='xelatex')){
			this.cmd_latexmk_tikz= `latexmk ${latexmk_bib_option} -norc -r latexmkrc -cd -f -pdfxe -quiet -silent -xelatex -pdflatex="xelatex --shell-escape --enable-write18 -interaction=nonstopmode -synctex=1 -file-line-error %S %O " > latexmd.log`;
		}else if(this.tikz_tex_engine=='lualatex'){
			this.cmd_latexmk_tikz= `latexmk ${latexmk_bib_option} -norc -r latexmkrc -cd -f -pdflua -quiet -silent -lualatex -pdflatex="lualatex --shell-escape --enable-write18 -interaction=nonstopmode -synctex=1 -file-line-error %S %O " > latexmd.log`;
		}else{//normaly means pdflatex
			this.cmd_latexmk_tikz= `latexmk ${latexmk_bib_option} -norc -r latexmkrc -cd -f -pdf -quiet -silent -xelatex -pdflatex="lualatex --shell-escape --enable-write18 -interaction=nonstopmode -synctex=1 -file-line-error %S %O " > latexmd.log`;
		}

		logger.debug(`The latex command would be  ${this.cmd_latexmk}`);
		logger.debug(`The latex command for tikz would be  ${this.cmd_latexmk_tikz}`);

		//Update sources things
		this.sources_globs.forEach ((duet,i) => { //use arrow function, so it does not bind 'this'
		// for (const duet of this.sources_globs){
			var key=duet[0];
			var globstr=duet[1];
			switch(key){
				case 'adocs' :
				case 'bibs' :
				case 'extra_texes' : //based on basefolder
					this.sources_globs[i][1]=this.basefolder+'/'+globstr;
					break;
				case 'figures' ://based on figuresfolder
					this.sources_globs[i][1]=this.figuresfolder+'/'+globstr;
					break;
				// case 'styles_tex' ://based on stylesfolder
				// case 'styles_html' ://
				// case 'styles_pres' ://
				// case 'styles_pdf' ://
				// 	this.sources_globs[i][1]=this.stylesfolder+'/'+globstr;
				// 	break;
				case 'orig_styles_tex' ://based on stylesfolder
				case 'orig_styles_html' ://
				case 'orig_styles_pres' ://
				case 'orig_styles_pdf' ://
					this.sources_globs[i][1]=this.orig_stylesfolder+'/'+globstr;
					break;
				case 'lib' ://based on appRoot
					this.sources_globs[i][1]=appRoot+'/'+globstr;
					break;	
			}
		})
		logger.debug('Sources globe has been updated to: '+this.sources_globs);
		logger.debug('Config Read is Finished.\n\n');
		// var the_gulp= gulp
		// 	.src(this.basefolder+'/'+config_yaml_filename)
		// 	.pipe(tap(function(file, t) {



		// 	}))
		// ;
		logger.debug(`The config was read from ${this.basefolder}/${config_yaml_filename} >>>>`)
		return;

	}
};
