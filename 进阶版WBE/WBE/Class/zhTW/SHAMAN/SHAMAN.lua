if GetLocale() ~= "zhTW" then
	return;
end

local SpellErrList={};
local playerClass, englishClass = UnitClass("player");

if englishClass ~= "SHAMAN" then
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

SpellIds["元素呼喚"] =  66842;
SpellIds["先祖呼喚"] =  66843;
SpellIds["火焰新星"] =  1535;
SpellIds["地縛圖騰"] =  2484;
SpellIds["灼熱圖騰"] =  3599;
SpellIds["火元素圖騰"] =  2894;
SpellIds["熔岩圖騰"] =  8190;
SpellIds["石爪圖騰"] =  5730;
SpellIds["精靈呼喚"] =  66844;
SpellIds["元素抗性圖騰"] =  8184;
SpellIds["根基圖騰"] =  8177;
SpellIds["土元素圖騰"] =  2062;
SpellIds["火舌圖騰"] =  8227;
SpellIds["大地之力圖騰"] =  8075;
SpellIds["石甲圖騰"] =  8071;
SpellIds["風懲圖騰"] =  3738;
SpellIds["英勇氣概"] =  32182;
SpellIds["鬼魂之狼"] =  2645;
SpellIds["閃電之盾"] =  324;
SpellIds["風怒圖騰"] =  8512;
SpellIds["召回圖騰"] =  36936;
SpellIds["戰慄圖騰"] =  8143;
SpellIds["水之盾"] =  52127;
SpellIds["治療之泉圖騰"] =  5394;
SpellIds["平靜思緒圖騰"] =  87718;
SpellIds["自然迅捷"] =  16188;
SpellIds["法力之潮圖騰"] =  16190;
SpellIds["法力之泉圖騰"] =  5675;
SpellIds["大地生命武器"] =  51730;
SpellIds["石化武器"] =  8017;
SpellIds["火舌武器"] =  8024;
SpellIds["冰封武器"] =  8033;
SpellIds["雷霆風暴"] =  51490;
SpellIds["精通元素"] =  16166;
SpellIds["野性之魂"] =  51533;
SpellIds["薩滿之怒"] =  30823; 

--無目標(種族特殊技能內碼對應表)
SpellIds["石像形態(種族特長)"] = 20594;
SpellIds["狂暴(種族特長)"] = 26297;
SpellIds["奧流之術(種族特長)"] = 28730;

NoSpellTarget[SpellIds["石像形態(種族特長)"]] =  true;
NoSpellTarget[SpellIds["狂暴(種族特長)"]] =  true;
NoSpellTarget[SpellIds["奧流之術(種族特長)"]] =  true;


NoSpellTarget[SpellIds["元素呼喚"]] =  true;
NoSpellTarget[SpellIds["先祖呼喚"]] =  true;
NoSpellTarget[SpellIds["火焰新星"]] =  true;
NoSpellTarget[SpellIds["地縛圖騰"]] =  true;
NoSpellTarget[SpellIds["灼熱圖騰"]] =  true;
NoSpellTarget[SpellIds["火元素圖騰"]] =  true;
NoSpellTarget[SpellIds["熔岩圖騰"]] =  true;
NoSpellTarget[SpellIds["石爪圖騰"]] =  true;
NoSpellTarget[SpellIds["精靈呼喚"]] =  true;
NoSpellTarget[SpellIds["元素抗性圖騰"]] =  true;
NoSpellTarget[SpellIds["根基圖騰"]] =  true;
NoSpellTarget[SpellIds["土元素圖騰"]] =  true;
NoSpellTarget[SpellIds["火舌圖騰"]] =  true;
NoSpellTarget[SpellIds["大地之力圖騰"]] =  true;
NoSpellTarget[SpellIds["石甲圖騰"]] =  true;
NoSpellTarget[SpellIds["風懲圖騰"]] =  true;
NoSpellTarget[SpellIds["英勇氣概"]] =  true;
NoSpellTarget[SpellIds["鬼魂之狼"]] =  true;
NoSpellTarget[SpellIds["閃電之盾"]] =  true;
NoSpellTarget[SpellIds["風怒圖騰"]] =  true;
NoSpellTarget[SpellIds["召回圖騰"]] =  true;
NoSpellTarget[SpellIds["戰慄圖騰"]] =  true;
NoSpellTarget[SpellIds["水之盾"]] =  true;
NoSpellTarget[SpellIds["治療之泉圖騰"]] =  true;
NoSpellTarget[SpellIds["平靜思緒圖騰"]] =  true;
NoSpellTarget[SpellIds["自然迅捷"]] =  true;
NoSpellTarget[SpellIds["法力之潮圖騰"]] =  true;
NoSpellTarget[SpellIds["法力之泉圖騰"]] =  true;
NoSpellTarget[SpellIds["大地生命武器"]] =  true;
NoSpellTarget[SpellIds["石化武器"]] =  true;
NoSpellTarget[SpellIds["火舌武器"]] =  true;
NoSpellTarget[SpellIds["冰封武器"]] =  true;
NoSpellTarget[SpellIds["雷霆風暴"]] =  true;
NoSpellTarget[SpellIds["精通元素"]] =  true;
NoSpellTarget[SpellIds["野性之魂"]] =  true;
NoSpellTarget[SpellIds["薩滿之怒"]] =  true; 


------
BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames);

function BeeSpellIsNoTarget(SpellId) --技能是否是有无目标标志
	return NoSpellTarget[SpellId] and true;
end

function BeeSpellIsRaid(spellId)
	return RaidSpell[spellId] and true;
end