local counter = 1;
local function create_check_button(parent, x_loc, y_loc, display_name, checked)
	counter = counter + 1;
	
	local check_button = CreateFrame("CheckButton", "eli_checkbutton_0" .. counter, parent, "ChatConfigCheckButtonTemplate");
    check_button:SetPoint("TOPLEFT", x_loc, y_loc);
    check_button:SetChecked(checked);
	getglobal(check_button:GetName() .. 'Text'):SetText(display_name);
	return check_button;
end

local function has_value(list, value)
	for _, v in pairs(list) do
		if v == value then return true end
	end
	return false
end

local function init()
    if loot_gold == nil then
        loot_gold = true;
    end
    if loot_quest_items == nil then
        loot_quest_items = false;
    end
    if loot_quality_items == nil then
        loot_quality_items = {[0]=false, false, false, false, false, false, false};
    end
    if only_auto_loot_key == nil then
        only_auto_loot_key = true;
    end
    
    local settings = CreateFrame("Frame");
    settings.name = "EliAutoLoot";

    local label = settings:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
    label:SetPoint("TOPLEFT", 16, -16);
    label:SetJustifyH("LEFT");
    label:SetJustifyV("TOP");
    label:SetText("EliAutoLoot");

    -- looting options
    local looting_options = settings:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    looting_options:SetPoint("TOPLEFT", 16, -50);
    looting_options:SetJustifyH("LEFT");
    looting_options:SetJustifyV("TOP");
    looting_options:SetText("Looting options");

    local looting_options_line = settings:CreateLine();
    looting_options_line:SetColorTexture(0.169, 0.169, 0.169, 1);
    looting_options_line:SetStartPoint("TOPLEFT", 15, -65);
    looting_options_line:SetEndPoint("TOPRIGHT", -15, -65);
    looting_options_line:SetThickness(1);
    
    -- gold
    settings.loot_gold_checkbox = create_check_button(settings, 16, -80, "Loot gold", loot_gold);
    settings.loot_gold_checkbox.tooltip = "Loots gold";
    settings.loot_gold_checkbox:SetScript("OnClick", 
        function(self)
            print(self:GetChecked());
            loot_gold = self:GetChecked();
        end);
    
    -- quest items
    settings.loot_quest_items_checkbox = create_check_button(settings, 16, -110, "Loot quest items", loot_quest_items);
    settings.loot_quest_items_checkbox.tooltip = "Loots all quest items";
    settings.loot_quest_items_checkbox:SetScript("OnClick", 
        function(self)
            loot_quest_items = self:GetChecked();
        end);
    
    -- quality
    settings.loot_quality_items_checkbox = {};
    settings.loot_quality_items_checkbox[0] = create_check_button(settings, 300, -80, "Loot |cff9d9d9dpoor |cffffffffitems", loot_quality_items[0]);
    settings.loot_quality_items_checkbox[0].tooltip = "Loots all |cff9d9d9dpoor |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[1] = create_check_button(settings, 300, -110, "Loot common items", loot_quality_items[1]);
    settings.loot_quality_items_checkbox[1].tooltip = "Loots all common quality items";
    
    settings.loot_quality_items_checkbox[2] = create_check_button(settings, 300, -140, "Loot |cff1eff00uncommon |cffffffffitems", loot_quality_items[2]);
    settings.loot_quality_items_checkbox[2].tooltip = "Loots all |cff1eff00uncommon |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[3] = create_check_button(settings, 300, -170, "Loot |cff0070ddrare |cffffffffitems", loot_quality_items[3]);
    settings.loot_quality_items_checkbox[3].tooltip = "Loots all |cff0070ddrare |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[4] = create_check_button(settings, 300, -200, "Loot |cffa335eeepic |cffffffffitems", loot_quality_items[4]);
    settings.loot_quality_items_checkbox[4].tooltip = "Loots all |cffa335eeepic |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[5] = create_check_button(settings, 300, -230, "Loot |cffff8000legendary |cffffffffitems", loot_quality_items[5]);
    settings.loot_quality_items_checkbox[5].tooltip = "Loots all |cffff8000legendary |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[6] = create_check_button(settings, 300, -260, "Loot |cffe6cc80artifact |cffffffffitems", loot_quality_items[6]);
    settings.loot_quality_items_checkbox[6].tooltip = "Loots all |cffe6cc80artifact |cffffffffquality items";
    
    for i = 0, 6, 1 do
        settings.loot_quality_items_checkbox[i]:SetScript("OnClick", 
            function(self)
                loot_quality_items[i] = self:GetChecked();
            end);
    end

    -- other options
    local other_options = settings:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    other_options:SetPoint("TOPLEFT", 16, -290);
    other_options:SetJustifyH("LEFT");
    other_options:SetJustifyV("TOP");
    other_options:SetText("Other options");

    local other_options_line = settings:CreateLine();
    other_options_line:SetColorTexture(0.169, 0.169, 0.169, 1);
    other_options_line:SetStartPoint("TOPLEFT", 15, -305);
    other_options_line:SetEndPoint("TOPRIGHT", -15, -305);
    other_options_line:SetThickness(1);

    -- only auto-loot key
    settings.only_auto_loot_key_checkbox = create_check_button(settings, 16, -320, "Only auto loot key", only_auto_loot_key);
    settings.only_auto_loot_key_checkbox.tooltip = "Auto loots only when auto loot key is held down";
    settings.only_auto_loot_key_checkbox:SetScript("OnClick", 
        function(self)
            only_auto_loot_key = self:GetChecked();
        end);
    
    InterfaceOptions_AddCategory(settings);
end

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("LOOT_READY");

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "EliAutoLoot" then
        init();
    elseif event == "LOOT_READY" then
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
end)

SLASH_ELIAUTOLOOT1, SLASH_ELIAUTOLOOT2 = '/eliautoloot', '/eal';
function SlashCmdList.ELIAUTOLOOT(msg, editBox)
    InterfaceOptionsFrame_Show();
    InterfaceOptionsFrame_OpenToCategory("EliAutoLoot");
end