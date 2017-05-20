function CoreLoot.ListUtils:AddNewListItem(listKeyString, listStateKeyString, itemID, itemName)
	local itemIDString = tostring(itemID)
	if CoreLoot.db[listKeyString][itemIDString] == nil then
		CoreLoot.db[listKeyString][itemIDString] = itemName
		CoreLoot.db[listStateKeyString][itemIDString] = true
	end
end

function CoreLoot.ListUtils:RemoveListItem(listKeyString, listStateKeyString, itemID)
	local itemIDString = tostring(itemID)
	if CoreLoot.db[listKeyString][itemIDString] ~= nil then
		CoreLoot.db[listKeyString][itemIDString] = nil
		CoreLoot.db[listStateKeyString][itemIDString] = nil
	end
end

function CoreLoot.ListUtils:HandlePickupItem(bag, slot)
	if slot == nil then return nil end
	if CoreLoot.MFrame == nil then return nil end
	if not CoreLoot.MFrame:IsVisible() then return nil end
	
	_type, itemID, subtype, subdata = GetCursorInfo()
	
	if _type ~= "item" then return nil end

	name, link, quality, iLevel, reqLevel, class, subclass, _, vendorPrice = GetItemInfo(itemID)

	local listStr = ""
	local listStateStr = ""
	local itemIdStr = tostring(itemID)
	if CoreLoot.ListUtils.AddWhitelist then
		-- Nothing to add check
		if not CoreLoot.ListUtils.Invert and CoreLoot.db.WhitelistState[itemIdStr] ~= nil then
			return nil
		-- Nothing to remove check
		elseif CoreLoot.ListUtils.Invert and CoreLoot.db.WhitelistState[itemIdStr] == nil then 
			return nil
		end

		listStr = "Whitelist"
		listStateStr = "WhitelistState"
	end

	if CoreLoot.ListUtils.AddBlacklist then
		-- Nothing to add check
		if not CoreLoot.ListUtils.Invert and CoreLoot.db.BlacklistState[itemIdStr] ~= nil then
			return nil
		-- Nothing to remove check
		elseif CoreLoot.ListUtils.Invert and CoreLoot.db.BlacklistState[itemIdStr] == nil then 
			return nil
		end

		listStr = "Blacklist"
		listStateStr = "BlacklistState"
	end

	if CoreLoot.ListUtils.AddAutosell then
		-- Nothing to add check
		if not CoreLoot.ListUtils.Invert and CoreLoot.db.AutosellState[itemIdStr] ~= nil then
			return nil
		-- Nothing to remove check
		elseif CoreLoot.ListUtils.Invert and CoreLoot.db.AutosellState[itemIdStr] == nil then 
			return nil
		end

		listStr = "Autosell"
		listStateStr = "AutosellState"
	end

	--if listStr == "" or listStateStr == "" then
	--	return nil
	--end

	if CoreLoot.ListUtils.Invert then 
		CoreLoot.ListUtils:RemoveListItem(listStr, listStateStr, itemID, name)
		CoreLoot:Print("Item " .. link .. " removed from " .. listStr)
	else
		CoreLoot.ListUtils:AddNewListItem(listStr, listStateStr, itemID, name)
		CoreLoot:Print("Item " .. link .. " added to " .. listStr)
	end

	CoreLoot.GuiUtils:PopulateDropdownListWidget(CoreLoot.ListWidgets.Whitelist, CoreLoot.db.Whitelist, CoreLoot.db.WhitelistState)
	CoreLoot.GuiUtils:PopulateDropdownListWidget(CoreLoot.ListWidgets.Blacklist, CoreLoot.db.Blacklist, CoreLoot.db.BlacklistState)
	CoreLoot.GuiUtils:PopulateDropdownListWidget(CoreLoot.ListWidgets.Autosell, CoreLoot.db.Autosell, CoreLoot.db.AutosellState)
end

function CoreLoot.ListUtils:DisableAllListInteractionToggles()
	CoreLoot.ListUtils.Whitelist = false
	CoreLoot.ListUtils.Blacklist = false
	CoreLoot.ListUtils.Autosell = false
	CoreLoot.ListUtils.Invert = false
end


function CoreLoot.ListUtils:MatchWhitelist(itemId)
	return CoreLoot.ListUtils:DoListCheck(itemId, CoreLoot.db.WhitelistState)
end

function CoreLoot.ListUtils:MatchBlacklist(itemId)
	return CoreLoot.ListUtils:DoListCheck(itemId, CoreLoot.db.BlacklistState)
end

function CoreLoot.ListUtils:MatchAutosell(itemId)
	return CoreLoot.ListUtils:DoListCheck(itemId, CoreLoot.db.AutosellState)
end

function CoreLoot.ListUtils:DoListCheck(itemId, stateList)
	if stateList[tostring(itemId)] then
		return true
	else
		return false
	end
end

function CoreLoot.ListUtils:CheckGreyMinGold(vendorPrice)
	local price = CoreLoot:ConvertCopper(vendorPrice)
	if price.gold < CoreLoot.db.GreyGoldKeep then
		return true
	else
		return false
	end
end
