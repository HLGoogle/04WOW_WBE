if GetLocale() ~= "zhTW" then
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

local Shapeshift={}; --姿態名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿態本地名称

if GetLocale() == "zhTW" then
end


local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志
local SpellRune = {};	--需要符文

--冰天賦

SpellIds["冰錮堅韌"] =     48792;
SpellIds["冰霜之徑"] =     3714;
SpellIds["冰霜之柱"] =     51271;
SpellIds["冰霜領域"] =     48266;
SpellIds["凜冬號角"] =     57330;
SpellIds["噬溫酷寒"] =     49203;
SpellIds["巫妖之軀"] =     49039;
SpellIds["強力符文武器"] =     47568;

--血天賦
SpellIds["死亡契約"] =     48743;
SpellIds["沸血術"] =     48721;
SpellIds["符文武器幻舞"] =     49028;
SpellIds["符文轉化"] =     48982;
SpellIds["血族之裔"] =     55233;
SpellIds["血魄領域"] =     48263;
SpellIds["骸骨之盾"] =     49222;
SpellIds["血魄轉化"] =     45529;

--邪天賦
SpellIds["亡靈大軍"] =     42650;
SpellIds["反魔法力場"] =     51052;
SpellIds["反魔法護罩"] =     48707;
SpellIds["召喚石像鬼"] =     49206;
SpellIds["死亡之門"] =     50977;
SpellIds["死亡凋零"] =     43265;
SpellIds["死者復生"] =     46584;
SpellIds["盟友復生"] =     61999;
SpellIds["穢邪領域"] =     48265;
SpellIds["黑暗變形"] =     63560;


--需激活技能
SpellIds["符文打擊"] =     56815;
--當自身閃躲招架后技能條圖標變亮 需目標

SpellIds["闇能灌注"] =     45772;
BuffName["闇能灌注"]= GetSpellInfo(SpellIds["闇能灌注"]);
BuffName["血魄領域"]= GetSpellInfo(SpellIds["血魄領域"]);
--需玩家寵物身上buff 層數 "闇能灌注" =5 后技能條圖標變亮 無需目標


--需要目標的技能
SpellIds["死亡打擊"] =         49998; 
SpellIds["瘟疫同化"] =         50842;
SpellIds["碎心打擊"] =         55050;  
SpellIds["符文武器幻舞"] =         49028;
SpellIds["絞殺"] =         47476;
SpellIds["血魄打擊"] =         45902;
SpellIds["黑暗敕令"] =         56222;
SpellIds["冰結之觸"] =         45477;         
SpellIds["冰鍊術"] =         45524;
SpellIds["心智冰封"] =         47528;
SpellIds["滅寂"] =         49020;
SpellIds["符文打擊"] =         56815;
SpellIds["膿瘡潰擊"] =         85948;
SpellIds["死亡之握"] =         49576;
SpellIds["死亡纏繞"] =         47541;
SpellIds["瘟疫打擊"] =         45462;
SpellIds["天譴打擊"] = 55090;
SpellIds["亡域打擊"] = 73975;
SpellIds["冰霜打擊"] =         49143;
SpellIds["凜風衝擊"] =         49184;

--無目標(種族特殊技能內碼對應表)
SpellIds["石像形態(種族特長)"] = 20594;
SpellIds["狂暴(種族特長)"] = 26297;
SpellIds["奧流之術(種族特長)"] = 50613;

NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true;
NoSpellTarget[SpellIds["狂暴(種族特長)"]] =  true;
NoSpellTarget[SpellIds["奧流之術(種族特長)"]] =  true;


NoSpellTarget[SpellIds["黑暗變形"]] =     true;

NoSpellTarget[SpellIds["冰錮堅韌"]] =     true;
NoSpellTarget[SpellIds["冰霜之徑"]] =     true;
NoSpellTarget[SpellIds["冰霜之柱"]] =     true;
NoSpellTarget[SpellIds["冰霜領域"]] =     true;
NoSpellTarget[SpellIds["凜冬號角"]] =     true;
NoSpellTarget[SpellIds["噬溫酷寒"]] =     true;
NoSpellTarget[SpellIds["巫妖之軀"]] =     true;
NoSpellTarget[SpellIds["強力符文武器"]] =     true;

--血天賦
NoSpellTarget[SpellIds["死亡契約"]] =     true;
NoSpellTarget[SpellIds["沸血術"]] =     true;
NoSpellTarget[SpellIds["符文轉化"]] =     true;
NoSpellTarget[SpellIds["血族之裔"]] =     true;
NoSpellTarget[SpellIds["血魄領域"]] =     true;
NoSpellTarget[SpellIds["骸骨之盾"]] =     true;
NoSpellTarget[SpellIds["血魄轉化"]] =     true;

--邪天賦
NoSpellTarget[SpellIds["亡靈大軍"]] =     true;
NoSpellTarget[SpellIds["反魔法力場"]] =     true;
NoSpellTarget[SpellIds["反魔法護罩"]] =     true;
NoSpellTarget[SpellIds["召喚石像鬼"]] =     true;
NoSpellTarget[SpellIds["死亡之門"]] =     true;
NoSpellTarget[SpellIds["死亡凋零"]] =     true;
NoSpellTarget[SpellIds["死者復生"]] =     true;
NoSpellTarget[SpellIds["盟友復生"]] =     true;
NoSpellTarget[SpellIds["穢邪領域"]] =     true;
NoSpellTarget[SpellIds["黑暗變形"]] =     true;



    -- 1 血魄符文
    -- 2 穢邪符文
    -- 3 冰霜符文
    -- 4 死亡符文


SpellRune[SpellIds["冰霜之徑"]] =     {0,0,1};    --1個冰霜符文
SpellRune[SpellIds["冰霜之柱"]] =    {0,0,1};  --1個冰霜符文
SpellRune[SpellIds["沸血術"]] =    {1,0,0};  --1個血魄符文
SpellRune[SpellIds["符文轉化"]] =    {1,0,0};  --1個血魄符文
SpellRune[SpellIds["骸骨之盾"]] =    {0,1,0};  --1個穢邪符文
--SpellRune[SpellIds["血魄轉化"]] =    {1,0,0};  --1個血魄符文
SpellRune[SpellIds["亡靈大軍"]] =    {1,1,1};  --1血魄1穢邪1冰霜
SpellRune[SpellIds["反魔法力場"]] =    {0,1,0};  --1個穢邪符文
SpellRune[SpellIds["死亡之門"]] =    {0,1,0};     --1個穢邪符文
SpellRune[SpellIds["死亡凋零"]] =    {0,1,0};    --1個穢邪符文
SpellRune[SpellIds["黑暗變形"]] =    {0,1,0};    --1個穢邪符文
--SpellRune[SpellIds["黑暗變形"]] =   {0,1,0};  --1點穢邪符文



--需要目標的技能
SpellRune[SpellIds["死亡打擊"]] =        {0,1,1};                     -- 1冰1邪
SpellRune[SpellIds["瘟疫同化"]] =        {1,0,0};                     -- 1血
SpellRune[SpellIds["碎心打擊"]] =        {1,0,0};                     -- 1血
SpellRune[SpellIds["絞殺"]] =        {1,0,0};                         --     1血
SpellRune[SpellIds["血魄打擊"]] =        {1,0,0};                     -- 1血
SpellRune[SpellIds["冰結之觸"]] =        {0,0,1};                     -- 1冰
SpellRune[SpellIds["冰鍊術"]] =        {0,0,1};                      --1冰
SpellRune[SpellIds["滅寂"]] =        {0,1,1};                         --     1冰1邪
SpellRune[SpellIds["膿瘡潰擊"]] =        {1,0,1};                     -- 1血1冰
SpellRune[SpellIds["瘟疫打擊"]] =        {0,1,0};                     -- 1邪
SpellRune[SpellIds["天譴打擊"]] =        {0,1,0};                      --       1邪
SpellRune[SpellIds["亡域打擊"]] =        {0,1,0};                     --        1邪/83級開放
SpellRune[SpellIds["凜風衝擊"]] =        {0,0,1};                     -- 1冰 

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

local function BeeSpellRune_Requirements(id)
	local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(id);
	if powerType ~= 5 then
		return true;
	elseif not SpellRune[id] then
		return true;
	--elseif not SpellRune[id] and powerType == 5 then
	
		--print("無法判斷符文數量，請和作者聯繫。")
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

	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = ...;
	--local _, _, prefix, suffix = string.find(arg2, "(.-)_(.+)");

	if arg2 == "SPELL_CAST_SUCCESS" and arg3 and UnitGUID("player") == arg3 then
		if arg9 == SpellIds["符文打擊"] then
			
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
				if GetSpellInfo(SpellIds["符文打擊"]) == arg2 then
				BeeSpellIsActivation_Event_56815();
			end
		end
	end
end

frame:SetScript("OnEvent", Activation_OnEvent);

function BeeSpellIsActivation_Event_56815()
	if not spellinf[SpellIds["符文打擊"]] then

		spellinf[SpellIds["符文打擊"]]={};
		
	end
				
	spellinf[SpellIds["符文打擊"]]["ActivationTime"]=GetTime();
end

function BeeSpellIsActivation(Id,unit) --处理被激活技能

	if not BeeSpellRune_Requirements(Id) then
		return false;
	end

	if Id == SpellIds["符文打擊"] then 
		return BeeSpellIsActivation_56815(Id);
	elseif Id == SpellIds["黑暗變形"] then 
		return BeeSpellIsActivation_63560(Id);
	else
		return true;
	end
end

function BeeSpellIsActivation_56815(Id) --符文打击

	if UnitBuff("player", BuffName["血魄領域"]) and BeeUnitMana("player")>=30 then
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

	local bn = BeeUnitBuffCount(BuffName["闇能灌注"],"pet",2,0);
	
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


