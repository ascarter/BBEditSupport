property supportRoot : missing value

on getSupportRoot()
	if supportRoot is missing value then
		tell application "Finder" to set supportRoot to (container of (container of (path to me))) as alias
	end if
	return supportRoot
end getSupportRoot

on loadPackage(theDocument)
	tell application "BBEdit"
		if class of theDocument is not text document then
			return missing value
		end if
		set sourceLanguage to the source language of theDocument
	end tell
	
	try
		set pkgRoot to ((getSupportRoot() as string) & "Packages:" & sourceLanguage & ".bbpackage") as alias
		set pkgLib to ((pkgRoot as string) & "Contents:Resources:package.scpt") as alias
		set pkg to load script (pkgLib)
		set packageRoot of pkg to pkgRoot
		return pkg
	on error msg
		log "Error loadPackage: " & msg
		return missing value
	end try
end loadPackage

on updateTags(doc)
	run script (((getSupportRoot() as string) & "Scripts:Ctags:Update.scpt") as alias)
end updateTags

on documentWillSave(doc)
	set pkg to loadPackage(doc)
	if pkg is not missing value then
		try
			tell pkg to documentWillSave(doc)
		on error msg number err
			log "Error documentWillSave: " & msg & " (" & err & ")"
		end try
	end if
end documentWillSave

on documentDidSave(doc)
	updateTags(doc)
	
	set pkg to loadPackage(doc)
	if pkg is not missing value then
		try
			tell pkg to documentDidSave(doc)
		on error msg number err
			-- Can be missing handler but haven't found a way to
			-- test for it
			log "Error documentDidSave: " & msg & " (" & err & ")"
		end try
	end if
end documentDidSave
