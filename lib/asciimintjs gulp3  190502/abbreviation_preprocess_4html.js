// const logger = require(`./logger.js`);
var logger=require('winston');
const fs = require('graceful-fs-extra');
const cfg = require(`./cfg.js`);


var adocAbbreviationsPreprocess4Html = module.exports = function adocAbbreviationsPreprocess4Html(the_content){

	logger.debug(`\n\n Begin adocAbbreviationsPreprocess4Html`);			

	// var EXT_PATTERN_REG=/^:((?:\w|-|_)+)-abbrev:(?:\s+)/mg;
	var EXT_PATTERN_REG=/^:((?:\w|-|_)+)-abbrev:(?:\s+)[a-z|:|,]*\[([\w\s,-]+)\(\[\.acro\].+\[([^\]]+)\]/gmu;
	var the_result=the_content;
	var the_case;
	var the_tex_glossary_file_path = `${cfg.buildfolder}/${cfg.tex_glossary}`;
	var the_tex_glossary_content="";

	//NOTE! BUG! maybe if we repeat the xxx-abrev it would do this two times!
	while((the_case=EXT_PATTERN_REG.exec(the_content))!==null){//Find one :xxx-abrev: we need to process all xxx for that

		const att_pattern_str = `\\{${the_case[1]}\\}`;
		const att_pattern_regexp = new RegExp(att_pattern_str, 'mu');//NOTE: no /g, we need to change only the first
		const att_first_str = `\\{${the_case[1]}-abbrev\\}`;
		const att_first_regexp = new RegExp(att_first_str, 'mu');//no /g, we want to know if only one


		//continue to next if the {xxx-abbrev} already exists. This protects against multiple :xxx-abbrev:
		if (the_result.search(att_first_regexp) !== -1){
			logger.debug(`More than one ${att_pattern_str}`);
			continue;
		}

		logger.debug(`Searching for the first ${att_pattern_str}`);
		the_result = the_result.replace(att_pattern_regexp,function(the_match){
			logger.debug(`The first {${the_case[1]}}, out of ${the_case.length}, was replaced with {${the_case[1]}-abbrev}`);
			return `{${the_case[1]}-abbrev}`;
		});
	}
	
	return the_result;
};

