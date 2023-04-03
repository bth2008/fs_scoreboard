--[[
Metrostroi SUI Scoreboard v3 by Alexell
---------------------------------------
Доп. модуль players_info.lua
---------------------------------------
Права на код определения местоположения игрока принадлежат: Agent Smith
Лицензия: GPU GPLv3
Репозиторий: https://github.com/Alexell/metrostroi_scoreboard
-------------------------------------------------------------
]]-- 
if SERVER then
	local train_list = {}
	train_list["gmod_subway_81-702"] 			= "81-702 (Д)"
	train_list["gmod_subway_81-703"] 			= "81-703 (E)"
	train_list["gmod_subway_81-502"] 			= "81-502 (Ема)"
	train_list["gmod_subway_81-502k"] 			= "81-502 (Ема Киев)"
	train_list["gmod_subway_ezh"] 				= "81-707 (Еж)"
	train_list["gmod_subway_ezh3"] 				= "81-710 (Еж3)"
	train_list["gmod_subway_ezh3ru1"] 			= "81-710 (Еж3РУ1)"
	train_list["gmod_subway_81-717_mvm"] 		= "81-717 (Номерной МСК)"
	train_list["gmod_subway_81-717_mvm_custom"] = "81-717 (Номерной МСК)"
	train_list["gmod_subway_81-717_lvz"] 		= "81-717 (Номерной СПБ)"
	train_list["gmod_subway_81-717_6"] 			= "81-717.6 (Номерной МСК)"
	train_list["gmod_subway_81-718"] 			= "81-718 (ТИСУ)"
	train_list["gmod_subway_81-720"] 			= "81-720 (Яуза)"
	train_list["gmod_subway_81-720_1"] 			= "81-720.1 (Яуза)"
	train_list["gmod_subway_81-722"] 			= "81-722 (Юбилейный)"
	train_list["gmod_subway_81-722_new"] 		= "81-722 (Юбилейный с новыми системами)"
	train_list["gmod_subway_81-722_1"] 			= "81-722.1 (Юбилейный)"
	train_list["gmod_subway_81-722_3"] 			= "81-722.3 (Юбилейный)"
	train_list["gmod_subway_81-740_4"] 			= "81-740.4 (Русич)"
	train_list["gmod_subway_81-760"] 			= "81-760 (Ока)"
	train_list["gmod_subway_81-760a"] 			= "81-760 (Баклажан)"
	train_list["gmod_subway_81-540_2_lvz"] 		= "81-540.2 (Пришелец)" 
	train_list["gmod_subway_81-540_2k"] 		= "81-540.2К (Пришелец)"
	train_list["gmod_subway_81-540_8"] 			= "81-540.8 (Саблезуб)"
	train_list["gmod_subway_em508"] 			= "81-508 (Ем-508)"
	train_list["gmod_subway_81-717_kkl"] 		= "81-717 (Номерной ККЛ)"
	train_list["gmod_subway_81-717_5a"] 		= "81-717.5А (Номерной Ретро)"
	train_list["gmod_subway_81-717_5a_custom"] 	= "81-717.5А (Номерной Ретро)"
	train_list["gmod_subway_81-717_5k"] 		= "81-717.5К (Номерной К)"
	train_list["gmod_subway_81-717_5m"] 		= "81-717.5М (Номерной М)"
	train_list["gmod_subway_81-7175p"] 			= "81-717.5П (Номерной Аквариум)"
	train_list["gmod_subway_81-717_mvm_g"] 		= "81-717 (Грузовой)"

	
	--"gmod_subway_81-702","gmod_subway_81-703","gmod_subway_81-502","gmod_subway_81-703","gmod_subway_ezh","gmod_subway_ezh3","gmod_subway_ezh3ru1","gmod_subway_81-717_mvm","gmod_subway_81-717_mvm_custom","gmod_subway_81-717_lvz","gmod_subway_81-717_6","gmod_subway_81-718","gmod_subway_81-720","gmod_subway_81-722","gmod_subway_81-760","gmod_subway_81-760a","gmod_subway_81-720","gmod_subway_81-540_2","gmod_subway_em508","gmod_subway_81-717_kkl","gmod_subway_81-717_5k","gmod_subway_81-7175p"

	-- Получение названия состава:
	local function GetTrainName(class)
		local train_name = ""
		for k, v in pairs (train_list) do
			if (class == k) then
				train_name = v
				break
			end
		end
		return train_name
	end
	
	-- Получение Entity состава
	local function GetTrain(ply)
		if (not IsValid(ply)) then return end
		local seat = ply:GetVehicle()
		if IsValid(seat) then
			return seat:GetNW2Entity("TrainEntity")
		end
	end

	-- Получение местоположения:
	local function GetPlayerLoc(ply)
		local player_station = ""
		local map_pos
		local station_pos
		local station_posx
		local station_posy
		local station_posz
		local player_pos
		local player_posx
		local player_posy
		local player_posz
		local get_pos1
		local get_pos2
		local radius = 4000 -- Радиус по умолчанию для станций на всех картах
		local cur_map = game.GetMap()
		local Sz
		local S
		
		player_pos = tostring(ply:GetPos())
		get_pos1 = string.find(player_pos, " ")
		player_posx = string.sub(player_pos,1,get_pos1)
		player_posx = tonumber(player_posx)	
		
		get_pos2 = string.find(player_pos, " ", get_pos1 + 1)
		player_posy = string.sub(player_pos,get_pos1,get_pos2)
		player_posy = tonumber(player_posy)
		
		player_posz = string.sub(player_pos,get_pos2 + 1)
		player_posz = tonumber(player_posz)	

		for k, v in pairs(Metrostroi.StationConfigurations) do
			map_pos = v.positions and v.positions[1]
			if map_pos and map_pos[1] then
				station_pos = tostring(map_pos[1])
				get_pos1 = string.find(station_pos, " ")
				station_posx = string.sub(station_pos,1,get_pos1)
				station_posx = tonumber(station_posx)
				
				get_pos2 = string.find(station_pos, " ", get_pos1 + 1)
				station_posy = string.sub(station_pos,get_pos1,get_pos2)
				station_posy = tonumber(station_posy)
				
				station_posz = string.sub(station_pos,get_pos2 + 1)
				station_posz = tonumber(station_posz)
				
				if (cur_map:find("gm_metro_jar_imagine_line"))  then
					if (v.names[1] == "ДДЭ" or v.names[1] == "Диспетчерская") then continue end
				end

				if ((station_posz > 0 and player_posz > 0) or (station_posz < 0 and player_posz < 0)) then -- оба Z больше нуля или меньше нуля
					Sz = math.max(math.abs(station_posz),math.abs(player_posz)) - math.min(math.abs(station_posz),math.abs(player_posz))
				end
				if ((station_posz < 0 and player_posz > 0) or (station_posz > 0 and player_posz < 0)) then -- один Z больше нуля или меньше нуля
					Sz = math.abs(player_posz) + math.abs(station_posz)
				end
				S = math.sqrt(math.pow((station_posx - player_posx), 2) + math.pow((station_posy - player_posy), 2))
			
				-- Поиск ближайшей точки в StationConfigurations с уменьшением радиуса:
				if (S < radius and Sz < 200)
				then 
					player_station = (v.names[1])
					radius = S
				end
			end
		end
		if (player_station=="") then player_station = "перегон" end
		return player_station
	end

	local function GetStationName(st_id,name_num)
		if Metrostroi.StationConfigurations[st_id] then
			if Metrostroi.StationConfigurations[st_id].names[name_num] then
				return Metrostroi.StationConfigurations[st_id].names[name_num]
			else
				return Metrostroi.StationConfigurations[st_id].names[1]
			end
		else
			return ""
		end
	end

	local function BuildStationInfo(train)
		local prev_st = ""
		local cur_st = ""
		local next_st = ""
		local line = 0
		local line_str = ""
		local station_str = ""
		local name_num = 1
		cur_st = GetStationName(train:ReadCell(49160),name_num)
		if cur_st ~= "" then
			line = train:ReadCell(49168)
			station_str = cur_st
		else
			prev_st = GetStationName(train:ReadCell(49162),name_num)
			next_st = GetStationName(train:ReadCell(49161),name_num)
			if (prev_st ~= "" and next_st ~= "") then
				line = train:ReadCell(49167)
				station_str = prev_st.." - "..next_st
			else
				station_str = GetPlayerLoc(train.Owner)
			end
		end
		if line ~= 0 then
			if game.GetMap() == "gm_mustox_neocrimson_line_a" then
				--На неомалине перепутаны номера путей
				line = line - 1
				if line == 0 then line = 2 end
			end
			line_str = "["..line.." путь] "
		end
		return line_str..station_str
	end


	-- при спавне состава (точнее при сцепке)
	hook.Add("MetrostroiCoupled","AddTrainInfo",function(ent,ent2)
		if IsValid(ent) then
			for k, v in pairs(train_list) do
				if ent:GetClass() == k then
					local train = ent:GetClass()
					local ply = ent.Owner
					
					if !IsValid(ply) or ply:GetNW2String("TrainClass","") != "" then return end
					ply:SetNW2String("TrainClass",train)
					ply:SetNW2String("TrainName",GetTrainName(train))
					ply:SetNW2String("RouteNumber","-")
				end
			end
		end
	end)
	
	-- при удалении состава
	hook.Add("EntityRemoved","DeleteTrainInfo",function (ent)
		for k, v in pairs(train_list) do
			if ent:GetClass() == k then
				local ply = ent.Owner
				if not IsValid(ply) then return end
				ply:SetNW2String("TrainClass","")
				ply:SetNW2String("TrainName","-")
				ply:SetNW2String("RouteNumber","-")
			end
		end
	end)
	-- Обновление номеров маршрутов
	timer.Create("UpdatePlayerRoutes",2,0, function()
		for k, v in pairs(train_list) do
			local trains = ents.FindByClass(k)
			if (trains) then
				for k2,v2 in pairs(trains) do
					local ply = v2.Owner
					if not IsValid(ply) then return end
					if (v2:GetNW2String("RouteNumber") != "") then
						ply:SetNW2String("RouteNumber",v2:GetNW2String("RouteNumber"))
					end
					ply = nil
				end
			end
		end
	end)
	
	-- Обновление информации игроков
	local PlayerList = {}
	timer.Create("UpdatePlayersInfo",3,0, function()
		PlayerList = player.GetAll()
		for k, v in pairs(PlayerList) do
			local train = GetTrain(v)
			--v:SetNW2String("PlayerLocation",GetPlayerLoc(v))
			if(IsValid(train)) then
				v:SetNW2String("PlayerLocation",BuildStationInfo(train))
			else
				v:SetNW2String("PlayerLocation",GetPlayerLoc(v))
			end
			if (IsValid(train) and train.DriverSeat == v:GetVehicle()) then
				v:SetNW2Bool("PlayerDriving",true)
			else
				v:SetNW2Bool("PlayerDriving",false)
			end
			train = nil
		end
	end)
	
	-- проверка на повторяющиеся номера маршрутов
	local PlayerList2 = {}
	local CurNick = ""
	local RouteNums = {}
	local rnum
	local tr_class = ""
	timer.Create("CheckRoutesUniq",60,0, function()
		PlayerList2 = player.GetAll()
		for k, v in pairs(PlayerList2) do
			rnum = v:GetNW2String("RouteNumber","-")
			tr_class = v:GetNW2String("TrainClass","")
			if (rnum ~= "-") then
				rnum = tonumber(rnum)
				if table.HasValue({"gmod_subway_81-702","gmod_subway_81-703","gmod_subway_81-502","gmod_subway_81-703","gmod_subway_ezh","gmod_subway_ezh3","gmod_subway_ezh3ru1","gmod_subway_81-717_mvm","gmod_subway_81-717_mvm_custom","gmod_subway_81-717_lvz","gmod_subway_81-717_6","gmod_subway_81-718","gmod_subway_81-720","gmod_subway_81-722","gmod_subway_81-760","gmod_subway_81-760a","gmod_subway_81-720","gmod_subway_81-540_2","gmod_subway_em508","gmod_subway_81-717_kkl","gmod_subway_81-717_5k","gmod_subway_81-7175p"},tr_class) then rnum = rnum / 10 end
			end
			if (isnumber(rnum)) then
				RouteNums[v:Nick()] = rnum
			end
		end
		for k, v in pairs(RouteNums) do
			for k2,v2 in pairs(RouteNums) do
				if (v == v2 and k != k2 and k2 != CurNick) then
					ULib.tsayColor(nil,false,Color(255, 0, 0), "Внимание! Игроки "..k.." и "..k2.." имеют одинаковые номера маршрутов!")
					CurNick = k
				end
			end
		end
		CurNick = ""
		rnum = ""
		RouteNums = {}
		PlayerList2 = {}
	end)
	
	-- невидимость для админов
	util.AddNetworkString("HandleInvisibility")
	util.AddNetworkString("JoinLeaveMessages")
	net.Receive( "HandleInvisibility", function(len, ply)
	    local is_invis = ply:GetNW2Bool("is_invisible", false)
		if(is_invis) then
			ulx.fancyLogAdmin(ply, true, "#A вернул своё отображение в TAB")	
			--набор фейковых сообщений о подключении
			hook.Run("player_connect", {bot=0,networkid=ply:SteamID(),name=ply:Nick(),userid=ply:UserID(),index=ply:EntIndex(),address=ply:IPAddress()})
			timer.Simple(10, function()
					hook.Run("PlayerInitialSpawnFake",ply)
				    timer.Simple(10, function()
					    hook.Run("PlayerLoaded",ply)
						ply:SetNW2Bool("is_invisible", false)
				    end)
			end)
		else
			ulx.fancyLogAdmin(ply, true, "#A скрыл своё отображение в TAB")	
			-- фейковое сообщение о выходе
			hook.Run("player_disconnect", {bot=0,networkid=ply:SteamID(),name=ply:Nick(),userid=ply:UserID(),index=ply:EntIndex(), reason="Disconnected by user"})
			ply:SetNW2Bool("is_invisible", true)
			ulx.cloak( ply, {ply}, 255, false )
		end
	end )
end