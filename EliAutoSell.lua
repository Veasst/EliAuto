local function has_value(t, value)
	for _, v in pairs(t) do
        if v == value then
            return true;
        end
	end
	return false;
end

local function sell_items()
    local total = 0
    for bag = 0,4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local item_link = GetContainerItemLink(bag, slot);
            if item_link then
                local item_name, _, item_rarity, _, _, _, _, _, _, _, item_sell_price, item_class_id, _, item_bind_type, _, _, _ = GetItemInfo(item_link);
                local _, item_count = GetContainerItemInfo(bag, slot);
                local item_level = GetDetailedItemLevelInfo(item_link);
                if not has_value(config.ignored_sell_items, item_name) then
                    if (config.sell_quality_items[item_rarity] and item_rarity == 0)
                        or (config.sell_quality_items[item_rarity]
                            and (config.sell_bind_items[item_bind_type]
                                or config.sell_equippable_items)
                            and item_level <= config.sell_item_level
                            and not config.ignore_class_types[item_class_id])
                        and item_sell_price ~= 0 then
                        total = total + (item_sell_price * item_count);
                        UseContainerItem(bag, slot);
                    end
                end
            end
        end
    end
    if total ~= 0 then
        print("[EliAutoSell] Items sold for: "..GetCoinTextureString(total));
    end
end

local sell_button = nil;
local frame = CreateFrame("Frame");
frame:RegisterEvent("MERCHANT_SHOW");
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "MERCHANT_SHOW" then
        if config.auto_sell then
            sell_items();
        end
        if not sell_button then
            sell_button = CreateFrame("Button", nil, MerchantFrame, "UIPanelButtonTemplate");
            sell_button:SetPoint("TOPLEFT", 60, -30);
            sell_button:SetText("EliAutoSell");
            sell_button:SetWidth(sell_button:GetTextWidth() + 10)
            sell_button:SetScript("OnClick", sell_items);
        end
    end
end);

local dialog = StaticPopupDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"];
dialog.OnAccept = nil;
dialog.OnShow = function()
    StaticPopup_Hide("CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL");
    SellCursorItem();
end
