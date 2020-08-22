#!/usr/local/bin/awk -f
# Implementation of Vigenere Cipher
# Copyright 2020 Brian Tabone, all rights reserved 
#

function _ord_init(    low, high, i, t)
{
    low = sprintf("%c", 7) # BEL is ascii 7
    if (low == "\a") {    # regular ascii
        low = 0
        high = 127
    } else if (sprintf("%c", 128 + 7) == "\a") {
        # ascii, mark parity
        low = 128
        high = 255
    } else {        # ebcdic(!)
        low = 0
        high = 255
    }

    for (i = low; i <= high; i++) {
        t = sprintf("%c", i)
        _ord_[t] = i
    }
}

function ord(str,    c)
{
    # only first character is of interest
    c = substr(str, 1, 1)
    return _ord_[c]
}

function chr(c)
{
    # force c to be numeric by adding 0
    return sprintf("%c", c + 0)
}

##################################################
# Perform the decryption rotation using the key value
function decrypt()
{
	keyIdx = 0;
	for (idx = 1; idx <= length(cipherText); idx++)
	{
			keyIdx++;
			if (keyIdx > length(cipherKey))
			{
				keyIdx = 1;
			}

			# This contains the rot value extracted from 
			# the key
			cipherRot = letterPosVec[substr(cipherKey, keyIdx, 1)];
			plaintextOrd = letterPosVec[substr(cipherText, idx, 1)];
			plaintextOrd = plaintextOrd - cipherRot;

# Cirucular buffer
			if (plaintextOrd < 1)
			{
					plaintextOrd += 26;
			}
			printf posLetterVec[plaintextOrd];
	}
	printf("\n");
}


##################################################
# Perform the rotation using the key value
function encrypt()
{
    cipherText=""
    keyIdx = 0;	
	for (idx = 1; idx <= length(plainText); idx++)
	{
			keyIdx++;	
			if (keyIdx > length(cipherKey))
			{
				keyIdx = 1;
			}
			
			# This contains the rot value extracted from 
			# the key
			cipherRot = letterPosVec[substr(cipherKey, keyIdx, 1)];
			plainOrd = letterPosVec[substr(plainText, idx, 1)];
			cipherOrd = plainOrd + cipherRot;
# Cirucular buffer
			if (cipherOrd > 26)
			{
					cipherOrd -= 26;
			}

			cipherText = cipherText posLetterVec[cipherOrd];
	}
	printf cipherText "\n";
}

BEGIN {
		if (length(ARGV) < 3)
		{
			print ("Usage: " ARGV[0] " <key> <plain text>" )	
			exit -1
		}

		plainText = tolower(ARGV[2])
		cipherKey = tolower(ARGV[1])
		
		_ord_init()
		start = ord("a",c)

		for (idx = start; idx < (start + 26); idx++)
		{
			letterPosVec[chr(idx)] = idx-start+1
			posLetterVec[idx-start+1] = chr(idx)
		}

		encrypt()
		decrypt()
}
