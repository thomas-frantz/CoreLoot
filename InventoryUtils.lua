function CoreLoot.InventoryUtils:HandleInventoryItem(bag, slot, action)
	if action == ClConst.action.trash then 

	elseif action == ClConst.action.autosell then

	end
end

-- Callback is called on each slot, providing the signature (bag, slot)
function CoreLoot.InventoryUtils:IterateBags(callback)
	for bag = 0, 4 do
		for slot = 0, GetContainerNumSlots(bag) do
			if not callback(bag, slot) then
				return nil
			end
		end
	end
end

function CoreLoot.InventoryUtils:DestroyBagItem(bag, slot, itemLink, msgFilterMatchPrintout)
	PickupContainerItem(bag, slot)
	DeleteCursorItem()
	if itemLink ~= nil then
		if msgFilterMatchPrintout ~= nil then
			CoreLoot:Print("Item matched filter: " .. msgFilterMatchPrintout .. ": " .. itemLink)
		else
			CoreLoot:Print("Destroyed: " .. itemLink)
		end
	end
end
