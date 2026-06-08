if GetLocale() ~= "zhCN" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "ROGUE" then
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


SpellIds["射击"]=3018;
SpellIds["投掷"]=2764;
SpellIds["自动攻击"]=6603;
SpellIds["刺骨"]=2098;
SpellIds["伏击"]=8676;
SpellIds["切割"]=5171;
SpellIds["偷袭"]=1833;
SpellIds["肾击"]=408;
SpellIds["破甲"]=8647;
SpellIds["拆卸"]=51722;
SpellIds["锁喉"]=703;
SpellIds["割裂"]=1943;
SpellIds["毒伤"]=32645;
SpellIds["致命投掷"]=26679;
SpellIds["影袭"]=1752;
SpellIds["闪避"]=5277;
SpellIds["恢复"]=73651;
SpellIds["脚踢"]=1766;
SpellIds["凿击"]=1776;
SpellIds["疾跑"]=2983;
SpellIds["背刺"]=53;
SpellIds["佯攻"]=1966;
SpellIds["毒刃"]=5938;
SpellIds["刀扇"]=51723;
SpellIds["备战就绪"]=74001;
SpellIds["潜行"]=1784;
SpellIds["搜索"]=921;
SpellIds["闷棍"]=6770;
SpellIds["开锁"]=1804;
SpellIds["消失"]=1856;
SpellIds["扰乱"]=1725;
SpellIds["致盲"]=2094;
SpellIds["解除陷阱"]=1842;
SpellIds["暗影斗篷"]=31224;
SpellIds["嫁祸诀窍"]=57934;
SpellIds["转嫁"]=73981;
SpellIds["烟雾弹"]=76577



NoSpellTarget[SpellIds["疾跑"]] =  true; 
NoSpellTarget[SpellIds["闪避"]] =  true; 
NoSpellTarget[SpellIds["恢复"]] =  true; 
NoSpellTarget[SpellIds["刀扇"]] =  true;  --TT
NoSpellTarget[SpellIds["备战就绪"]] =  true; 
NoSpellTarget[SpellIds["潜行"]] =  true; 
NoSpellTarget[SpellIds["搜索"]] =  true; 
NoSpellTarget[SpellIds["消失"]] =  true; 

NoSpellTarget[SpellIds["暗影斗篷"]] =  true; 
NoSpellTarget[SpellIds["烟雾弹"]] =  true; 
NoSpellTarget[SpellIds["切割"]] =  true;

 

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