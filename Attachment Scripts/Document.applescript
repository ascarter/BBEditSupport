on updateTags(doc)
	tell application "Finder"
		run script (((container of (container of (path to me))) as string) & "Scripts:Ctags:Update.scpt") as alias
	end tell
end updateTags

on runAttachmentScript(doc, scriptName)
	tell application "BBEdit"
		set sourceLanguage to the source language of doc
	
		tell application "Finder"
			set pkgScript to ((container of (container of (path to me))) as text) & "Packages:" & sourceLanguage & ".bbpackage:Contents:Attachment Scripts:" & scriptName		
			if not (exists file (pkgScript)) then
				return
			end if
		end tell
	
		set docPath to quoted form of POSIX path of ((file of doc) as string)
		set docLanguage to quoted form of (source language of doc as string)
		set envVars to "BB_DOC_PATH=" & docPath & " BB_DOC_LANGUAGE=" & docLanguage
		do shell script envVars & space & quoted form of POSIX path of pkgScript
	end tell
end runAttachmentScript

on documentDidSave(doc)
	tell application "BBEdit"
		if class of doc is not text document then
			return
		end if
	end tell
	updateTags(doc)
	runAttachmentScript(doc, "documentDidSave")
end documentDidSave
