function CoreLoot.ListUtils:AddNewListItem(listKeyString, listStateKeyString, itemID, itemName)
	local itemIDString = tostring(itemID)
	if CoreLoot.db[listKeyString][itemIDString] == nil then
		CoreLoot.db[listKeyString][itemIDString] = itemName
		CoreLoot.db[listStateKeyString][itemIDString] = true
	else
        CoreLoot:Print(" [Debug] AddNewListItem > list key or item ID string nil: " .. listKeyString .. " id: " .. itemIDString)
    end
end

function CoreLoot.ListUtils:RemoveListItem(listKeyString, listStateKeyString, itemID)
	local itemIDString = tostring(itemID)
	if CoreLoot.db[listKeyString][itemIDString] ~= nil then
		CoreLoot.db[listKeyString][itemIDString] = nil
		CoreLoot.db[listStateKeyString][itemIDString] = nil
    else
        CoreLoot:Print(" [Debug] RemoveListItem > list key or item ID string nil: " .. listKeyString .. " id: " .. itemIDString)
    end
end

function CoreLoot.ListUtils:HandleListAction(itemLink, itemName, listKeyString, listStateKeyString, itemID, removeItem)
    if removeItem then
        CoreLoot.ListUtils:RemoveListItem(listKeyString, listStateKeyString, itemID)
        CoreLoot:Print("Item " .. itemLink .. " removed from " .. listKeyString)
    else
        CoreLoot.ListUtils:AddNewListItem(listKeyString, listStateKeyString, itemID, itemName)
        CoreLoot:Print("Item " .. itemLink .. " added to " .. listKeyString)
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

    local remove = CoreLoot.ListUtils.Invert
	if CoreLoot.ListUtils.AddWhitelist then
        if (remove and CoreLoot.db.WhitelistState[itemIdStr] ~= nil) or (not remove and CoreLoot.db.WhitelistState[itemIdStr] == nil) then
            CoreLoot.ListUtils:HandleListAction(link, name, "Whitelist", "WhitelistState", itemID, remove)
        end
	end

	if CoreLoot.ListUtils.AddBlacklist then
        if (remove and CoreLoot.db.BlacklistState[itemIdStr] ~= nil) or (not remove and CoreLoot.db.BlacklistState[itemIdStr] == nil) then
            CoreLoot.ListUtils:HandleListAction(link, name, "Blacklist", "BlacklistState", itemID, remove)
        end
	end

	if CoreLoot.ListUtils.AddAutosell then
        if (remove and CoreLoot.db.AutosellState[itemIdStr] ~= nil) or (not remove and CoreLoot.db.AutosellState[itemIdStr] == nil) then
            CoreLoot.ListUtils:HandleListAction(link, name, "Autosell", "AutosellState", itemID, remove)
        end
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
