FSScoreBoard = FSScoreBoard or {}

if SERVER then
	AddCSLuaFile("fs_scoreboard/fs_scoreboard.lua")
	AddCSLuaFile("fs_scoreboard/fs_scoreboard_row.lua")
else
	include("fs_scoreboard/fs_scoreboard.lua")
end

timer.Create("FSScoreBoard.Init",2,1,function()
	function GAMEMODE:ScoreboardShow()
		FSScoreBoard:Show()
	end
	function GAMEMODE:ScoreboardHide()
		FSScoreBoard:Hide()
	end
end)