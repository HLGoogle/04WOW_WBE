F = F or CreateFrame("Frame")
F:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
F:RegisterEvent("PLAYER_REGEN_ENABLED")
local lastUpdate = GetTime()
local targets = {}
F:SetScript("OnEvent", function(self, event, ...)
        if event == "COMBAT_LOG_EVENT_UNFILTERED" then
            local timestamp = ...
            local currentTime = GetTime()
            local playerGUID = UnitGUID("player")
            local arg = {...}
            local TargetGUID = arg[3]
            if TargetGUID ~= playerGUID and TargetGUID ~= "0x0000000000000000" and UnitAffectingCombat("player") then
                if currentTime - lastUpdate >= 2  then
                    local totalTargets = table.getn(targets)
                    if totalTargets > 0 then
                    print("周围目标:", totalTargets)
                    lastUpdate = currentTime
                    wipe(targets)
                    end
                    if totalTargets > 3 then
                        local allTargetsInRange = true
                        for _, targetGUID in ipairs(targets) do
                            local unitID = "raid" .. targetGUID
                            if not BeeRange(unitID) or BeeRange(unitID) > 10 then
                                allTargetsInRange = false
                                break
                            end
                        end
                        if allTargetsInRange and GetSpellCooldown("火焰之雨") == 0 and not UnitChannelInfo("player") then
                            CastSpellByName("火焰之雨")
                            CameraOrSelectOrMoveStart()
                            CameraOrSelectOrMoveStop()
                            print("Executing command, total targets:", totalTargets)
                        end
                    end
                end
                if not tContains(targets, TargetGUID) then
                    tinsert(targets, TargetGUID)
                end
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            wipe(targets)
            print("脱离战斗，targets表已清空。")
        end
end)