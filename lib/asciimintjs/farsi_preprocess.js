// const logger = require(`./logger.js`);
var logger=require('winston');

var adocFarsiPreprocess = module.exports =  function adocFarsiPreprocess(the_content){


	logger.debug(`\n\n Begin adocFarsiPreprocess`);			

	// d=delimiter,r=role, m=macro, cm=custom macro, s=style, a=attribute, b=bracket attribute, av=value for attribute, bv=bracket attribute value
	var farsi_map=[
		// ['r','نو','newthought'],
		// ['r','گوش‌زمینه','cornerbackground'],
		// ['r','سردرنویس','epigraph'],
		// ['s','بازگفت','quote'],
		// ['m','پانویس','footnote'],
		// ['r','کنارچکیده','sidesummary'],
		// ['r','کنارگزیده','pullquote'],
		// ['m','پی‌گیر','citep'],
        // [['nl'],",","،"],
        [['d'],",","٫"],
        [['r','s'],"abstract","چکیده"],
        [['r'],"acronym","کوتاه‌نوشت"],
        [['r'],"ac","کوت"],// acronym= ac, کوتاه‌نوشت=کوت
        [['r','s'],"acknowledgments","سپاس‌گذاری"],
        [['b'],"anchore","لنگر"],
        [['r','s'],"appendix","پیوست"],
        [['av'],"article","نوشتار"], //And مقاله
        [['av','bv'],"background","پس‌زمینه"],
        [['r','s'],"bibliography","یادکردها"], //And گواهی‌ها
        [['av','bv'],"book","کتاب"],
        [['r','s','a','b','av','bv'],"chapter","فصل"],
        [['r'],"chapter-caption","فصل‌گزاره"],//'s'
        [['m'],"cite","یادکرد"], //And گواه
        [['bv'],"caption","گزاره"],
        [['r','s'],"colophon","انجامه"],
        [['bv'],"color","رنگ"],
        [['bv'],"column","ستون"],
        [['r','s'],"copyright","حق پخش"],
        [['r'],"corner-background","گوش‌زمینه"],// 's'
        [['r'],"cross-insert","جایگذار"], //'s'
        [['r'],"data","داده"],//'s'
        [['r','s'],"dedication","پیشکش"],
        [['r','a','b'],"editor","سرویراستار"],
        [['r','a','b'],"copy-editor","ویراستار زبان"],
        [['av','bv'],"en","انگلیسی"],   
        [['r'],"end-note","پایان نویس"],//'s'
        [['r'],"epigraph","سردرنویس"],//'s'
        [['r'],"example","نمونه"], //'s'
        [['av','bv'],"fa","فارسی"],   
        [['r'],"figure","نمودار"], //Image   //s     
        [['r','m'],"footnote","پانویس"],
        [['r'],"form","کاربرگه"],//s
        [['r'],"formula","ریختار"],//s
        [['b'],"height","بلندا"],
        [['r','s'],"glossary","واژه‌نامه"],
        [['m'],"ifdef","اگربود"],
        [['m'],"ifeval","اگرشد"],
        [['m'],"ifndef","اگرنبود"],
        [['m'],"image","نگاره"],
        [['r'],"initial","سرآغاز"], //Lettrine
        [['m'],"include","دربرگیر"],
        [['r','s'],"index","نمایه"],
        [['r','m'],"indexterm","نماواژه"],
        [['r','m'],"isnb","شابک"],
        [['r'],"keywords","کلیدواژگان"],//s
        [['a','b'],"layout","چیدمان"],
        [['r','a','b'],"label","برچسب"],
        [['r','a','b'],"link","پیوند"],
        [['r'],"lang","زبان"],
        [['bv'],"name","نام"],
        [['r'],"newthought","نو"],
        [['av','bv'],"nothing","پوچ"],
        [['b'],"options","گزینه‌ها"],
        [['r','a','b'],"organisation","سازمان"],
        [['r','b','bv'],"page","صفحه"],//s
        [['r','b','bv'],"paragraph","بند"],//s
        [['bv'],"portion","دانگ"],//And همهٔصفحه
        [['r','s'],"part","بخش"],//s
        [['r','b'],"part-caption","بخش‌گزاره"],
        [['r','b'],"position","جای"],
        [['r','s'],"preface","پیشگفتار"],
        [['r'],"pull-quote","کنارگزیده"],
        [['r','s'],"quote","بازگفت"],
        [['r','b'],"reftext","و‌ا‌نویس"],
        [['r','m'],"render","بنمای"], //And بکش
        [['r'],"review","بازبینی"],//'s'
        [['a','b'],"reviewer","بازبیننده"],
        [['r'],"review-add","خرده‌افزا"],
        [['r'],"review-del","خرده‌زدا"],
        [['r'],"review-sub","خرده‌بجا"],
        [['a','b'],"revision","بازنوشت"],
        [['r','b'],"side-figure","کنارنمودار"], // Side Figure, Side Image, Margin Figure, Margin Image
        [['r','b'],"side-note","کنارنویس"],//Side Note, Margin Note
        [['r','b'],"side-summary","کنارزبده"],//Side Summary, Margin Summary
        [['r'],"slide","برگه"],//s
        [['r','m'],"slider","برگه‌چرخان"],//s
        [['r'],"subtitle","زیرسرنویس"],
        [['r'],"table","جدول"],
        [['a','b'],"theme","بن‌مایه"], //motif نقش‌مایه
        [['r'],"title","سرنویس"],
        [['r'],"title-short","سرنویس‌کوتاه"],
        [['r','s'],"toc","فهرست"],
        //"transition-effect","گذرمایه"],
        [['a','b'],"type","گونه"],
        [['b'],"width","پهنا"]		
	];

	var the_result=the_content;
	var find_pattern,replace_pattern;
	const 
		BRAKET_BEGIN=`\\[\\s*`,
		BRAKET_END=`\\s*\\]`,
		BRAKET_NONLETTER_BEFORE=`(${BRAKET_BEGIN}.*)`,
		BRAKET_NONLETTER_AFTER=`(.*${BRAKET_END})`,
		BRAKET_STYLE_BEFORE=`(${BRAKET_BEGIN})`,//(?!(\\.|#))
		BRAKET_STYLE_AFTER=`(?!\\w)(.*${BRAKET_END})`,//`(#|\\.|\\s*|=|,|،|)${BRAKET_END}`,//[x], [x ,...] [x ،...][x =...]
		BRAKET_ROLE_BEFORE=`(${BRAKET_BEGIN}.*\\.)`,//
		BRAKET_ROLE_AFTER=BRAKET_STYLE_AFTER,//`(#|\\.|\\s*|=|,|،|)${BRAKET_END}`,//[x], [x ,...] [x ،...][x =...]
		BRAKET_ATTR_BEFORE=`(${BRAKET_BEGIN}.*,\\s*)`,//
		BRAKET_ATTR_AFTER=`\\s*(=|,|،|)`,//[x], [x ,...] [x ،...][x =...]
		BRAKET_POST=`(${BRAKET_ATTR_AFTER}${BRAKET_END})`
	;
	logger.debug(`Patterns: \n s_b:${BRAKET_STYLE_BEFORE} \n s_a:${BRAKET_STYLE_AFTER} \n r_b:${BRAKET_ROLE_BEFORE} \n r_a:${BRAKET_ROLE_AFTER} \n a_b:${BRAKET_ATTR_BEFORE} \n a_a:${BRAKET_ATTR_AFTER}`);
	var match_types;
	for (var i=0;i<farsi_map.length;i++){
		var match_types=farsi_map[i][0];
		var en_match=farsi_map[i][1];
		var fa_match=farsi_map[i][2];
		match_types.forEach((match_type)=>{//Each name might be applied for different rules
			switch (match_type){
				//NOTE: maybe in future we have different idea about "," vs. "،"
				case 'd':
					find_pattern=BRAKET_NONLETTER_BEFORE+fa_match+BRAKET_NONLETTER_AFTER;
					// find_pattern=``;//dummy find pattern
					// return;//Go next matching
					break;
				case 'r':
					find_pattern=BRAKET_ROLE_BEFORE+fa_match+BRAKET_ROLE_AFTER;
					break;
				case 's':
					find_pattern=BRAKET_STYLE_BEFORE+fa_match+BRAKET_STYLE_AFTER;
					break;
				case 'a':
					find_pattern=BRAKET_ATTR_BEFORE+fa_match+BRAKET_ATTR_AFTER;
					break;
				case 'm':
					find_pattern=fa_match+'(:\\[(?:\n|.)*?\\])';//removed the first part '([^\w])'+
					logger.debug(`Macro pattern: ${find_pattern}`);
					break;
				case 'cm':
					find_pattern='([^\w])'+fa_match+':\\[(.*)\\]';
					logger.debug("Found custom macro: "+find_pattern+replace_pattern)
					break;
				default:
					logger.debug(`Found a type: ${match_type} that is not handled.`);//
					return true;
					// process.exit();
			}

			the_result=the_result.replace(new RegExp(find_pattern,'gmiu'),function(the_match,p1,p2,p3){
				var res,sep;
				switch (match_type){
					//NOTE: at the moment I think it is better to use only "," as delimiter and ignore "،"  
					//notice the problem with "," matching: there can be more than one "," in each []
					case 'd':
						// res=p1+fa_match+p2;
						//match those which are not inside double quotes
						logger.debug(`This ${the_match}`);
						res=the_match.replace(new RegExp(fa_match+'(?=\\s*(?:[^"]*"[^"]*")*[^"]*$)','gmiu'),function(sub_match){
							return en_match;
						});
						logger.debug(`Will change to ${res}`);
					break;
					case 'r':
						// sep = (p2==',' || p2=='،') ? ',':'';
						// res=p1+en_match+sep+p3;
						res=p1+en_match+p2;
					break;
					case 's':
						// sep = (p2==',' || p2=='،') ? ',':'';
						// res=p1+en_match+sep+p3;
						res=p1+en_match+p2;
					break;
					case 'a':
						// sep = (p2==',' || p2=='،') ? ',':'';
						// res=p1+en_match+sep+p3;
						res=p1+en_match+p2;
					break;
					case 'm':
						res=en_match+p1;
						logger.debug(`p1: ${p1}`);
					break;
					case 'cm':
						logger.debug(`Line 485 ${p1}\\${en_match}{${p2}}`);
						res=`${p1}[.${en_match}]#${p2}#`;
					break;
				}
				logger.debug(` Found for --${find_pattern}--   the --${the_match}-- as --${match_type}-- will rep with ${res}`)

				return res;
			});
		});			

	}

	//Replace
	// the_result=util.replaceAll(the_result,'(\\[.*)،(.*\\])',',')


	return the_result;
}
