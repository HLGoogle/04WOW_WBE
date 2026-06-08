if GetLocale() ~= "zhCN" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "DRUID" then
	return;
end


local Shapeshift={}; --姿态名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿态本地名称
local ShapeshiftAllName={}; --详细姿态名称

if GetLocale() == "zhCN" then
	Shapeshift[1]="枭兽形态";
	Shapeshift[2]="熊形态";
	Shapeshift[3]="旅行形态";
	
	Shapeshift[4]="水栖形态";
	Shapeshift[5]="猎豹形态";
	Shapeshift[6]="飞行形态";
	Shapeshift[7]="生命之树";
	
	ShapeshiftAllName["猎豹或熊形态"]="猎豹形态,熊形态";
	
	spellSubNameErrText["等级"]="形态";
	ShapeshiftName = "形态";
end

local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志


SpellIds["强化野性冲锋"]=81021;
SpellIds["强化野性冲锋(等级 1)"]=81017;

SpellIds["迅捷治愈"] = 18562;
SpellIds["愈合"] = 8936;
SpellIds["回春术"] = 774;


SpellIds["生命之树(变形)"] = 	33891;
SpellIds["星辰坠落"] =      48505;
SpellIds["枭兽形态(变形)"] =    24858;
SpellIds["树皮术"] =   22812;
SpellIds["台风"] =        50516;
SpellIds["自然之握"] =       16689;
SpellIds["激怒(熊形态)"] =        5229;
SpellIds["狂暴回复(熊形态)"] =        22842;
SpellIds["挑战咆哮(熊形态)"] =        5209;
SpellIds["挫志咆哮(熊形态)"] =   99;
SpellIds["旅行形态(变形)"] =        783;
SpellIds["水栖形态(变形)"] =        1066;
SpellIds["熊形态(变形)"] =   5487;
SpellIds["猎豹形态(变形)"] =      768;
SpellIds["潜行(猎豹形态)"] =     5215;
SpellIds["猛虎之怒(猎豹形态)"] =      5217;
SpellIds["急奔(猎豹形态)"] =      1850;
SpellIds["飞行形态(变形)"] = 33943;
SpellIds["野蛮咆哮(猎豹形态)"] =       52610;  --(无需目标但需要连击点数)
SpellIds["狂暴(猎豹或熊形态)"] =       50334;
SpellIds["生存本能(猎豹或熊形态)"] =    61336;
SpellIds["自然迅捷"] =  17116; 
 

SpellIds["横扫(熊形态)"] = 	779;
SpellIds["横扫(猎豹形态)"] = 	62078;
SpellIds["野性冲锋(猎豹形态)"] = 	49376;
SpellIds["野性冲锋(熊形态)"] = 	16979;

SpellIds["痛击(熊形态)"] = 	77758;
SpellIds["狂奔怒吼(猎豹形态)"] = 	77764;
SpellIds["狂奔怒吼(熊形态)"] = 	77761;

SpellIds["野性毒菇"] =  88747;
SpellIds["野性毒菇：引爆"] =  88751;

SpellIds["野性成长"] = 	48438;
SpellIds["自然迅捷"] = 	17116;
SpellIds["宁静"] = 	740;
SpellIds["迅捷飞行形态(变形)"] = 	40120;
SpellIds["飓风"] = 	16914;
SpellIds["日光术"] = 	78675;
SpellIds["自然之力"] = 	33831;

SpellIds["毁灭(猎豹形态)"] = 6785;

SpellIds["裂伤(猎豹形态)"]=33876;  
SpellIds["裂伤(熊形态)"]=33878;  

-------------CTM-------

SpellIds["自动攻击"]=6603;
SpellIds["愤怒"]=5176;
SpellIds["月火术"]=8921;
SpellIds["荆棘术"]=467;
SpellIds["纠缠根须"]=339;
SpellIds["星火术"]=2912;
SpellIds["传送：月光林地"]=18960;
SpellIds["虫群"]=5570;
SpellIds["精灵之火"]=770;
SpellIds["安抚"]=2908;
SpellIds["激活"]=29166;
SpellIds["休眠"]=2637;
SpellIds["旋风"]=33786;
SpellIds["滋养"]=50464;
SpellIds["起死回生"]=50769;
SpellIds["复生"]=20484;
SpellIds["净化腐蚀"]=2782;
SpellIds["野性印记"]=1126;
SpellIds["生命绽放"]=33763;
SpellIds["治疗之触"]=5185;
SpellIds["凶猛撕咬(猎豹形态)"]=22568;
SpellIds["斜掠(猎豹形态)"]=1822;
SpellIds["爪击(猎豹形态)"]=1082;
SpellIds["低吼(熊形态)"]=6795;
SpellIds["重殴(熊形态)"]=6807;
SpellIds["迎头痛击(熊形态)"]=80964;
SpellIds["迎头痛击(猎豹形态)"]=80965;
SpellIds["精灵之火（野性）(野性)"]=16857;
SpellIds["畏缩(猎豹形态)"]=8998;
SpellIds["猛击(熊形态)"]=5211;
SpellIds["突袭(猎豹形态)"]=9005;
SpellIds["撕碎(猎豹形态)"]=5221;
SpellIds["割裂(猎豹形态)"]=1079;
SpellIds["割碎(猎豹形态)"]=22570;
SpellIds["割伤(熊形态)"]=33745;
SpellIds["粉碎(熊形态)"]=80313;
-----------


NoSpellTarget[SpellIds["星辰坠落"]] =      true;
NoSpellTarget[SpellIds["枭兽形态(变形)"]] =    true;
NoSpellTarget[SpellIds["树皮术"]] =   true;
NoSpellTarget[SpellIds["台风"]] =        true;
NoSpellTarget[SpellIds["自然之握"]] =       true;
NoSpellTarget[SpellIds["激怒(熊形态)"]] =        true;
NoSpellTarget[SpellIds["狂暴回复(熊形态)"]] =        true;
NoSpellTarget[SpellIds["挑战咆哮(熊形态)"]] =        true;
NoSpellTarget[SpellIds["挫志咆哮(熊形态)"]] =   true;
NoSpellTarget[SpellIds["旅行形态(变形)"]] =        true;
NoSpellTarget[SpellIds["水栖形态(变形)"]] =        true;
NoSpellTarget[SpellIds["熊形态(变形)"]] =   true;
NoSpellTarget[SpellIds["猎豹形态(变形)"]] =      true;
NoSpellTarget[SpellIds["潜行(猎豹形态)"]] =     true;
NoSpellTarget[SpellIds["猛虎之怒(猎豹形态)"]] =      true;
NoSpellTarget[SpellIds["急奔(猎豹形态)"]] =      true;
NoSpellTarget[SpellIds["飞行形态(变形)"]] = true;
NoSpellTarget[SpellIds["野蛮咆哮(猎豹形态)"]] =       true;  --(无需目标但需要连击点数)
NoSpellTarget[SpellIds["狂暴(猎豹或熊形态)"]] =       true;
NoSpellTarget[SpellIds["生存本能(猎豹或熊形态)"]] =    true;
NoSpellTarget[SpellIds["自然迅捷"]] =  true; 


NoSpellTarget[SpellIds["横扫(猎豹形态)"]] =         true;
NoSpellTarget[SpellIds["横扫(熊形态)"]] =         true;

NoSpellTarget[SpellIds["痛击(熊形态)"]] =         true;
NoSpellTarget[SpellIds["狂奔怒吼(猎豹形态)"]] =         true;
NoSpellTarget[SpellIds["狂奔怒吼(熊形态)"]] =         true;

NoSpellTarget[SpellIds["野性毒菇"]] =  true;
NoSpellTarget[SpellIds["野性毒菇：引爆"]] =  true;
NoSpellTarget[SpellIds["生命之树(变形)"]] =  true;


NoSpellTarget[SpellIds["野性成长"]] =  true;
NoSpellTarget[SpellIds["自然迅捷"]] =  true;
NoSpellTarget[SpellIds["宁静"]] =  true;
NoSpellTarget[SpellIds["迅捷飞行形态(变形)"]] =  true;
NoSpellTarget[SpellIds["飓风"]] =  true;

NoSpellTarget[SpellIds["日光术"]] =  true;
NoSpellTarget[SpellIds["自然之力"]] =  true;

----------CTM---

NoSpellTarget[SpellIds["传送：月光林地"]] =  true;


----------

BuffName["强化野性冲锋"]=GetSpellInfo(SpellIds["强化野性冲锋"]);
BuffName["强化野性冲锋(等级 1)"]=GetSpellInfo(SpellIds["强化野性冲锋(等级 1)"]);

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);


function BeeSpellIsActivation(Id,unit,name) --处理被激活技能

	if Id == SpellIds["迅捷治愈"] then 
		return BeeSpellIsActivation_18562(Id,unit,name);
	elseif Id == SpellIds["野蛮咆哮(猎豹形态)"] then
		return BeeSpellIsActivation_52610(Id,unit,name);
	elseif Id == SpellIds["毁灭(猎豹形态)"] then	
		return BeeSpellIsActivation_81017(Id,unit,name);
	else
		return true;
	end
end

---毁灭(猎豹形态)之奔窜:技能处理
function BeeSpellIsActivation_81017(Id,unit,name)
	if UnitAura("player", BuffName["强化野性冲锋"]) or UnitAura("player", BuffName["强化野性冲锋(等级 1)"]) then
		return true,true,false;
	else
		return false,"",true; -- 第3返回标记判断继续
	end
end

---野蛮咆哮(猎豹形态):技能处理
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
	if (BeeUnitBuff(BeeGetSpellName(SpellIds["回春术"]),unit)>0 or BeeUnitBuff(BeeGetSpellName(SpellIds["愈合"]),unit)>0) then
		local powerCost = WowBee.Spell.Property[name]["PowerCost"] ;
		if BeeUnitMana("player") >= powerCost  then
			return name,true,false;
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
	
--	for i,v in pairs(Shapeshift) do
	
	--	if strfind(spellSubName,v) then
		--	t = v;
		--	break;
		--end
	--end
	
	if not t then
		return true;
	end
	
	local _,Name = BeeGetShapeshiftId();
	
	if not Name then
		Name = "人形态";
	end
	
	if strfind(spellSubName,Name) then
		return true;
	else
		return false;
	end
end
