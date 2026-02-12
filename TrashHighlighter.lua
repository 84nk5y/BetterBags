local function HighlightTrashItems(self)
    for _, itemButton in self:EnumerateItems() do
        if itemButton.myIcon then
            itemButton.myIcon:Hide()
        end
    end

    for _, itemButton in self:EnumerateValidItems() do
        local bagId = itemButton:GetBagID()
        local slotId = itemButton:GetID()
        local info = C_Container.GetContainerItemInfo(bagId, slotId)

        if info and info.quality == Enum.ItemQuality.Poor then
            if not itemButton.myIcon then
                itemButton.myIcon = itemButton:CreateTexture(nil, "OVERLAY")
                itemButton.myIcon:SetTexture("Interface/Buttons/UI-GroupLoot-Coin-Up")
                itemButton.myIcon:SetPoint("TOPLEFT", 2, -2)
                itemButton.myIcon:SetSize(15, 15)
            end
            itemButton.myIcon:Show()
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
    local isInitialLogin, isReloadingUi = ...
    if isInitialLogin or isReloadingUi then
        if ContainerFrameContainer and ContainerFrameContainer.ContainerFrames then
            for i = 1, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
                local frame = ContainerFrameContainer.ContainerFrames[i]
                if frame then
                    hooksecurefunc(frame, "UpdateItems", HighlightTrashItems)
                end
            end
        end

        if ContainerFrameCombinedBags then
            hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", HighlightTrashItems)
        end

        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)