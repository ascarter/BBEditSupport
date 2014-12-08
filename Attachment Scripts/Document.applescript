property supportRoot : missing value

on getSupportRoot()
	if supportRoot is missing value then
		tell application "Finder" to set supportRoot to (container of (container of (path to me))) as alias
	end if
	return supportRoot
end getSupportRoot

on getPackageRoot(theDocument)
	tell application "BBEdit"
		if class of theDocument is not text document then
			return missing value
		end if
		set sourceLanguage to the source language of theDocument
	end tell
	
	try
		return ((getSupportRoot() as string) & "Packages:" & sourceLanguage & ".bbpackage") as alias
	on error msg
		log (sourceLanguage as string) & " package not installed"
		return missing value
	end try
end getPackageRoot

on getAttachmentScript(theDocument, scriptName)
	set pkgRoot to getPackageRoot(theDocument)
	if pkgRoot is missing value then
		return missing value
	end if
	try
		return ((pkgRoot as string) & "Contents:Attachment Scripts:" & scriptName) as alias
	on error
		log "Script " & scriptName & " not found"
		return missing value
	end try
end getAttachmentScript

on updateTags(doc)
	try
		run script (((getSupportRoot() as string) & "Scripts:Ctags:Update.scpt") as alias)
	on error msg
		log "Error running ctags: " & msg
	end try
end updateTags

on runAttachmentScript(doc, scriptName)
	try
		set pkgScript to getAttachmentScript(doc, scriptName)
		if pkgScript is missing value then
			return
		end if
		tell application "BBEdit"
			set docPath to quoted form of POSIX path of ((file of doc) as string)
			set docLanguage to quoted form of (source language of doc as string)
		end tell
		set envVars to "BB_DOC_PATH=" & docPath & " BB_DOC_LANGUAGE=" & docLanguage
		do shell script envVars & space & quoted form of POSIX path of pkgScript
	on error msg
		log "Error running script " & scriptName & ": " & msg
	end try
end runAttachmentScript

on documentWillSave(doc)
  return
	runAttachmentScript(doc, "documentWillSave")
end documentWillSave

on documentDidSave(doc)
  return
	updateTags(doc)
	runAttachmentScript(doc, "documentDidSave")
end documentDidSave

(*
on run
	tell application "BBEdit" to set doc to active document of window 1
	--documentWillSave(doc)
	documentDidSave(doc)
end run
*)
