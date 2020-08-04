##########################
# Functions to log to a log file

BEGIN {
	LOGLEVELS["FATAL"] = 1;
	LOGLEVELS["WARNING"] = 2;
	LOGLEVELS["INFO"] = 3;
	LOGLEVELS["DEBUG"] = 4;

	# Default log file name
	logfilename="/tmp/awkscript.log";
	
	LOGLEVEL=LOGLEVELS["INFO"];
}
# basepath is full directory path plus base name
# level is the maximum level that will be logged, messages above this level are ignored
# Example basepath:
# /tmp/my_awk_prog
# Then log files will be called /tmp/my_awk_prog-YYYYMMDDHHSS.log
function log_init(basepath, level)
{
	now	 = systime();
	# return date(1)-style output
	filedatetime = strftime("%Y%m%d%H%M%S", now);
	
	logfilename=basepath "-" filedatetime ".log";

	if (LOGLEVELS[level] == 0)
	{
		logMessage = "Invalid log level " level ". Legal values are";
		for (levelStr in LOGLEVELS)
		{
		    if (LOGLEVELS[levelStr] > 0)
		    {
		    	logMessage = logMessage " " levelStr;
		    }
		}
		log_fatal(logMessage);
	}
	LOGLEVEL=LOGLEVELS[level];
}

function log_message(message, level)
{
	if (LOGLEVEL >= LOGLEVELS[level])
	{
		print get_log_datetime() ":" level ":" message >> logfilename;
	}
}

function log_debug(message)
{
	log_message(message, "DEBUG");
}

function log_info(message)
{
	log_message(message, "INFO");
}

function log_warn(message)
{
	log_message(message, "WARNING");
}

function log_fatal(message)
{
	log_message(message, "FATAL");
	print(message);
	exit;
}

function get_log_datetime()
{
	now = systime();
	return strftime("%Y-%m-%d-%H:%M:%S", now);
}
