local check_button_id = 0;
local function create_check_button(parent, x_loc, y_loc, display_name, checked)
	check_button_id = check_button_id + 1;

	local check_button = CreateFrame("CheckButton", "eli_checkbutton_0" .. check_button_id, parent, "ChatConfigCheckButtonTemplate");
    check_button:SetPoint("TOPLEFT", x_loc, y_loc);
    check_button:SetChecked(checked);
	getglobal(check_button:GetName() .. 'Text'):SetText(display_name);
	return check_button;
end

local function init_config_variables()
    -- auto loot
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

    -- auto sell
    if config.sell_quality_items == nil then
        config.sell_quality_items = {[0]=false, false, false, false, false};
    end

    if config.sell_bind_items == nil then
        config.sell_bind_items = {[0]=true, false, false, false, false};
    end

    if config.sell_equippable_items == nil then
        config.sell_equippable_items = false;
    end

    if config.sell_item_level == nil then
        config.sell_item_level = 100;
    end

    if config.ignore_class_types == nil then
        config.ignore_class_types = {};
        for i = 0, 18 do
            config.ignore_class_types[i] = true;
        end
    end

    if config.auto_sell == nil then
        config.auto_sell = false;
    end
end

local eli_auto = nil;
local function init_eli_auto()
    eli_auto = CreateFrame("Frame", nil, UIParent);
    eli_auto.name = "EliAuto";

    local label = eli_auto:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
    label:SetPoint("TOPLEFT", 16, -16);
    label:SetJustifyH("LEFT");
    label:SetJustifyV("TOP");
    label:SetText("EliAuto");

    InterfaceOptions_AddCategory(eli_auto);
end

local function init_auto_loot()
    local settings = CreateFrame("Frame", nil, eli_auto);
    settings.name = "EliAutoLoot";
    settings.parent = eli_auto.name;

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

local function init_auto_sell()
    local settings = CreateFrame("Frame", nil, eli_auto);
    settings.name = "EliAutoSell";
    settings.parent = eli_auto.name;

    local label = settings:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
    label:SetPoint("TOPLEFT", 16, -16);
    label:SetJustifyH("LEFT");
    label:SetJustifyV("TOP");
    label:SetText("EliAutoSell");

    -- selling options
    local selling_options = settings:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    selling_options:SetPoint("TOPLEFT", 16, -50);
    selling_options:SetJustifyH("LEFT");
    selling_options:SetJustifyV("TOP");
    selling_options:SetText("Selling options");

    local selling_options_line = settings:CreateLine();
    selling_options_line:SetColorTexture(0.169, 0.169, 0.169, 1);
    selling_options_line:SetStartPoint("TOPLEFT", 15, -65);
    selling_options_line:SetEndPoint("TOPRIGHT", -15, -65);
    selling_options_line:SetThickness(1);

    -- bind items
    settings.sell_bind_items_checkbox = {};
    settings.sell_bind_items_checkbox[1] = create_check_button(settings, 16, -80, "Sell bind on pickup items", config.sell_bind_items[1]);
    settings.sell_bind_items_checkbox[1].tooltip = "Sells bind on pickup items";

    settings.sell_bind_items_checkbox[2] = create_check_button(settings, 16, -110, "Sell bind on equip items", config.sell_bind_items[2]);
    settings.sell_bind_items_checkbox[2].tooltip = "Sells bind on equip items";

    settings.sell_bind_items_checkbox[3] = create_check_button(settings, 16, -140, "Sell bind on use items", config.sell_bind_items[3]);
    settings.sell_bind_items_checkbox[3].tooltip = "Sells bind on use items";

    for i = 1, 3, 1 do
        settings.sell_bind_items_checkbox[i]:SetScript("OnClick",
            function(self)
                config.sell_bind_items[i] = self:GetChecked();
            end);
    end

    -- equippable items
    settings.sell_equippable_items_checkbox = create_check_button(settings, 16, -170, "Sell equippable items", config.sell_equippable_items);
    settings.sell_equippable_items_checkbox.tooltip = "Sells equippable items";
    settings.sell_equippable_items_checkbox:SetScript("OnClick",
        function(self)
            config.sell_equippable_items = self:GetChecked();
        end);

    -- quality
    settings.sell_quality_items_checkbox = {};
    settings.sell_quality_items_checkbox[0] = create_check_button(settings, 300, -80, "Sell |cff9d9d9dpoor |cffffffffitems", config.sell_quality_items[0]);
    settings.sell_quality_items_checkbox[0].tooltip = "Sells |cff9d9d9dpoor |cffffffffquality items";

    settings.sell_quality_items_checkbox[1] = create_check_button(settings, 300, -110, "Sell common items", config.sell_quality_items[1]);
    settings.sell_quality_items_checkbox[1].tooltip = "Sells common quality items";

    settings.sell_quality_items_checkbox[2] = create_check_button(settings, 300, -140, "Sell |cff1eff00uncommon |cffffffffitems", config.sell_quality_items[2]);
    settings.sell_quality_items_checkbox[2].tooltip = "Sells |cff1eff00uncommon |cffffffffquality items";

    settings.sell_quality_items_checkbox[3] = create_check_button(settings, 300, -170, "Sell |cff0070ddrare |cffffffffitems", config.sell_quality_items[3]);
    settings.sell_quality_items_checkbox[3].tooltip = "Sells |cff0070ddrare |cffffffffquality items";

    settings.sell_quality_items_checkbox[4] = create_check_button(settings, 300, -200, "Sell |cffa335eeepic |cffffffffitems", config.sell_quality_items[4]);
    settings.sell_quality_items_checkbox[4].tooltip = "Sells |cffa335eeepic |cffffffffquality items";

    for i = 0, 4, 1 do
        settings.sell_quality_items_checkbox[i]:SetScript("OnClick",
            function(self)
                config.sell_quality_items[i] = self:GetChecked();
            end);
    end

    -- item level
    local sell_item_level_slider = CreateFrame("Slider", "SELL_ITEM_LEVEL_SLIDER", settings, "OptionsSliderTemplate");
    sell_item_level_slider:SetMinMaxValues(1, 200);
    sell_item_level_slider:SetValue(config.sell_item_level);
    sell_item_level_slider:SetValueStep(1);
    sell_item_level_slider:SetWidth(250);
    sell_item_level_slider:SetOrientation('HORIZONTAL');
    sell_item_level_slider:SetPoint("TOPLEFT", 16, -230);
    _G[sell_item_level_slider:GetName() .. "Low"]:SetText("1");
    _G[sell_item_level_slider:GetName() .. "High"]:SetText("200");
    _G[sell_item_level_slider:GetName() .. "Text"]:SetText("Sell items only under item level");

    local sell_item_level_edit_box = CreateFrame("EditBox", nil, settings, "InputBoxTemplate");
    sell_item_level_edit_box:SetAutoFocus(false);
    sell_item_level_edit_box:SetSize(30, 30);
    sell_item_level_edit_box:ClearAllPoints();
    sell_item_level_edit_box:SetPoint("CENTER", sell_item_level_slider, "CENTER", 0, -20);
    sell_item_level_edit_box:SetNumeric(true);
    sell_item_level_edit_box:SetNumber(config.sell_item_level);
    sell_item_level_edit_box:SetMultiLine(false);
    sell_item_level_edit_box:SetCursorPosition(0);

    sell_item_level_slider:SetScript("OnValueChanged",
        function(self, value)
            sell_item_level_edit_box:SetNumber(math.floor(value));
            config.sell_item_level = math.floor(value);
        end);

    sell_item_level_edit_box:SetScript("OnEnterPressed",
        function(self)
            local value = self:GetNumber();
            if value > 200 then
                value = 200;
            elseif value < 0 then
                value = 0;
            end
            self:SetNumber(value);
            sell_item_level_slider:SetValue(value);
            self:ClearFocus();
        end);

    -- ignore options
    local ignore_options = settings:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    ignore_options:SetPoint("TOPLEFT", 16, -270);
    ignore_options:SetJustifyH("LEFT");
    ignore_options:SetJustifyV("TOP");
    ignore_options:SetText("Ignore options");

    local ignore_options_line = settings:CreateLine();
    ignore_options_line:SetColorTexture(0.169, 0.169, 0.169, 1);
    ignore_options_line:SetStartPoint("TOPLEFT", 15, -285);
    ignore_options_line:SetEndPoint("TOPRIGHT", -15, -285);
    ignore_options_line:SetThickness(1);

    -- ignore item type
    settings.ignore_class_types_checkbox = {};
    settings.ignore_class_types_checkbox[1] = create_check_button(settings, 16, -300, "Ignore consumables", config.ignore_class_types[0]);
    settings.ignore_class_types_checkbox[1].tooltip = "Ignores consumables";

    settings.ignore_class_types_checkbox[2] = create_check_button(settings, 16, -330, "Ignore containers", config.ignore_class_types[1]);
    settings.ignore_class_types_checkbox[2].tooltip = "Ignores containers";

    settings.ignore_class_types_checkbox[3] = create_check_button(settings, 16, -360, "Ignore weapons", config.ignore_class_types[2]);
    settings.ignore_class_types_checkbox[3].tooltip = "Ignores weapons";

    settings.ignore_class_types_checkbox[4] = create_check_button(settings, 16, -390, "Ignore gems", config.ignore_class_types[3]);
    settings.ignore_class_types_checkbox[4].tooltip = "Ignores gems";

    settings.ignore_class_types_checkbox[5] = create_check_button(settings, 16, -420, "Ignore armor", config.ignore_class_types[4]);
    settings.ignore_class_types_checkbox[5].tooltip = "Ignores armor";

    settings.ignore_class_types_checkbox[6] = create_check_button(settings, 16, -450, "Ignore profession items", config.ignore_class_types[7]);
    settings.ignore_class_types_checkbox[6].tooltip = "Ignores profession items";

    settings.ignore_class_types_checkbox[7] = create_check_button(settings, 300, -300, "Ignore enchancement items", config.ignore_class_types[8]);
    settings.ignore_class_types_checkbox[7].tooltip = "Ignores enchancement items";

    settings.ignore_class_types_checkbox[8] = create_check_button(settings, 300, -330, "Ignore recipes", config.ignore_class_types[9]);
    settings.ignore_class_types_checkbox[8].tooltip = "Ignores recipes";

    settings.ignore_class_types_checkbox[9] = create_check_button(settings, 300, -360, "Ignore miscellaneous", config.ignore_class_types[15]);
    settings.ignore_class_types_checkbox[9].tooltip = "Ignores miscellaneous items";

    settings.ignore_class_types_checkbox[10] = create_check_button(settings, 300, -390, "Ignore glyphs", config.ignore_class_types[16]);
    settings.ignore_class_types_checkbox[10].tooltip = "Ignores glyphs";

    settings.ignore_class_types_checkbox[11] = create_check_button(settings, 300, -420, "Ignore battle pets", config.ignore_class_types[17]);
    settings.ignore_class_types_checkbox[11].tooltip = "Ignores battle pets";

    local i = 1;
    local type_class_ids = {0, 1, 2, 3, 4, 7, 8, 9, 15, 16, 17};
    for _, value in ipairs(type_class_ids) do
        settings.ignore_class_types_checkbox[i]:SetScript("OnClick",
        function(self)
            config.ignore_class_types[value] = self:GetChecked();
        end);
        i = i+1;
    end

    -- other options
    local other_options = settings:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    other_options:SetPoint("TOPLEFT", 16, -480);
    other_options:SetJustifyH("LEFT");
    other_options:SetJustifyV("TOP");
    other_options:SetText("Other options");

    local other_options_line = settings:CreateLine();
    other_options_line:SetColorTexture(0.169, 0.169, 0.169, 1);
    other_options_line:SetStartPoint("TOPLEFT", 15, -495);
    other_options_line:SetEndPoint("TOPRIGHT", -15, -495);
    other_options_line:SetThickness(1);

    -- auto sell
    settings.auto_sell_checkbox = create_check_button(settings, 16, -510, "Auto sell after openning merchant window", config.auto_sell);
    settings.auto_sell_checkbox.tooltip = "All items will be sold right after openning merchant window";
    settings.auto_sell_checkbox:SetScript("OnClick",
        function(self)
            config.auto_sell = self:GetChecked();
        end);

    InterfaceOptions_AddCategory(settings);
end

local function init()
    init_config_variables();
    init_eli_auto();
    init_auto_loot();
    init_auto_sell();
end

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "EliAutoLoot" then
        init();
    end
end);

SLASH_ELIAUTOLOOT1, SLASH_ELIAUTOLOOT2 = '/eliautoloot', '/eal';
function SlashCmdList.ELIAUTOLOOT(msg, editBox)
    InterfaceOptionsFrame_Show();
    InterfaceOptionsFrame_OpenToCategory("EliAutoLoot");
end

SLASH_ELIAUTOSELL1, SLASH_ELIAUTOSELL2 = '/eliautosell', '/eas';
function SlashCmdList.ELIAUTOSELL(msg, editBox)
    InterfaceOptionsFrame_Show();
    InterfaceOptionsFrame_OpenToCategory("EliAutoSell");
end
