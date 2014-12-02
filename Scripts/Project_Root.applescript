on projectRoot()
	set theFile to missing value
	
	tell application "BBEdit"
		set activeWindow to front window
		
		if (class of activeWindow is project window) then
			set projectDocument to project document of activeWindow
			
			if ((count of items of projectDocument) > 0) then
				set firstFileItem to item 1 of projectDocument as alias
			else
				set firstFileItem to file of document of activeWindow as alias
			end if
			
			if (on disk of projectDocument) then
				set theProjectFile to file of projectDocument as alias
				
				tell application "Finder"
					set theProjectDir to container of theProjectFile
					set firstFileDir to container of firstFileItem
				end tell
				
				if (firstFileDir is equal to theProjectDir) then
					-- Use project file
					set theFile to theProjectDir as alias
				else
					-- External project file -> use first item to set context
					set theFile to firstFileItem
				end if
			else
				-- BBEdit doesn't provide direct access to the Instaproject root
				-- Use the first node from the project list
				set theFile to firstFileItem
			end if
		end if
	end tell
	return theFile
end projectRoot

on run
	return projectRoot()
end run