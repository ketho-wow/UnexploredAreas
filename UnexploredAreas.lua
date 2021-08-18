-- Elrox was interested in finding undiscovered areaIDs
-- there are a few caveats:
-- * C_MapExplorationInfo.GetExploredAreaIDsAtPosition() doesnt find all areaIDs in a zone
--		even if the whole zone is explored. some areaids just are not on the uimap when cursor highlighted
-- * the exploration achievements dont require all areaids in a zone
--		so this is not ideal for easily finding undiscovered areaids and their location, compared to using wowhead
-- * uimapids have to be mapped to parent areaids

-- For example, Dun Morogh: areaID 1, uiMapID 27
-- * https://www.wowhead.com/achievement=627/explore-dun-morogh requires 15 areas
-- * C_MapExplorationInfo.GetExploredAreaIDsAtPosition() finds 19 areaIDs
-- * https://wow.tools/dbc/?dbc=areatable lists 22 areaIDs
-- e.g. Bahrum's Post is not required for the achievement and is not found by GetExploredAreaIDsAtPosition

local _, addonTbl = ...

local data
if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	data = addonTbl.retail
else
	data = addonTbl.tbc
end

UnexploredAreas = {}
local UA = UnexploredAreas
UA.AreaTable = data.AreaTable
UA.UiMapAssignment = data.UiMapAssignment

local grid

local function CreateGrid(detail)
	local t = {}
	for i = 1, detail do
		for j = 1, detail do
			tinsert(t, CreateVector2D(i/detail, j/detail))
		end
	end
	return t
end

local function SortKeys(tbl)
	local t = {}
	for k in pairs(tbl) do
		tinsert(t, k)
	end
	sort(t)
	return t
end

function UA:GetDiscoveredAreaIDs(uiMapID)
	grid = grid or CreateGrid(20)
	local discovered = {}
	for _, vector in pairs(grid) do -- look through mouse cursor positions
		local explored = C_MapExplorationInfo.GetExploredAreaIDsAtPosition(uiMapID, vector)
		if explored then
			for _, areaID in pairs(explored) do
				discovered[areaID] = true
			end
		end
	end
	return discovered
end

-- /run UnexploredAreas:GetAreaInfo(27)
function UA:GetAreaInfo(uiMapID)
	if not uiMapID then
		uiMapID = C_Map.GetBestMapForUnit("player")
	end
	local parentAreaID = self.UiMapAssignment[uiMapID]
	local areaIDs = self.AreaTable[parentAreaID]
	local discovered = self:GetDiscoveredAreaIDs(uiMapID)
	-- local undiscovered = {}
	-- for id in pairs(areaIDs) do
	-- 	if not discovered[id] then
	-- 		undiscovered[id] = true
	-- 	end
	-- end
	print(format("%s: uiMapID |cffFFFF00%d|r, areaID |cffFFFF00%d|r",
		C_Map.GetMapInfo(uiMapID).name, uiMapID, parentAreaID))
	for _, id in pairs(SortKeys(areaIDs)) do
		local explored = discovered[id] and "|cff1EFF00Discovered|r" or "|cffFF0000Unknown|r"
		print(id, explored, C_Map.GetAreaInfo(id))
	end
end
