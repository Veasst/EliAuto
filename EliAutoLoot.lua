local function has_value(list, value)
	for _, v in pairs(list) do
		if v == value then return true end
	end
	return false
end

local frame = CreateFrame("Frame");
frame:RegisterEvent("LOOT_READY");

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "LOOT_READY" then
        if (only_auto_loot_key and GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE"))
            or (not only_auto_loot_key) then
            for i = GetNumLootItems(), 1, -1 do
                local loot_icon, _, _, _, loot_quality, _, is_quest_item, _, _ = GetLootSlotInfo(i);
                if loot_quest_items and is_quest_item then
                    LootSlot(i);
                elseif loot_gold and has_value({133789, 133788, 133787, 133786, 133785, 133784}, loot_icon) then
                    LootSlot(i);
                elseif loot_quality_items[loot_quality] then
                    LootSlot(i);
                end
            end
        end
    end
end);

SLASH_ELIAUTOLOOT1, SLASH_ELIAUTOLOOT2 = '/eliautoloot', '/eal';
function SlashCmdList.ELIAUTOLOOT(msg, editBox)
    InterfaceOptionsFrame_Show();
    InterfaceOptionsFrame_OpenToCategory("EliAutoLoot");
end