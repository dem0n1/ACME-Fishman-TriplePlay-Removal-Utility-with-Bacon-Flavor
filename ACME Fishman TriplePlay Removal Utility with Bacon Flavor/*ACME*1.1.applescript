-- ⌘⌘⌘⌘⌘⌘𝌵𝌵𝌵𝌵䷈䷈䷔䷔䷔䷑䷑♳♳䷙䷙䷝䷝䷝䷴䷴𝌏𝌏𝌏𝌏⌘⌘⌘⌘⌘⌘
--	Created by: Mark David Johansen
--	Created on: 12/12/12 12:12:12 AM
--	Version 1.1
--	Copyright © 2012-2013 Fishman Transducers, INC.
--	All Rights Reserved
--
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--  [>•<]  [>•<]  [>•<]  Declaration  [>•<]  [>•<]  [>•<]  [>•<]  [>•<]  | 
--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
--
global sysVer
global homePath
global desktopPath
global rootPath
global SystemVersionPlistPath
global kontaktElementsSelectionR2PlistPath
global niKompleteElementsMK2
global kontaktElementsSelectionPath
global appBuildVersionArray
global computerName
global buildNumber
global productBuildVers
global appendData
global testCases
global theTest
global passFail
global infoPlistPath
global standAlone
global timeNow
global timeNowNoColon
global pathToFiles
global foundPaths
global currDate
global theDate
global theTime
global theLogFile
global wholePassFail
global testCase -- test case name 

property exitStatus : -1
property fileCount : -1
property i : -1
on run
	set currDate to ((current date) as «class isot» as string)
	set theDate to text -19 thru -10 of currDate
	set theTime to text -8 thru -1 of currDate
	set buildNumber to missing value
	set homePath to (path to home folder) as text
	set desktopPath to (path to desktop folder) as text
	set rootPath to (path to startup disk) as text
	set slashLibraryPreferences to (path to preferences folder from local domain)
	set kontaktElementsSelectionPath to quoted form of ("/Users/Shared/Kontakt Elements Selection R2 Library/Instruments/TriplePlay/" as string) --Test for Kontakt 5 Elements
	set kompleteElementsDefault to rootPath & ("Users:Shared:Kontakt Elements Selection R2 Library:Instruments:TriplePlay:")'s quoted form
	set niKompleteElementsMK2 to "com.native-instruments.Komplete Elements Mk2.plist " as string
	set kontaktElementsSelectionR2PlistPath to quoted form of (slashLibraryPreferences & niKompleteElementsMK2 as string)
	set SystemVersionPlistPath to rootPath & "System:Library:CoreServices:SystemVersion.plist" -- Path to SystemVersion.plist file.
	set computerName to (computer name of (system info))
	set sysVer to (system version of (system info))
	set appBuildVersionArray to {}
	set theLogFile to {}
	set wholePassFail to {} -- Hold the cumulative values of the tests run
	set buildNumber to "notpresent"
	set standAloneDefault to "/Applications/TriplePlay.app"
	set pathToFiles to {¬
		"~/Library/Saved Application State/com.fishman.tripleplayStandalone.savedState", ¬
		"~/Library/Preferences/com.fishman.tripleplayStandalone.plist", ¬
		"~/Library/Application Support/TriplePlay", ¬
		"~/Library/Application Support/TriplePlayFactory", ¬
		"~/Library/Caches/TriplePlay", ¬
		"/Library/Application Support/IK Multimedia/SampleTank 2.x/Presets/Juicer Bass.ikmp", ¬
		"/Library/Application Support/IK Multimedia/SampleTank 2.x/Presets/Presets/- Reset Combi -.ikmp", ¬
		"/Library/Audio/Plug-Ins/Components/TriplePlay.component", ¬
		"/Library/Audio/Plug-Ins/Components/TriplePlayFX.component", ¬
		"/Library/Audio/Plug-Ins/VST/TriplePlay.vst", ¬
		"/Library/Audio/Plug-Ins/VST/TriplePlayFX.vst", ¬
		"/Library/Application Support/TriplePlayFactory", ¬
		"/Library/Application Support/IK Multimedia/SampleTank 2.x/Presets/Presets"}
	
	do shell script "Defaults write com.apple.finder AppleShowAllFiles FALSE"
	do shell script "killall Finder"
	my IsItA_Directory(item -2 of pathToFiles)
	set h to 1
	--set testCase to "null" as string
	set testCase to "" -- test case name 
	set testCase to {}
	tell application "System Events" to set productBuildVers to sysVer & space & (the value of property list item "ProductBuildVersion" of contents of property list file SystemVersionPlistPath) -- item "Product Build Version" of SystemVersion.plist
	my TestForCompatibility()
	tell me to set the clipboard to "" -- clear clipboard
	
	-- ###############################
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	--  [>•<]  [>•<]  [>•<]   Beginning of Script [>•<]  [>•<]  [>•<]  [>•<]  [>•<]  | 
	--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	--
	set fileExistsSystem to false
	--#####*****@@@@@ Look fer Elements @@@@@*****#####--
	tell application "System Events" to set fileExistsSystem to exists disk item (kompleteElementsDefault) -- Is the Komplete Elements' Kontakt Elements Selection R2 Library at ~/User/Shared/
	if fileExistsSystem is false then -- If it is Kontakt isn't at default…
		try -- Query /Library/Preferences/com.native-instruments.Komplete Elements Mk2.plist  for key ContentDir
			tell application "System Events" to set kontaktElementsSelectionPath to the value of property list item "ContentDir" of contents of property list file kontaktElementsSelectionR2PlistPath
			set kontaktElementsSelectionPath to POSIX path of kontaktElementsSelectionPath -- Set slash path to TriplePlay (Kontakt) folder from returned by plist
		on error -- If the plist isn't found, or whatever, try asking to find it.
			choose file with prompt "Locate the TriplePlay folder within the Instruments folder of Kontakt Elements Selection R2 Library" & return & "This is part of your Komplete Elements MK2 Kontakt Player Content Install." default location (path to shared documents folder) as alias
			if result is "Cancel" or false then
				set kontaktElementsSelectionPath to " null " & tab & "Kontakt Elements Selection R2"
			else
				set kontaktElementsSelectionPath to result
				set kontaktElementsSelectionPath to POSIX path of kontaktElementsSelectionPath
			end if
		end try
	else
		
	end if
	--set my pathToFiles to my pathToFiles as list
	--get pathToFiles
	--################
	repeat while h is less than or equal to 3
		if h is equal to 1 then
			my FindNamesEndWith(space & "S (TP).stip", h) --(fileNameEnd)
			set foundPaths1 to foundPaths
		else if h is equal to 2 then
			my FindNamesEndWith(space & "M (TP).ikmp", h) --(fileNameEnd)
			set foundPaths2 to foundPaths
		else if h is equal to 3 then
			my FindNamesEndWith(space & "M (TP).nkm", h) --(fileNameEnd)
			set foundPaths3 to foundPaths
		end if
		set h to h + 1
	end repeat
	set h to missing value
	--#####*****@@@@@ BOM and PLIST finder from Installer @@@@@*****#####--
	set shellScript12 to "mdfind -onlyin '/private/var/db/receipts/' 'kMDItemFSName == \"com.fishman.tripleplay*\"'cd"
	set foundPathsTwelve to (do shell script the shellScript12)
	if foundPathsTwelve is equal to "" then set foundPathsTwelve to {" null " & tab & "No Recipts" & return}
	--#####*****@@@@@ BOM and PLIST finder from Installer @@@@@*****#####--
	
	set foundPathsAll to foundPaths1 & return & foundPaths2 & return & foundPaths3 & return & foundPathsTwelve
	log foundPathsAll
	set foundPathsAll to my makeTextIntoList(foundPathsAll, return) --(txt, delim)
	--#####*****@@@@@ STANDALONE APP FINDER @@@@@*****#####--
	try 
		alias POSIX file standAloneDefault
		set appBuildVersionArray's end to standAloneDefault
	on error
		set shellScript10 to "mdfind -onlyin '/' 'kMDItemCFBundleIdentifier == \"com.fishman.*\"'cd"
		set foundPathsComDotFishman to (do shell script the shellScript10)
		if foundPathsComDotFishman is equal to "" then set foundPathsComDotFishman to {" null " & tab & "com.fishman.*" & return}
		set foundPathsComDotFishMen to my makeTextIntoList(foundPathsComDotFishman, return) --(txt, delim)
		--#####*****@@@@@ STANDALONE APP LOCATION PARSER @@@@@*****#####--
		set i to ""
		set i to 1
		repeat until i is equal to (count of foundPathsComDotFishMen)
			set appBuildVersionList to item i of foundPathsComDotFishMen
			if appBuildVersionList ends with "TriplePlay.app" then
				set the end of appBuildVersionArray to appBuildVersionList --'s item i --appBuildVersionArray
				set i to i + 1
			else
				set i to i + 1
			end if
		end repeat
		if (count of items of appBuildVersionArray) is greater than 1 then -- If more than one standalone present dialog with option to pick what to delete (TWErP)
			choose from list appBuildVersionArray default items every item of my appBuildVersionArray with title "Multiple TriplePlay Apps Found" with prompt "Multiple TriplePlay.apps on boot drive." & return & return & "Select All with command-a, Select multiple by command-clicking. Selected items will be deleted." OK button name "Remove Selected" cancel button name "Just the Rest" with multiple selections allowed and empty selection allowed
			if result is "Just the Rest" or false then set buildNumber to "NobodyHome" -- If button select is Just the Rest then delete no TP.app from list
		else
			set appBuildVersionArray to my makeTextIntoList(appBuildVersionArray, return) --(txt, delim)
		end if
	end try
	
	set i to ""
	set outputVector to {}
	try
		repeat with i from 1 to the count of appBuildVersionArray
			set infoPlistPath to ((item i of appBuildVersionArray) & "/Contents/Info.plist") as string -- Get version number from Info.plist of apps in list.
			tell application "System Events" to set buildNumber to the value of property list item "CFBundleShortVersionString" of contents of property list file infoPlistPath
			if i is greater than 1 then
				set outputVector to outputVector & return & " Path:" & space & (item i of appBuildVersionArray) & tab & " Build:" & space & buildNumber as text
			else
				set outputVector to " Path:" & space & (item i of appBuildVersionArray) & tab & " Build:" & space & buildNumber & return as text
			end if
		end repeat
		set foundPathsComDotFishMen to outputVector
		
	on error
	choose file with prompt "Locate your TriplePlay application:" of type {"app"} default location (path to Applications folder) as alias
		choose file with prompt "Locate your TriplePlay application:" of type {"app"} default location (POSIX file (rootPath & "Applications") as alias)
		if result is false then
			set buildNumber to "NobodyHome"
		else
			set standAloneMacPath to result
		end if
		set standAlone to POSIX path of standAloneMacPath as text
		set exitStatus to (do shell script "ls " & standAlone & "; echo $?")
		log exitStatus
		if exitStatus ends with return & "0" then
			set infoPlistPath to ((item 1 of pathToFiles) & "/Contents/Info.plist")
			tell application "System Events" to set buildNumber to the value of property list item "CFBundleShortVersionString" of contents of property list file infoPlistPath
		else
			
		end if
		set exitStatus to ""
	end try
	
	set testCase to "TriplePlay Standalone — " & buildNumber
	set testCases to "TriplePlay Standalone — " & return & (paragraphs of (foundPathsComDotFishMen)) --as text
	--#####*****@@@@@ STANDALONE APP @@@@@*****#####--
	
	set pathToFiles to appBuildVersionArray & foundPathsAll & pathToFiles & kontaktElementsSelectionPath
	set fileCount to count of items of pathToFiles
	log fileCount
	
	--################
	
	my scriptSetUp()
	my timeNowRoutine("no")
	my DeleteFiles()
	
	--################
	set wholePassFail to wholePassFail & return & return & "*A File Not Deleted entry may be caused by:" & return & "The file has not been generated. This may be expected behavior, check to see if this is expected." & return & "The file was manually deleted prior to running the removal utility." & return & "The listed path may no longer be valid due to a design change. The utility still tracks that path in case the target was not removed previously." & return & "The file/folder is not present at expected location due a design change that the utility is not tracking yet, check for an update to the removal utility."
	logToFile(wholePassFail, theLogFile, appendData) of me
	set i to -1
	set {sysVer, homePath, desktopPath, rootPath, SystemVersionPlistPath, computerName, buildNumber, productBuildVers} to {"", "", "", "", "", "", "", "", "", ""}
	set {appendData, theTest, passFail, infoPlistPath, standAlone, timeNow, timeNowNoColon, currDate, theDate, theTime} to {"", "", "", "", "", "", "", "", "", ""}
	set {theLogFile, wholePassFail, exitStatus, fileCount, testCase, pathToFiles} to {"", "", "", "", "", ""}
	tell me to say "Done."
	-- ###############################
end run
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--  [>|<•>|<•>|<]  Routines [>|<•>|<•>|<] [>•<]  [>•<]  [>•<]  [>•<]  [>•<]  | 
--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
--
on FindNamesEndWith(fileNameEnd, h)
	if h is not 3 then
		set shellScript to ("mdfind -onlyin '/Library/Application Support/IK Multimedia/' 'kMDItemFSName == \"*" & fileNameEnd & "\"'cd") as string
	else
		set shellScript to ("mdfind -onlyin" & space & kontaktElementsSelectionPath & space & "'kMDItemFSName == \"*" & fileNameEnd & "\"'cd") as string
	end if
	set foundPaths to (do shell script the shellScript)
	if foundPaths is equal to "" then set foundPaths to {"null" & tab & "No file" & fileNameEnd & return}
	return (foundPaths)
end FindNamesEndWith

on DeleteFiles()
	if buildNumber is equal to "NobodyHome" then
		set i to 2
	else
		set i to 1
	end if
	repeat while i ≤ fileCount
		if fileCount ≥ 1 then
			set fileToDelete to item i of pathToFiles as text
			set theTest to fileToDelete as text
			set fileToDelete to the quoted form of fileToDelete as string
			log fileToDelete
			if fileToDelete does not start with " null " then
				(do shell script ("ls" & space & fileToDelete & space & "; echo $?") with administrator privileges)
				set exitStatus to result
				if exitStatus ends with return & "0" then
					do shell script "/bin/rm -R -f " & fileToDelete
					set passFail to "Deleted"
				else
					set passFail to "File Not Deleted.*"
				end if
				--display dialog theTest & return & passFail & return & exitStatus & return & i buttons {"OK"} default button 1
				set i to i + 1
				LogToMemory(theTest, passFail)
			end if
		else
			set passFail to " ø null ø "
			set i to i + 1
			LogToMemory(theTest, passFail)
		end if
		set exitStatus to ""
	end repeat
end DeleteFiles

on LogToMemory(theTest, passFail) -- 
	set wholePassFail to wholePassFail & theTest & tab & passFail & return
	set the clipboard to wholePassFail as text
	set {theTest, passFail} to {"", ""}
	return wholePassFail
end LogToMemory

on scriptSetUp()
	-- Log file name and run heading #################
	set theLogFile to desktopPath & testCase & space & computerName & space & productBuildVers & space & theDate & ".txt" as text
	set appendData to true
	set wholePassFail to testCase & tab & theDate & space & theTime & tab & sysVer & tab & productBuildVers & tab & computerName & return & "Path ********************" & space & "" & space & "******************** Result" & return & testCases & return & return as text
end scriptSetUp

on timeNowRoutine(safeYesNo) -- if "yes" return filename safe (hh*mm*ss), if "no" return timestamp with colon seperators.
	set timeNowAll to (current date) as text
	set timeNowWords to words -1 thru -4 of timeNowAll
	set currHour to item 1 of timeNowWords
	set currMin to item 2 of timeNowWords
	set currSec to item 3 of timeNowWords
	set currAMPM to item 4 of timeNowWords
	--
	set timeNow to currHour & ":" & currMin & ":" & currSec & space & currAMPM
	set timeNowNoColon to currHour & "*" & currMin & "*" & currSec & "_" & currAMPM
	if safeYesNo is "no" then
		return timeNow
	else if safeYesNo is "yes" then
		return timeNowNoColon
	else
		return ""
	end if
end timeNowRoutine

on logToFile(wholePassFail, theLogFile, appendData)
	try
		set the theLogFile to the theLogFile as text
		set the open_theLogFile to open for access file theLogFile with write permission
		if appendData is false then set eof of the open_theLogFile to 0
		write wholePassFail to the open_theLogFile starting at eof
		close access the open_theLogFile
		return true
	on error
		try
			close access file theLogFile
		end try
		return false
	end try
end logToFile

on makeTextIntoList(txt, delim)
	local saveD
	set saveD to AppleScript's text item delimiters
	try
		set AppleScript's text item delimiters to {delim}
		set theList to every text item of txt
	on error errStr number errNum
		set AppleScript's text item delimiters to saveD
		error errStr number errNum
	end try
	set AppleScript's text item delimiters to saveD
	return (theList)
end makeTextIntoList

on IsItA_Directory(someItem) -- someItem is a string
	set filePosixPath to quoted form of (POSIX path of someItem)
	set fileType to (do shell script "file -b " & filePosixPath)
	if fileType ends with "directory" then return true
	return false
end IsItA_Directory

on TestForCompatibility()
	tell application "System Events"
		activate
		get system attribute "sysv"
		if result is greater than or equal to 4200 then -- Mac OS X 10.6.8
			if UI elements enabled then
				tell application process me
					tell me to say "Triple Play now being removed. Enter Admin credentials when prompted to continue."
					activate
					my EnabledGUIScripting(true)
				end tell
			else
				beep
				my EnabledGUIScripting(true)
				display dialog "GUI Scripting is not enabled" & return & return & "Open System Preferences and check Enable Access for Assistive Devices in the Accessibility (or Universal Access) preference pane, then run this script again." with icon stop
				if button returned of result is "OK" then
					tell application "System Preferences"
						activate
						set current pane to pane "com.apple.preference.universalaccess"
					end tell
				end if
			end if
		else
			beep
			display dialog "This computer will not run this script" & return & return & "The script uses GUI Scripting technology, and requires TriplePlay which will not install on a Mac computer with an operating systm below Mac OS X Snow Leopard v10.6." with icon critical buttons {"Quit"} default button "Quit"
		end if
	end tell
end TestForCompatibility

on EnabledGUIScripting(switch)
	-- Call this handler and pass 'true' in the switch parameter to enable GUI Scripting before your script executes any GUI Scripting commands,
	-- or pass 'false' to disable GUI Scripting. You need not test the 'UI elements enabled' setting before calling this handler, 
	-- because authorization is required only if 'UI elements enabled' will be changed. Returns the final setting of 'UI elements enabled', 
	-- even if unchanged.
	tell application "System Events"
		activate -- brings System Events authentication dialog to front
		set UI elements enabled to switch
		return UI elements enabled
	end tell
end EnabledGUIScripting
--
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--[>•<] [>|<] EOF «END OF SCRIPT» EOF [>|<] [>•<]  [>•<]  [>•<]  [>•<]  [>•<]  | 
--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
-- 1.0 version finalized 12/12/12
-- 1.0.1 Added removal of: TP presets/Kontact instruments used in custom patches, plug-ins FX versions, receipts for new install 01/12/13
-- 1.0.2 Added factory patches backup folder — TriplePlayFactory and corrected paths of 2 sampletank files that were not properly escaped. 1/21/13
-- 1.0.3 Added checks for new locations of TriplePlay elements while still checking older paths for those who have not cleaned-up in some time.
-- 		These will be taken out before beta 2 release. Enabled using MDFind (Spotlight) for locating TP installed sounds and presets. 2/20/13
-- 1.1 Rearchitectected the app to be less absolute path dependent and more flexible
--###############################
-- do shell script "[path/to/app] [param]" user name "[admin name]" password "[password]" with administrator privileges
(*
1 * (16^3) == 4096
0 * (16^2) ==    0
6 * (16^1) ==   96
8 * (16^0) ==    8
      sysv == 4200

--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Ballad\\ EP\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Blinded\\ EP\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Cello\\ 2\\ LP\\ RNG\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Classic\\ Brass\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Clean\\ STR\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Compressed\\ Kit\\ 2\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Double\\ Bass\\ w\\ sl\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Film\\ E\\ Motion\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Flute\\ 1\\ LP\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Hard\\ EP\\ with\\ cab\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/In\\ Carz\\ Leg\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Legato\\ Alto\\ Sax\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Les\\ Paul\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Mean\\ Bottom\\ Leg\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Mystical\\ Phasestr\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Taylor\\ Acoustic\\ 3D\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Violin\\ 2\\ LP\\ EXPO\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Soprano\\ Legato\\ 2\\ M\\ \\(TP\\).ikmp", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Soprano\\ Legato\\ 2\\ S\\ \\(TP\\).stip", ¬
--"/Users/Shared/Kontakt\\ Elements\\ Selection\\ R2\\ Library/Instruments/TriplePlay/", ¬
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Presets/", 
--"/Library/Application\\ Support/IK\\ Multimedia/SampleTank\\ 2.x/Presets/Juicer\\ Bass.ikmp", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.component.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.component.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.Kontakt.Presets.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.Kontakt.Presets.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.SampleTank.Instruments.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.SampleTank.Instruments.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.SampleTank.Presets.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.SampleTank.Presets.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.standalone.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.standalone.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.TriplePlayFactory.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.TriplePlayFactory.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.vst.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplay.vst.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplayFX.component.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplayFX.component.pkg.plist", ¬
--"/private/var/db/receipts/com.fishman.tripleplayFX.vst.pkg.bom", ¬
--"/private/var/db/receipts/com.fishman.tripleplayFX.vst.pkg.plist"¬
*)
--NI Instruments do not have to be installed in /Users/Shared/ — currently using potentially incorrect assumption, probably correct in over 70% of use cases though.
--###############################
