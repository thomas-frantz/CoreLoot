function CoreLoot.GuiUtils:DropdownOnValueChangedHandler(widget, key, checked)
	if CoreLoot.ListWidgets.Whitelist == nil or 
	   CoreLoot.ListWidgets.Blacklist == nil or
	   CoreLoot.ListWidgets.Autosell == nil
	then return nil end

	if widget == "Whitelist" then
		if CoreLoot.db.Whitelist[key] == nil then return nil end
		CoreLoot.db.WhitelistState[key] = not CoreLoot.db.WhitelistState[key]
	elseif widget == "Blacklist" then
		if CoreLoot.db.Blacklist[key] == nil then return nil end
		CoreLoot.db.BlacklistState[key] = checked
	elseif widget == "Autosell" then
		if CoreLoot.db.Autosell[key] == nil then return nil end
		CoreLoot.db.AutosellState[key] = checked
	end
end

function CoreLoot.GuiUtils:PopulateDropdownListWidget(widget, list, listState)
	widget:SetList({})
	for k,v in pairs(list) do
		widget:AddItem(k, v)
		widget:SetItemValue(k, listState[k])
	end
end

function CoreLoot.GuiUtils:AddDropdownListItem(widget, key, value, state)
	widget:AddItem(tostring(key), value)
	widget:SetItemValue(tostring(key), state)
end

function CoreLoot.GuiUtils:RedrawClUi()
	CoreLoot.GUI:Release(CoreLoot.MFrame)
	CoreLoot:RenderMainFrame()
end
