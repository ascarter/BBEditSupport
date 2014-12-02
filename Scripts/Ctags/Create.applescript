-- Create ctags file for currently active project

on makeTags()
	tell application "Finder"
		set supportRoot to (container of (container of (container of (path to me)))) as alias
	end tell
	
	run script (((supportRoot as string) & "Scripts:Project Root.scpt") as alias)
	set projectRoot to result
	
	if projectRoot is not equal to missing value then
		-- Build ctags based on system language definitions
		do shell script ("cd " & (POSIX path of projectRoot) & "; /usr/local/bin/bbedit --maketags")
	end if
end makeTags

on run
	makeTags()
end run
