#!/usr/bin/awk -f
BEGIN {
	FS=",";
	logDate = "";
	brianWins = 0;
	popsWins = 0;
	brianOverallWins = 0;
	popsOverallWins = 0;
	idx = 0;
	dayCount = 0;
}
	
/\// {
	# Record the current day's data
	processDay();

	# Start the next day
	gsub(/[^0-9/]/,"",$1);
	logDate=$1;	
	dayCount++;
}

/[PB]/ {
	for (i=1;i<=NF;i++)
	{
		gsub(/[^PB]/,"",$i);
		wins[$i]++;
	}
}

function processDay()
{
	if (logDate != "")
	{
		winLog[logDate] = wins["P"] "," wins["B"] "," wins["P"] + wins["B"];

		# Variable to track order of winLog used when printing it out in order
		winLogOrder[idx] = logDate; 
		idx++;
	}
	brianOverallWins += wins["B"];
	popsOverallWins += wins["P"];
	if (wins["B"] > wins["P"])
	{
		brianWins++;			
	} else if (wins["P"] > wins["B"])
	{
		popsWins++;
	}
	delete wins;
}

END {
	processDay();

	print "Date,Pops Overall,Pops Games,Brian Overall,Brian Games,Total";
	for (wIdx = 0; wIdx < length(winLogOrder); wIdx++)
	{
		print  winLogOrder[wIdx] "," winLog[winLogOrder[wIdx]];
	}

	print "";
	print "Pops Overall, Pops Game Wins, Brian's Overall, Brian's Game Wins, Total Games, Total Days"
	print popsOverallWins "," popsWins "," brianOverallWins "," brianWins "," popsWins + brianWins, dayCount;
}
