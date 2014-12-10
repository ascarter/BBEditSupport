property supportRoot : missing value

on getSupportRoot()
	if supportRoot is missing value then
		tell application "Finder" to set supportRoot to (container of (container of (path to me))) as alias
	end if
	return supportRoot
end getSupportRoot

on echoContents(doc)
	tell application "BBEdit"
		set prevDelimiter to AppleScript's text item delimiters
		set AppleScript's text item delimiters to {ASCII character 10}
		set output to (lines of text of doc) as string
		set AppleScript's text item delimiters to prevDelimiter
		return "echo " & quoted form of output
	end tell
end echoContents

on replaceContents(doc, output)
	tell application "BBEdit"
		set currSel to selection of window of doc
		set contents of doc to output
		select insertion point before currSel
	end tell
end replaceContents

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
	on error msg
		log "Script not found: " & msg
		return missing value
	end try
	
	set envVars to "BB_DOC_PATH=" & docPath & " BB_DOC_LANGUAGE=" & docLanguage
	return do shell script echoContents(doc) & " | " & envVars & space & quoted form of POSIX path of pkgScript
end runAttachmentScript

on documentWillSave(doc)
	try
		set output to runAttachmentScript(doc, "documentWillSave")
		if output is not missing value and length of output > 0 then
			replaceContents(doc, output)
		end if
	on error msg
		log msg
	end try
	
end documentWillSave

on documentDidSave(doc)
	try
		updateTags(doc)
		runAttachmentScript(doc, "documentDidSave")
	on error msg
		log msg
	end try
end documentDidSave

(*
on run
	tell application "BBEdit" to set doc to active document of window 1
	documentWillSave(doc)
	documentDidSave(doc)
end run
*)
