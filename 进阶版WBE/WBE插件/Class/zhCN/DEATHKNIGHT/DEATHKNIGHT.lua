if GetLocale() ~= "zhCN" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "DEATHKNIGHT" then
	return;
end

local frame = CreateFrame("Frame");

frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame:RegisterEvent("COMBAT_TEXT_UPDATE");

local Shapeshift={}; --姿态名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿态本地名称

if GetLocale() == "zhCN" then
end


local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志
local SpellRune = {};	--需要符文

--冰天赋

SpellIds["冰封之韧"] =     48792;
SpellIds["冰霜之路"] =     3714;
SpellIds["冰霜之柱"] =     51271;
SpellIds["冰霜灵气"] =     48266;
SpellIds["寒冬号角"] =     57330;
SpellIds["饥饿之寒"] =     49203;
SpellIds["巫妖之躯"] =     49039;
SpellIds["符文武器增效"] =     47568;

--血天赋
SpellIds["天灾契约"] =     48743;
SpellIds["血液沸腾"] =     48721;
SpellIds["符文刃舞"] =     49028;
SpellIds["符文分流"] =     48982;
SpellIds["凛风冲击"] =     55233;
SpellIds["鲜血灵气"] =     48263;
SpellIds["白骨之盾"] =     49222;
SpellIds["活力分流"] =     45529;
SpellIds["吸血鬼之血"]=55233;

--邪天赋
SpellIds["亡者大军"] =     42650;
SpellIds["反魔法领域"] =     51052;
SpellIds["反魔法护罩"] =     48707;
SpellIds["召唤石像鬼"] =     49206;
SpellIds["黑锋之门"] =     50977;
SpellIds["枯萎凋零"] =     43265;
SpellIds["亡者复生"] =     46584;
SpellIds["复活盟友"] =     61999;
SpellIds["邪恶灵气"] =     48265;
SpellIds["黑暗突变"] =     63560;

SpellIds["符文熔铸"]=53428;  
SpellIds["自动攻击"]=6603;  
SpellIds["爆发"]=77575;  
SpellIds["黑暗模拟"]=77606;  


--需激活技能
SpellIds["符文打击"] =     56815;
--当自身闪躲招架后技能条图标变亮 需目标

SpellIds["暗影灌注"] =     45772;
BuffName["暗影灌注"]= GetSpellInfo(SpellIds["暗影灌注"]);
BuffName["鲜血灵气"]= GetSpellInfo(SpellIds["鲜血灵气"]);
--需玩家宠物身上buff 层数 "暗影灌注" =5 后技能条图标变亮 无需目标

--需要目标的技能
SpellIds["灵界打击"] =         49998; 
SpellIds["传染"] =         50842;
SpellIds["心脏打击"] =         55050;  
SpellIds["符文刃舞"] =         49028;
SpellIds["绞袭"] =         47476;
SpellIds["鲜血打击"] =         45902;
SpellIds["黑暗命令"] =         56222;
SpellIds["冰冷触摸"] =         45477;         
SpellIds["寒冰锁链"] =         45524;
SpellIds["心灵冰冻"] =         47528;
SpellIds["湮没"] =         49020;
SpellIds["符文打击"] =         56815;
SpellIds["脓疮打击"] =         85948;
SpellIds["死亡之握"] =         49576;
SpellIds["凋零缠绕"] =         47541;
SpellIds["暗影打击"] =         45462;
SpellIds["天灾打击"] = 55090;
SpellIds["死疽打击"] = 73975;
SpellIds["冰霜打击"] =         49143;
SpellIds["凛风冲击"] =         49184;


NoSpellTarget[SpellIds["黑暗突变"]] =     true;

NoSpellTarget[SpellIds["冰封之韧"]] =     true;
NoSpellTarget[SpellIds["冰霜之路"]] =     true;
NoSpellTarget[SpellIds["冰霜之柱"]] =     true;
NoSpellTarget[SpellIds["冰霜灵气"]] =     true;
NoSpellTarget[SpellIds["寒冬号角"]] =     true;
NoSpellTarget[SpellIds["饥饿之寒"]] =     true;
NoSpellTarget[SpellIds["巫妖之躯"]] =     true;
NoSpellTarget[SpellIds["符文武器增效"]] =     true;

--血天赋
NoSpellTarget[SpellIds["天灾契约"]] =     true;
NoSpellTarget[SpellIds["血液沸腾"]] =     true;
NoSpellTarget[SpellIds["符文分流"]] =     true;
NoSpellTarget[SpellIds["凛风冲击"]] =     true;
NoSpellTarget[SpellIds["鲜血灵气"]] =     true;
NoSpellTarget[SpellIds["白骨之盾"]] =     true;
NoSpellTarget[SpellIds["活力分流"]] =     true;
NoSpellTarget[SpellIds["吸血鬼之血"]] =     true;

--邪天赋
NoSpellTarget[SpellIds["亡者大军"]] =     true;
NoSpellTarget[SpellIds["反魔法领域"]] =     true;
NoSpellTarget[SpellIds["反魔法护罩"]] =     true;
NoSpellTarget[SpellIds["召唤石像鬼"]] =     true;
NoSpellTarget[SpellIds["黑锋之门"]] =     true;
NoSpellTarget[SpellIds["枯萎凋零"]] =     true;
NoSpellTarget[SpellIds["亡者复生"]] =     true;
NoSpellTarget[SpellIds["复活盟友"]] =     true;
NoSpellTarget[SpellIds["邪恶灵气"]] =     true;
NoSpellTarget[SpellIds["黑暗突变"]] =     true;

NoSpellTarget[SpellIds["黑暗模拟"]] =     true;
NoSpellTarget[SpellIds["符文熔铸"]] =     true;


    -- 1 血魄符文
    -- 2 秽邪符文
    -- 3 冰霜符文
    -- 4 死亡符文

SpellRune[SpellIds["冰霜之路"]] =     {0,0,1};    --1个冰霜符文
SpellRune[SpellIds["冰霜之柱"]] =    {0,0,1};  --1个冰霜符文
SpellRune[SpellIds["血液沸腾"]] =    {1,0,0};  --1个血魄符文
SpellRune[SpellIds["符文分流"]] =    {1,0,0};  --1个血魄符文
SpellRune[SpellIds["白骨之盾"]] =    {0,1,0};  --1个秽邪符文
--SpellRune[SpellIds["活力分流"]] =    {1,0,0};  --1个血魄符文
SpellRune[SpellIds["亡者大军"]] =    {1,1,1};  --1血魄1秽邪1冰霜
SpellRune[SpellIds["反魔法领域"]] =    {0,1,0};  --1个秽邪符文
SpellRune[SpellIds["黑锋之门"]] =    {0,1,0};     --1个秽邪符文
SpellRune[SpellIds["枯萎凋零"]] =    {0,1,0};    --1个秽邪符文
SpellRune[SpellIds["黑暗突变"]] =    {0,1,0};    --1个秽邪符文
--SpellRune[SpellIds["黑暗突变"]] =   {0,1,0};  --1点秽邪符文


--需要目标的技能
SpellRune[SpellIds["灵界打击"]] =        {0,1,1};                     -- 1冰1邪
SpellRune[SpellIds["传染"]] =        {1,0,0};                     -- 1血
SpellRune[SpellIds["心脏打击"]] =        {1,0,0};                     -- 1血
SpellRune[SpellIds["绞袭"]] =        {1,0,0};                         --     1血
SpellRune[SpellIds["鲜血打击"]] =        {1,0,0};                     -- 1血
SpellRune[SpellIds["冰冷触摸"]] =        {0,0,1};                     -- 1冰
SpellRune[SpellIds["寒冰锁链"]] =        {0,0,1};                      --1冰
SpellRune[SpellIds["湮没"]] =        {0,1,1};                         --     1冰1邪
SpellRune[SpellIds["脓疮打击"]] =        {1,0,1};                     -- 1血1冰
SpellRune[SpellIds["暗影打击"]] =        {0,1,0};                     -- 1邪
SpellRune[SpellIds["天灾打击"]] =        {0,1,0};                      --       1邪
SpellRune[SpellIds["死疽打击"]] =        {0,1,0};                     --        1邪/83级开放
SpellRune[SpellIds["凛风冲击"]] =        {0,0,1};                     -- 1冰 

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

local function BeeSpellRune_Requirements(id)
	local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(id);
	if powerType ~= 5 then
		return true;
	elseif not SpellRune[id] then
		return true;
	--elseif not SpellRune[id] and powerType == 5 then
	
		--print("无法判断符文数量，请和作者联繫。")
		--return false; 
	end
	
	local Rune1 = BeeRuneCount(1);
	local Rune2 = BeeRuneCount(2);
	local Rune3 = BeeRuneCount(3);
	local Rune4 = BeeRuneCount(4);
	
	local Rune = SpellRune[id];
	
	if Rune1 < Rune[1] then
		if Rune4 >= Rune[1] then
			Rune4 = Rune4 - Rune[1] ;
		else
			return false
		end
	end
	
	
	if Rune2 < Rune[2] then
		if Rune4 >= Rune[2] then
			Rune4 = Rune4 - Rune[2] ;
		else
			return  false
		end
	end
	
	if Rune3 < Rune[3] then
		if Rune4 >= Rune[3] then
			Rune4 = Rune4 - Rune[3] ;
		else
			return false
		end
	end
	
	return true;
end
spellinf = spellinf or {};

local function Activation_Event_CastSpell(self, event, ...)

	--local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = ...;
	--local _, _, prefix, suffix = string.find(arg2, "(.-)_(.+)");
	
	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;

	if tonumber((select(4, GetBuildInfo()))) >= 40200 then	
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,_,arg6,arg7,arg8,_,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	else
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	end
	
	
	
	if arg2 == "SPELL_CAST_SUCCESS" and arg3 and UnitGUID("player") == arg3 then
		if arg9 == SpellIds["符文打击"] then
			
			if not spellinf[arg9] then
				spellinf[arg9]={};
			end
			spellinf[arg9]["Cast"]=GetTime();
			spellinf[arg9]["ActivationTime"]=GetTime();
		end
	end
end

local function Activation_OnEvent(self, event, ...) --处理被激活技能事件
	--local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = ...;
	
	--local arg1,arg2 = select(1, ...);
	--local arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	
	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;

	if tonumber((select(4, GetBuildInfo()))) >= 40200 then	
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,_,arg6,arg7,arg8,_,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	else
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	end

	
	if ( event == "COMBAT_LOG_EVENT_UNFILTERED" )  then
		Activation_Event_CastSpell(self, event, ...)
	elseif ( event == "COMBAT_TEXT_UPDATE" )  then
		if (arg1 == "SPELL_ACTIVE") then
			if GetSpellInfo(SpellIds["符文打击"]) == arg2 then
				BeeSpellIsActivation_Event_56815();
			end
		end
	end
end

frame:SetScript("OnEvent", Activation_OnEvent);

function BeeSpellIsActivation_Event_56815()
	if not spellinf[SpellIds["符文打击"]] then
		spellinf[SpellIds["符文打击"]]={};
	end
	spellinf[SpellIds["符文打击"]]["ActivationTime"]=GetTime();
end

function BeeSpellIsActivation(Id,unit) --处理被激活技能

	if not BeeSpellRune_Requirements(Id) then
		return false;
	end

	if Id == SpellIds["符文打击"] then 
		return BeeSpellIsActivation_56815(Id);
	elseif Id == SpellIds["黑暗突变"] then 
		return BeeSpellIsActivation_63560(Id);
	else
		return true;
	end
end

function BeeSpellIsActivation_56815(Id) --符文打击

	if UnitBuff("player", BuffName["鲜血灵气"]) and BeeUnitMana("player")>=30 then
		return true;
	end
	
	if spellinf and spellinf[Id] and spellinf[Id]["ActivationTime"] then
		
		if GetTime() - spellinf[Id]["ActivationTime"] <=5 then
			if spellinf[Id]["Cast"] then
				if spellinf[Id]["Cast"] < spellinf[Id]["ActivationTime"] then
					return true;
				else
					return false;
				end
			else
				return true;
			end
		end
		return false;
	end
	
	return false;
end

function BeeSpellIsActivation_63560(Id) --黑暗突变

	local bn = BeeUnitBuffCount(BuffName["暗影灌注"],"pet",2,0);
	
	if bn and bn >=5 then
		return true;
	else
		return false;
	end
end

function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true;
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId];
end


function BeeGetDkInfectionTargetInf()
	
	local v =0;
	local n = 0;
	local SWING = 0;
	local SWING1 = 0;
	local PeriodicTime;
	
	for i, data in pairs(DkInfectionTbl["buff"]) do
		
		if data["time"] then
			v = v +1;	
		end
		
		if data["Attack"] and (data["Attack"]=="SWING" or data["Attack"]=="<=15") then
			SWING= SWING +1;
		end
		
		if data["time"] and (data["Attack"]=="SWING" or data["Attack"]=="<=15") then
			SWING1= SWING1 +1;
		end
		
		if data["PeriodicTime"] then
			
			local a = 21 - (GetTime() - data["PeriodicTime"])
			if not PeriodicTime then
				PeriodicTime = a;
			else
				if a < PeriodicTime then
					PeriodicTime = a;
				end
			end
		end
		n= n +1;
	end
	
	if not PeriodicTime then
		PeriodicTime=0;
	end
		
		PeriodicTime = tonumber(format("%.2f", PeriodicTime));
	
	return n,v,n-v,SWING,SWING1,SWING-SWING1,PeriodicTime;
end

DkInfectionTbl={};
DkInfectionTbl["buff"]={};
DkInfectionTbl["血之疫病"]=55078;
DkInfectionTbl["血红热疫"]=81130;
DkInfectionTbl["冰霜疫病"]=55095;
DkInfectionTbl["血液沸腾"]=48721;
DkInfectionTbl["枯萎凋零"]=52212;

DkInfectionTbl["time"]=GetTime();

Bee_DK_UNIT_COMBAT_Frame = CreateFrame("Frame");
Bee_DK_UNIT_COMBAT_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
Bee_DK_UNIT_COMBAT_Frame:RegisterEvent("PARTY_MEMBERS_CHANGED");
Bee_DK_UNIT_COMBAT_Frame:RegisterEvent("RAID_ROSTER_UPDATE");

local DK_UnitGuids={};

local AffectingCombat = 0;

local function DecompositionEvent(v)
	return {strsplit("_",v)};
end

local function Bee_DK_UNIT_COMBAT_Frame_OnUpdate()
	
	if not DK_UnitGuids[UnitGUID("player")] then
		 DK_UnitGuids[UnitGUID("player")]="player";
	end
	 
	if GetTime() - DkInfectionTbl["time"] > 0.1 then
		DkInfectionTbl["time"]=GetTime();
		
		if UnitAffectingCombat("player") and AffectingCombat == 0 then
			AffectingCombat=1;
		end
		
		if AffectingCombat == 1 and (not UnitAffectingCombat("player") or  UnitIsCorpse("player") or UnitIsDeadOrGhost("player")) then
			if not UnitAffectingCombat("player") then
				AffectingCombat =0;
			end
			DkInfectionTbl["buff"]={};
		end
		
		for i, v in pairs(DkInfectionTbl["buff"]) do
			if (v["time"] and GetTime() - v["time"] > 4) or (v["AttackTime"] and GetTime() - v["AttackTime"] > 4) then
				DkInfectionTbl["buff"][i]=nil;				
			end
		end
	end
	
end

local function Bee_DK_UNIT_COMBAT_Frame_OnEvent(self, event, ...)
	--[[
	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;
		
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	--]]	
			--3,4
			--6,7
			--9,10
			
			
	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;

	if tonumber((select(4, GetBuildInfo()))) >= 40200 then	
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,_,arg6,arg7,arg8,_,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	else
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	end
	
	local PlayGuid = UnitGUID("player");	

	if ( event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" )  then
	
		local r = GetNumRaidMembers();
		local p = GetNumPartyMembers();
		
		DK_UnitGuids={};
		
		if r>0 then
			for i=1 , r do
				local u ="raid" .. tostring(i);
				local Guid = UnitGUID(u);
				if Guid then
					DK_UnitGuids[Guid]=u;
				end
			end
		elseif p > 0 then
			for i=1 , p do
				local u ="party" .. tostring(i);
				local Guid = UnitGUID(u);
				if Guid then
					DK_UnitGuids[Guid]=u;
				end
			end
		else
			DK_UnitGuids[PlayGuid]="player";
		end

	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED" and arg2 )  then
		local V = DecompositionEvent(arg2);
		if PlayGuid == arg6 and (V[2] == "DAMAGE" or V[2] == "MISSED" or V[3] == "DAMAGE" or V[3] == "MISSED") then
			if not DkInfectionTbl["buff"][arg3] then
				DkInfectionTbl["buff"][arg3]={};
			end
			
			DkInfectionTbl["buff"][arg3]["Attack"]=V[1];
			DkInfectionTbl["buff"][arg3]["AttackTime"] = GetTime();
		elseif arg3 and arg6 and (V[2] == "DAMAGE" or V[2] == "MISSED" or V[3] == "DAMAGE" or V[3] == "MISSED") then		
			if DK_UnitGuids[arg3] or DK_UnitGuids[arg6] then
								
				local u,id;
				
				if DK_UnitGuids[arg3] then
					u = DK_UnitGuids[arg3];
					id = arg6;
				elseif DK_UnitGuids[arg6] then
					u = DK_UnitGuids[arg6];
					id = arg3;
				end
				
				if V[1] == "SWING" and BeeRange(u)<=15 then
				
					if not DkInfectionTbl["buff"][id] then
						DkInfectionTbl["buff"][id]={};
					end
				
					DkInfectionTbl["buff"][id]["Attack"]=V[1];
					DkInfectionTbl["buff"][id]["AttackTime"] = GetTime();
					
					--print("<<",arg2,arg4,arg7,GetSpellInfo(arg9),arg9)
					
					--print(BeeGetDkInfectionTargetInf())
				end
				
				if PlayGuid == arg3 and arg6 and arg9 then
			
					if DkInfectionTbl["血液沸腾"] == arg9 or 
					DkInfectionTbl["枯萎凋零"] == arg9 then
					
						if not DkInfectionTbl["buff"][arg6] then
							DkInfectionTbl["buff"][arg6]={};
						end
					
						DkInfectionTbl["buff"][arg6]["Attack"]="<=15";
						DkInfectionTbl["buff"][arg6]["AttackTime"] = GetTime();
						--print(">>",arg2,arg4,arg7,GetSpellInfo(arg9),arg9)
					
					end
				end
			end
		end
		
		
		if arg2 == "SPELL_PERIODIC_DAMAGE" or arg2 == "SPELL_AURA_APPLIED" 
		 or arg2 == "SPELL_AURA_APPLIED_DOSE"  or arg2 == "SPELL_AURA_REMOVED_DOSE" 
		 or arg2 == "SPELL_AURA_REFRESH" then

			if PlayGuid == arg3 and arg6 and arg9 then
			
				if DkInfectionTbl["血之疫病"] == arg9 or 
				DkInfectionTbl["血红热疫"] == arg9 or 
				DkInfectionTbl["冰霜疫病"] == arg9 then
				
					if not DkInfectionTbl["buff"][arg6] then
						DkInfectionTbl["buff"][arg6]={};
					end
					DkInfectionTbl["buff"][arg6]["time"] = GetTime();
					DkInfectionTbl["buff"][arg6]["AttackTime"] = GetTime();
					
					if arg2 == "SPELL_AURA_APPLIED" or arg2 == "SPELL_AURA_REFRESH" then
						DkInfectionTbl["buff"][arg6]["PeriodicTime"] = GetTime();				
					end
					--print("<<",arg2,arg4,arg7,GetSpellInfo(arg9))
				end
			end
		
		elseif (PlayGuid == arg3 and arg2 == "SPELL_AURA_REMOVED") then
			
			if DkInfectionTbl["血之疫病"] == arg9 or 
				DkInfectionTbl["血红热疫"] == arg9 or 
				DkInfectionTbl["冰霜疫病"] == arg9 then
				DkInfectionTbl["buff"][arg6]=nil;
			end
		end
		
		if arg2 == "PARTY_KILL" or arg2 == "UNIT_DIED" then
			DkInfectionTbl["buff"][arg6]=nil;
		end
		
		--print("1>>",event,arg1,arg2,arg3,arg4)
	end
end

Bee_DK_UNIT_COMBAT_Frame:SetScript("OnEvent", Bee_DK_UNIT_COMBAT_Frame_OnEvent);
Bee_DK_UNIT_COMBAT_Frame:SetScript("OnUpdate",Bee_DK_UNIT_COMBAT_Frame_OnUpdate)
