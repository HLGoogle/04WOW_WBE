if GetLocale() ~= "zhCN" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "SHAMAN" then
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

SpellIds["元素的召唤"] =  66842;
SpellIds["先祖的召唤"] =  66843;
SpellIds["火焰新星"] =  1535;
SpellIds["地缚图腾"] =  2484;
SpellIds["灼热图腾"] =  3599;
SpellIds["火元素图腾"] =  2894;
SpellIds["熔岩图腾"] =  8190;
SpellIds["石爪图腾"] =  5730;
SpellIds["灵魂的召唤"] =  66844;
SpellIds["元素抗性图腾"] =  8184;
SpellIds["根基图腾"] =  8177;
SpellIds["土元素图腾"] =  2062;
SpellIds["火舌图腾"] =  8227;
SpellIds["大地之力图腾"] =  8075;
SpellIds["石肤图腾"] =  8071;
SpellIds["空气之怒图腾"] =  3738;
SpellIds["英勇"] =  32182;
SpellIds["幽魂之狼"] =  2645;
SpellIds["闪电之盾"] =  324;
SpellIds["风怒图腾"] =  8512;
SpellIds["图腾召回"] =  36936;
SpellIds["战栗图腾"] =  8143;
SpellIds["水之护盾"] =  52127;
SpellIds["治疗之泉图腾"] =  5394;
SpellIds["宁静心智图腾"] =  87718;
SpellIds["自然迅捷"] =  16188;
SpellIds["法力之潮图腾"] =  16190;
SpellIds["法力之泉图腾"] =  5675;
SpellIds["大地生命武器"] =  51730;
SpellIds["石化武器"] =  8017;
SpellIds["火舌武器"] =  8024;
SpellIds["冰封武器"] =  8033;
SpellIds["雷霆风暴"] =  51490;
SpellIds["元素掌握"] =  16166;
SpellIds["野性狼魂"] =  51533;
SpellIds["萨满之怒"] =  30823; 

------------------CTM---------


SpellIds["自动攻击"]=6603;
SpellIds["闪电箭"]=403;
SpellIds["大地震击"]=8042;
SpellIds["净化术"]=370;
SpellIds["烈焰震击"]=8050;
SpellIds["风剪"]=57994;
SpellIds["冰霜震击"]=8056;
SpellIds["闪电链"]=421;
SpellIds["熔岩爆裂"]=51505;
SpellIds["束缚元素"]=76780;
SpellIds["妖术"]=51514;
SpellIds["灵魂行者的恩赐"]=79206;
SpellIds["根源打击"]=73899;
SpellIds["水上行走"]=546;
SpellIds["星界传送"]=556;
SpellIds["风怒武器"]=8232;
SpellIds["视界术"]=6196;
SpellIds["水下呼吸"]=131;
SpellIds["元素释放"]=73680;
SpellIds["治疗波"]=331;
SpellIds["先祖之魂"]=2008;
SpellIds["净化灵魂"]=51886;
SpellIds["治疗之涌"]=8004;
SpellIds["治疗链"]=1064;
SpellIds["强效治疗波"]=77472;
SpellIds["治疗之雨"]=73920

SpellIds["大地之盾"]=974;  
SpellIds["激流"]=61295;  
SpellIds["灵魂链接图腾"]=98008;  

SpellIds["熔岩猛击"]=60103;  
SpellIds["风暴打击"]=17364;  


------------------

NoSpellTarget[SpellIds["元素的召唤"]] =  true;
NoSpellTarget[SpellIds["先祖的召唤"]] =  true;
NoSpellTarget[SpellIds["火焰新星"]] =  true;
NoSpellTarget[SpellIds["地缚图腾"]] =  true;
NoSpellTarget[SpellIds["灼热图腾"]] =  true;
NoSpellTarget[SpellIds["火元素图腾"]] =  true;
NoSpellTarget[SpellIds["熔岩图腾"]] =  true;
NoSpellTarget[SpellIds["石爪图腾"]] =  true;
NoSpellTarget[SpellIds["灵魂的召唤"]] =  true;
NoSpellTarget[SpellIds["元素抗性图腾"]] =  true;
NoSpellTarget[SpellIds["根基图腾"]] =  true;
NoSpellTarget[SpellIds["土元素图腾"]] =  true;
NoSpellTarget[SpellIds["火舌图腾"]] =  true;
NoSpellTarget[SpellIds["大地之力图腾"]] =  true;
NoSpellTarget[SpellIds["石肤图腾"]] =  true;
NoSpellTarget[SpellIds["空气之怒图腾"]] =  true;
NoSpellTarget[SpellIds["英勇"]] =  true;
NoSpellTarget[SpellIds["幽魂之狼"]] =  true;
NoSpellTarget[SpellIds["闪电之盾"]] =  true;
NoSpellTarget[SpellIds["风怒图腾"]] =  true;
NoSpellTarget[SpellIds["图腾召回"]] =  true;
NoSpellTarget[SpellIds["战栗图腾"]] =  true;
NoSpellTarget[SpellIds["水之护盾"]] =  true;
NoSpellTarget[SpellIds["治疗之泉图腾"]] =  true;
NoSpellTarget[SpellIds["宁静心智图腾"]] =  true;
NoSpellTarget[SpellIds["自然迅捷"]] =  true;
NoSpellTarget[SpellIds["法力之潮图腾"]] =  true;
NoSpellTarget[SpellIds["法力之泉图腾"]] =  true;
NoSpellTarget[SpellIds["大地生命武器"]] =  true;
NoSpellTarget[SpellIds["石化武器"]] =  true;
NoSpellTarget[SpellIds["火舌武器"]] =  true;
NoSpellTarget[SpellIds["冰封武器"]] =  true;
NoSpellTarget[SpellIds["雷霆风暴"]] =  true;
NoSpellTarget[SpellIds["元素掌握"]] =  true;
NoSpellTarget[SpellIds["野性狼魂"]] =  true;
NoSpellTarget[SpellIds["萨满之怒"]] =  true; 


----------CTM----

NoSpellTarget[SpellIds["灵魂行者的恩赐"]] =  true; 
NoSpellTarget[SpellIds["星界传送"]] =  true; 
NoSpellTarget[SpellIds["风怒武器"]] =  true; 
NoSpellTarget[SpellIds["视界术"]] =  true; 
NoSpellTarget[SpellIds["治疗之雨"]] =  true; 

NoSpellTarget[SpellIds["灵魂链接图腾"]] =  true; 

BuffName["灵魂行者的恩赐"]=GetSpellInfo(SpellIds["灵魂行者的恩赐"]);
------
BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true;
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId] and true;
end

local N_71155 = GetSpellInfo(101052); --脱缰雷霆
