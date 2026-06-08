if GetLocale() ~= "zhCN" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "WARLOCK" then
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

SpellIds["召唤仪式"] = 	698;
SpellIds["召唤小鬼(召唤)"] = 	688;
SpellIds["召唤虚空行者(召唤)"] = 	697;
SpellIds["召唤地狱猎犬(召唤)"] = 	691;
SpellIds["召唤魅魔(召唤)"] = 	712;
SpellIds["召唤末日守卫(守卫)"] = 	18540;
SpellIds["召唤地狱火(守卫)"] = 	1122;
SpellIds["基尔罗格之眼(召唤)"] = 	126;
SpellIds["恶魔法阵：传送"] = 	48020;
SpellIds["恶魔法阵：召唤"] = 	48018;
SpellIds["魔甲术"] = 	687;
SpellIds["生命通道"] = 	755;
SpellIds["制造治疗石"] = 	6201;
SpellIds["制造灵魂石"] = 	693;
SpellIds["暗影防护结界"] = 	6229;
SpellIds["灵魂仪式"] = 	29893;
SpellIds["灵魂收割"] = 	79268;
SpellIds["灵魂燃烧"] = 	74434;
SpellIds["灵魂碎裂"] = 	29858;
SpellIds["灵魂链接"] = 	19028;
SpellIds["邪甲术"] = 	28176;
SpellIds["无尽呼吸"] = 	5697;
SpellIds["恶魔之魂"] = 	77801;
SpellIds["地狱烈焰"] = 	1949;
SpellIds["暗影之怒"] = 	30283;
SpellIds["暗影烈焰"] = 	47897;
SpellIds["浩劫灾祸"] = 	80240;
SpellIds["火焰之雨"] = 	5740;
SpellIds["恐惧嚎叫"] = 	5484;
SpellIds["生命分流"] = 	1454;
SpellIds["恶魔增效"] = 	47193;
SpellIds["恶魔变形"] = 	36298;

-------CTM----
SpellIds["射击"]=5019;
SpellIds["自动攻击"]=6603;
SpellIds["暴风雪"]=10;
SpellIds["奴役恶魔"]=1098;
SpellIds["放逐术"]=710;
SpellIds["暗影箭"]=686;
SpellIds["灵魂之火"]=6353;
SpellIds["灼热之痛"]=5676;
SpellIds["烧尽"]=29722;
SpellIds["献祭"]=348;
SpellIds["邪焰"]=77799;
SpellIds["元素诅咒"]=1490;
SpellIds["吸取灵魂"]=1120;
SpellIds["吸取生命"]=689;
SpellIds["恐惧"]=5782;
SpellIds["末日灾祸"]=603;
SpellIds["死亡缠绕"]=6789;
SpellIds["痛苦灾祸"]=980;
SpellIds["腐蚀术"]=172;
SpellIds["虚弱诅咒"]=702;
SpellIds["语言诅咒"]=1714;
SpellIds["腐蚀之种"]=27243;
SpellIds["黑暗意图"]=80398;

SpellIds["暗影灼烧"]=17877;  
SpellIds["混乱之箭"]=50796;  
SpellIds["燃烧"]=17962;
------------


NoSpellTarget[SpellIds["召唤仪式"]] =  true; --	698;
NoSpellTarget[SpellIds["召唤小鬼(召唤)"]] =  true; --	688;
NoSpellTarget[SpellIds["召唤虚空行者(召唤)"]] =  true; --	697;
NoSpellTarget[SpellIds["召唤地狱猎犬(召唤)"]] =  true; --	691;
NoSpellTarget[SpellIds["召唤魅魔(召唤)"]] =  true; --	712;
NoSpellTarget[SpellIds["召唤末日守卫(守卫)"]] =  true; --	18540;
NoSpellTarget[SpellIds["召唤地狱火(守卫)"]] =  true; --	1122;
NoSpellTarget[SpellIds["基尔罗格之眼(召唤)"]] =  true; --	126;
NoSpellTarget[SpellIds["恶魔法阵：传送"]] =  true; --	48020;
NoSpellTarget[SpellIds["恶魔法阵：召唤"]] =  true; --	48018;
NoSpellTarget[SpellIds["魔甲术"]] =  true; --	687;
NoSpellTarget[SpellIds["生命通道"]] =  true; --	755;
NoSpellTarget[SpellIds["制造治疗石"]] =  true; --	6201;
NoSpellTarget[SpellIds["制造灵魂石"]] =  true; --	693;
NoSpellTarget[SpellIds["暗影防护结界"]] =  true; --	6229;
NoSpellTarget[SpellIds["灵魂仪式"]] =  true; --	29893;
NoSpellTarget[SpellIds["灵魂收割"]] =  true; --	79268;
NoSpellTarget[SpellIds["灵魂燃烧"]] =  true; --	74434;
NoSpellTarget[SpellIds["灵魂碎裂"]] =  true; --	29858;
NoSpellTarget[SpellIds["灵魂链接"]] =  true; --	19028;
NoSpellTarget[SpellIds["邪甲术"]] =  true; --	28176;
NoSpellTarget[SpellIds["无尽呼吸"]] =  true; --	5697;
NoSpellTarget[SpellIds["恶魔之魂"]] =  true; --	77801;
NoSpellTarget[SpellIds["地狱烈焰"]] =  true; --	1949;
NoSpellTarget[SpellIds["暗影之怒"]] =  true; --	30283;
NoSpellTarget[SpellIds["暗影烈焰"]] =  true; --	47897;
NoSpellTarget[SpellIds["浩劫灾祸"]] =  true; --	80240;
NoSpellTarget[SpellIds["火焰之雨"]] =  true; --	5740;
NoSpellTarget[SpellIds["恐惧嚎叫"]] =  true; --	5484;
NoSpellTarget[SpellIds["生命分流"]] =  true; --	1454;
NoSpellTarget[SpellIds["恶魔增效"]] =  true; --	47193;
NoSpellTarget[SpellIds["恶魔变形"]] =  true; --	36298;

BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);
 
--function BeeSpellIsActivation(Id,unit,name) --处理被激活技能
	--if Id == SpellIds["愤怒之锤"] then 
		
	--end
--end


function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true;
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId] and true;
end
