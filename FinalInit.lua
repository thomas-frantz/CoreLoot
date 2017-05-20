function CoreLoot:ConvertCopper(amount)
	amount = tonumber(amount)
	local gold   = floor(amount / (100 * 100))
	local silver = math.fmod(floor(amount / 100), 100)
	local copper = math.fmod(floor(amount), 100)
	return { gold = gold, silver = silver, copper = copper }
end

function CoreLoot:GetPricePrintout(convertedFromCopper)
	return convertedFromCopper.gold .. "g" .. convertedFromCopper.silver .. "s" .. convertedFromCopper.copper .. "c"
end

function CoreLoot:FilterInventory()
	CoreLoot.InventoryUtils:IterateBags(function(bag, slot)
		local itemLink = GetContainerItemLink(bag, slot)
		local itemId = GetContainerItemID(bag, slot)
		local texture, count, locked, quality, readable, lootable, link, isFiltered = GetContainerItemInfo(bag, slot)
		if itemId ~= nil then
			local name, link, _, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
			if not CoreLoot.ListUtils:MatchWhitelist(itemId) then

				local reason = nil
				if CoreLoot.ListUtils:MatchBlacklist(itemId) and CoreLoot.db.EnableBlacklist then
					reason = "Matched Blacklist"
				end

				if quality == 0 and CoreLoot.db.EnableTrashGreys then
					if CoreLoot.ListUtils:CheckGreyMinGold(vendorPrice) then
						reason = "Grey value < " .. CoreLoot.db.GreyGoldKeep .. "g"
					end
				end

				if subclass == "Food & Drink" and CoreLoot.db.EnableTrashFood then
					if reqLevel > 0 and reqLevel < CoreLoot.db.FoodMinLevel then
						reason = "Food & Drink level < " .. CoreLoot.db.FoodMinLevel
					end
				end

				if reason ~= nil then
					local valueStr = CoreLoot:GetPricePrintout(CoreLoot:ConvertCopper(vendorPrice))
					local stackValueStr = CoreLoot:GetPricePrintout(CoreLoot:ConvertCopper(vendorPrice * count))
					local value = vendorPrice
					local stackValue = vendorPrice * count
					CoreLoot:Print("Destroying: " .. link .. " x" .. count .. " (" .. stackValueStr .. "): Reason \"" .. reason .. "\"")
					CoreLoot.InventoryUtils:DestroyBagItem(bag, slot)
				end


				--[[
				if CoreLoot.ListUtils:MatchBlacklist(itemId) and CoreLoot.db.EnableBlacklist then
					CoreLoot.InventoryUtils:DestroyBagItem(bag, slot, link, "blacklist")
				end

				if quality == 0 and CoreLoot.db.EnableTrashGreys then
					if CoreLoot.ListUtils:CheckGreyMinGold(vendorPrice) then
						CoreLoot.InventoryUtils:DestroyBagItem(bag, slot, link, "grey minimum gold")
					end
				end

				if subclass == "Food & Drink" and CoreLoot.db.EnableTrashFood then
					if reqLevel > 0 and reqLevel < CoreLoot.db.FoodMinLevel then
						CoreLoot.InventoryUtils:DestroyBagItem(bag, slot, link, "food & drink min level")
					end
				end
				]]
			end
		end
		return true
	end)
end

function CoreLoot:DoAutosellCheck()
	CoreLoot.InventoryUtils:IterateBags(function(bag, slot)
		local itemId = GetContainerItemID(bag, slot)
		local texture, count, locked, quality, readable, lootable, link, isFiltered = GetContainerItemInfo(bag, slot)

		if itemId ~= nil and not CoreLoot.ListUtils:MatchWhitelist(itemId) then
			local name, link, _, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
			if CoreLoot.db.EnableAutosell and (CoreLoot.ListUtils:MatchAutosell(itemId) or quality == 0) then
				table.insert(CoreLoot.Buffers.sell, {
					ItemId = itemId,
					ItemCoords = { bag = bag, slot = slot },
					ItemInfo = {
						qualit = quality,
						link = link,
						stack = count,
						valueStr = CoreLoot:ConvertCopper(vendorPrice),
						stackValueStr = CoreLoot:ConvertCopper(vendorPrice * count),
						value = vendorPrice,
						stackValue = vendorPrice * count
					}
				})
			end
		end
		return true
	end)
end

function CoreLoot:InitAutosellCheck()
	CoreLoot:DoAutosellCheck()
	CoreLoot:ScheduleTimer("RecursiveSellHandler", 1)
end

function CoreLoot:RecursiveSellHandler()
	local continue = true

	for i=1, 7 do
		if CoreLoot.Buffers.sell ~= nil and CoreLoot.Buffers.sell[i] ~= nil then
			local item = CoreLoot.Buffers.sell[i]
			local itemId = GetContainerItemID(item.ItemCoords.bag, item.ItemCoords.slot)
			if itemId == item.ItemId then -- Make sure this item is still what's there
				CoreLoot:Print("Selling: " .. item.ItemInfo.link .. " x" .. item.ItemInfo.stack .. " Value: " .. CoreLoot:GetPricePrintout(item.ItemInfo.stackValueStr))
				CoreLoot.Buffers.sellCopper = CoreLoot.Buffers.sellCopper + item.ItemInfo.stackValue

                PickupContainerItem(item.ItemCoords.bag, item.ItemCoords.slot)
                PickupMerchantItem()
				CoreLoot.Buffers.sell[i] = nil
			elseif itemId ~= nil then
				CoreLoot:Print("Selling Error: Item IDs do not match: " .. item.ItemId .. " vs " .. itemId)
			else
				CoreLoot:Print("Item no longer exists: " .. item.ItemId)
			end
		else
			continue = false
		end
	end

	if continue then
		local tmp = {}
		for i,v in pairs(CoreLoot.Buffers.sell) do
			table.insert(tmp, v)
		end
		CoreLoot.Buffers.sell = tmp

		CoreLoot:Print("Continuing")
		CoreLoot:ScheduleTimer("RecursiveSellHandler", 1)
	else
		CoreLoot.Buffers.sell = {}
		local sold = CoreLoot:ConvertCopper(CoreLoot.Buffers.sellCopper)
		CoreLoot:Print("Finished, total: " .. CoreLoot:GetPricePrintout(sold))
		CoreLoot.Buffers.sellCopper = 0
	end
end

function CoreLoot:OnInitialize()
	--[[
	This will add/remove items from lists. This fires when the item is picked up in the
	inventory
	]]
	CoreLoot:RegisterEvent("ITEM_LOCKED", CoreLoot.ListUtils.HandlePickupItem)

	--[[
	This handles autolooting items
	]]
	CoreLoot:RegisterEvent("LOOT_OPENED", function()
		CoreLoot.ListUtils:DisableAllListInteractionToggles()
		if CoreLoot.db.EnableCoreLoot then
			if CoreLoot.db.EnableAutoloot then
				for i=1, GetNumLootItems(), 1 do
					LootSlot(i)
				end
			end
		end
	end)

	--[[
	This will throttle the calls to FilterInventory so we aren't filtering it more than one time
	at any given moment.
	]]
	CoreLoot:RegisterBucketEvent("LOOT_CLOSED", 3, function() CoreLoot:ScheduleTimer("FilterInventory", 1) end)

	--[[
	Prevents the "This will bind this item to your character" confirmation box
	]]
	CoreLoot:RegisterEvent("CONFIRM_LOOT_ROLL", function(e, slot, rolltype)
		ConfirmLootRoll(slot, rolltype)
	end)

	--[[
	Handles autoselling, and autorepair.
	]]
	CoreLoot:RegisterEvent("MERCHANT_SHOW", function()
		CoreLoot:Print("MSHOW")
		CoreLoot.ListUtils:DisableAllListInteractionToggles()
		CoreLoot:ScheduleTimer("InitAutosellCheck", 1)

		if CoreLoot.db.EnableAutorepair and CanMerchantRepair() then
			if CanGuildBankRepair() and CoreLoot.db.EnableGuildRepair then
				RepairAllItems(1)
				CoreLoot:Print("Repairing with guild.")
			else
				RepairAllItems()
				CoreLoot:Print("Repairing.")
			end
		end
	end)

	CoreLoot:RegisterChatCommand("coreloot", CoreLoot.RenderMainFrame)
end
