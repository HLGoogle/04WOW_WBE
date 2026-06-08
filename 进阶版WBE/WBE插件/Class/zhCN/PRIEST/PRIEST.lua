if GetLocale() ~= "zhCN" then
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


--BuffNames["脉轮：佑"] = GetSpellInfo(81207);
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

--技能转换

function BeeSpellIsConversion(spell) -- 圣言术：罚
	if BeeGetSpellName(SpellIds["圣言术：罚"]) ~= spell then
		return false;
	end
		
	local spellId = false;

	if BeePlayerBuffTime(BuffNames["脉轮：罚"])>0 then
		spellId=SpellIds["圣言术：罚"];
	elseif BeePlayerBuffTime(BuffNames["脉轮：佑"])>0 then
			spellId=SpellIds["圣言术：佑"];
	elseif BeePlayerBuffTime(BuffNames["脉轮：静"])>0 then
		spellId=SpellIds["圣言术：静"];	
	end
	if spellId then
		return spellId,BeeGetSpellName(spellId);
	else
		return false;
	end
end

function BeeSpellIsEx(spell)
	if BeeGetSpellName(SpellIds["圣言术：佑"])==spell or BeeGetSpellName(SpellIds["圣言术：罚"])==spell or BeeGetSpellName(SpellIds["圣言术：静"])==spell then
		return BeeSpellIsEx_88625(spell);
	end
end

function BeeSpellIsEx_88625(spell) -- 圣言术：罚
	local spellId,slotID,typenumber,Cooldown;
	local spellname,level,powerCost,castTime , minRange, maxRange;
	spellId = SpellIds[spell];
	typenumber=1;
	spellname,level, _, powerCost,_,_,castTime, minRange, maxRange = GetSpellInfo(spellId);
	WowBee.Spell.Property[spell]={};
	WowBee.Spell.Property[spell]["Type"]=1;
	WowBee.Spell.Property[spell]["TypeName"]="spell";
	WowBee.Spell.Property[spell]["SpellId"]=spellId;
	WowBee.Spell.Property[spell]["SlotID"]=false;
	WowBee.Spell.Property[spell]["Time"]= GetTime();
		
	WowBee.Spell.Property[spell]["PowerCost"]= powerCost;
	WowBee.Spell.Property[spell]["CastTime"]= castTime;
	WowBee.Spell.Property[spell]["SpellName"]= spellname;
	WowBee.Spell.Property[spell]["Level"]= level;
	WowBee.Spell.Property[spell]["Spell"]= spell;
	WowBee.Spell.Property[spell]["RaidSpell"]= false;
	if spellId==SpellIds["圣言术：罚"] then
		WowBee.Spell.Property[spell]["HasRange"]=1;
	elseif spellId==SpellIds["圣言术：佑"] then
		WowBee.Spell.Property[spell]["HasRange"]=false;
	elseif spellId==SpellIds["圣言术：静"] then
		WowBee.Spell.Property[spell]["HasRange"]=1;
	end

	return 	true,1,spell;
end

function Bee_IsSpell_Conversion(name,tunit,gcd,Special,isname,typenumber,SpellLevel,temp_UnitGUID,unitguid)
	if not(BeeGetSpellName(SpellIds["圣言术：佑"])==name or BeeGetSpellName(SpellIds["圣言术：罚"])==name or BeeGetSpellName(SpellIds["圣言术：静"])==name) then
		return false,-100;
	end

	if WowBee.Config.SetGCD and not gcd then
		if BeeGCD()> WowBee.Config.SetGCD_Time then	
			return false,typenumber,"公共CD没好",Cooldown;
		end
	end
	
	local spellId = WowBee.Spell.Property[name]["SpellId"];
	local slotID = WowBee.Spell.Property[name]["SlotID"];
		
	local T_temp1 = GetUnitSpeed("player");
	local T_temp2 = WowBee.Spell.Property[name]["CastTime"] ;

	if T_temp2 >0 and T_temp1>0 then
			
		return false,typenumber,"你移动中",Cooldown;
	end
		
	local UnitCan_a;

	if  WowBee.Spell.Property[name]["HasRange"] and tunit ~= "nogoal" then
		UnitCan_a = UnitCanAssist("player", tunit);
		if  not UnitCan_a then
			return false,typenumber,"技能对目标无效",Cooldown;
		end
			
		if BeeRange(tunit)>40 then
			return false,typenumber,"技能距离太远",Cooldown;
		end
	end

	local start, duration, enabled  = GetSpellCooldown(spellId)
		
	Cooldown = start + duration - GetTime();
		
	if Cooldown < 0 then
		Cooldown = 0;
	end
		
	if Cooldown >0 then
		return false,typenumber,"技能冷却中",Cooldown;
	end
		
	if BeeUnitMana("player") < WowBee.Spell.Property[name]["PowerCost"]  then
		 return false,typenumber,"能量不足",Cooldown;
	end	
	return 	true,1,name;
end


