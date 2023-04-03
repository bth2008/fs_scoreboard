local PlayerRow = {}

local SCREEN_COEFFICIENT = ScrW()/1920;
if SCREEN_COEFFICIENT > 1 then SCREEN_COEFFICIENT = 1 end

local function FixedRoute(class,route)
    local result = "-"
    if (class ~= "-" and route ~= "-") then
        local rnum = tonumber(route)
        if table.HasValue({"gmod_subway_81-702","gmod_subway_81-703","gmod_subway_ezh","gmod_subway_ezh3","gmod_subway_ezh3ru1","gmod_subway_81-717_mvm","gmod_subway_81-718","gmod_subway_81-720","gmod_subway_81-720_1"},class) then rnum = rnum / 10 end
        result = rnum
    end
    return result
end

function PlayerRow:Init()
    self.AvatarBTN = vgui.Create("DButton",self)
    self.AvatarBTN.DoClick = function() self.Player:ShowProfile() end
    self.AvatarIMG = vgui.Create("AvatarImage",self.AvatarBTN)
    self.AvatarIMG:SetMouseInputEnabled(false)
    self.Nick = vgui.Create("DLabel",self)
    self.Team = vgui.Create("DLabel",self)
    self.Route = vgui.Create("DLabel",self)
    self.Train = vgui.Create("DLabel",self)
    self.Station = vgui.Create("DLabel",self)
    self.Pax = vgui.Create("DLabel",self)
    self.Ping = vgui.Create("DLabel",self)
    self.Karma = vgui.Create("DLabel",self)
    self.MuteButton = vgui.Create("DImageButton", self)
    self.AddKarmaBtn = vgui.Create("DImageButton", self)
    self.RemoveKarmaBtn = vgui.Create("DImageButton", self)
end

function PlayerRow:Paint(w,h)
    if not IsValid(self.Player) then
        self:Remove()
        FSScoreBoard.Panel:InvalidateLayout()
        return
    end
    local color = Color(100,100,100,255)
    if IsValid(self.Player) then
        color = team.GetColor(self.Player:Team())
    end
    draw.RoundedBox(0,5*SCREEN_COEFFICIENT,5*SCREEN_COEFFICIENT,self:GetWide()-80,50*SCREEN_COEFFICIENT,Color(0,0,0,180))
    draw.RoundedBox(0,5*SCREEN_COEFFICIENT,5*SCREEN_COEFFICIENT,self:GetWide()-80,50*SCREEN_COEFFICIENT,Color(color.r,color.g,color.b,30))
    surface.SetDrawColor(255,255,255,150)
    surface.DrawOutlinedRect(5*SCREEN_COEFFICIENT,5*SCREEN_COEFFICIENT,self:GetWide()-80,45*SCREEN_COEFFICIENT,1)
end

function PlayerRow:PerformLayout()
    self.AvatarBTN:SetPos(6*SCREEN_COEFFICIENT,6*SCREEN_COEFFICIENT)
    self.AvatarBTN:SetSize(43*SCREEN_COEFFICIENT,43*SCREEN_COEFFICIENT)
    self.AvatarIMG:SetSize(43*SCREEN_COEFFICIENT,43*SCREEN_COEFFICIENT)

    self.Nick:SetPos(60*SCREEN_COEFFICIENT,20*SCREEN_COEFFICIENT)
    self.Team:SetPos(250*SCREEN_COEFFICIENT,20*SCREEN_COEFFICIENT)
    self.Route:SetPos(400*SCREEN_COEFFICIENT,20*SCREEN_COEFFICIENT)
    self.Station:SetPos(500*SCREEN_COEFFICIENT,20*SCREEN_COEFFICIENT)
    self.Train:SetPos(800*SCREEN_COEFFICIENT,20*SCREEN_COEFFICIENT)
    self.Pax:SetPos(1100*SCREEN_COEFFICIENT, 20*SCREEN_COEFFICIENT)
    self.Ping:SetPos(1150*SCREEN_COEFFICIENT, 20*SCREEN_COEFFICIENT)
    self.Karma:SetPos(1200*SCREEN_COEFFICIENT, 20*SCREEN_COEFFICIENT)
    self.MuteButton:SetPos(1280*SCREEN_COEFFICIENT, 13*SCREEN_COEFFICIENT)
    self.AddKarmaBtn:SetPos(1240*SCREEN_COEFFICIENT, 20*SCREEN_COEFFICIENT)
    self.RemoveKarmaBtn:SetPos(1260*SCREEN_COEFFICIENT, 20*SCREEN_COEFFICIENT)
    self.Nick:SizeToContents()
    self.Team:SizeToContents()
    self.Route:SizeToContents()
    self.Station:SizeToContents()
    self.Train:SizeToContents()
    self.Pax:SizeToContents()
    self.Ping:SizeToContents()
    self.Karma:SizeToContents()
    self.MuteButton:SetSize(32*SCREEN_COEFFICIENT,32*SCREEN_COEFFICIENT)
    self.AddKarmaBtn:SetSize(16*SCREEN_COEFFICIENT,16*SCREEN_COEFFICIENT)
    self.RemoveKarmaBtn:SetSize(16*SCREEN_COEFFICIENT,16*SCREEN_COEFFICIENT)
    self.Nick:SetMouseInputEnabled(true)
    self.Nick:SetCursor("hand")
end

function PlayerRow:ApplySchemeSettings()
    self.Nick:SetFont("fsscoreboardmain")
    self.Team:SetFont("fsscoreboardmain")
    self.Route:SetFont("fsscoreboardmain")
    self.Station:SetFont("fsscoreboardmain")
    self.Train:SetFont("fsscoreboardmain")
    self.Pax:SetFont("fsscoreboardmain")
    self.Ping:SetFont("fsscoreboardmain")
    self.Karma:SetFont("fsscoreboardmain")
end

function PlayerRow:UpdatePlayerData()
    local ply = self.Player
    if not IsValid(ply) then return end
    self.Nick:SetText(ply:Nick())
    self.Team:SetText(team.GetName(ply:Team()))
    self.Team:SetTextColor()--team.GetColor(ply:Team()))
    self.Route:SetText(FixedRoute(ply:GetNW2String("TrainClass"),ply:GetNW2String("RouteNumber","-")))
    self.Station:SetText(ply:GetNW2String("PlayerLocation"))
    self.Train:SetText(ply:GetNW2String("TrainName"," -"))
    self.Pax:SetText(ply:Frags())
    self.Ping:SetText(ply:Ping())
    self.Karma:SetText(ply:GetNWString("player_rating"))
    self.AddKarmaBtn:SetImage("icon16/thumb_up.png")
    self.RemoveKarmaBtn:SetImage("icon16/thumb_down.png")
    if(ply:IsMuted()) then
        self.MuteButton:SetImage("icon32/muted.png")
    else
        self.MuteButton:SetImage("icon32/unmuted.png")
    end
    self.MuteButton.DoClick = function()
        ply:SetMuted(not ply:IsMuted())
    end
    self.AddKarmaBtn.DoClick = function()
        net.Start("FS_Karma_Change_Intent")
        net.WriteEntity(LocalPlayer())
        net.WriteEntity(ply)
        net.WriteBool(true)
        net.SendToServer()
    end
    self.RemoveKarmaBtn.DoClick = function()
        net.Start("FS_Karma_Change_Intent")
        net.WriteEntity(LocalPlayer())
        net.WriteEntity(ply)
        net.WriteBool(false)
        net.SendToServer()
    end
    function self.Nick:DoClick()
        if ply:SteamID() == LocalPlayer():SteamID() then return end
        RunConsoleCommand("ulx","goto",ply:Nick())
    end
    if(ply:GetNW2Bool("is_invisible", false)) then
        self:Remove()
    end
end

function PlayerRow:SetPlayer(ply)
    self.Player = ply
    self:UpdatePlayerData()
    self.AvatarIMG:SetPlayer(ply)
end

function PlayerRow:Think()
    if not self.PlayerUpdate or self.PlayerUpdate < CurTime() then
        self.PlayerUpdate = CurTime() + 1
        self:UpdatePlayerData()
    end
end

vgui.Register("fsplayerrow",PlayerRow,"DPanel")
