property supportRoot : missing value

on getSupportRoot()
	if supportRoot is missing value then
		tell application "Finder" to set supportRoot to (container of (container of (path to me))) as alias
	end if
	return supportRoot
end getSupportRoot

on parseResults(results)
	set prevDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {","}
	set output to paragraphs of results as string
	set AppleScript's text item delimiters to prevDelimiter
	return output
end parseResults

on updateTags(doc)
	try
		run script (((getSupportRoot() as string) & "Scripts:Ctags:Update.scpt") as alias)
	on error msg
		log "Error running ctags: " & msg
	end try
end updateTags

on runAttachmentScript(doc, scriptName)
	tell application "BBEdit"
		if class of doc is not text document then
			return
		end if
		set sourceLanguage to the source language of doc
	end tell
	
	try
		set pkgScript to ((getSupportRoot() as string) & "Packages:" & sourceLanguage & ".bbpackage:Contents:Attachment Scripts:" & scriptName) as alias
		tell application "BBEdit"
			set docPath to quoted form of POSIX path of ((file of doc) as string)
			set docLanguage to quoted form of (source language of doc as string)
		end tell
		
		set envVars to "BB_DOC_PATH=" & docPath & " BB_DOC_LANGUAGE=" & docLanguage
		set results to do shell script envVars & space & quoted form of POSIX path of pkgScript
		if length of results > 0 then
			run script "make new results browser with data {" & parseResults(results) & "} with properties {name:\"Save\"}"
		end if
	on error msg
		log msg
	end try
end runAttachmentScript

on documentWillSave(doc)
	runAttachmentScript(doc, "documentWillSave")
end documentWillSave

on documentDidSave(doc)
	updateTags(doc)
	runAttachmentScript(doc, "documentDidSave")
end documentDidSave

(*
on run
	tell application "BBEdit" to set doc to active document of window 1
	documentWillSave(doc)
	documentDidSave(doc)
end run
*)
