-- Create ctags file for currently active project

-- Determine the project root directory
on getProjectRoot()
	tell application "BBEdit"
		set activeWindow to front window
		
		if (class of activeWindow is not project window) then
			return missing value
		end if
		
		set projectDocument to project document of activeWindow
		
		if ((count of items of projectDocument) > 0) then
			set firstItem to (item 1 of projectDocument) as alias
		else
			if file of document of activeWindow is not missing value then
				set firstItem to (file of document of activeWindow) as alias
			else
				-- File is unsaved
				return missing value
			end if
		end if
		
		if (on disk of projectDocument) then
			tell application "Finder"
				set projectDir to (container of (file of projectDocument))
				set firstItemDir to (container of firstItem)
			end tell
			
			if (firstItemDir is equal to projectDir) then
				-- Use project file
				return projectDir as alias
			end if
		end if
		
		-- Project is either insta-project or external
		-- Use first item
		return firstItem
	end tell
end getProjectRoot


on run
	tell application "Finder"
		set supportRoot to (container of (container of (container of (path to me)))) as alias
	end tell
	
	set projectRoot to getProjectRoot()
	
	if projectRoot is not equal to missing value then
		-- Build ctags based on system language definitions
		do shell script ("cd " & (POSIX path of projectRoot) & "; /usr/local/bin/bbedit --maketags")
	end if
end run