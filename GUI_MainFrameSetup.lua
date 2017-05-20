function CoreLoot:RenderMainFrame()
	-- Main GUI foundation
	CoreLoot.MFrame = CoreLoot.GUI:Create("Frame")
	CoreLoot.MFrameContainer = CoreLoot.GUI:Create("InlineGroup")
	CoreLoot.scroller = CoreLoot.GUI:Create("ScrollFrame")

	-- Configure main frame
	CoreLoot.MFrame:SetCallback("OnClose", function(w) CoreLoot.GUI:Release(w) end)
	CoreLoot.MFrame:SetTitle("CoreLoot")
	CoreLoot.MFrame:SetStatusText("Doing stuff.")
	CoreLoot.MFrame:SetHeight(600)
	CoreLoot.MFrame:EnableResize(false)
	CoreLoot.MFrame:SetLayout("Fill")
	-- Configure the group container
	CoreLoot.MFrameContainer:SetFullWidth(true)
	CoreLoot.MFrameContainer:SetFullHeight(true)
	CoreLoot.MFrameContainer:SetLayout("Fill")
	CoreLoot.MFrameContainer:SetHeight(500)
	-- Configure the scroller container
	CoreLoot.scroller:SetLayout("Flow")

	-- Add children
	CoreLoot.MFrame:AddChild(CoreLoot.MFrameContainer)
	CoreLoot.MFrameContainer:AddChild(CoreLoot.scroller)

	------------------------
	-- Option Widgets
	------------------------
	local _EnableCoreLoot = CoreLoot.GUI:Create("CheckBox")
		  _EnableCoreLoot:SetLabel("Enable CoreLoot")
		  _EnableCoreLoot:SetWidth(120)
		  _EnableCoreLoot:SetValue(CoreLoot.db.EnableCoreLoot)
		  _EnableCoreLoot:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableCoreLoot = value end)

	local _EnableAutolootingCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _EnableAutolootingCheckbox:SetLabel("Autoloot")
		  _EnableAutolootingCheckbox:SetWidth(120)
		  _EnableAutolootingCheckbox:SetValue(CoreLoot.db.EnableAutoloot)
		  _EnableAutolootingCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableAutoloot = value end)

	local _EnableAutorollCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _EnableAutorollCheckbox:SetLabel("Autoroll")
		  _EnableAutorollCheckbox:SetWidth(120)
		  _EnableAutorollCheckbox:SetValue(CoreLoot.db.EnableAutoroll)
		  _EnableAutorollCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableAutoroll = value end)

	local _TrashFoodCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _TrashFoodCheckbox:SetLabel("Trash Food")
		  _TrashFoodCheckbox:SetWidth(120)
		  _TrashFoodCheckbox:SetValue(CoreLoot.db.EnableTrashFood)
		  _TrashFoodCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableTrashFood = value end)

	local _EnableWhitelistCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _EnableWhitelistCheckbox:SetLabel("Enable Whitelist")
		  _EnableWhitelistCheckbox:SetWidth(120)
		  _EnableWhitelistCheckbox:SetValue(CoreLoot.db.EnableWhitelist)
		  _EnableWhitelistCheckbox:SetDisabled(true)

	local _EnableBlacklistCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _EnableBlacklistCheckbox:SetLabel("Enable Blacklist")
		  _EnableBlacklistCheckbox:SetWidth(120)
		  _EnableBlacklistCheckbox:SetValue(CoreLoot.db.EnableBlacklist)
		  _EnableBlacklistCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableBlacklist = value end)

	local _EnableAutoSellCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _EnableAutoSellCheckbox:SetLabel("Enable Autosell")
		  _EnableAutoSellCheckbox:SetWidth(120)
		  _EnableAutoSellCheckbox:SetValue(CoreLoot.db.EnableAutosell)
		  _EnableAutoSellCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableAutosell = value end)

	local _AddToWhitelistCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _AddToWhitelistCheckbox:SetLabel("Add Whitelist")
		  _AddToWhitelistCheckbox:SetWidth(120)
		  _AddToWhitelistCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.ListUtils.AddWhitelist = value end)

	local _AddToBlacklistCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _AddToBlacklistCheckbox:SetLabel("Add Blacklist")
		  _AddToBlacklistCheckbox:SetWidth(120)
		  _AddToBlacklistCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.ListUtils.AddBlacklist = value end)

	local _AddToAutosellListCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _AddToAutosellListCheckbox:SetLabel("Add Autosell")
		  _AddToAutosellListCheckbox:SetWidth(120)
		  _AddToAutosellListCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.ListUtils.AddAutosell = value end)

	local _EnableAutoRepair = CoreLoot.GUI:Create("CheckBox")
		  _EnableAutoRepair:SetLabel("Auto Repair")
		  _EnableAutoRepair:SetWidth(120)
		  _EnableAutoRepair:SetValue(CoreLoot.db.EnableAutorepair)
		  _EnableAutoRepair:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableAutorepair = value end)

	local _EnableGuildRepair = CoreLoot.GUI:Create("CheckBox")
		  _EnableGuildRepair:SetLabel("Use Guild")
		  _EnableGuildRepair:SetWidth(120)
		  _EnableGuildRepair:SetValue(CoreLoot.db.EnableGuildRepair)
		  _EnableGuildRepair:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableGuildRepair = value end)

	local _GreyMinGoldSlider = CoreLoot.GUI:Create("Slider")
		  _GreyMinGoldSlider:SetLabel("Greys: Min Val")
		  _GreyMinGoldSlider:SetSliderValues(0, 100, 1)
		  _GreyMinGoldSlider:SetWidth(120)
		  _GreyMinGoldSlider:SetValue(CoreLoot.db.GreyGoldKeep)
		  _GreyMinGoldSlider:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.GreyGoldKeep = value end)

	local _WhitelistDropdown = CoreLoot.GUI:Create("Dropdown")
		  _WhitelistDropdown:SetMultiselect(true)
		  _WhitelistDropdown:SetFullWidth(true)
		  _WhitelistDropdown:SetLabel("Whitelisted Items *Always takes priority, cannot be disabled.")
		  _WhitelistDropdown:SetCallback("OnValueChanged", function(_, _, key, checked) 
		  	CoreLoot.GuiUtils:DropdownOnValueChangedHandler("Whitelist", key, checked) 
	  	    end)
		  CoreLoot.ListWidgets.Whitelist = _WhitelistDropdown
		  CoreLoot.GuiUtils:PopulateDropdownListWidget(CoreLoot.ListWidgets.Whitelist, CoreLoot.db.Whitelist, CoreLoot.db.WhitelistState)


	local _BlacklistDropdown = CoreLoot.GUI:Create("Dropdown")
		  _BlacklistDropdown:SetMultiselect(true)
		  _BlacklistDropdown:SetFullWidth(true)
		  _BlacklistDropdown:SetLabel("Blacklisted Items")
		  _BlacklistDropdown:SetCallback("OnValueChanged", function(_, _, key, checked) 
		  	CoreLoot.GuiUtils:DropdownOnValueChangedHandler("Blacklist", key, checked) 
	  	    end)
		  CoreLoot.ListWidgets.Blacklist = _BlacklistDropdown
		  CoreLoot.GuiUtils:PopulateDropdownListWidget(CoreLoot.ListWidgets.Blacklist, CoreLoot.db.Blacklist, CoreLoot.db.BlacklistState)

	local _AutosellListDropdown = CoreLoot.GUI:Create("Dropdown")
		  _AutosellListDropdown:SetMultiselect(true)
		  _AutosellListDropdown:SetFullWidth(true)
		  _AutosellListDropdown:SetLabel("Autosell List")
		  _AutosellListDropdown:SetCallback("OnValueChanged", function(_, _, key, checked) 
		  	CoreLoot.GuiUtils:DropdownOnValueChangedHandler("Autosell", key, checked) 
	  	    end)
		  CoreLoot.ListWidgets.Autosell = _AutosellListDropdown
		  CoreLoot.GuiUtils:PopulateDropdownListWidget(CoreLoot.ListWidgets.Autosell, CoreLoot.db.Autosell, CoreLoot.db.AutosellState)

	local _TrashGreysCheckbox = CoreLoot.GUI:Create("CheckBox")
		  _TrashGreysCheckbox:SetLabel("Trash Greys")
		  _TrashGreysCheckbox:SetWidth(120)
		  _TrashGreysCheckbox:SetValue(CoreLoot.db.EnableTrashGreys)
		  _TrashGreysCheckbox:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.EnableTrashGreys = value end)

	local _FoodKeepMinLevelSlider = CoreLoot.GUI:Create("Slider")
		  _FoodKeepMinLevelSlider:SetLabel("Food Keep Min Level")
		  _FoodKeepMinLevelSlider:SetWidth(240)
		  _FoodKeepMinLevelSlider:SetSliderValues(0, 200, 1)
		  _FoodKeepMinLevelSlider:SetValue(CoreLoot.db.FoodMinLevel)
		  _FoodKeepMinLevelSlider:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.db.FoodMinLevel = value end)

	local _InvertListAction = CoreLoot.GUI:Create("CheckBox")
		  _InvertListAction:SetLabel("Invert List Action")
		  _InvertListAction:SetWidth(240)
		  _InvertListAction:SetValue(CoreLoot.ListUtils.Invert)
		  _InvertListAction:SetCallback("OnValueChanged", function(_, _, value) CoreLoot.ListUtils.Invert = value end)
	------------------------
	-- Create Options Groups
	------------------------
	local GeneralOptionsGroup = CoreLoot.GUI:Create("InlineGroup")
		  GeneralOptionsGroup:SetFullWidth(true)
		  GeneralOptionsGroup:SetLayout("Flow")
		  GeneralOptionsGroup:SetTitle("General Options")
		  GeneralOptionsGroup:AddChild(_EnableCoreLoot)
		  GeneralOptionsGroup:AddChild(_EnableAutolootingCheckbox)
		  GeneralOptionsGroup:AddChild(_EnableAutorollCheckbox)

	local ListInteractionsGroup = CoreLoot.GUI:Create("InlineGroup")
		  ListInteractionsGroup:SetFullWidth(true)
		  ListInteractionsGroup:SetLayout("Flow")
		  ListInteractionsGroup:SetTitle("List Interactions")
		  ListInteractionsGroup:AddChild(CoreLoot.GUI:GetGuiHeading("Global List Interactions"))
		  ListInteractionsGroup:AddChild(_InvertListAction)
		  ListInteractionsGroup:AddChild(CoreLoot.GUI:GetGuiHeading("Individual List Interactions"))
		  ListInteractionsGroup:AddChild(_EnableWhitelistCheckbox)
		  ListInteractionsGroup:AddChild(_AddToWhitelistCheckbox)
		  ListInteractionsGroup:AddChild(_WhitelistDropdown)
		  ListInteractionsGroup:AddChild(_EnableBlacklistCheckbox)
		  ListInteractionsGroup:AddChild(_AddToBlacklistCheckbox)
		  ListInteractionsGroup:AddChild(_BlacklistDropdown)
		  ListInteractionsGroup:AddChild(_EnableAutoSellCheckbox)
		  ListInteractionsGroup:AddChild(_AddToAutosellListCheckbox)
		  ListInteractionsGroup:AddChild(_AutosellListDropdown)

	local GreyFilteringGroup = CoreLoot.GUI:Create("InlineGroup")
		  GreyFilteringGroup:SetFullWidth(true)
		  GreyFilteringGroup:SetLayout("Flow")
		  GreyFilteringGroup:SetTitle("Grey Filtering")
		  GreyFilteringGroup:AddChild(_TrashGreysCheckbox)
		  GreyFilteringGroup:AddChild(_GreyMinGoldSlider)

	local FoodFilteringGroup = CoreLoot.GUI:Create("InlineGroup")
		  FoodFilteringGroup:SetFullWidth(true)
		  FoodFilteringGroup:SetLayout("Flow")
		  FoodFilteringGroup:SetTitle("Food Filtering")
		  FoodFilteringGroup:AddChild(_TrashFoodCheckbox)
		  FoodFilteringGroup:AddChild(_FoodKeepMinLevelSlider)

	local RepairOptionsGroup = CoreLoot.GUI:Create("InlineGroup")
		  RepairOptionsGroup:SetFullWidth(true)
		  RepairOptionsGroup:SetLayout("Flow")
		  RepairOptionsGroup:SetTitle("Repair Options")
		  RepairOptionsGroup:AddChild(_EnableAutoRepair)
		  RepairOptionsGroup:AddChild(_EnableGuildRepair)

	CoreLoot.scroller:AddChild(CoreLoot:GetProfileWidget())
	CoreLoot.scroller:AddChild(GeneralOptionsGroup)
	CoreLoot.scroller:AddChild(ListInteractionsGroup)
	CoreLoot.scroller:AddChild(GreyFilteringGroup)
	CoreLoot.scroller:AddChild(FoodFilteringGroup)
	CoreLoot.scroller:AddChild(RepairOptionsGroup)

end