
-- Global variables
lastSwap1 = "none";
lastSwap2 = "none";

-- Main
SlashCmdList["MRSCOMMAND"] = function(msg)
	local commands = mrs_SplitString(msg)
	commands[1] = string.lower(commands[1])
	if commands[1] == "swap" then
		local player1Name = string.lower(commands[2]);
		local player2Name = string.lower(commands[3]);
		mrs_Swap(player1Name, player2Name)
		lastSwap1 = player1Name;
		lastSwap2 = player2Name;
	end
	if commands[1] == "swapback" then
		mrs_Swap(lastSwap1, lastSwap2)
	end
	if commands[1] == "swapbackafterbl" then
		if mrs_HasBuff(lastSwap1, "Bloodlust") then
			mrs_Swap(lastSwap1, lastSwap2)
		end
	end
end 
SLASH_MRSCOMMAND1 = "/mrs";

function mrs_Swap(player1Name, player2Name)
	local player1Index, player1SubGroup = mrs_GetRaidIndexAndSubGroupForUnitName(player1Name);
	local player2Index, player2SubGroup = mrs_GetRaidIndexAndSubGroupForUnitName(player2Name);
	SetRaidSubgroup(player1Index, 8);
	SetRaidSubgroup(player2Index, player1SubGroup);
	SetRaidSubgroup(player1Index, player2SubGroup);
end

function mrs_HasBuff(playerName, buff)
	local playerIndex = mrs_GetRaidIndexAndSubGroupForUnitName(playerName);
	for i = 1, 32 do
		local d = UnitBuff("raid" .. playerIndex, i);
		if d and d == buff then
			return true;
		end
	end
	return false;
end

function mrs_GetRaidIndexAndSubGroupForUnitName(playerName)
	local numberOfRaidMembers = GetNumRaidMembers();
	for i = 1, numberOfRaidMembers do
		local name, _, subGroup = GetRaidRosterInfo(i);
		if string.lower(name) == playerName then
			return i, subGroup;
		end
	end
end

function mrs_SplitString(s)
	t = { };
	index = 1;
	for value in string.gmatch(s, "%S+") do 
		t[index] = value;
		index = index + 1;
	end
	return t;
end




