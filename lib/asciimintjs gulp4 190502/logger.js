/*
Autoconfigs and internal settings
*/
const fs = require('graceful-fs-extra');

var logger = module.exports = {
	first_time: true,
	show_stdout: true,
	log_filename:'asciimint.log',
	basefolder:process.cwd(),
	get logfile_path(){return (this.basefolder+'/'+this.log_filename);},
	belog:function(content){
		logger.log(`\n\n\nBegining ${content}`);
	},
	log: function(new_info){
		if (this.show_stdout){
			logger.log(new_info);
		}
		//truncate the logfile in first-use
		if (this.first_time){
			this.first_time=false;
			var the_file;
			if (fs.exists(this.logfile_path)){
				the_file=fs.openSync(this.logfile_path);
				fs.ftruncateSync(the_file, 'r+');				
				fs.close(the_file);
			}
		}
		fs.appendFile(this.log_filename, new_info+"\n", (err) => {
		  if (err) throw err;
		});
	}
}



