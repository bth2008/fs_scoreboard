require("mysqloo")

local DATABASE_HOST = ""
local DATABASE_PORT = 3306
local DATABASE_NAME = ""
local DATABASE_USERNAME = ""
local DATABASE_PASSWORD = ""

local db = mysqloo.connect(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)

util.AddNetworkString("FS_Karma_Change_Intent")

function db:onConnected()
    local q = self:query("SET names 'utf8'")
    q:start()
end
db:connect()
hook.Add("PlayerInitialSpawn","PlayerKarmaInit", function(ply)
    db:ping()
    local q = db:prepare("SELECT total_rating FROM user_rating WHERE STEAM_ID=?")
    q:setString(1, ply:SteamID())
    function q:onSuccess(data)
        if #data < 1 then
            local ins_query = db:prepare("INSERT INTO `user_rating`(STEAM_ID, total_rating) VALUES(?,?)")
            ins_query:setString(1, ply:SteamID())
            ins_query:setNumber(2, 100)
            ins_query:start()
            ply:SetNWString("player_rating",100)
        else
            ply:SetNWString("player_rating", data[1]["total_rating"])
        end
    end
    q:start()
end)

function AddKarma(sender, receiver)
    local new_karma = math.floor(math.sqrt(tonumber(sender:GetNWString("player_rating"))))
    ChangeKarma(sender, receiver, new_karma)
end
function RemoveKarma(sender, receiver)
    local new_karma = -math.floor(math.sqrt(tonumber(sender:GetNWString("player_rating"))))
    ChangeKarma(sender, receiver, new_karma)
end

function ChangeKarma(sender, receiver, new_karma)
    if sender == receiver then
        sender:ChatPrint("Вы не можете изменять рейтинг себе")
        return
    end
    db:ping()
    local q = db:prepare("INSERT INTO rating_actions(from_user_steam_id, to_user_steam_id, amount, date_time) VALUES(?,?,?,NOW())")
    q:setString(1, sender:SteamID())
    q:setString(2, receiver:SteamID())
    q:setNumber(3, new_karma)
    function q:onSuccess()
        q2 = db:prepare("UPDATE user_rating SET total_rating = total_rating + ? WHERE STEAM_ID=?")
        q2:setNumber(1, new_karma)
        q2:setString(2, receiver:SteamID())
        function q2:onSuccess()
            receiver:SetNWString("player_rating", tonumber(receiver:GetNWString("player_rating")) + new_karma)
            sender:ChatPrint("Вы изменили рейтинг "..receiver:Nick().." на "..new_karma.." пунктов")
            receiver:ChatPrint(sender:Nick().." изменил ваш рейтинг на "..new_karma.." пунктов")
        end
        function q2:onError(err)
            sender:ChatPrint(err)
        end
        q2:start()
    end
    q:start()
end

function HandleChangeKarma(sender, receiver, callback)
    db:ping()
    local q = db:prepare("SELECT 1 FROM rating_actions WHERE from_user_steam_id = ? AND to_user_steam_id = ? AND date_time > NOW() - INTERVAL 1 DAY")
    q:setString(1, sender:SteamID())
    q:setString(2, receiver:SteamID())
    function q:onSuccess(data)
        if #data > 0 then
            sender:ChatPrint("Вы уже меняли рейтинг этого пользователя сегодня.")
            sender:ChatPrint("Следующее изменение возможно через 24 часа!")
        else
            callback(sender, receiver)
        end
    end
    function q:onError(err) print(err) end
    q:start()
end

net.Receive("FS_Karma_Change_Intent", function(len)
    local sender = net.ReadEntity()
    local receiver = net.ReadEntity()
    local direction = net.ReadBool()
    if direction then
        HandleChangeKarma(sender, receiver, AddKarma)
    else
        HandleChangeKarma(sender, receiver, RemoveKarma)
    end
end)