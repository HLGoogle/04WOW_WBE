if GetLocale() ~= "zhCN" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "PALADIN" then
	return;
end

local Shapeshift={}; --姿态名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿态本地名称

if GetLocale() == "zhCN" then

end

local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志



SpellIds["公正圣印"] = 20164;
SpellIds["正义圣印"] = 20154;
SpellIds["洞察圣印"] = 20165;
SpellIds["真理圣印"] = 31801;
SpellIds["炽热防御者"] = 31850;
SpellIds["抗性光环"] = 19891;
SpellIds["专注光环"] = 19746;
SpellIds["正义之怒"] = 25780;
SpellIds["王者祝福"] = 20217;
SpellIds["力量祝福"] = 19740;
SpellIds["神圣守卫"] = 70940;
SpellIds["神圣之盾"] = 20925;
SpellIds["圣佑术"] = 498;
SpellIds["圣盾术"] = 642;
SpellIds["虔诚光环"] = 465;
SpellIds["十字军光环"] = 32223;
SpellIds["惩戒光环"] = 7294;
SpellIds["远古列王守卫"] =86150 ;
SpellIds["奉献"] = 26573;
SpellIds["神圣恳求"] = 54428;
SpellIds["神圣愤怒"] = 2812;
SpellIds["复仇之怒"] = 31884;
SpellIds["神恩术"] = 31842;
SpellIds["异端裁决"] = 84963;
SpellIds["光环掌握"] = 31821;
SpellIds["黎明圣光"] = 85222;
SpellIds["保护之手"] = 1022;
SpellIds["圣光普照"] = 82327;
SpellIds["神圣之光"] = 82326;
SpellIds["愤怒之锤"] = 24275;
SpellIds["神圣风暴"] = 53385;
SpellIds["圣洁怒火(等级 1)"] = 53375;

SpellIds["战争艺术"] = 59578;
SpellIds["谴责"] = 85509;
SpellIds["驱邪术"] = 879;


-----CTM---------

SpellIds["自动攻击"]=6603;
SpellIds["十字军打击"]=35395;
SpellIds["审判"]=20271;
SpellIds["责难"]=96231;
SpellIds["圣光术"]=635;
SpellIds["荣耀圣令"]=85673;
SpellIds["救赎"]=7328;
SpellIds["圣光闪现"]=19750;
SpellIds["圣疗术"]=633;
SpellIds["清洁术"]=4987;
SpellIds["超度邪恶"]=10326;
SpellIds["制裁之锤"]=853;
SpellIds["清算之手"]=62124;
SpellIds["正义防御"]=31789;
SpellIds["自由之手"]=1044;
SpellIds["拯救之手"]=1038;
SpellIds["牺牲之手"]=6940


SpellIds["复仇者之盾"]=31935;  
SpellIds["正义之锤"]=53595;  
SpellIds["正义盾击"]=53600;  

SpellIds["圣光道标"]=53563;  
SpellIds["神圣震击"]=20473;  

SpellIds["圣殿骑士的裁决"]=85256;  
SpellIds["忏悔"]=20066;  
SpellIds["狂热"]=85696;


----------------

BuffName["战争艺术"]=GetSpellInfo(SpellIds["战争艺术"]);
BuffName["谴责"]=GetSpellInfo(SpellIds["谴责"]);




RaidSpell[SpellIds["保护之手"]]=3;




NoSpellTarget[SpellIds["公正圣印"]] = true;
NoSpellTarget[SpellIds["正义圣印"]] = true;
NoSpellTarget[SpellIds["洞察圣印"]] = true;
NoSpellTarget[SpellIds["真理圣印"]] = true;
NoSpellTarget[SpellIds["炽热防御者"]] = true;
NoSpellTarget[SpellIds["抗性光环"]] = true;
NoSpellTarget[SpellIds["专注光环"]] = true;
NoSpellTarget[SpellIds["正义之怒"]] = true;
NoSpellTarget[SpellIds["王者祝福"]] = true;
NoSpellTarget[SpellIds["力量祝福"]] = true;
NoSpellTarget[SpellIds["神圣守卫"]] = true;
NoSpellTarget[SpellIds["神圣之盾"]] = true;
NoSpellTarget[SpellIds["圣佑术"]] = true;
NoSpellTarget[SpellIds["圣盾术"]] = true;
NoSpellTarget[SpellIds["虔诚光环"]] = true;
NoSpellTarget[SpellIds["十字军光环"]] = true;
NoSpellTarget[SpellIds["惩戒光环"]] = true;
NoSpellTarget[SpellIds["远古列王守卫"]] = true ;
NoSpellTarget[SpellIds["奉献"]] = true;
NoSpellTarget[SpellIds["神圣恳求"]] = true;
NoSpellTarget[SpellIds["神圣愤怒"]] = true;
NoSpellTarget[SpellIds["复仇之怒"]] = true;
NoSpellTarget[SpellIds["神恩术"]] = true;
NoSpellTarget[SpellIds["异端裁决"]] = true;
NoSpellTarget[SpellIds["光环掌握"]] = true;
NoSpellTarget[SpellIds["黎明圣光"]] = true;
NoSpellTarget[SpellIds["圣光普照"]] = true;
NoSpellTarget[SpellIds["神圣风暴"]] = true;


BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

function BeeSpellIsMove(Id,unit,name) --处理移动中能施放的技能
	if Id == SpellIds["驱邪术"]  and (UnitAura("player", BuffName["战争艺术"]) or UnitAura("player", BuffName["谴责"])) then 
		return true;
	end
end

function BeeSpellIsActivation(Id,unit,name) --处理被激活技能
	--if Id == SpellIds["愤怒之锤"] then 
		
	--	return BeeSpellIsActivation_24275(Id,unit,name);
	
	--else
		return true;
	--end
end

function BeeSpellIsActivation_24275(Id,unit,name)
	if BeeUnitHealth(unit,"%")<=20 or (BeePlayerBuffTime(GetSpellInfo(SpellIds["复仇之怒"]))>0 and BeeTalentInfo(GetSpellInfo(SpellIds["圣洁怒火(等级 1)"]))) then
		return true;
	else
		return false;
	end
end

function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true;
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId] and true;
end