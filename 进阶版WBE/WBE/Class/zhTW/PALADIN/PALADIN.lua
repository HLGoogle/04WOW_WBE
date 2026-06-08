if GetLocale() ~= "zhTW" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "PALADIN" then
	return;
end

local Shapeshift={}; --姿態名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿態本地名称

if GetLocale() == "zhTW" then

end

local BuffName = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志



SpellIds["公正聖印"] = 20164;
SpellIds["正義聖印"] = 20154;
SpellIds["洞悉聖印"] = 20165;
SpellIds["真理聖印"] = 31801;
SpellIds["忠誠防衛者"] = 31850;
SpellIds["抗性光環"] = 19891;
SpellIds["專注光環"] = 19746;
SpellIds["正義之怒"] = 25780;
SpellIds["王者祝福"] = 20217;
SpellIds["力量祝福"] = 19740;
SpellIds["神性守護"] = 70940;
SpellIds["神聖之盾"] = 20925;
SpellIds["聖佑術"] = 498;
SpellIds["聖盾術"] = 642;
SpellIds["虔誠光環"] = 465;
SpellIds["十字軍光環"] = 32223;
SpellIds["懲罰光環"] = 7294;
SpellIds["遠古諸王守護者"] =86150 ;
SpellIds["奉獻"] = 26573;
SpellIds["神性祈求"] = 54428;
SpellIds["神聖憤怒"] = 2812;
SpellIds["復仇之怒"] = 31884;
SpellIds["神恩術"] = 31842;
SpellIds["異端審問"] = 84963;
SpellIds["精通光環"] = 31821;
SpellIds["黎明曙光"] = 85222;
SpellIds["保護聖禦"] = 1022;
SpellIds["神聖光輝"] = 82327;
SpellIds["神聖之光"] = 82326;
SpellIds["憤怒之錘"] = 24275;
SpellIds["神性風暴"] = 53385;
SpellIds["聖化之怒(等級 1)"] = 53375;

SpellIds["戰爭藝術"] = 59578;
SpellIds["裁決"] = 85509;
SpellIds["驅邪術"] = 879;

BuffName["戰爭藝術"]=GetSpellInfo(SpellIds["戰爭藝術"]);
BuffName["裁決"]=GetSpellInfo(SpellIds["裁決"]);




RaidSpell[SpellIds["保護聖禦"]]=3;


--無目標(種族特殊技能內碼對應表)
SpellIds["石像形態(種族特長)"] = 20594;
SpellIds["狂暴(種族特長)"] = 26297;
SpellIds["奧流之術(種族特長)"] = 28730;

NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true;
NoSpellTarget[SpellIds["狂暴(種族特長)"]] =  true;
NoSpellTarget[SpellIds["奧流之術(種族特長)"]] =  true;


NoSpellTarget[SpellIds["公正聖印"]] = true;
NoSpellTarget[SpellIds["正義聖印"]] = true;
NoSpellTarget[SpellIds["洞悉聖印"]] = true;
NoSpellTarget[SpellIds["真理聖印"]] = true;
NoSpellTarget[SpellIds["忠誠防衛者"]] = true;
NoSpellTarget[SpellIds["抗性光環"]] = true;
NoSpellTarget[SpellIds["專注光環"]] = true;
NoSpellTarget[SpellIds["正義之怒"]] = true;
NoSpellTarget[SpellIds["王者祝福"]] = true;
NoSpellTarget[SpellIds["力量祝福"]] = true;
NoSpellTarget[SpellIds["神性守護"]] = true;
NoSpellTarget[SpellIds["神聖之盾"]] = true;
NoSpellTarget[SpellIds["聖佑術"]] = true;
NoSpellTarget[SpellIds["聖盾術"]] = true;
NoSpellTarget[SpellIds["虔誠光環"]] = true;
NoSpellTarget[SpellIds["十字軍光環"]] = true;
NoSpellTarget[SpellIds["懲罰光環"]] = true;
NoSpellTarget[SpellIds["遠古諸王守護者"]] = true ;
NoSpellTarget[SpellIds["奉獻"]] = true;
NoSpellTarget[SpellIds["神性祈求"]] = true;
NoSpellTarget[SpellIds["神聖憤怒"]] = true;
NoSpellTarget[SpellIds["復仇之怒"]] = true;
NoSpellTarget[SpellIds["神恩術"]] = true;
NoSpellTarget[SpellIds["異端審問"]] = true;
NoSpellTarget[SpellIds["精通光環"]] = true;
NoSpellTarget[SpellIds["黎明曙光"]] = true;
NoSpellTarget[SpellIds["神聖光輝"]] = true;
NoSpellTarget[SpellIds["神性風暴"]] = true;


BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

function BeeSpellIsMove(Id,unit,name) --处理移动中能施放的技能
	if Id == SpellIds["驅邪術"]  and (UnitAura("player", BuffName["戰爭藝術"]) or UnitAura("player", BuffName["裁決"])) then 
		return true;
	end
end

function BeeSpellIsActivation(Id,unit,name) --处理被激活技能
	--if Id == SpellIds["憤怒之錘"] then 
		
	--	return BeeSpellIsActivation_24275(Id,unit,name);
	
	--else
		return true;
	--end
end

function BeeSpellIsActivation_24275(Id,unit,name)
	if BeeUnitHealth(unit,"%")<=20 or (BeePlayerBuffTime(GetSpellInfo(SpellIds["復仇之怒"]))>0 and BeeTalentInfo(GetSpellInfo(SpellIds["聖化之怒(等級 1)"]))) then
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