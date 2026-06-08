if GetLocale() ~= "zhTW" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "PRIEST" then
	return;
end

local Shapeshift={}; --姿态名称ID对照
local spellSubNameErrText={}; -- 错误技能信息
local ShapeshiftName = nil; --姿态本地名称

if GetLocale() == "zhCN" then
end

local BuffNames = {};				--BUFF名称
local RaidSpell={};					--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
local SpellIds={};					-- 技能ID
local NoSpellTarget={}; 		--无目标标志


SpellIds["心灵之火"] = 588;
SpellIds["真言术：韧"] = 21562;
SpellIds["光明之泉"] = 724;
SpellIds["脉轮"] = 14751;
SpellIds["心灵尖啸"] = 8122;
SpellIds["心灵视界"] = 2096;
SpellIds["暗影防护"] = 27683;
SpellIds["渐隐术"] = 586;
SpellIds["群体驱散"] = 32375;
SpellIds["心灵意志"]=73413;
SpellIds["神圣新星"] = 15237;
SpellIds["希望圣歌"] = 64901; 
SpellIds["神圣赞美诗"] = 64843;
SpellIds["暗影形态"] = 15473;

SpellIds["圣言术：罚"] = 88625;
SpellIds["圣言术：佑"] = 88685;
SpellIds["圣言术：静"] = 88684;

SpellIds["真言术：盾"] = 17;

SpellIds["吸血鬼的拥抱"]=15286;





------已验证-------------

SpellIds["射击"]=5019;
SpellIds["自动攻击"]=6603;
SpellIds["束缚亡灵"]=9484;
SpellIds["法力燃烧"]=8129;
SpellIds["漂浮术"]=1706;
SpellIds["防护恐惧结界"]=6346;
SpellIds["驱散魔法"]=527;
SpellIds["吸血鬼之触"]=34914;
SpellIds["噬灵疫病"]=2944;
SpellIds["安抚心灵"]=453;
SpellIds["心灵震爆"]=8092;
SpellIds["暗影恶魔"]=34433;
SpellIds["暗言术：灭"]=32379;
SpellIds["暗言术：痛"]=589;
SpellIds["消散"]=47585;
SpellIds["精神控制"]=605;
SpellIds["精神灼烧"]=48045;
SpellIds["精神鞭笞"]=15407;
SpellIds["心灵尖刺"]=73510;
SpellIds["复活术"]=2006;
SpellIds["强效治疗术"]=2060;
SpellIds["快速治疗"]=2061;
SpellIds["恢复"]=139;
SpellIds["惩击"]=585;
SpellIds["愈合祷言"]=33076;
SpellIds["治疗术"]=2050;
SpellIds["治疗祷言"]=596;
SpellIds["祛病术"]=528;
SpellIds["神圣之火"]=14914;
SpellIds["联结治疗"]=32546;
SpellIds["信仰飞跃"]=73325;


SpellIds["心灵专注"]=89485;  
SpellIds["痛苦压制"]=33206;  
SpellIds["真言术：障"]=62618;  
SpellIds["能量灌注"]=10060;  
SpellIds["苦修"]=47540;

SpellIds["守护之魂"]=47788;  
SpellIds["治疗之环"]=34861;  
SpellIds["绝望祷言"]=19236
SpellIds["天使长"]=87151;
----------------



NoSpellTarget[SpellIds["心灵之火"]] = true;
NoSpellTarget[SpellIds["真言术：韧"]] = true;
NoSpellTarget[SpellIds["光明之泉"]] = true;
NoSpellTarget[SpellIds["脉轮"]] = true;
NoSpellTarget[SpellIds["心灵尖啸"]] = true;
NoSpellTarget[SpellIds["心灵视界"]] = true;
NoSpellTarget[SpellIds["暗影防护"]] = true;
NoSpellTarget[SpellIds["渐隐术"]] = true;
NoSpellTarget[SpellIds["群体驱散"]] = true;
NoSpellTarget[SpellIds["心灵意志"]] = true;
NoSpellTarget[SpellIds["神圣新星"]] = true;
NoSpellTarget[SpellIds["希望圣歌"]] = true; 
NoSpellTarget[SpellIds["神圣赞美诗"]] = true;
NoSpellTarget[SpellIds["暗影形态"]] = true;
NoSpellTarget[SpellIds["吸血鬼的拥抱"]] = true;

-------CTM------------------



NoSpellTarget[SpellIds["消散"]] = true;
NoSpellTarget[SpellIds["心灵专注"]] = true;
NoSpellTarget[SpellIds["真言术：障"]] = true;
NoSpellTarget[SpellIds["绝望祷言"]] = true;

NoSpellTarget[SpellIds["天使长"]] = true;

---------


BuffNames["脉轮：佑"] = GetSpellInfo(81207);
BuffNames["脉轮：佑"] = GetSpellInfo(81206);
BuffNames["脉轮：静"] = GetSpellInfo(81208);
BuffNames["脉轮：罚"] = GetSpellInfo(81209);
BuffNames["虚弱灵魂"] = GetSpellInfo(6788);


BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);


--施放目标类型（团/队/个人）的技能 团=3,队=2,个人=1
--RaidSpell[SpellIds["真言术：盾"]]=3;

--技能需要能量判断
local IsPowerCost={};

IsPowerCost[GetSpellInfo(SpellIds["真言术：盾"])]=true;


--技能需要能量判断
function BeeSpellIsPowerCost(spell)
	return IsPowerCost[spell];
end

function BeeSpellIsActivation(Id,unit) --处理被激活技能
	if GetSpellInfo(SpellIds["真言术：盾"]) == GetSpellInfo(Id) and BeeUnitBuff(BuffNames["虚弱灵魂"],unit,2,0)>0 then
		return false,false,false,true;
	end
	return true;
end

function BeeSpellIsNoTarget(SpellIds) --技能是否是有无目标标志
	return NoSpellTarget[SpellIds] and true
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId];
end