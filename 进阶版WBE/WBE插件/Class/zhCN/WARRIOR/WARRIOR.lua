if GetLocale() ~= "zhCN" then
	return;
end

local SpellErrList={};

local playerClass, englishClass = UnitClass("player");

if englishClass ~= "WARRIOR" then
	return;
end

local frame = CreateFrame("Frame");

frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame:RegisterEvent("COMBAT_TEXT_UPDATE");

local Shapeshift={}; --姿态名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿态本地名称

--鲁莽,1719,鲁莽,鲁莽,ID对照不了原来的名称;  盾墙,871,盾墙,盾墙,ID对照不了原来的名称;

if GetLocale() == "zhCN" then
	Shapeshift[1]="战斗";
	Shapeshift[2]="防御";
	Shapeshift[3]="狂暴";
	
	spellSubNameErrText["等级"]="姿态";
	ShapeshiftName = "姿态";
end

local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志


SpellIds["复仇(防御姿态)"] = 6572;
SpellIds["压制(战斗姿态)"] = 7384;
SpellIds["雷霆一击(战斗，防御姿态)"] = 	6343;
SpellIds["命令怒吼"] = 	469;
SpellIds["战斗怒吼"] = 	6673;
SpellIds["挑战怒吼"] = 	1161;
SpellIds["挫志怒吼"] = 	1160;
SpellIds["旋风斩(狂暴姿态)"] = 	1680;
SpellIds["狂怒回复"] = 	55694;
SpellIds["狂暴之怒"] = 	18499;
SpellIds["破胆怒吼"] = 	5246;
SpellIds["鲁莽"] = 	1719;

SpellIds["法术反射(战斗、防御姿态)"] = 	23920;
SpellIds["盾墙"] = 	871;
SpellIds["盾牌格挡(防御姿态)"] = 	2565;
SpellIds["破釜沉舟"] = 	12975;
SpellIds["震荡波"] = 	46968;
SpellIds["防御姿态"] = 	71;
SpellIds["狂暴姿态"] = 	2458;
SpellIds["战斗姿态"] = 	2457;

SpellIds["横扫攻击(战斗，狂暴姿态)"]  = 	12328;
SpellIds["致命平静"] = 	85730;
SpellIds["击倒(战斗姿态)"] = 	85388;
SpellIds["剑刃风暴(等级 1)"] = 	9632;
SpellIds["刺耳怒吼"]  = 	12323;
SpellIds["死亡之愿"]  = 	12292;
SpellIds["怒击"]  = 	58390;
SpellIds["暴怒"]  = 	6613;
SpellIds["英勇之怒"] = 	60970;
SpellIds["乘胜追击"] =  34428;
SpellIds["持久追击雕文"] =  58104;

SpellIds["巨人打击(战斗，狂暴姿态)"] =  86346;
SpellIds["怒火中烧"] =  1134;
SpellIds["英勇飞跃"] =  6544;

SpellIds["冲锋(战斗姿态)"] = 	100;

SpellIds["援护(防御姿态)"] = 	3411;
SpellIds["拦截(狂暴姿态)"] = 	20252;
SpellIds["战神"] =  57499;

SpellIds["猛击"] =  1464;
SpellIds["拳击"] = 	6552;
SpellIds["集结呐喊"] = 	97462;

---CTM-
SpellIds["射击"]=3018;
SpellIds["投掷"]=2764;
SpellIds["攻击"]=88163;
SpellIds["自动攻击"]=6603;
SpellIds["反击风暴"]=20230;
SpellIds["撕裂(战斗，防御姿态)"]=772;
SpellIds["断筋(战斗，狂暴姿态)"]=1715;
SpellIds["英勇打击"]=78;
SpellIds["重击"]=88161;
SpellIds["英勇投掷"]=57755;
SpellIds["碎裂投掷(战斗姿态)"]=64382;
SpellIds["斩杀(战斗，狂暴姿态)"]=5308;
SpellIds["顺劈斩"]=845;
SpellIds["嘲讽(防御姿态)"]=355;
SpellIds["破甲攻击"]=7386;
SpellIds["缴械(防御姿态)"]=676

 
SpellIds["剑刃风暴"]=46924;  
SpellIds["致死打击"]=12294; 

SpellIds["毁灭打击"]=20243; 
SpellIds["盾牌猛击"]=23922;

SpellIds["强化断筋"]=23694;
------

BuffName["持久追击雕文"] = GetSpellInfo(SpellIds["持久追击雕文"]);
BuffName["强化断筋"] = GetSpellInfo(SpellIds["强化断筋"]);




NoSpellTarget[SpellIds["雷霆一击(战斗，防御姿态)"]] = 	true;
NoSpellTarget[SpellIds["命令怒吼"]] = 	true;
NoSpellTarget[SpellIds["战斗怒吼"]] = 	true;
NoSpellTarget[SpellIds["挑战怒吼"]] = 	true;
NoSpellTarget[SpellIds["挫志怒吼"]] = 	true;
NoSpellTarget[SpellIds["旋风斩(狂暴姿态)"]] = 	true;
NoSpellTarget[SpellIds["狂怒回复"]] = 	true;
NoSpellTarget[SpellIds["狂暴之怒"]] = 	true;
NoSpellTarget[SpellIds["破胆怒吼"]] = 	true;
NoSpellTarget[SpellIds["鲁莽"]] = 	true;

NoSpellTarget[SpellIds["法术反射(战斗、防御姿态)"]] = 	true;
NoSpellTarget[SpellIds["盾墙"]] = 	true;
NoSpellTarget[SpellIds["盾牌格挡(防御姿态)"]] = 	true;
NoSpellTarget[SpellIds["破釜沉舟"]] = 	true;
NoSpellTarget[SpellIds["震荡波"]] = 	true;
NoSpellTarget[SpellIds["防御姿态"]] = true;
NoSpellTarget[SpellIds["狂暴姿态"]] = 	true;
NoSpellTarget[SpellIds["战斗姿态"]] = 	true;


NoSpellTarget[SpellIds["致命平静"]] = 	true;
NoSpellTarget[SpellIds["剑刃风暴(等级 1)"]] = 	true;
NoSpellTarget[SpellIds["刺耳怒吼"]]  = 	true;
NoSpellTarget[SpellIds["死亡之愿"]]  = 	true;
NoSpellTarget[SpellIds["暴怒"]]  = 	true;
NoSpellTarget[SpellIds["英勇之怒"]] = 	true;

NoSpellTarget[SpellIds["怒火中烧"]] = 	true;
NoSpellTarget[SpellIds["英勇飞跃"]] = 	true;
NoSpellTarget[SpellIds["集结呐喊"]] = 	true;

-------CTM---

NoSpellTarget[SpellIds["反击风暴"]] = 	true;

-----------

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

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
		
		if arg9 == SpellIds["复仇(防御姿态)"] then
			
			if not spellinf[arg9] then
				spellinf[arg9]={};
			end
			spellinf[arg9]["Cast"]=GetTime();
			spellinf[arg9]["ActivationTime"]=GetTime();
		elseif arg9 == SpellIds["压制(战斗姿态)"] then
		
			if not spellinf[arg9] then
				spellinf[arg9]={};
			end
			spellinf[arg9]["Cast"]=GetTime();
			spellinf[arg9]["ActivationTime"]=GetTime();
		
		elseif arg9 == SpellIds["乘胜追击"] then
		
		
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
			if GetSpellInfo(SpellIds["复仇(防御姿态)"]) == arg2 then
				BeeSpellIsActivation_Event_Revenge();
			elseif GetSpellInfo(SpellIds["压制(战斗姿态)"]) == arg2 then
				BeeSpellIsActivation_Event_Suppress();
			elseif GetSpellInfo(SpellIds["乘胜追击"]) == arg2 then
				BeeSpellIsActivation_Event_34428();
			end
		end
	end
end

frame:SetScript("OnEvent", Activation_OnEvent);
spellinf = spellinf or {};

function BeeSpellIsActivation_Event_34428()

	if not spellinf[SpellIds["乘胜追击"]] then
		spellinf[SpellIds["乘胜追击"]]={};
	end		
	spellinf[SpellIds["乘胜追击"]]["ActivationTime"]=GetTime();
end

function BeeSpellIsActivation_Event_Revenge()

	if not spellinf[SpellIds["复仇(防御姿态)"]] then
		spellinf[SpellIds["复仇(防御姿态)"]]={};
	end		
	spellinf[SpellIds["复仇(防御姿态)"]]["ActivationTime"]=GetTime();
end

function BeeSpellIsActivation_Event_Suppress()

	if not spellinf[SpellIds["压制(战斗姿态)"]] then
		spellinf[SpellIds["压制(战斗姿态)"]]={};
	end
	spellinf[SpellIds["压制(战斗姿态)"]]["ActivationTime"]=GetTime();
	spellinf[SpellIds["压制(战斗姿态)"]]["destGUID"]=UnitGUID("target");
end

function BeeSpellIsActivation(Id,unit) --处理被激活技能
--[[
	if Id == SpellIds["复仇(防御姿态)"] then 
		
		return BeeSpellIsActivation_Revenge(Id);
		
	elseif Id == SpellIds["压制(战斗姿态)"] then 
		
		return BeeSpellIsActivation_Suppress(Id,unit);
		
	elseif Id == SpellIds["乘胜追击"] then 
		
		return BeeSpellIsActivation_34428(Id);
	
	else
		return true;
	end
	--]]
	return true;
end

function BeeSpellIsActivation_34428(Id) --乘胜追击
	
	local n = 20;
	
	if select(3,GetShapeshiftFormInfo(2)) and spellinf[Id] and spellinf[Id]["ActivationTime"] then
	
		local IsGlyph = BeeGetGlyphSocketInfo(BuffName["持久追击雕文"]);
		if IsGlyph then
			n = 25;
		end
		
		if GetTime() - spellinf[Id]["ActivationTime"] <=n then
			
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

function BeeSpellIsActivation_Revenge(Id) --复仇(防御姿态)

	if select(3,GetShapeshiftFormInfo(2)) and spellinf[Id] and spellinf[Id]["ActivationTime"] then
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

function BeeSpellIsActivation_Suppress(Id,unit) --压制

	if select(3,GetShapeshiftFormInfo(1)) and spellinf[Id] and spellinf[Id]["ActivationTime"] and spellinf[SpellIds["压制(战斗姿态)"]]["destGUID"] == UnitGUID(unit) then
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

function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true
end

function BeeGetShapeshiftIds(spellSubName) -- 获得技能姿态要求
	
	local t = "";

	if not strfind(spellSubName,ShapeshiftName) then
		return t;
	end
	
	for i,v in pairs(Shapeshift) do
		if strfind(spellSubName,v) then
			t = t .. i;
		end
	end
	
	return t;
end

function BeeSpellIsShapeshift(SpellId) -- 判断技能是否姿态是否符合

	local spellName, spellSubName = GetSpellInfo(SpellId);
	
	if not spellSubName or spellSubName == "" then
		return true;
	end
	
	if (SpellId == SpellIds["冲锋(战斗姿态)"] or SpellId == SpellIds["援护(防御姿态)"] or SpellId == SpellIds["拦截(狂暴姿态)"]) and BeeTalentInfo("战神") then
		return true;
	end
	
	local Shapeshifts = BeeGetShapeshiftIds(spellSubName)
	
	if Shapeshifts ~= "" then
		
		local Shapeshift = tostring(BeeGetShapeshiftId());
		if strfind(Shapeshifts,Shapeshift) then
			return true;
		else
			return false;
		end
	else
		return true;
	end
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId];
end

function BeeSpellIsMove(Id,unit,name) --处理移动中能施放的技能
	if Id == SpellIds["猛击"] then 
		return true;
	end
end





local InternalCDFrame = CreateFrame("Frame");
local InternalCDFrame_u = 0 ;
local TalentName_12289 = GetSpellInfo(12289) --强化断筋

local function InternalCDFrame_OnEvent(self, event, ...)

	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;

	if tonumber((select(4, GetBuildInfo()))) >= 40200 then	
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,_,arg6,arg7,arg8,_,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	else
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	end
	
	
	if "COMBAT_LOG_EVENT_UNFILTERED" == event then
	
		if UnitGUID("player") == arg3 and arg2 == "SPELL_AURA_APPLIED" then
				
			if BuffName["强化断筋"] == arg10 then
			
				local n = BeeTalentInfo(TalentName_12289);
				
				if n >0 then
					
					if not InternalCDTbl[BuffName["强化断筋"]] then
						InternalCDTbl[BuffName["强化断筋"]]={};
					end
					
					if n == 1 then
						InternalCDTbl[BuffName["强化断筋"]]["Cycle"]=60;
					elseif n == 2 then
						InternalCDTbl[BuffName["强化断筋"]]["Cycle"]=30;
					end
					InternalCDTbl[BuffName["强化断筋"]]["time"]=GetTime();
				else
					InternalCDTbl[BuffName["强化断筋"]]=nil;
				end
			end
		end
	end
end

InternalCDFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
InternalCDFrame:SetScript("OnEvent", InternalCDFrame_OnEvent);

