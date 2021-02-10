--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Featured Maps API",
		desc      = "Access to featured maps (community.json > .MapItems).",
		author    = "moreginger",
		date      = "07 February 2021",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -100000,
		enabled   = true
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local mapItems = nil

local function InitMapItems()
	if mapItems == nil then
		mapItems = WG.CommunityWindow.LoadStaticCommunityData().MapItems or {}
	end
end

local function All()
	InitMapItems()
	return mapItems
end

local function Get(name)
	InitMapItems()
	for i = 1, #mapItems do
		if mapItems[i].Name == name then
			return mapItems[i]
		end
	end
	return nil
end

local function ToMapType(mapItem)
	if mapItem.IsSpecial then
		return "Special"
	elseif mapItem.IsChickens then
		return "Chicken"
	elseif mapItem.IsFFA then
		return "FFA"
	elseif mapItem.Is1v1 then
		return "1v1"
	elseif mapItem.IsTeams then
		return "Team"
	end
	return "Special"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- External Interface

local FeaturedMaps = {}
FeaturedMaps.All = All
FeaturedMaps.Get = Get
FeaturedMaps.ToMapType = ToMapType

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Widget Interface

function widget:Initialize()
	WG.FeaturedMaps = FeaturedMaps
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
