CoreLoot = LibStub("AceAddon-3.0"):NewAddon("CoreLoot", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
CoreLoot.GUI = LibStub("AceGUI-3.0")

ClConst = {
	quality = {
		grey = 0,
		common = 1,
		uncommon = 2,
		rare = 3,
		epic = 4,
		legendary = 5,
		artifact = 6,
		heirloom = 7
	},
	action = {
		trash  = 1,
		autosell = 2,
	}
}

CLGlobal = {
	FoodAndDrink = "Food & Drink",

	ColorGold = "ffd700",
	ColorSilver = "c7c7cf",
	ColorCopper = "eda55f"
}

CoreLoot.GuiUtils = {
	COLOR_GOLD = "ffd700",
	COLOR_SILVER = "c7c7cf",
	COLOR_COPPER = "eda55f"
}

CoreLoot.ListWidgets = {
	Whitelist = nil,
	Blacklist = nil,
	Autosell = nil
}

CoreLoot.ListUtils = {
	AddWhitelist = false,
	AddBlacklist = false,
	AddAutosell = false,
	Invert = false
}

CoreLoot.InventoryUtils = {}

CoreLoot.Locks = {
	AutosellInProgress = false,
	LootFilteringInProgress = false
}

CoreLoot.DefaultDatabase = {
	EnableCoreLoot = true,
	EnableAutoloot = true,
	EnableWhitelist = true,
	EnableBlacklist = true,
	EnableAutosell = true,
	Whitelist = {},
	WhitelistState = {},
	Blacklist = {},
	BlacklistState = {},
	Autosell = {},
	AutosellState = {},
	EnableTrashGreys = true,
	GreyGoldKeep = 0,
	EnableTrashFood = true,
	FoodMinLevel = 0,
	EnableAutorepair = true,
	EnableGuildrepair = false,
	EnableAutoloot = true,
	EnableAutoroll = true,
}

CoreLoot.DefaultProfiles = {
	profile = "Default",
	all = {
		["Default"] = {
			EnableCoreLoot = true,
			EnableAutoloot = true,
			EnableWhitelist = true,
			EnableBlacklist = true,
			EnableAutosell = true,
			Whitelist = {},
			WhitelistState = {},
			Blacklist = {},
			BlacklistState = {},
			Autosell = {},
			AutosellState = {},
			EnableTrashGreys = true,
			GreyGoldKeep = 0,
			EnableTrashFood = true,
			FoodMinLevel = 0,
			EnableAutorepair = true,
			EnableGuildrepair = false,
			EnableAutoloot = true,
			EnableAutoroll = true,
		}
	}
}

CoreLoot.Buffers = {

	--[[
		Format:
		{
			ItemId = 1234,
			ItemCoords = {bag = 1, slot = 3}
			ItemInfo = {
				quality = ...
				link = ...
				valueStr = "1g2s3c"
				stackValueStr = "10g1s2c"
				value = copper value
				stackValue = copper * count
			}
		}
	]]
	trash = {},
	sell = {},
	sellCopper = 0
}

-- function CoreLoot:FilterInventory() end

function CoreLoot:IterateClassSubclasses(...)
  for class = 1, select("#", ...) do
    CoreLoot:Print(select(class, ...).. ":", strjoin(", ", GetAuctionItemSubClasses(class)))
  end
end

function CoreLoot:CopyProfile(profileName)
	if CoreLoot.profiles.all[profileName] ~= nil and CoreLoot.profiles.profile ~= profileName then
		CoreLoot.db = CoreLoot.profiles.all[profileName]
		CoreLoot.profiles.all[CoreLoot.profiles.profile] = CoreLoot.db
	end
end

function CoreLoot:NewProfile(profileName)
	if CoreLoot.profiles.all[profileName] == nil then
		CoreLoot.profiles.all[CoreLoot.profiles.profile] = CoreLoot.db -- Save current DB
		CoreLoot.profiles.all[profileName] = CoreLoot.DefaultDatabase -- Copy default DB to new profile
		CoreLoot:SetProfile(profileName)
	end
end

function CoreLoot:DeleteProfile(profileName)
	if CoreLoot.profiles.all[profileName] ~= nill and profileName ~= "Default" then
		if CoreLoot.profiles.profile == profileName then
			CoreLoot:SetProfile("Default")
		end

		CoreLoot.profiles.all[profileName] = nil
	end
end

function CoreLoot:GetProfilesList()
	local list = {}
	for k,_ in pairs(CoreLoot.profiles.all) do
		table.insert(list, k)
	end
	return list
end

-- Iterate over the current profiles names list, and call a function
-- callback on the index and name for each profile.
function CoreLoot:IterateProfiles(callback)
	for idx,name in pairs(CoreLoot:GetProfilesList()) do
		callback(idx, name)
	end
end

function CoreLoot:SetProfile(profileName)
	if CoreLoot.profiles.all[profileName] ~= nil then
		if CoreLoot.profiles.all[CoreLoot.profiles.profile] ~= nil then
			CoreLoot.profiles.all[CoreLoot.profiles.profile] = CoreLoot.db
		end
		CoreLoot.profiles.profile = profileName
		CoreLoot.db = CoreLoot.profiles.all[profileName]
		CoreLootSelectedProfile = profileName
	end
end

function CoreLoot.GUI:GetGuiHeading(headingText)
	local h = CoreLoot.GUI:Create("Heading")
	h:SetText(headingText)
	h:SetFullWidth(true)
	return h
end

CoreLoot:RegisterEvent("PLAYER_LOGOUT", function()
	CoreLootProfiles = CoreLoot.profiles
	CoreLootProfiles.all[CoreLoot.profiles.profile] = CoreLoot.db
	CoreLootSelectedProfile = CoreLoot.profiles.profile
end)

CoreLoot:RegisterEvent("ADDON_LOADED", function(event, arg1)
	if arg1 == "CoreLoot" then
		if CoreLootProfiles == nil then
			CoreLootProfiles = CoreLoot.DefaultProfiles
		end

		if CoreLootProfiles.all.Default == nil then
			CoreLootProfiles.all["Default"] = CoreLoot.DefaultProfiles.all.Default
		end
		--CoreLoot:IterateClassSubclasses(GetAuctionItemClasses())

		CoreLoot.profiles = CoreLootProfiles
		CoreLoot.db = CoreLoot.profiles.all[CoreLoot.profiles.profile]

		if CoreLootSelectedProfile == nil then
			CoreLootSelectedProfile = "Default"
		end
		CoreLoot:SetProfile(CoreLootSelectedProfile)

	end
end)
