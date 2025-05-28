set sourceFolder to (choose folder with prompt "选择源文件夹")
set destFolder to (choose folder with prompt "选择目标文件夹")

tell application "Finder"
	set subFolders to every folder of folder sourceFolder
	repeat with subFolder in subFolders
		set subFolderName to name of subFolder
		set destSubFolder to destFolder & subFolderName as text
		if not (exists folder destSubFolder) then
			make new folder at folder destFolder with properties {name:subFolderName}
		end if
		move (files of subFolder whose name extension is "jpg" or name extension is "png") to folder destSubFolder
	end repeat
end tell
