# UnexploredAreas
Finds unexplored areaIDs for a uiMap.

There are a few problems with this approach:
* Some areas cannot be tracked with [C_MapExplorationInfo.GetExploredAreaIDsAtPosition()](https://wow.gamepedia.com/API_C_MapExplorationInfo.GetExploredAreaIDsAtPosition)
* Not all areas count for exploration achievements

# Usage
Use this function with the [UiMapID](https://wow.gamepedia.com/UiMapID)
```lua
/run UnexploredAreas:GetAreaInfo(27)
```
![](https://i.imgur.com/nw3FLm9.png)

See also:
* https://www.curseforge.com/wow/addons/explorer-markers
* https://www.curseforge.com/wow/addons/mypathfinder
* https://www.curseforge.com/wow/addons/tomtom
* https://www.wowhead.com/battle-for-azeroth-pathfinder-how-to-unlock-flying-in-bfa#battle-for-azeroth-explorer-a
