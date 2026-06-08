----------------------------------
--"自定义参数"
----------------------------------
local tiaoshi=false

----------------------------------
--"插队函数"
----------------------------------
if BeeCastSpellFast() then   
    return true;  
end
----------------------------------
--"函数"
----------------------------------
function zuoqi()
    if IsMounted("player")==1 then return true else return false end
end
function youxiao(unit)
    if not unit then unit="target" end
    if not UnitIsDeadOrGhost(unit) and BeeUnitCanAttack(unit) and InLosTo(UnitGUID(unit))==1 then return true else return false end
end
function apr()
    if GetNumRaidMembers()>0 then
        return "r"
    elseif GetNumPartyMembers()>0 then
        return "p"      
    else
        return "a"                
    end
end
function save(arr)
    BeeSetVariable("guai",arr)
end
----------------------------------
--"变量申明"
----------------------------------
local mybuff=BeeUnitBuffList("player")
local mid=UnitGUID("player")
local tarbuff=BeeUnitBuffList("target")
local tid=UnitGUID("target")
local myhp=BeeUnitHealth("player","%")
local mymp=BeeUnitMana("player","%")
local tarhp=BeeUnitHealth("target")
local apr=apr()
local shuliang=LMonsterCount(30)
local lhsp=GetItemCount("灵魂碎片")
local zdzt=GetVariable("zdzt")
local lhsp=GetItemCount("灵魂碎片")
local fashang=GetSpellBonusDamage(6)
local baoji=GetSpellCritChance(7)
local jisu=GetCombatRating(20)
local gczs=GetVariable("gczs")
----------------------------------
--"非战斗状态"
----------------------------------
if zuoqi() or BeeStringFind("格拉库的肉松蛋糕",mybuff) or BeeStringFind("进食",mybuff) then return end

--按住alt+鼠标指向 强制加非战斗怪进战斗
if IsLeftAltKeyDown() and youxiao("mouseover") then BeeRun("腐蚀术","mouseover") end


if BeeUnitCastSpellName("player") then 
    if BeeUnitCastSpellName("player")=="吸取灵魂" and BeeIsRun("吸取灵魂") then 
        if gczs~=true and BeeStringFind("根除",mybuff) then 
            SetVariable("gczs",true) 
            BeeRun("/stopcasting")  
            BeeRun("吸取灵魂") 
            return 
        end
        if BeeUnitBuff("根除","player") <=0.2 and BeeUnitBuff("根除","player") >0 then 
            print(2)
            SetVariable("gczs",false)
            BeeRun("/stopcasting")  
            BeeRun("吸取灵魂") 
            BeeRun("/cancelAura 根除")
            return
        end
        if (BeeUnitBuff("英勇","player")<0.2 and BeeUnitBuff("英勇","player")>0) or (BeeUnitBuff("嗜血","player")<0.2 and BeeUnitBuff("嗜血","player")>0) then
            print(3)
            SetVariable("gczs",false)
            BeeRun("/stopcasting")  
            BeeRun("吸取灵魂") 
            BeeRun("/cancelAura 英勇\\n/cancelAura 嗜血")
            return
        end        
    end
    return
end
if youxiao() then
    if UnitIsPlayer("target") and not BeeStringFind("魔甲术",mybuff) then BeeRun("魔甲术")  return end
    if not UnitIsPlayer("target") and not BeeStringFind("邪甲术",mybuff) then BeeRun("邪甲术")  return end
end



if IsInCombat(mid)==0 then 
    if zdzt==true then zdzt=false SetVariable("zdzt",false) end
    if GetItemCount("邪能治疗石")<1 and lhsp>0 then BeeRun("制造治疗石") return end
    if BeeWeaponEnchantInfo(1)<1 then 
        if GetItemCount("完美法术石")<1 and lhsp>0 then 
            BeeRun("制造法术石") 
            return 
        else
            BeeRun("/use 完美法术石\\n/use 16")
            alan("ReplaceEnchant()")
        end
    end
    if GetItemCount("恶魔灵魂石")<1 then BeeRun("制造灵魂石") return end
    if apr=="a" and GetItemCount("恶魔灵魂石")>0 and GetItemCooldown("item:36895")==0 and not BeeStringFind("灵魂石复活",mybuff) then SelectM(mid) BeeRun("/use 恶魔灵魂石") return end
    if not BeeStringFind("侦测隐形",mybuff) then BeeRun("侦测隐形","player") return end
    if not BeeStringFind("魔息术",mybuff) then BeeRun("魔息术","player") return end
    return 
end
----------------------------------
--"战斗状态"
----------------------------------
--更新周围怪物状态表
local nowarr={}
if shuliang>0 then
    local lasttime=GetVariable("lasttime")
    if lasttime==nil then lasttime=0 end
    local guai=BeeGetVariable("guai")
    if guai==nil then guai={} end
    local nowtar={}
    if time()-lasttime>0.2 then
        local arr=LMonsterGUID(30)
        if arr==nil then return end
        for k,v in pairs(arr) do
            local list=GetBuffList(v)
            if IsInCombat(v)==1 and InLosTo(v)==1 and Li.FindBuff(list, "圣盾术", mid)==-1 and GetHealth(v)>1 then
                local pipei=false
                for k2,v2 in pairs(guai) do
                    if v==guai[k2]["id"] then
                        nowtar=guai[k2]
                        --print("匹配")
                        pipei=true
                        break
                    end
                end
                nowtar["hp"]=GetHealth(v)
                nowtar["mhp"]=GetMaxHealth(v)
                nowtar["hp%"]=(nowtar["hp"]/nowtar["mhp"])*100
                nowtar["name"]=GetName(v)
                
                local fsst=Li.FindBuff(list, "腐蚀术", mid)
                if pipei then
                    if tiaoshi then
                        print("第"..tostring(k).."个怪")
                        print("id:"..nowtar["id"])
                        print("名字:"..nowtar["name"])
                        print("血量百分比:"..nowtar["hp%"])
                        print("当前血量:"..nowtar["hp"])
                        print("最大血量:"..nowtar["mhp"])
                    end
                    if fsst ~=-1 then
                        nowtar["fss"]=true   
                        nowtar["fsst"]=fsst 
                        --print(nowtar["fb"])           
                    else
                        nowtar["fss"]=false
                        nowtar["fsst"]=0  
                        nowtar["zs"]=false
                    end
                    if nowtar["tk"]==nil then nowtar["tk"]=0 end
                    if nowtar["lasttime"]==nil then nowtar["lasttime"]=0 end
                    nowarr[table.getn(nowarr)+1]=nowtar
                else
                    nowtar["id"]=v
                    if fsst >0 then
                        nowtar["fsst"]=fsst
                        nowtar["fss"]=true   
                        nowtar["fb"]=baoji                
                    else
                        nowtar["fss"]=false
                        nowtar["fb"]=0
                    end
                    nowtar["tk"]=0
                    nowtar["zs"]=false
                    nowtar["lasttime"]=0
                    nowarr[table.getn(nowarr)+1]=nowtar
                end
            end
        end
    end
    
    SetVariable("lasttime",time())
    save(nowarr)
    shuliang=table.getn(nowarr)
    
    if tiaoshi then
        print("共"..tostring(shuliang).."个怪")
        for k,v in pairs(nowarr) do
            print("第"..tostring(k).."个怪")
            print("id:"..nowarr[k]["id"])
            print("名字:"..nowarr[k]["name"])
            print("血量百分比:"..nowarr[k]["hp%"])
            print("当前血量:"..nowarr[k]["hp"])
            print("最大血量:"..nowarr[k]["mhp"])
        end
    end
end



if zdzt==nil or zdzt==false then zdzt=true SetVariable("zdzt",true) end

if not BeeStringFind("生命分流",mybuff) or (myhp>=50 and mymp<=60) then
    BeeRun("生命分流")
    return
end

if shuliang<1 then nowarr=BeeGetVariable("guai") return end

if not youxiao() then SelectM(nowarr[1]["id"]) end

if shuliang==1 then
    
    if nowarr[1]["hp%"]<=25 and apr=="a" then  
        if not BeeStringFind("根除",mybuff) then 
            SetVariable("gczs",false) 
        else
            SetVariable("gczs",true)
        end
        BeeRun("吸取灵魂") 
        return 
    end

    if not BeeStringFind("腐蚀术",tarbuff) and BeeIsRun("腐蚀术") then 
        if nowarr[1]["hp%"]<=35 then
            nowarr[1]["zs"]=true
        else
            nowarr[1]["zs"]=false
        end
        nowarr[1]["fss"]=true
        nowarr[1]["fb"]=baoji        
        BeeRun("腐蚀术") 
        save(nowarr)
        return 
    end
    
    if not BeeStringFind("暗影掌握",tarbuff) and BeeIsRun("暗影箭") then BeeRun("暗影箭") return end
    
    if BeeUnitBuff("鬼影缠身","target")<=3 and BeeIsRun("鬼影缠身") then BeeRun("鬼影缠身") return end
    
    if tarhp<25 and BeeStringFind("暗影冥思",mybuff) and BeeIsRun("暗影箭") then BeeRun("暗影箭") return end
    
    if BeeUnitBuffCount("暗影之拥")==3 and BeeIsRun("腐蚀术") then
        --"冰冻结晶,4T10,嫁祸诀窍后期添加"
        if not nowarr[1]["zs"] and tarhp<35 then
            if GetItemCount("狂野魔法药水")>0 and GetItemCooldown("狂野魔法药水")==0 then BeeRun("/use 狂野魔法药水") end
            nowarr[1]["zs"]=true
            nowarr[1]["fb"]=baoji     
            BeeRun("腐蚀术") 
            save(nowarr)
            return
        end
        
        if baoji>nowarr[1]["fb"] then
            nowarr[1]["fb"]=baoji     
            BeeRun("腐蚀术") 
            save(nowarr)
            return
        end
    end
    
    if BeeUnitBuff("痛苦无常","target")<=1.5 and time()-nowarr[1]["tk"]>=5 and BeeIsRun("痛苦无常") then 
        BeeRun("痛苦无常") 
        nowarr[1]["tk"]=time()
        save(nowarr)
        return 
    end

    if BeeUnitBuff("痛苦诅咒","target")<=1.5 and BeeIsRun("痛苦诅咒") then BeeRun("痛苦诅咒") return end
    
    if nowarr[1]["hp%"]<=25 then  
        if not BeeStringFind("根除",mybuff) then 
            SetVariable("gczs",false) 
        else
            SetVariable("gczs",true)
        end
        BeeRun("吸取灵魂") 
        return 
    end
    
    if nowarr[1]["hp%"]>25 and BeeIsRun("暗影箭") then BeeRun("暗影箭") return end
    
end

if shuliang>1 and shuliang<=5 then
    local mintime=999
    local minhp=100
    local timeindex=0
    local hpindex=0
    local bftime=0
    --全员补腐蚀
    for i=1,shuliang do
        bftime=nowarr[i]["fsst"]
        if not bftime then bftime = 0 end
        if bftime>0 and time()-nowarr[i]["lasttime"]<=3 then bftime=15 end
        if bftime<mintime then mintime=bftime timeindex=i end
        --print("第"..i.."个怪;buff剩余"..bftime.."秒;当前最低"..mintime.."秒")
        if nowarr[i]["hp%"]<minhp then minhp=nowarr[i]["hp%"] hpindex=i end
        if bftime<=0.5 or (nowarr[i]["hp%"]<35 and nowarr[i]["zs"]==false) then 
            alan("LCastSpell(47813,'"..nowarr[i]["id"].."')")
            if nowarr[i]["hp%"]<35 then nowarr[i]["zs"]=true end
            nowarr[i]["fss"]=true
            nowarr[1]["fb"]=baoji
            nowarr[i]["lasttime"]=time()
            save(nowarr)           
            return 
        end
    end

    --鬼影
    if BeeSpellCD("鬼影缠身")==0 then
        for i=1,shuliang do
            local list=GetBuffList(nowarr[i]["id"])
            bftime=Li.FindBuff(list, "鬼影缠身", mid)
            if bftime<=0 and BeeIsRun("鬼影缠身") then 
                alan("LCastSpell(59164,'"..nowarr[i]["id"].."')") 
                nowarr[i]["lasttime"]=time()
                save(nowarr)
                return 
            end
        end
    end

    --瞬发暗影箭补最短腐蚀
    if (BeeStringFind("暗影冥思",mybuff) or mintime<shuliang*2) and BeeIsRun("暗影箭") then 
        alan("LCastSpell(47809,'"..nowarr[timeindex]["id"].."')") 
        nowarr[timeindex]["lasttime"]=time()
        save(nowarr)
        return 
    end
    
    if minhp<25 then 
        if not BeeStringFind("根除",mybuff) then 
            SetVariable("gczs",false) 
        else
            SetVariable("gczs",true)
        end
        SelectM(nowarr[hpindex]["id"])
        BeeRun("吸取灵魂")
        return 
    elseif minhp>25 and mintime>shuliang*2 and BeeIsRun("痛苦无常") then 
        for i=1,shuliang do
            local list=GetBuffList(nowarr[i]["id"])
            local bftime=Li.FindBuff(list, "痛苦无常", mid)
            if bftime<=0 then 
                alan("LCastSpell(47843,'"..nowarr[i]["id"].."')") 
                nowarr[i]["tk"]=time()
                save(nowarr)
                return 
            end
        end
    end

    if BeeIsRun("暗影箭") then 
        alan("LCastSpell(47809,'"..nowarr[timeindex]["id"].."')") 
        nowarr[timeindex]["lasttime"]=time()
        save(nowarr)
        return 
    end

end

if shuliang>5 then
    --for k,v
    
end
