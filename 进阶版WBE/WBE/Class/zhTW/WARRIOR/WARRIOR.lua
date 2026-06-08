if GetLocale() ~= "zhTW" then
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

local Shapeshift={}; --姿態名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿態本地名称


 --魯莽,1719,魯莽,魯莽,ID對照不了原來的名稱;  盾牆,871,盾牆,盾牆,ID對照不了原來的名稱;

if GetLocale() == "zhTW" then
	
	Shapeshift[1]="戰鬥";
	Shapeshift[2]="防禦";
	Shapeshift[3]="狂暴";
	
	spellSubNameErrText["等級"]="姿態";
	ShapeshiftName = "姿態";
end

local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志


SpellIds["復仇(防禦姿態)"] = 6572;
SpellIds["壓制(戰鬥姿態)"] = 7384;
SpellIds["雷霆一擊(戰鬥，防禦姿態)"] = 	6343;
SpellIds["命令之吼"] = 	469;
SpellIds["戰鬥怒吼"] = 	6673;
SpellIds["挑戰怒吼"] = 	1161;
SpellIds["挫志怒吼"] = 	1160;
SpellIds["旋風斬(狂暴姿態)"] = 	1680;
SpellIds["狂怒恢復"] = 	55694;
SpellIds["狂暴之怒"] = 	18499;
SpellIds["破膽怒吼"] = 	5246;
SpellIds["魯莽"] = 	1719;

SpellIds["法術反射(戰鬥，防禦姿態)"] = 	23920;
SpellIds["盾牆"] = 	871;
SpellIds["盾牌格擋(防禦姿態)"] = 	2565;
SpellIds["破釜沉舟"] = 	12975;
SpellIds["震懾波"] = 	46968;
SpellIds["防禦姿態"] = 	71;
SpellIds["狂暴姿態"] = 	2458;
SpellIds["戰鬥姿態"] = 	2457;

SpellIds["橫掃攻擊(戰鬥，狂暴姿態)"]  = 	12328;
SpellIds["沉著殺機"] = 	85730;
SpellIds["撂倒(戰鬥姿態)"] = 	85388;
SpellIds["劍刃風暴(等級 1)"] = 	9632;
SpellIds["刺耳怒吼"]  = 	12323;
SpellIds["死亡之願"]  = 	12292;
SpellIds["狂怒之擊"]  = 	58390;
SpellIds["暴怒"]  = 	6613;
SpellIds["英勇烈怒"] = 	60970;
SpellIds["勝利衝擊"] =  34428;
SpellIds["持久勝利雕紋"] =  58104;

SpellIds["巨像碎擊(戰鬥，狂暴姿態)"] =  86346;
SpellIds["心靈之怒"] =  1134;
SpellIds["英勇躍擊"] =  6544;

SpellIds["衝鋒(戰鬥姿態)"] = 	100;

SpellIds["阻擾(防禦姿態)"] = 	3411;
SpellIds["攔截(狂暴姿態)"] = 	20252;
SpellIds["征戰者"] =  57499;

SpellIds["猛擊"] =  1464;
SpellIds["拳擊"] = 	6552;
SpellIds["振奮咆哮"] = 	97462;

BuffName["持久勝利雕紋"] = GetSpellInfo(SpellIds["持久勝利雕紋"]);

--無目標(種族特殊技能內碼對應表)
SpellIds["石像形態(種族特長)"] = 20594;
SpellIds["狂暴(種族特長)"] = 26297;
SpellIds["奧流之術(種族特長)"] = 28730;
SpellIds["血之烈怒(種族特長)"] = 	20572;

NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true;
NoSpellTarget[SpellIds["狂暴(種族特長)"]] =  true;
NoSpellTarget[SpellIds["奧流之術(種族特長)"]] =  true;
NoSpellTarget[SpellIds["血之烈怒(種族特長)"]] =  true;

NoSpellTarget[SpellIds["雷霆一擊(戰鬥，防禦姿態)"]] = 	true;
NoSpellTarget[SpellIds["命令之吼"]] = 	true;
NoSpellTarget[SpellIds["戰鬥怒吼"]] = 	true;
NoSpellTarget[SpellIds["挑戰怒吼"]] = 	true;
NoSpellTarget[SpellIds["挫志怒吼"]] = 	true;
NoSpellTarget[SpellIds["旋風斬(狂暴姿態)"]] = 	true;
NoSpellTarget[SpellIds["狂怒恢復"]] = 	true;
NoSpellTarget[SpellIds["狂暴之怒"]] = 	true;
NoSpellTarget[SpellIds["破膽怒吼"]] = 	true;
NoSpellTarget[SpellIds["魯莽"]] = 	true;

NoSpellTarget[SpellIds["法術反射(戰鬥，防禦姿態)"]] = 	true;
NoSpellTarget[SpellIds["盾牆"]] = 	true;
NoSpellTarget[SpellIds["盾牌格擋(防禦姿態)"]] = 	true;
NoSpellTarget[SpellIds["破釜沉舟"]] = 	true;
NoSpellTarget[SpellIds["震懾波"]] = 	true;
NoSpellTarget[SpellIds["防禦姿態"]] = true;
NoSpellTarget[SpellIds["狂暴姿態"]] = 	true;
NoSpellTarget[SpellIds["戰鬥姿態"]] = 	true;



NoSpellTarget[SpellIds["沉著殺機"]] = 	true;
NoSpellTarget[SpellIds["劍刃風暴(等級 1)"]] = 	true;
NoSpellTarget[SpellIds["刺耳怒吼"]]  = 	true;
NoSpellTarget[SpellIds["死亡之願"]]  = 	true;
NoSpellTarget[SpellIds["暴怒"]]  = 	true;
NoSpellTarget[SpellIds["英勇烈怒"]] = 	true;

NoSpellTarget[SpellIds["心靈之怒"]] = 	true;
NoSpellTarget[SpellIds["英勇躍擊"]] = 	true;
NoSpellTarget[SpellIds["振奮咆哮"]] = 	true;

-------CTM---

NoSpellTarget[SpellIds["反击风暴(战斗姿态)"]] = 	true;

-----------

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

local function Activation_Event_CastSpell(self, event, ...)

	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = ...;
	--local _, _, prefix, suffix = string.find(arg2, "(.-)_(.+)");

	if arg2 == "SPELL_CAST_SUCCESS" and arg3 and UnitGUID("player") == arg3 then
		
		if arg9 == SpellIds["復仇(防禦姿態)"] then
			
			if not spellinf[arg9] then
				spellinf[arg9]={};
			end
			spellinf[arg9]["Cast"]=GetTime();
			spellinf[arg9]["ActivationTime"]=GetTime();
		elseif arg9 == SpellIds["壓制(戰鬥姿態)"] then
		
			if not spellinf[arg9] then
				spellinf[arg9]={};
			end
			spellinf[arg9]["Cast"]=GetTime();
			spellinf[arg9]["ActivationTime"]=GetTime();
		
		elseif arg9 == SpellIds["勝利衝擊"] then
		
		
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
	local arg1,arg2 = select(1, ...);
	local arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	
	if ( event == "COMBAT_LOG_EVENT_UNFILTERED" )  then
		Activation_Event_CastSpell(self, event, ...)
	elseif ( event == "COMBAT_TEXT_UPDATE" )  then
        if (arg1 == "SPELL_ACTIVE") then
				if GetSpellInfo(SpellIds["復仇(防禦姿態)"]) == arg2 then
				BeeSpellIsActivation_Event_Revenge();
				elseif GetSpellInfo(SpellIds["壓制(戰鬥姿態)"]) == arg2 then
				BeeSpellIsActivation_Event_Suppress();
				elseif GetSpellInfo(SpellIds["勝利衝擊"]) == arg2 then
				BeeSpellIsActivation_Event_34428();
			end
		end
	end
end

frame:SetScript("OnEvent", Activation_OnEvent);
spellinf = spellinf or {};

function BeeSpellIsActivation_Event_34428()

	if not spellinf[SpellIds["勝利衝擊"]] then

		spellinf[SpellIds["勝利衝擊"]]={};
	end		
	spellinf[SpellIds["勝利衝擊"]]["ActivationTime"]=GetTime();
end

function BeeSpellIsActivation_Event_Revenge()

	if not spellinf[SpellIds["復仇(防禦姿態)"]] then

		spellinf[SpellIds["復仇(防禦姿態)"]]={};
	end		
	spellinf[SpellIds["復仇(防禦姿態)"]]["ActivationTime"]=GetTime();
end

function BeeSpellIsActivation_Event_Suppress()

	if not spellinf[SpellIds["壓制(戰鬥姿態)"]] then

		spellinf[SpellIds["壓制(戰鬥姿態)"]]={};
		
	end
		
		spellinf[SpellIds["壓制(戰鬥姿態)"]]["ActivationTime"]=GetTime();
		spellinf[SpellIds["壓制(戰鬥姿態)"]]["destGUID"]=UnitGUID("target");
end

function BeeSpellIsActivation(Id,unit) --处理被激活技能
--[[
	if Id == SpellIds["復仇(防禦姿態)"] then 
		
		return BeeSpellIsActivation_Revenge(Id);
		
	elseif Id == SpellIds["壓制(戰鬥姿態)"] then 
		
		return BeeSpellIsActivation_Suppress(Id,unit);
		
	elseif Id == SpellIds["勝利衝擊"] then 
		
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
	
		local IsGlyph = BeeGetGlyphSocketInfo(BuffName["持久勝利雕紋"]);
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

function BeeSpellIsActivation_Revenge(Id) --復仇(防禦姿態)

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

function BeeSpellIsActivation_Suppress(Id,unit) --壓制

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
	
	if (SpellId == SpellIds["衝鋒(戰鬥姿態)"] or SpellId == SpellIds["阻擾(防禦姿態)"] or SpellId == SpellIds["攔截(狂暴姿態)"]) and BeeTalentInfo("征戰者") then
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
	if Id == SpellIds["猛擊"] then 
		return true;
	end
end
