if GetLocale() ~= "zhTW" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "MAGE" then
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


SpellIds["射击"]=5019;
SpellIds["自动攻击"]=6603;
SpellIds["寒冰箭"]=116;
SpellIds["冰霜新星"]=122;
SpellIds["冰锥术"]=120;
SpellIds["冰枪术"]=30455;
SpellIds["寒冰屏障"]=45438;
SpellIds["暴风雪"]=10;
SpellIds["霜甲术"]=7302;
SpellIds["冰霜之环"]=82676;
SpellIds["奥术飞弹"]=5143;
SpellIds["法术反制"]=2139;
SpellIds["唤醒"]=12051;
SpellIds["变形术"]=118;
SpellIds["闪现术"]=1953;
SpellIds["奥术冲击"]=30451;
SpellIds["魔爆术"]=1449;
SpellIds["解除诅咒"]=475;
SpellIds["缓落术"]=130;
SpellIds["法师结界"]=543;
SpellIds["造餐术"]=42955;
SpellIds["法力护盾"]=1463;
SpellIds["制造法力宝石"]=759;
SpellIds["镜像"]=55342;
SpellIds["奥术光辉"]=1459;
SpellIds["法师护甲"]=6117;
SpellIds["法术吸取"]=30449;
SpellIds["召唤餐桌"]=43987;
SpellIds["隐形术"]=66;
SpellIds["时间扭曲"]=80353;
SpellIds["火球术"]=133;
SpellIds["火焰冲击"]=2136;
SpellIds["灼烧"]=2948;
SpellIds["熔岩护甲"]=30482;
SpellIds["烈焰风暴"]=2120;
SpellIds["霜火之箭"]=44614;
SpellIds["烈焰宝珠"]=82731

SpellIds["减速"]=31589;  
SpellIds["奥术弹幕"]=44425;  
SpellIds["气定神闲"]=12043;  
SpellIds["传送门：埃索达"]=32266;  
SpellIds["传送门：塞拉摩"]=49360;  
SpellIds["传送门：暴风城"]=10059;  
SpellIds["传送门：达纳苏斯"]=11419;  
SpellIds["传送门：铁炉堡"]=11416;  
SpellIds["传送：埃索达"]=32271;  
SpellIds["传送：塞拉摩"]=49359;  
SpellIds["传送：暴风城"]=3561;  
SpellIds["传送：达纳苏斯"]=3565;  
SpellIds["传送：铁炉堡"]=3562;  
SpellIds["生命之血(等级1)"]=81708;
 
NoSpellTarget[SpellIds["冰霜新星"]] =  true; 
NoSpellTarget[SpellIds["冰锥术"]] =  true; 
NoSpellTarget[SpellIds["寒冰屏障"]] =  true; 
NoSpellTarget[SpellIds["暴风雪"]] =  true; 
NoSpellTarget[SpellIds["冰霜之环"]] =  true; 
NoSpellTarget[SpellIds["唤醒"]] =  true; 
NoSpellTarget[SpellIds["闪现术"]] =  true; 
NoSpellTarget[SpellIds["魔爆术"]] =  true; 
NoSpellTarget[SpellIds["法师结界"]] =  true; 
NoSpellTarget[SpellIds["造餐术"]] =  true; 
NoSpellTarget[SpellIds["法力护盾"]] =  true; 
NoSpellTarget[SpellIds["制造法力宝石"]] =  true; 
NoSpellTarget[SpellIds["镜像"]] =  true; 
NoSpellTarget[SpellIds["奥术光辉"]] =  true; 

NoSpellTarget[SpellIds["法师护甲"]] =  true; 
NoSpellTarget[SpellIds["召唤餐桌"]] =  true; 
NoSpellTarget[SpellIds["隐形术"]] =  true; 
NoSpellTarget[SpellIds["时间扭曲"]] =  true; 
NoSpellTarget[SpellIds["熔岩护甲"]] =  true; 
NoSpellTarget[SpellIds["烈焰风暴"]] =  true; 

NoSpellTarget[SpellIds["烈焰宝珠"]] =  true;

NoSpellTarget[SpellIds["传送门：埃索达"]] =  true; 
NoSpellTarget[SpellIds["传送门：塞拉摩"]] =  true; 
NoSpellTarget[SpellIds["传送门：暴风城"]] =  true;
NoSpellTarget[SpellIds["传送门：达纳苏斯"]] =  true;  
NoSpellTarget[SpellIds["传送门：铁炉堡"]] =  true;
NoSpellTarget[SpellIds["传送：埃索达"]] =  true;
NoSpellTarget[SpellIds["传送：塞拉摩"]] =  true;
NoSpellTarget[SpellIds["传送：暴风城"]] =  true;
NoSpellTarget[SpellIds["传送：达纳苏斯"]] =  true;
NoSpellTarget[SpellIds["传送：铁炉堡"]] =  true;
NoSpellTarget[SpellIds["生命之血(等级1)"]] =  true;
 
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
