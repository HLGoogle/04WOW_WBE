if GetLocale() ~= "zhTW" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "HUNTER" then
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

SpellIds["準備就緒"] = 	 23989;

SpellIds["專注之火"] = 	 32300;
SpellIds["熱情"] = 	 806;
SpellIds["狂野怒火"] = 	 19574;

SpellIds["陷阱發射器"] = 	 77769;
SpellIds["偽裝"] = 	 51753;
SpellIds["獵狐守護"] = 	 82661;

SpellIds["石像形態(種族特長)"] = 	20594;
SpellIds["照明彈"] = 	1543;
SpellIds["假死"] = 	5384;
SpellIds["冰凍陷阱(冰霜)"] = 	1499;
SpellIds["威懾"] = 	19263;
SpellIds["寒冰陷阱(冰霜)"] = 	13809;
SpellIds["毒蛇陷阱(自然)"] = 	34600;
SpellIds["爆炸陷阱(火焰)"] = 	13813;
SpellIds["獻祭陷阱(火焰)"] = 	13795;
SpellIds["逃脫"] = 	781;
SpellIds["主人的呼喚"] = 	53271;
SpellIds["復活寵物"] = 	982;
SpellIds["擊殺命令"] = 	34026;
SpellIds["治療寵物"] = 	136;
SpellIds["獵豹守護"] = 	5118;
SpellIds["解散野獸"] = 	2641;
SpellIds["豹群守護"] = 	13159;
SpellIds["野性守護"] = 	20043;
SpellIds["野獸知識"] = 	1462;
SpellIds["雄鷹守護"] = 	13165;
SpellIds["餵養寵物"] = 	6991;
SpellIds["鷹眼術"] = 	6197;  

SpellIds["眼鏡蛇射擊"] = 	77767;  
SpellIds["穩固射擊"] = 	56641;  


--無目標(種族特殊技能內碼對應表)
SpellIds["石像形態(種族特長)"] = 20594;
SpellIds["狂暴(種族特長)"] = 26297;
SpellIds["奧流之術(種族特長)"] = 28730;

BuffName["獵狐守護"]=GetSpellInfo(SpellIds["獵狐守護"]);



NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true;
NoSpellTarget[SpellIds["狂暴(種族特長)"]] =  true;
NoSpellTarget[SpellIds["奧流之術(種族特長)"]] =  true;


NoSpellTarget[SpellIds["準備就緒"]] =  true; --	 23989;

NoSpellTarget[SpellIds["專注之火"]] =  true; --	 32300;
NoSpellTarget[SpellIds["熱情"]] =  true; --	 805;
NoSpellTarget[SpellIds["狂野怒火"]] =  true; --	 19574;

NoSpellTarget[SpellIds["陷阱發射器"]] =  true; --	 56871;
NoSpellTarget[SpellIds["偽裝"]] =  true; --	 51753;
NoSpellTarget[SpellIds["獵狐守護"]] =  true; --	 82661;

NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true; --	20594;
NoSpellTarget[SpellIds["照明彈"]] =  true; --	1543;
NoSpellTarget[SpellIds["假死"]] =  true; --	5384;
NoSpellTarget[SpellIds["冰凍陷阱(冰霜)"]] =  true; --	1499;
NoSpellTarget[SpellIds["威懾"]] =  true; --	19263;
NoSpellTarget[SpellIds["寒冰陷阱(冰霜)"]] =  true; --	13809;
NoSpellTarget[SpellIds["毒蛇陷阱(自然)"]] =  true; --	34600;
NoSpellTarget[SpellIds["爆炸陷阱(火焰)"]] =  true; --	13813;
NoSpellTarget[SpellIds["獻祭陷阱(火焰)"]] =  true; --	13795;
NoSpellTarget[SpellIds["逃脫"]] =  true; --	781;
NoSpellTarget[SpellIds["主人的呼喚"]] =  true; --	53271;
NoSpellTarget[SpellIds["復活寵物"]] =  true; --	982;
NoSpellTarget[SpellIds["擊殺命令"]] =  true; --	34026;
NoSpellTarget[SpellIds["治療寵物"]] =  true; --	136;
NoSpellTarget[SpellIds["獵豹守護"]] =  true; --	5118;
NoSpellTarget[SpellIds["解散野獸"]] =  true; --	2641;
NoSpellTarget[SpellIds["豹群守護"]] =  true; --	13159;
NoSpellTarget[SpellIds["野性守護"]] =  true; --	20043;
NoSpellTarget[SpellIds["野獸知識"]] =  true; --	1462;
NoSpellTarget[SpellIds["雄鷹守護"]] =  true; --	13165;
NoSpellTarget[SpellIds["餵養寵物"]] =  true; --	6991;
NoSpellTarget[SpellIds["鷹眼術"]] =  true; --	6197;  
 
 
BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);
 
function BeeSpellIsMove(Id,unit,name) --处理移动中能施放的技能
	if (Id == SpellIds["眼鏡蛇射擊"] or Id == SpellIds["穩固射擊"]) and UnitAura("player", BuffName["獵狐守護"]) then 
		return true;
	end
end

function BeeSpellIsActivation(Id,unit,name) --处理被激活技能
	--if Id == SpellIds["憤怒之錘"] then 
	--end
	return true;
end

function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true;
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId] and true;
end
