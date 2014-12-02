on loadPackage(theDocument)
	tell application "BBEdit"
		if class of theDocument is not text document then
			return missing value
		end if
		set sourceLanguage to the source language of theDocument
	end tell

	try
		tell application "Finder" to set bbSupportRoot to (container of (container of (path to me))) as alias
		set pkgRoot to ((bbSupportRoot as string) & "Packages:" & sourceLanguage & ".bbpackage") as alias
		set pkgLib to ((pkgRoot as string) & "Contents:Resources:package.scpt") as alias
		set pkg to load script (pkgLib)
		set packageRoot of pkg to pkgRoot
		return pkg
	on error msg
		log "Error loadPackage: " & msg
		return missing value
	end try
end loadPackage

on documentDidSave(doc)
	set pkg to loadPackage(doc)
	if pkg is not missing value then
		try
			tell pkg to handleDocumentDidSave(doc)
		on error msg number err
			log "Error documentDidSave: " & msg & " (" & err & ")"
		end try
	end if
end documentDidSave
