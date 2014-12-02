-- Update ctags file for currently active project if it already exists

on makeTags()
	tell application "Finder"
		set supportRoot to (container of (container of (container of (path to me)))) as alias
	end tell
	
	run script (((supportRoot as string) & "Scripts:Project Root.scpt") as alias)
	set projectRoot to result
	
	if projectRoot is not equal to missing value then
		-- Check for existing tag file
		-- if it exists, rebuild it
		-- This allows a project to opt-in to tags by creating the tags file once
		tell application "Finder"
			if exists ((projectRoot as string) & "tags") then
				run script (((supportRoot as string) & "Scripts:Ctags:Create.scpt") as alias)
			end if
		end tell
	end if
end makeTags

on run
	makeTags()
end run
