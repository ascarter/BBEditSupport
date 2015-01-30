-- Create ctags file for active project

on run
	tell application "BBEdit"
		set activeWindow to front window
		
		if (class of activeWindow is not project window) then
			return
		end if
		
		set projectDocument to project document of activeWindow
		
		if ((count of items of projectDocument) > 0) then
			set firstItem to (item 1 of projectDocument) as alias
		else
			if file of document of activeWindow is not missing value then
				set firstItem to (file of document of activeWindow) as alias
			else
				-- File is unsaved
				return
			end if
		end if
		
		if (on disk of projectDocument) then
			tell application "Finder"
				set projectDir to (container of (file of projectDocument))
				set firstItemDir to (container of firstItem)
			end tell
			
			if (firstItemDir is equal to projectDir) then
				-- Use project file
				set projectRoot to projectDir as alias
			end if
		end if
		
		-- Project is either insta-project or external
		-- Use first item
		set projectRoot to firstItem
	end tell
	
	if projectRoot is not equal to missing value then
		do shell script ("/usr/local/bin/bbedit --maketags " & (POSIX path of projectRoot))
	end if
end run

