if GetLocale() ~= "zhTW" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "WARLOCK" then
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

SpellIds["召喚儀式"] = 	698;
SpellIds["召喚小鬼(召喚)"] = 	688;
SpellIds["召喚虛無行者(召喚)"] = 	697;
SpellIds["召喚惡魔獵犬(召喚)"] = 	691;
SpellIds["召喚魅魔(召喚)"] = 	712;
SpellIds["召喚末日守衛(守護者)"] = 	18540;
SpellIds["召喚煉獄火(守護者)"] = 	1122;
SpellIds["基爾羅格之眼(召喚)"] = 	126;
SpellIds["惡魔法陣:傳送"] = 	48020;
SpellIds["惡魔法陣:召喚"] = 	48018;
SpellIds["惡魔護甲"] = 	687;
SpellIds["生命通道"] = 	755;
SpellIds["製造治療石"] = 	6201;
SpellIds["製造靈魂石"] = 	693;
SpellIds["防護暗影結界"] = 	6229;
SpellIds["靈魂儀式"] = 	29893;
SpellIds["靈魂收割"] = 	79268;
SpellIds["靈魂炙燃"] = 	74434;
SpellIds["靈魂粉碎"] = 	29858;
SpellIds["靈魂鏈結"] = 	19028;
SpellIds["魔化護甲"] = 	28176;
SpellIds["魔息術"] = 	5697;
SpellIds["惡魔之魂"] = 	77801;
SpellIds["地獄烈焰"] = 	1949;
SpellIds["暗影之怒"] = 	30283;
SpellIds["暗影之焰"] = 	47897;
SpellIds["浩劫災厄"] = 	80240;
SpellIds["火焰之雨"] = 	5740;
SpellIds["恐懼嚎叫"] = 	5484;
SpellIds["生命分流"] = 	1454;
SpellIds["魔性活化"] = 	47193;
SpellIds["惡魔化身"] = 	36298;






--無目標(種族特殊技能內碼對應表)
SpellIds["石像形態(種族特長)"] = 20594;
SpellIds["狂暴(種族特長)"] = 26297;
SpellIds["奧流之術(種族特長)"] = 28730;

NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true;
NoSpellTarget[SpellIds["狂暴(種族特長)"]] =  true;
NoSpellTarget[SpellIds["奧流之術(種族特長)"]] =  true;

NoSpellTarget[SpellIds["召喚儀式"]] =  true; --	698;
NoSpellTarget[SpellIds["召喚小鬼(召喚)"]] =  true; --	688;
NoSpellTarget[SpellIds["召喚虛無行者(召喚)"]] =  true; --	697;
NoSpellTarget[SpellIds["召喚惡魔獵犬(召喚)"]] =  true; --	691;
NoSpellTarget[SpellIds["召喚魅魔(召喚)"]] =  true; --	712;
NoSpellTarget[SpellIds["召喚末日守衛(守護者)"]] =  true; --	18540;
NoSpellTarget[SpellIds["召喚煉獄火(守護者)"]] =  true; --	1122;
NoSpellTarget[SpellIds["基爾羅格之眼(召喚)"]] =  true; --	126;
NoSpellTarget[SpellIds["惡魔法陣:傳送"]] =  true; --	48020;
NoSpellTarget[SpellIds["惡魔法陣:召喚"]] =  true; --	48018;
NoSpellTarget[SpellIds["惡魔護甲"]] =  true; --	687;
NoSpellTarget[SpellIds["生命通道"]] =  true; --	755;
NoSpellTarget[SpellIds["製造治療石"]] =  true; --	6201;
NoSpellTarget[SpellIds["製造靈魂石"]] =  true; --	693;
NoSpellTarget[SpellIds["防護暗影結界"]] =  true; --	6229;
NoSpellTarget[SpellIds["靈魂儀式"]] =  true; --	29893;
NoSpellTarget[SpellIds["靈魂收割"]] =  true; --	79268;
NoSpellTarget[SpellIds["靈魂炙燃"]] =  true; --	74434;
NoSpellTarget[SpellIds["靈魂粉碎"]] =  true; --	29858;
NoSpellTarget[SpellIds["靈魂鏈結"]] =  true; --	19028;
NoSpellTarget[SpellIds["魔化護甲"]] =  true; --	28176;
NoSpellTarget[SpellIds["魔息術"]] =  true; --	5697;
NoSpellTarget[SpellIds["惡魔之魂"]] =  true; --	77801;
NoSpellTarget[SpellIds["地獄烈焰"]] =  true; --	1949;
NoSpellTarget[SpellIds["暗影之怒"]] =  true; --	30283;
NoSpellTarget[SpellIds["暗影之焰"]] =  true; --	47897;
NoSpellTarget[SpellIds["浩劫災厄"]] =  true; --	80240;
NoSpellTarget[SpellIds["火焰之雨"]] =  true; --	5740;
NoSpellTarget[SpellIds["恐懼嚎叫"]] =  true; --	5484;
NoSpellTarget[SpellIds["生命分流"]] =  true; --	1454;
NoSpellTarget[SpellIds["魔性活化"]] =  true; --	47193;
NoSpellTarget[SpellIds["惡魔化身"]] =  true; --	36298;

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);
 
--function BeeSpellIsActivation(Id,unit,name) --处理被激活技能
	--if Id == SpellIds["憤怒之錘"] then 
		
	--end
--end


function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true;
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId] and true;
end
