#!/usr/bin/awk -f
@include "include/logger.awk";

BEGIN {
	FS=",";
	logDate = "";
	brianGamesWon = 0;
	popsGamesWon = 0;
	draws = 0;
	handsWonByBrian = 0;
	handsWonByPops = 0;
	idx = 0;
	log_init("./dominos_analysis", "DEBUG");
}
	
/\// {
	# Record the current day's data
	processDay();

	# Start the next day
	gsub(/[^0-9/]/,"",$1);
	logDate=$1;	
}

/[PBD]/ {
	for (i=1;i<=NF;i++)
	{
		gsub(/[^PBD]/,"",$i);
		wins[$i]++;
	}
}

function processDay()
{
	if (logDate != "")
	{
		if (!("D" in wins))
		{
			wins["D"] = 0;
		}

		winLog[logDate] = wins["P"] "," wins["B"] "," wins["D"] "," wins["P"] + wins["B"] + wins["D"];

		# Variable to track order of winLog used when printing it out in order
		winLogOrder[idx] = logDate; 
		idx++;
		handsWonByBrian += wins["B"];
		handsWonByPops += wins["P"];
		if (wins["B"] > wins["P"])
		{
			brianGamesWon++;			
		} else if (wins["P"] > wins["B"])
		{
			popsGamesWon++;
		}
		else if (wins["P"] == wins["B"])
		{
			log_info("A draw found on " logDate);
			draws++;
		}
		delete wins;
	}

}

END {
	processDay();

	print "Date,Pops ,Brian, Draw, Total";
	for (wIdx = 0; wIdx < length(winLogOrder); wIdx++)
	{
		print  winLogOrder[wIdx] "," winLog[winLogOrder[wIdx]];
	}

	print ""
	print "Pops Overall, Pops Game Wins, Brian Overall Wins, Brian Game Wins, Draws, Total Games, Total Days";
	print handsWonByPops "," popsGamesWon "," handsWonByBrian "," brianGamesWon "," draws "," handsWonByPops + handsWonByBrian "," length(winLog); 
}
