local function Repair()
    if not CanMerchantRepair() then return end

    local repairAllCost, canRepair = GetRepairAllCost()
    if not canRepair or repairAllCost == 0 then return end

    if repairAllCost > GetMoney() then
        print("|cffB0C4DE[AutoRepair]|r |cffFF0000Not enough money for repair!|r")
        return
    end

    local guildFundsBefore = nil
    local useGuildFunds = false

    if IsInGuild() and CanGuildBankRepair() then
        local guildFundsAvailable = GetGuildBankWithdrawMoney()
        if guildFundsAvailable == -1 or guildFundsAvailable > 0 then
            guildFundsBefore = guildFundsAvailable
            useGuildFunds = true
        end
    end

    if useGuildFunds then
        RepairAllItems(true)

        local guildFundsAfter = GetGuildBankWithdrawMoney()

        if guildFundsBefore == -1 then
            print("|cffB0C4DE[AutoRepair]|r Repair cost: "..GetCoinTextureString(repairAllCost).." |cff00FF00(Guild paid all)|r")
        else
            local guildPaid = guildFundsBefore - guildFundsAfter
            local playerPaid = repairAllCost - guildPaid

            if guildPaid > 0 then
                if playerPaid == 0 then
                    print("|cffB0C4DE[AutoRepair]|r Repair cost: "..GetCoinTextureString(repairAllCost).." |cff00FF00(Guild paid all)|r")
                else
                    print("|cffB0C4DE[AutoRepair]|r Repair cost: "..GetCoinTextureString(repairAllCost)..
                        "  |cff00FF00(Guild: "..GetCoinTextureString(guildPaid)..")|r"..
                        "  |cffFFFFFF(Player: "..GetCoinTextureString(playerPaid).."|r)")
                end
            else
                print("|cffB0C4DE[AutoRepair]|r Repair cost: "..GetCoinTextureString(repairAllCost).." |cffFFFFFF(Player funds)|r")
            end
        end
    else
        RepairAllItems(false)

        print("|cffB0C4DE[AutoRepair]|r Repair cost: "..GetCoinTextureString(repairAllCost).." |cffFFFFFF(Player funds)|r")
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", Repair)