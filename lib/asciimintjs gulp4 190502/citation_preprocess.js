// const logger = require(`./logger.js`);
var logger=require('winston');

var adocCitationPreprocess = module.exports = function adocCitationPreprocess(the_content,dest){

	logger.debug(`\n\n Begin adocCitationPreprocess`);			
	logger.debug(`Destination ${dest}`);			

	// NOTE: we cannot support multipe citation with page number at the same time 
	var result;
	var //For cite or citenp[somekey1,somekey2(23-54)]
		// CITATION_KEY = '(\\w+)(\\(\\d+(-\\d+)*\\))?',//this includes paranthesis
		BIBTEX_KEY_PATTERN=`[^\\s,()\\[\\]]+`;//I tried to be this pattern to be the same as asciidoctor-bibtex in sake of compatibility
		CITATION_PAGE=`(\\(\\d+(-\\d+)*\\))`,
		CITATION_KEY = `(${BIBTEX_KEY_PATTERN})(\\(\\d+(-\\d+)*\\))?`,//somekey(21-34)
    	// matches a citation type
    	CITATION_MODE = 'cite|citenp',
    	// matches a citation list
    	CITATION_AFTERKEY = `(\\s*,\\s*${CITATION_KEY})*`,
    	CITATION_SERIE = `(?:${CITATION_KEY}${CITATION_AFTERKEY})`,
    	// matches the whole citation
		CITATION_ALL = `(${CITATION_MODE}):\\[(${CITATION_SERIE})\\]`
		//In future for bibliography
		// CITATION_ALL = (cite):(?:(\S*?)?\[(|.*?[^\\])\])(?:\+(\S*?)?\[(|.*?[^\\])\])*
	;			
	result=the_content.replace(new RegExp(CITATION_ALL,'gmiu'),function(the_match,p1,p2,p3,p4){
		logger.debug(`Citation for ${CITATION_ALL} DocBook ${the_match} with p1:${p1} p2:${p2} p3:${p3} p4:${p4}`);
		// logger.debug(`Citation for ${CITATION_ALL} DocBook`);
		var citation_mode=p1.toString(),
			citation_keypage=p2.toString(),
			citation_keys=p3.toString(),
			citation_page=(p4!==undefined)?(p4.toString().slice(1,-1)):'';
		var citation_keypage_nopagenum = citation_keypage.replace(new RegExp(CITATION_PAGE,'gmiu'),'');			
		var rep_res;
		switch(dest){
			case ('html'):
			break;
			case ('docbook'):
			case ('tex'):
				var cite_page_string=(citation_page!=``)?`[${citation_page}]`:``;
				switch(citation_mode){
					case('cite'):
						// rep_res=`+++<![CDATA[\\citep${cite_page_string}{${citation_keypage}}]]>+++`;
						if (citation_page!='') {
							rep_res =`+++<citation role="citep" condition="${citation_page}" >${citation_keypage_nopagenum}</citation>+++`;// we used to use citation_keypage							
						} else {
							rep_res =`+++<citation role="citep" >${citation_keypage_nopagenum}</citation>+++`;// we used to use citation_keypage														
						}
					break;
					case('citenp'):
						// rep_res=`+++<![CDATA[\\citet${cite_page_string}{${citation_keypage}}]]>+++`;
						if (citation_page!='') {
							rep_res =`+++<citation role="citet" condition="${citation_page}" >${citation_keypage_nopagenum}</citation>+++`;// we used to use citation_keypage
						} else {
							rep_res =`+++<citation role="citet" >${citation_keypage_nopagenum}</citation>+++`;// we used to use citation_keypage
						}
					break;
					default:
						logger.debug("Not cite nor citenp?!!!, I will quit!");
				}
			case ('pdf'):
			break;
			case ('adoc'):
			break;
			default:
				logger.debug("Citation for unknown type requested, check the caller function.");
				process.exit();
			break;
		}
		logger.debug(rep_res);
		return rep_res;
	});
	return result;
}