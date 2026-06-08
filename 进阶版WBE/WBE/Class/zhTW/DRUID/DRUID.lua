if GetLocale() ~= "zhTW" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "DRUID" then
	return;
end



local Shapeshift={}; --姿態名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿態本地名称
local ShapeshiftAllName={}; --详细姿態名称

if GetLocale() == "zhTW" then
	
	Shapeshift[1]="梟獸形態";
	Shapeshift[2]="熊形態";
	Shapeshift[3]="旅行形態";
	
	Shapeshift[4]="水棲形態";
	Shapeshift[5]="獵豹形態";
	Shapeshift[6]="飛行形態";
	Shapeshift[7]="生命之樹";
	
	ShapeshiftAllName["獵豹或熊形態"]="獵豹形態,熊形態";
	
	
	spellSubNameErrText["等級"]="形態";
	ShapeshiftName = "形態";
end

local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志



SpellIds["奔竄(等級 1)"]=81017;

SpellIds["迅癒"] = 18562;
SpellIds["癒合"] = 8936;
SpellIds["回春術"] = 774;


SpellIds["生命之樹(變身)"] = 	33891;
SpellIds["星殞術"] =      48505;
SpellIds["梟獸形態(變身)"] =    24858;
SpellIds["樹皮術"] =   22812;
SpellIds["颱風"] =        50516;
SpellIds["自然之握"] =       16689;
SpellIds["狂怒(熊形態)"] =        5229;
SpellIds["狂暴恢復(熊形態)"] =        22842;
SpellIds["挑戰咆哮(熊形態)"] =        5209;
SpellIds["挫志咆哮(熊形態)"] =   99;
SpellIds["旅行形態(變身)"] =        783;
SpellIds["水棲形態(變身)"] =        1066;
SpellIds["熊形態(變身)"] =   5487;
SpellIds["獵豹形態(變身)"] =      768;
SpellIds["潛行(獵豹形態)"] =     5215;
SpellIds["猛虎之怒(獵豹形態)"] =      5217;
SpellIds["突進(獵豹形態)"] =      1850;
SpellIds["飛行形態(變身)"] = 33943;
SpellIds["兇蠻咆哮(獵豹形態)"] =       52610;  --(無需目標但需要連擊點數)
SpellIds["狂暴(獵豹或熊形態)"] =       50334;
SpellIds["求生本能(獵豹或熊形態)"] =    61336;
SpellIds["自然迅捷"] =  17116; 
SpellIds["影遁(種族特長)"] =         58984; 

SpellIds["揮擊(熊形態)"] = 	779;
SpellIds["揮擊(獵豹形態)"] = 	62078;
SpellIds["野性衝鋒(獵豹形態)"] = 	49376;
SpellIds["野性衝鋒(熊形態)"] = 	16979;

SpellIds["痛擊(熊形態)"] = 	77758;
SpellIds["奔竄咆哮(獵豹形態)"] = 	77764;
SpellIds["奔竄咆哮(熊形態)"] = 	77761;

SpellIds["狂野蘑菇"] =  88747;
SpellIds["狂野蘑菇 - 引爆"] =  88751;

SpellIds["野性痊癒"] = 	48438;
SpellIds["自然迅捷"] = 	17116;
SpellIds["寧靜"] = 	740;
SpellIds["迅捷飛行形態(變身)"] = 	40120;
SpellIds["颶風"] = 	16914;
SpellIds["太陽光束"] = 	78675;
SpellIds["自然之力"] = 	33831;

SpellIds["劫掠(獵豹形態)"] = 6785;



--無目標(種族特殊技能內碼對應表)
SpellIds["石像形態(種族特長)"] = 20594;
SpellIds["狂暴(種族特長)"] = 26297;
SpellIds["奧流之術(種族特長)"] = 28730;

NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true;
NoSpellTarget[SpellIds["狂暴(種族特長)"]] =  true;
NoSpellTarget[SpellIds["奧流之術(種族特長)"]] =  true;


NoSpellTarget[SpellIds["星殞術"]] =      true;
NoSpellTarget[SpellIds["梟獸形態(變身)"]] =    true;
NoSpellTarget[SpellIds["樹皮術"]] =   true;
NoSpellTarget[SpellIds["颱風"]] =        true;
NoSpellTarget[SpellIds["自然之握"]] =       true;
NoSpellTarget[SpellIds["狂怒(熊形態)"]] =        true;
NoSpellTarget[SpellIds["狂暴恢復(熊形態)"]] =        true;
NoSpellTarget[SpellIds["挑戰咆哮(熊形態)"]] =        true;
NoSpellTarget[SpellIds["挫志咆哮(熊形態)"]] =   true;
NoSpellTarget[SpellIds["旅行形態(變身)"]] =        true;
NoSpellTarget[SpellIds["水棲形態(變身)"]] =        true;
NoSpellTarget[SpellIds["熊形態(變身)"]] =   true;
NoSpellTarget[SpellIds["獵豹形態(變身)"]] =      true;
NoSpellTarget[SpellIds["潛行(獵豹形態)"]] =     true;
NoSpellTarget[SpellIds["猛虎之怒(獵豹形態)"]] =      true;
NoSpellTarget[SpellIds["突進(獵豹形態)"]] =      true;
NoSpellTarget[SpellIds["飛行形態(變身)"]] = true;
NoSpellTarget[SpellIds["兇蠻咆哮(獵豹形態)"]] =       true;  --(無需目標但需要連擊點數)
NoSpellTarget[SpellIds["狂暴(獵豹或熊形態)"]] =       true;
NoSpellTarget[SpellIds["求生本能(獵豹或熊形態)"]] =    true;
NoSpellTarget[SpellIds["自然迅捷"]] =  true; 
NoSpellTarget[SpellIds["影遁(種族特長)"]] =         true;

NoSpellTarget[SpellIds["揮擊(獵豹形態)"]] =         true;
NoSpellTarget[SpellIds["揮擊(熊形態)"]] =         true;

NoSpellTarget[SpellIds["痛擊(熊形態)"]] =         true;
NoSpellTarget[SpellIds["奔竄咆哮(獵豹形態)"]] =         true;
NoSpellTarget[SpellIds["奔竄咆哮(熊形態)"]] =         true;

NoSpellTarget[SpellIds["狂野蘑菇"]] =  true;
NoSpellTarget[SpellIds["狂野蘑菇 - 引爆"]] =  true;
NoSpellTarget[SpellIds["生命之樹(變身)"]] =  true;


NoSpellTarget[SpellIds["野性痊癒"]] =  true;
NoSpellTarget[SpellIds["自然迅捷"]] =  true;
NoSpellTarget[SpellIds["寧靜"]] =  true;
NoSpellTarget[SpellIds["迅捷飛行形態(變身)"]] =  true;
NoSpellTarget[SpellIds["颶風"]] =  true;

NoSpellTarget[SpellIds["太陽光束"]] =  true;
NoSpellTarget[SpellIds["自然之力"]] =  true;


BuffName["奔竄(等級 1)"]=GetSpellInfo(SpellIds["奔竄(等級 1)"]);




----------

BuffName["强化野性冲锋(等级 1)"]=GetSpellInfo(SpellIds["强化野性冲锋(等级 1)"]);

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);


function BeeSpellIsActivation(Id,unit,name) --处理被激活技能

	if Id == SpellIds["迅癒"] then 
		return BeeSpellIsActivation_18562(Id,unit,name);
	elseif Id == SpellIds["兇蠻咆哮(獵豹形態)"] then
		return BeeSpellIsActivation_52610(Id,unit,name);
elseif Id == SpellIds["劫掠(獵豹形態)"] then	
		return BeeSpellIsActivation_81017(Id,unit,name);
	else
		return true;
	end
end

---劫掠(獵豹形態)之奔竄:技能處理
function BeeSpellIsActivation_81017(Id,unit,name)
	if UnitAura("player", BuffName["奔竄(等級 1)"]) then
		return true,true,false;
	else
		return false,"",true; -- 第3返回标记判断继续
	end
end

---兇蠻咆哮(獵豹形態):技能處理
function BeeSpellIsActivation_52610(Id,unit,name)
	--if BeeSpellIsShapeshift(Id) then
		local isUsable, notEnoughMana = IsUsableSpell(Id);
			
		if isUsable == 1  then
			return true,true;
		elseif notEnoughMana==1 then
			return false,"能量不足";
		end
		
	--end
end

---迅捷治愈:技能处理
function BeeSpellIsActivation_18562(Id,unit,name)
	if (BeeUnitBuff(BeeGetSpellName(SpellIds["回春術"]),unit)>0 or BeeUnitBuff(BeeGetSpellName(SpellIds["癒合"]),unit)>0) then
		local powerCost = WowBee.Spell.Property[name]["PowerCost"] ;
		if BeeUnitMana("player") >= powerCost  then
			return name;
		end
	end

	return false;
end

function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId];
end

function BeeSpellIsShapeshift(SpellId) -- 判断技能是否姿态是否符合

	local spellName, spellSubName = GetSpellInfo(SpellId);
	
	if spellSubName == "" then
		return true;
	end
	
	if ShapeshiftAllName[spellSubName] then
		spellSubName= ShapeshiftAllName[spellSubName];
	end
	
	local t = false;
	
	for i,v in pairs(Shapeshift) do
	
		if strfind(spellSubName,v) then
			t = v;
			break;
		end
	end
	
	if not t then
		return true;
	end
	
	local _,Name = BeeGetShapeshiftId();
	
	if not Name then
		Name = "人形態";
	end
	
	if strfind(spellSubName,Name) then
		return true;
	else
		return false;
	end
end
