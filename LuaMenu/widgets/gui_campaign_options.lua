--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Campaign Options Window",
		desc      = "Stuff",
		author    = "GoogleFrog, KingRaptor",
		date      = "4 July 2016",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -100000,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Configuration

local ITEM_OFFSET = 38

local COMBO_X = 230
local COMBO_WIDTH = 235
local CHECK_WIDTH = 230
local TEXT_OFFSET = 6

local DIFFICULTY_NAME_MAP = {"Imported", "Easy", "Normal", "Hard", "Brutal", "None"}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Utilities

local function PopulateTab(settingPresets, settingOptions, settingsDefault)
	local children = {}
	local offset = 5
	local customSettingsSwitch
	local label, list

	if settingPresets then
		label, list, customSettingsSwitch, offset = MakePresetsControl(settingPresets, offset)
		children[#children + 1] = label
		children[#children + 1] = list
	end

	for i = 1, #settingOptions do
		local data = settingOptions[i]
		if data.displayModeToggle then
			label, list, offset = ProcessScreenSizeOption(data, offset)
		elseif data.isNumberSetting then
			label, list, offset = ProcessSettingsNumber(data, offset, settingsDefault, customSettingsSwitch)
		else
			label, list, offset = ProcessSettingsOption(data, offset, settingsDefault, customSettingsSwitch)
		end
		children[#children + 1] = label
		children[#children + 1] = list
	end

	return children
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Difficulty Window

local function InitializeDifficultyWindow(parent)
	local Configuration = WG.Chobby.Configuration

	local offset = 5
	local freezeSettings = true

	Label:New {
		x = 20,
		y = offset + TEXT_OFFSET,
		width = 90,
		height = 30,
		valign = "top",
		align = "left",
		objectOverrideFont = Configuration:GetFont(2),
		caption = "Difficulty",
		parent = parent,
	}
	local comboDifficulty = ComboBox:New {
		x = COMBO_X,
		y = offset,
		width = COMBO_WIDTH,
		height = 30,
		items = {"Easy", "Normal", "Hard", "Brutal"},
		selected = 2,
		objectOverrideFont = Configuration:GetFont(2),
		itemFontSize = Configuration:GetFont(2).size,
		selected = WG.CampaignData.GetDifficultySetting(),
		OnSelect = {
			function (obj)
				if freezeSettings then
					return
				end
				WG.CampaignData.SetDifficultySetting(obj.selected)
			end
		},
		parent = parent,
	}
	offset = offset + ITEM_OFFSET

	local function UpdateSettings()
		freezeSettings = true
		comboDifficulty:Select(WG.CampaignData.GetDifficultySetting())
		freezeSettings = false
	end
	WG.CampaignData.AddListener("CampaignSettingsUpdate", UpdateSettings)
	WG.CampaignData.AddListener("CampaignLoaded", UpdateSettings)

	freezeSettings = false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Stats Window

local function MakeStatLabel(parent, offset, name)
	TextBox:New {
		x = 20,
		y = offset + TEXT_OFFSET,
		width = 200,
		height = 30,
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = name,
		parent = parent,
	}
	local infoText = TextBox:New {
		x = COMBO_X + 8,
		y = offset + TEXT_OFFSET,
		width = 200,
		height = 30,
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = "",
		parent = parent,
	}
	return offset + ITEM_OFFSET, infoText
end

local function InitializeStatsWindow(parent)
	local Configuration = WG.Chobby.Configuration

	local offset = 5
	local freezeSettings = true

	local leastDifficulty, totalTime, totalVictoryTime, planets, bonusObjectives, level, experience

	offset, leastDifficulty  = MakeStatLabel(parent, offset, "Lowest difficulty")
	offset, totalTime        = MakeStatLabel(parent, offset, "Ingame time")
	offset, totalVictoryTime = MakeStatLabel(parent, offset, "Victory ingame time")
	offset, planets          = MakeStatLabel(parent, offset, "Planets captured")
	offset, bonusObjectives  = MakeStatLabel(parent, offset, "Bonus objectives")
	offset, level            = MakeStatLabel(parent, offset, "Commander level")
	offset, experience       = MakeStatLabel(parent, offset, "Commander experience")

	local function UpdateStats()
		local gamedata = WG.CampaignData.GetGamedataInATroublingWay()
		leastDifficulty:SetText(DIFFICULTY_NAME_MAP[(gamedata.leastDifficulty or 4) + 1])
		totalTime:SetText(Spring.Utilities.FormatTime((gamedata.totalPlayFrames or 0)/30, true))
		totalVictoryTime:SetText(Spring.Utilities.FormatTime((gamedata.totalVictoryPlayFrames or 0)/30, true))
		planets:SetText(tostring(#(gamedata.planetsCaptured.list or {})))
		bonusObjectives:SetText(tostring(#(gamedata.bonusObjectivesComplete.list or {})))
		level:SetText(tostring((gamedata.commanderLevel or 0) + 1))
		experience:SetText(tostring(gamedata.commanderExperience or 0))
	end

	UpdateStats()

	WG.CampaignData.AddListener("CampaignLoaded", UpdateStats)
	WG.CampaignData.AddListener("PlanetUpdate", UpdateStats)
	WG.CampaignData.AddListener("PlayTimeAdded", UpdateStats)
	WG.CampaignData.AddListener("GainExperience", UpdateStats)

	freezeSettings = false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Score Window

local function MakePlanetControls(bestPlanet)
	local holder = Panel:New {
		x = 0,
		y = 0,
		width = "100%",
		resizable = false,
		draggable = false,
		padding = {0, 0, 0, 0},
	}
	
	local nameLabel = TextBox:New {
		x = "6%",
		y = 5,
		right = "80%",
		height = 40,
		valign = 'center',
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = bestPlanet.name,
		parent = holder,
	}
	local difficultyLabel = TextBox:New {
		x = "26%",
		y = 5,
		right = "60%",
		height = 40,
		valign = 'center',
		align = 'center',
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = DIFFICULTY_NAME_MAP[bestPlanet.difficulty + 1],
		parent = holder,
	}
	local bonusLabel = TextBox:New {
		x = "46%",
		y = 5,
		right = "40%",
		height = 40,
		valign = 'center',
		align = 'center',
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = string.format("%d%%", bestPlanet.bonusProp*100),
		parent = holder,
	}
	local framesLabel = TextBox:New {
		x = "66%",
		y = 5,
		right = "20%",
		height = 40,
		valign = 'center',
		align = 'center',
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = Spring.Utilities.FormatTime(bestPlanet.frames/30, true, true),
		parent = holder,
	}
	local lossesLabel = TextBox:New {
		x = "86%",
		y = 5,
		right = "0%",
		height = 40,
		valign = 'center',
		align = 'center',
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = bestPlanet.losses,
		parent = holder,
	}
	
	local externalFuncs = {}
	function externalFuncs.UpdateBestPlanet(newPestPlanet)
		bestPlanet = newPestPlanet
		difficultyLabel:SetText(DIFFICULTY_NAME_MAP[bestPlanet.difficulty + 1])
		bonusLabel:SetText(string.format("%d%%", bestPlanet.bonusProp*100))
		framesLabel:SetText(Spring.Utilities.FormatTime(bestPlanet.frames/30, true, true))
		lossesLabel:SetText(bestPlanet.losses)
	end
	
	function externalFuncs.GetHolder()
		return holder
	end
	
	return externalFuncs
end

local function InitializeScoresWindow(parent)
	local init = true
	
	local canPrioritiseBy = {
		"Difficulty",
		"Bonuses",
		"Time",
		"Losses",
	}
	local internalPrioName = {
		"difficulty",
		"bonusCount",
		"frames",
		"losses",
	}
	
	local sortMult = {
		difficulty = 1,
		bonusCount = 1,
		frames = -1,
		losses = -1,
	}
	local comboPositions = {110, 370, 561}
	
	local listHolder = Control:New {
		x = 6,
		right = 6,
		y = 60,
		bottom = 15,
		parent = parent,
		resizable = false,
		draggable = false,
		padding = {0, 0, 0, 0},
	}
	
	local headings = {
		{name = "Planet",     x = "0%", right = "80%"},
		{name = "Difficulty", x = "20%", right = "60%"},
		{name = "Bonuses",    x = "40%", right = "40%"},
		{name = "Time",       x = "60%", right = "20%"},
		{name = "Losses",     x = "80%", right = "0%"},
	}
	
	local planetList = WG.Chobby.SortableList(listHolder, headings, 75, 2)
	local sortByOptions = {}
	local planetControls = {}
	local currentSort = Spring.Utilities.CopyTable(internalPrioName)
	
	local function GetBestPlanet(planetID)
		local bestPool = WG.CampaignData.GetPlanetVictoryLog(planetID)
		if not bestPool then
			return
		end
		for i = 1, #currentSort do
			local bestFound = false
			local bestSet = false
			local sortBy = currentSort[i]
			for j = 1, #bestPool do
				local score = bestPool[j][sortBy] * sortMult[sortBy]
				if (not bestFound) or score > bestFound then
					bestSet = {}
					bestSet[#bestSet + 1] = bestPool[j]
					bestFound = score
				elseif score == bestFound then
					bestSet[#bestSet + 1] = bestPool[j]
				end
			end
			bestPool = bestSet
		end
		
		local bestPlanet = Spring.Utilities.CopyTable(bestPool[1])
		local planetDef = WG.CampaignData.GetPlanetDef(planetID)
		if planetDef.gameConfig.bonusObjectiveConfig and #planetDef.gameConfig.bonusObjectiveConfig > 0 then
			bestPlanet.bonusProp = bestPlanet.bonusCount / #planetDef.gameConfig.bonusObjectiveConfig
		else
			bestPlanet.bonusProp = 1
		end
		bestPlanet.bonusCount = nil
		bestPlanet.name = planetDef.name
		return bestPlanet
	end
	
	local function UpdateState()
		local victoryPlanets = WG.CampaignData.GetCapturedPlanetList()
		local items = {}
		for i = 1, #victoryPlanets do
			local planetID = victoryPlanets[i]
			local bestPlanet = GetBestPlanet(planetID)
			if bestPlanet then
				if not planetControls[planetID] then
					planetControls[planetID] = MakePlanetControls(bestPlanet)
				else
					planetControls[planetID].UpdateBestPlanet(bestPlanet)
				end
				items[#items + 1] = {planetID, planetControls[planetID].GetHolder(), {bestPlanet.name, bestPlanet.difficulty, bestPlanet.bonusProp, bestPlanet.frames, bestPlanet.losses}}
			end
		end
		planetList:Clear()
		planetList:AddItems(items)
	end
	
	for i = 1, 3 do
		sortByOptions[i] = ComboBox:New {
			x = comboPositions[i],
			y = 12,
			width = 120,
			height = 30,
			parent = parent,
			items = canPrioritiseBy,
			objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
			selected = canPrioritiseBy[i],
			OnSelect = {
				function (obj, index)
					if init then
						return
					end
					local newSort = {}
					local sortAdded = {}
					for j = 1, #sortByOptions do
						local sortName = internalPrioName[sortByOptions[j].selected]
						if not sortAdded[sortName] then
							newSort[#newSort + 1] = sortName
							sortAdded[sortName] = true
						end
					end
					for j = 1, #internalPrioName do
						local sortName = internalPrioName[j]
						if not sortAdded[sortName] then
							newSort[#newSort + 1] = sortName
							sortAdded[sortName] = true
						end
					end
					currentSort = newSort
					
					UpdateState()
				end
			},
		}
	end

	TextBox:New {
		x = 20,
		y = 20,
		width = 200,
		height = 30,
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = "Show best",
		parent = parent,
	}
	TextBox:New {
		x = 236,
		y = 20,
		width = 200,
		height = 30,
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = "breaking ties by",
		parent = parent,
	}
	TextBox:New {
		x = 495,
		y = 20,
		width = 200,
		height = 30,
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		text = "then by",
		parent = parent,
	}
	
	local function ResetState()
		planetControls = {}
		UpdateState()
	end
	
	WG.CampaignData.AddListener("VictoryLogUpdated", UpdateState)
	WG.CampaignData.AddListener("CampaignLoaded", ResetState)
	
	ResetState()
	init = false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Initialization

local function MakeTab(name, children)
	local contentsPanel = ScrollPanel:New {
		x = 5,
		right = 5,
		y = 10,
		bottom = 8,
		horizontalScrollbar = false,
		verticalScrollbar = false,
		children = children
	}

	return {
		name = name,
		caption = name,
		objectOverrideFont = WG.Chobby.Configuration:GetFont(3),
		children = {contentsPanel}
	}
end

local function MakeStandardTab(name, ChildrenFunction)
	local window = Control:New {
		name = "statsHandler",
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%",
		OnParent = {
			function(obj)
				if obj:IsEmpty() then
					ChildrenFunction(obj)
				end
			end
		},
	}

	local contentsPanel = ScrollPanel:New {
		x = 5,
		right = 5,
		y = 10,
		bottom = 8,
		horizontalScrollbar = false,
		verticalScrollbar = false,
		children = {window}
	}

	return {
		name = name,
		caption = name,
		objectOverrideFont = WG.Chobby.Configuration:GetFont(3),
		children = {contentsPanel}
	}
end

local function RefreshControls(window)
	WG.CampaignSaveWindow.PopulateSaveList()
end

local function InitializeControls(window)
	window.OnParent = nil

	local btnClose = Button:New {
		right = 11,
		y = WG.TOP_BUTTON_Y,
		width = 80,
		height = WG.BUTTON_HEIGHT,
		caption = i18n("close"),
		objectOverrideFont = WG.Chobby.Configuration:GetButtonFont(3),
		classname = "negative_button",
		OnClick = {
			function()
				window:Hide()
			end
		},
		parent = window
	}

	local tabs = {
		MakeTab("Save/Load", {WG.CampaignSaveWindow.GetControl()}),
		--MakeStandardTab("Difficulty", InitializeDifficultyWindow),
		MakeStandardTab("Stats", InitializeStatsWindow),
		MakeStandardTab("Scores", InitializeScoresWindow),
	}

	local tabPanel = Chili.DetachableTabPanel:New {
		x = 7,
		right = 7,
		y = 50,
		bottom = 6,
		padding = {0, 0, 0, 0},
		minTabWidth = 120,
		tabs = tabs,
		parent = window,
		OnTabChange = {
		}
	}

	local tabBarHolder = Control:New {
		name = "tabBarHolder",
		x = 6,
		y = 5,
		right = 65,
		height = 55,
		resizable = false,
		draggable = false,
		padding = {14, 8, 14, 0},
		parent = window,
		children = {
			tabPanel.tabBar
		}
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- External Interface

local CampaignOptionsWindow = {}

function CampaignOptionsWindow.GetControl()

	local window = Control:New {
		name = "campaignOptionsWindow",
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		padding = {0, 0, 0, 0},
		OnParentPost = {
			function(obj)
				if obj:IsEmpty() then
					InitializeControls(obj)
				else
					RefreshControls(obj)
				end
			end
		},
	}
	return window
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Callins

function widget:Initialize()
	CHOBBY_DIR = LUA_DIRNAME .. "widgets/chobby/"
	VFS.Include(LUA_DIRNAME .. "widgets/chobby/headers/exports.lua", nil, VFS.RAW_FIRST)

	WG.CampaignOptionsWindow = CampaignOptionsWindow
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
