on loadPackage(theDocument)
	tell application "BBEdit"
		if class of theDocument is not text document then
			return null
		end if
		set sourceLanguage to the source language of theDocument
	end tell
	-- display alert sourceLanguage
	try
		tell application "Finder" to set bbSupportRoot to (container of (container of (path to me))) as alias
		set packageContents to ((bbSupportRoot as string) & "Packages:" & sourceLanguage & ".bbpackage:Contents") as alias
		set packageLib to ((packageContents as string) & "Resources:lib.scpt") as alias
		set thePackage to load script (packageLib)
		set packageRoot of thePackage to packageContents
		return thePackage
	on error
		return null
	end try
end loadPackage

on documentDidSave(theDocument)
	set thePackage to loadPackage(theDocument)
	if thePackage is not null then
		try
			tell thePackage to handleDocumentDidSave(theDocument)
		on error msg number err
			display alert msg & " (" & err & ")"
		end try
	end if
end documentDidSave
