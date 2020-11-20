local check_button_id = 0;
local function create_check_button(parent, x_loc, y_loc, display_name, checked)
	check_button_id = check_button_id + 1;
	
	local check_button = CreateFrame("CheckButton", "eli_checkbutton_0" .. check_button_id, parent, "ChatConfigCheckButtonTemplate");
    check_button:SetPoint("TOPLEFT", x_loc, y_loc);
    check_button:SetChecked(checked);
	getglobal(check_button:GetName() .. 'Text'):SetText(display_name);
	return check_button;
end

local function init()
    if config == nil then
        config = {};
        config.loot_gold = true;
        config.loot_quest_items = false;
        config.loot_quality_items = {[0]=false, false, false, false, false, false, false};
        config.only_auto_loot_key = true;
    end

    if config.no_auto_loot_key == nil then
        config.no_auto_loot_key = "None";
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
    settings.loot_gold_checkbox = create_check_button(settings, 16, -80, "Loot gold", config.loot_gold);
    settings.loot_gold_checkbox.tooltip = "Loots gold";
    settings.loot_gold_checkbox:SetScript("OnClick", 
        function(self)
            config.loot_gold = self:GetChecked();
        end);
    
    -- quest items
    settings.loot_quest_items_checkbox = create_check_button(settings, 16, -110, "Loot quest items", config.loot_quest_items);
    settings.loot_quest_items_checkbox.tooltip = "Loots all quest items";
    settings.loot_quest_items_checkbox:SetScript("OnClick", 
        function(self)
            config.loot_quest_items = self:GetChecked();
        end);
    
    -- quality
    settings.loot_quality_items_checkbox = {};
    settings.loot_quality_items_checkbox[0] = create_check_button(settings, 300, -80, "Loot |cff9d9d9dpoor |cffffffffitems", config.loot_quality_items[0]);
    settings.loot_quality_items_checkbox[0].tooltip = "Loots all |cff9d9d9dpoor |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[1] = create_check_button(settings, 300, -110, "Loot common items", config.loot_quality_items[1]);
    settings.loot_quality_items_checkbox[1].tooltip = "Loots all common quality items";
    
    settings.loot_quality_items_checkbox[2] = create_check_button(settings, 300, -140, "Loot |cff1eff00uncommon |cffffffffitems", config.loot_quality_items[2]);
    settings.loot_quality_items_checkbox[2].tooltip = "Loots all |cff1eff00uncommon |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[3] = create_check_button(settings, 300, -170, "Loot |cff0070ddrare |cffffffffitems", config.loot_quality_items[3]);
    settings.loot_quality_items_checkbox[3].tooltip = "Loots all |cff0070ddrare |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[4] = create_check_button(settings, 300, -200, "Loot |cffa335eeepic |cffffffffitems", config.loot_quality_items[4]);
    settings.loot_quality_items_checkbox[4].tooltip = "Loots all |cffa335eeepic |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[5] = create_check_button(settings, 300, -230, "Loot |cffff8000legendary |cffffffffitems", config.loot_quality_items[5]);
    settings.loot_quality_items_checkbox[5].tooltip = "Loots all |cffff8000legendary |cffffffffquality items";
    
    settings.loot_quality_items_checkbox[6] = create_check_button(settings, 300, -260, "Loot |cffe6cc80artifact |cffffffffitems", config.loot_quality_items[6]);
    settings.loot_quality_items_checkbox[6].tooltip = "Loots all |cffe6cc80artifact |cffffffffquality items";
    
    for i = 0, 6, 1 do
        settings.loot_quality_items_checkbox[i]:SetScript("OnClick", 
            function(self)
                config.loot_quality_items[i] = self:GetChecked();
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
    settings.only_auto_loot_key_checkbox = create_check_button(settings, 16, -320, "Only auto loot key", config.only_auto_loot_key);
    settings.only_auto_loot_key_checkbox.tooltip = "Auto loots only when auto loot key is held down";
    settings.only_auto_loot_key_checkbox:SetScript("OnClick", 
        function(self)
            config.only_auto_loot_key = self:GetChecked();
        end);

    -- no auto-loot key
    local no_auto_loot_key = settings:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    no_auto_loot_key:SetPoint("TOPLEFT", 300, -320);
    no_auto_loot_key:SetJustifyH("LEFT");
    no_auto_loot_key:SetJustifyV("TOP");
    no_auto_loot_key:SetText("No auto loot key");

    settings.no_auto_loot_key_dropdown = CreateFrame("FRAME", nil, settings, "UIDropDownMenuTemplate");
    settings.no_auto_loot_key_dropdown:SetPoint("TOPLEFT", 300, -340);
    UIDropDownMenu_SetWidth(settings.no_auto_loot_key_dropdown, 100);
    UIDropDownMenu_SetText(settings.no_auto_loot_key_dropdown, config.no_auto_loot_key);

    UIDropDownMenu_Initialize(settings.no_auto_loot_key_dropdown, function(self, level, menuList)
        -- common
        local info = UIDropDownMenu_CreateInfo();
        info.func = function(self, arg1, arg2, checked)
            UIDropDownMenu_SetText(settings.no_auto_loot_key_dropdown, self:GetText());
            config.no_auto_loot_key = self:GetText();
        end;
        info.notCheckable = true;
        -- end common
        info.text = "ALT key";
        info.checked = info.text == config.no_auto_loot_key;
        UIDropDownMenu_AddButton(info);
        info.text = "CTRL key";
        info.checked = info.text == config.no_auto_loot_key;
        UIDropDownMenu_AddButton(info);
        info.text = "SHIFT key";
        info.checked = info.text == config.no_auto_loot_key;
        UIDropDownMenu_AddButton(info);
        info.text = "None";
        info.checked = info.text == config.no_auto_loot_key;
        UIDropDownMenu_AddButton(info);
    end);

    InterfaceOptions_AddCategory(settings);
end

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "EliAutoLoot" then
        init();
    end
end);
