local db = {}
local debugInfo=0 --Set to 1 to print debug info to the console
local currentRankData=0	
local currentUsergroup=0
local currentUserID=0


		--Use of DBIt should save having to check for active DB
function connectDB()
	IGI.DB = DBit.StartConnection("igiranks", IGI.MySQL.Host, IGI.MySQL.Username, IGI.MySQL.Password, IGI.MySQL.Database, IGI.MySQL.Port, function()
		MsgN("Connected!")
		end)
end	



local callback = function(data, lastInsert)
	MsgN("Query complete!")
	if (#data > 0) then
		if data[1].active==1 then currentRankData=1
		else currentRankData=0
		end
	else currentRankData=0
	end
	setRank()
end

local failback = function(error)
	connectDB()
	MsgN("Error!")
	MsgN(error) -- the error of the query
end 
   
													
function rankCheck(ply,id,etc)
	--connectDB()
	MsgN("rankCheck Started")
	local myQuery = "SELECT active FROM fs_subscribers WHERE servercategory ='".."gmod_ttt".."' and".." ".."steamid".."='"..id.."'"
	MsgN("Starting query")	
			
	currentUsergroup=ply:GetUserGroup()
	currentUserID=id

	 IGI.DB:Query(myQuery, callback, failback, true) -- perform the query string 'myQuery',
													-- -- call 'callback' when done,
													-- -- call 'failback' in the event of an error,
													-- -- and the last argument 'true' means "please retry indefinitely if this query fails"



end

function setRank()
			MsgN("Set Rank Starting")
			MsgN(currentUsergroup)
			MsgN(currentRankData)
			
			if currentUsergroup=="user" and currentRankData==1 then
			RunConsoleCommand("ulx","adduserid", currentUserID, "subscriber")
			end
			if currentUsergroup=="moderator" and currentRankData==1 then
			RunConsoleCommand("ulx","adduserid", currentUserID, "moderatorsub")
			end
			if currentUsergroup=="trialmoderator" and currentRankData==1 then
			RunConsoleCommand("ulx","adduserid", currentUserID, "trialmodsub")
			end	
			if currentUsergroup=="subscriber" and currentRankData==0 then
			RunConsoleCommand("ulx","removeuserid",currentUserID)
			end
			if currentUsergroup=="subscriber" and currentRankData==nil then
			RunConsoleCommand("ulx","removeuserid",currentUserID)
			end
			if currentUsergroup=="moderatorsub" and currentRankData==0 then
			RunConsoleCommand("ulx","adduserid", currentUserID, "moderator")
			end
			if currentUsergroup=="moderatorsub" and currentRankData==nil then
			RunConsoleCommand("ulx","adduserid", currentUserID, "moderator")
			end
			if currentUsergroup=="trialmodsub" and currentRankData==0 then
			RunConsoleCommand("ulx","adduserid", currentUserID, "trialmoderator")
			end
			if currentUsergroup=="trialmodsub" and currentRankData==nil then
			RunConsoleCommand("ulx","adduserid", currentUserID, "trialmoderator")
			end
end
hook.Add("Initialize", "IgiDBConnect", connectDB)	
hook.Add("PlayerAuthed", "RankCheck", rankCheck)								
