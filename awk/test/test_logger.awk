#!/usr/bin/awk -f
# Test the logger system
@include "../include/logger.awk"

BEGIN {
	log_init("/tmp/awk_test_logger", "DEBUG");
	log_debug("A debug message");
	system("sleep 1");
	log_info("An info message");
	system("sleep 1");
	log_warn("A warning");
	system("sleep 1");
	log_fatal("Fatal error, should exit");
}
