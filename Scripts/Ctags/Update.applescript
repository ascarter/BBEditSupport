-- Update ctags file for currently active project if it already exists

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
	set projectRoot to getProjectRoot()
	if projectRoot is missing value then
		return
	end if
	
	-- Check for existing tag file
	-- if it exists, rebuild it
	-- This allows a project to opt-in to tags by creating the tags file once
	tell application "Finder"
		if exists ((projectRoot as string) & "tags") then
			run script ((((container of (path to me)) as string) & "Scripts:Ctags:Create.scpt") as alias)
		end if
	end tell
end run