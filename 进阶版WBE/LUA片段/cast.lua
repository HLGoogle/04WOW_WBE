local _spellid = 133 -- 火球术1级
local castingStatus = {} -- 用于跟踪玩家的施法状态
local hitTargets = {} -- 用于跟踪已经被打击的目标

-- 判断目标是否在玩家正前方180度范围内
local function IsInFront(player, target)
    local playerX, playerY, playerZ = player:GetLocation()
    local targetX, targetY, targetZ = target:GetLocation()
    
    local playerFacing = player:GetO()
    local angleToTarget = math.atan2(targetY - playerY, targetX - playerX)
    
    local relativeAngle = math.abs(math.deg(angleToTarget - playerFacing))
    if relativeAngle > 180 then
        relativeAngle = 360 - relativeAngle
    end
    
    return relativeAngle <= 90
end

-- 定义玩家施法事件的处理函数
local function OnPlayerCastSpell(event, player, spell, skipCheck)
    local spellId = spell:GetEntry()  -- 获取施法的技能ID
    local target = spell:GetTarget()  -- 获取施法的目标
    local playerGUID = player:GetGUIDLow() -- 获取玩家的GUID
    
    if spellId == _spellid then  -- 如果施放的技能ID是133
        if not castingStatus[playerGUID] then  -- 检查玩家是否已经在施法
            castingStatus[playerGUID] = true  -- 设置施法标志
            local targets = player:GetUnfriendlyUnitsInRange(30)  -- 获取玩家周围30码内的所有敌对单位
            for _, unit in ipairs(targets) do  -- 遍历所有敌对单位
                local unitGUID = unit:GetGUIDLow()  -- 获取每个单位的GUID
                if target ~= unit and IsInFront(player, unit) and not hitTargets[unitGUID] and unit:IsWithinLoS(player) then  -- 确保不对原始目标重复施法，并且目标在玩家正前方180度范围内，且未被打击过
                    hitTargets[unitGUID] = true -- 标记目标已被打击
                    player:CastSpell(unit, _spellid, true)  -- 对其他敌对单位施放技能133
					hitTargets[unitGUID] = false -- 清除标记目标,方便下次打击
                end
            end
            castingStatus[playerGUID] = false  -- 重置施法标志
        end
    end
end

-- 注册新的事件
RegisterPlayerEvent(5, OnPlayerCastSpell)
