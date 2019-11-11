
const fs = require('graceful-fs-extra');
var logger=require('winston');
var	jschardet = require('jschardet');
var	iconvLite=require('iconv-lite');


var util = module.exports = {
	escapeRegExp : function (str) {
	  return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); // $& means the whole matched string
	},
	replaceAll : function (str, find, replace) {
	  var res= str.replace(new RegExp(find, 'gmiu'), replace);
	  logger.debug(`Replaced all--- ${find} -- as  ${this.escapeRegExp(find)} --- by ${replace}`)
	  return res;
	},
	convFileUTF8 : function(in_file, out_file){
		var org_content="";
		org_content=fs.readFileSync(in_file);
		 var encInfo = jschardet.detect(org_content);
		 var mid_content = iconvLite.decode(org_content,encInfo.encoding);
		 conv_content=iconvLite.encode(mid_content,"utf8");
		// logger.debug("\n\n"+content+"\n\n");
		// fs.writeFileSync(out_file,utf8.encode(content),{encoding:"utf8"});
		// content=iconvLite.encode(content,'utf8');
		fs.writeFileSync(out_file,conv_content,'utf8');

	}
};
