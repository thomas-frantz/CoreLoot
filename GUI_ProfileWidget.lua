function CoreLoot:GetProfileWidget()
	local GUIProfile = CoreLoot.GUI:Create("InlineGroup")
		  GUIProfile:SetTitle("Profiles")
		  GUIProfile:SetFullWidth(true)
		  GUIProfile:SetLayout("Flow")

	local ProfileNameEditbox = self.GUI:Create("EditBox")
		  ProfileNameEditbox:SetLabel("New Profile")
		  ProfileNameEditbox:DisableButton(true)
		  ProfileNameEditbox:SetWidth(240)

	local ProfileListDropdown = self.GUI:Create("Dropdown")
		  ProfileListDropdown:SetWidth(240)
		  ProfileListDropdown:SetLabel("Select Profile")
		  ProfileListDropdown:SetList(CoreLoot:GetProfilesList())

	local DeleteProfileDropdown = self.GUI:Create("Dropdown")
		  DeleteProfileDropdown:SetWidth(240)
		  DeleteProfileDropdown:SetLabel("Delete Profile")

	local CopyProfileDropdown = self.GUI:Create("Dropdown")
		  CopyProfileDropdown:SetWidth(240)
		  CopyProfileDropdown:SetLabel("Copy Profile")

	local UpdateDropdowns = function()
		local profiles = CoreLoot:GetProfilesList()
		ProfileListDropdown:SetList(profiles)
	  	DeleteProfileDropdown:SetList(profiles)
	  	CopyProfileDropdown:SetList(profiles)

	  	CoreLoot:IterateProfiles(function(idx, name)
			if name == CoreLoot.profiles.profile then
				ProfileListDropdown:SetText(name)
				ProfileListDropdown:SetItemValue(idx, true)
			end

			if name == "Default" then
				DeleteProfileDropdown:SetItemValue(idx, true)
			end
			CopyProfileDropdown:SetItemValue(idx, false)
  		end)
	end


	ProfileListDropdown:SetCallback("OnValueChanged", function(_, _, key)
		local profiles = CoreLoot:GetProfilesList()
		CoreLoot:SetProfile(profiles[key])
		CoreLoot.GuiUtils.RedrawClUi()
	end)

	ProfileNameEditbox:SetCallback("OnEnterPressed", function(_, _, text)
		if text ~= "" then
	  		CoreLoot:NewProfile(text)
	  		CoreLoot.GuiUtils.RedrawClUi()
	  	end
	end)


	DeleteProfileDropdown:SetCallback("OnValueChanged", function(_, _, key)
		local profiles = CoreLoot:GetProfilesList()
		CoreLoot:DeleteProfile(profiles[key])
		CoreLoot.GuiUtils.RedrawClUi()
	end)


	CopyProfileDropdown:SetCallback("OnValueChanged", function(_, _, key)
        local profiles = CoreLoot:GetProfilesList()
        CoreLoot:CopyProfile(profiles[key])
        CoreLoot.GuiUtils.RedrawClUi()
	end)

	UpdateDropdowns()

	GUIProfile:AddChild(ProfileNameEditbox)
	GUIProfile:AddChild(ProfileListDropdown)
	GUIProfile:AddChild(DeleteProfileDropdown)
	GUIProfile:AddChild(CopyProfileDropdown)
	return GUIProfile
end
