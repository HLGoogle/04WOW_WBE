if GetLocale() ~= "zhTW" then
	return;
end

function BeeSpellIsAllClassInf(SpellIds,NoSpellTarget,BuffNames)

	SpellIds["急救"]=45542;
	SpellIds["炼金术"]=80731;
	SpellIds["药水大师"]=28675;
	SpellIds["烹饪"]=2550;
	SpellIds["基础营火"]=818;
	SpellIds["裁缝"]=75156;
	SpellIds["钓鱼"]=7620
	SpellIds["珠宝加工"]=28894;  
	SpellIds["选矿"]=31252;  
	SpellIds["锻造"]=51300;
	SpellIds["附魔"]=7411;
	SpellIds["分解"]=13262;
	SpellIds["地精工程师"]=20222;  
	SpellIds["工程学"]=51306
	SpellIds["侏儒工程学"]=20219; 
	SpellIds["剥皮"]=74522; 
	SpellIds["转化大师"]=28672
	SpellIds["考古学"]=88961;  
	SpellIds["勘测"]=80451;
	
	SpellIds["转化大师"]=28672;  
	SpellIds["生命之血(等级8)"]=74497;  
	SpellIds["采集草药"]=74519;

	SpellIds["制皮"]=51302;
	SpellIds["药剂大师"]=28677;
	
	--无目标(种族特殊技能内码对应表)
	SpellIds["石像形态(种族特长)"] = 20594;
	SpellIds["狂暴(种族特长)"] = 26297;
	SpellIds["奥术洪流(种族特长)"] = 28730;
	SpellIds["影遁(种族特长)"]=58984;
	SpellIds["纳鲁的赐福(种族特长)"] = 59545;
	SpellIds["血性狂怒(种族特长)"] = 	20572;
	SpellIds["自利(种族特长)"]=59752;
	SpellIds["战争践踏(种族特长)"]=20549;  
	
	SpellIds["双形态(种族特长)"]=68996;  
	SpellIds["狂野奔跑(种族特长)"]=87840;  
	SpellIds["疾步夜行(种族特长)"]=68992;
	
	SpellIds["呼叫大胖(种族特长)"]=69046;  
	SpellIds["火箭弹幕(种族特长)"]=69041;  
	SpellIds["火箭跳(种族特长)"]=69070;


	NoSpellTarget[SpellIds["石像形态(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["狂暴(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["奥术洪流(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["影遁(种族特长)"]]= true;
	NoSpellTarget[SpellIds["纳鲁的赐福(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["血性狂怒(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["自利(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["战争践踏(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["双形态(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["狂野奔跑(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["疾步夜行(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["呼叫大胖(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["火箭弹幕(种族特长)"]] =  true;
	NoSpellTarget[SpellIds["火箭跳(种族特长)"]] =  true;
	
	
	NoSpellTarget[SpellIds["急救"]] = true;
	NoSpellTarget[SpellIds["炼金术"]] = true;
	NoSpellTarget[SpellIds["药水大师"]] = true;
	NoSpellTarget[SpellIds["烹饪"]] = true;
	NoSpellTarget[SpellIds["基础营火"]] = true;
	NoSpellTarget[SpellIds["裁缝"]] = true;
	NoSpellTarget[SpellIds["钓鱼"]] = true;
	NoSpellTarget[SpellIds["附魔"]] = true;
	NoSpellTarget[SpellIds["分解"]] = true;
	
	NoSpellTarget[SpellIds["地精工程师"]] = true;
	NoSpellTarget[SpellIds["工程学"]] = true;
	NoSpellTarget[SpellIds["侏儒工程学"]] = true;
	
	NoSpellTarget[SpellIds["剥皮"]] = true;
	NoSpellTarget[SpellIds["转化大师"]] = true;
	
	NoSpellTarget[SpellIds["考古学"]] = true;
	NoSpellTarget[SpellIds["勘测"]] = true;
	
	NoSpellTarget[SpellIds["转化大师"]] = true;
	NoSpellTarget[SpellIds["生命之血(等级8)"]] = true;
	NoSpellTarget[SpellIds["采集草药"]] = true;
	NoSpellTarget[SpellIds["制皮"]] = true;
	
	NoSpellTarget[SpellIds["药剂大师"]] = true;
	
end


local IgnoreSpellIds = {};
IgnoreSpellIds["急救"]=45542;
IgnoreSpellIds["炼金术"]=80731;
IgnoreSpellIds["药水大师"]=28675;
IgnoreSpellIds["烹饪"]=2550;
IgnoreSpellIds["基础营火"]=818;
IgnoreSpellIds["裁缝"]=75156;
IgnoreSpellIds["钓鱼"]=7620
IgnoreSpellIds["珠宝加工"]=28894;  
IgnoreSpellIds["选矿"]=31252;  
IgnoreSpellIds["锻造"]=51300;
IgnoreSpellIds["附魔"]=7411;
IgnoreSpellIds["分解"]=13262;

IgnoreSpellIds["地精工程师"]=20222;  
IgnoreSpellIds["工程学"]=51306
IgnoreSpellIds["侏儒工程学"]=20219; 

IgnoreSpellIds["石像形态(种族特长)"] = 20594;
IgnoreSpellIds["狂暴(种族特长)"] = 26297;
IgnoreSpellIds["奥术洪流(种族特长)"] = 28730;
IgnoreSpellIds["影遁(种族特长)"]=58984;
IgnoreSpellIds["纳鲁的赐福(种族特长)"] = 59545;
IgnoreSpellIds["血性狂怒(种族特长)"] = 	20572;
IgnoreSpellIds["自利(种族特长)"]=59752;
IgnoreSpellIds["战争践踏(种族特长)"]=20549;  

IgnoreSpellIds["双形态(种族特长)"]=68996;  
IgnoreSpellIds["狂野奔跑(种族特长)"]=87840;  
IgnoreSpellIds["疾步夜行(种族特长)"]=68992;
	
IgnoreSpellIds["剥皮"]=74522;  
IgnoreSpellIds["转化大师"]=28672

IgnoreSpellIds["呼叫大胖(种族特长)"]=69046;  
IgnoreSpellIds["火箭弹幕(种族特长)"]=69041;  
IgnoreSpellIds["火箭跳(种族特长)"]=69070; 
  
IgnoreSpellIds["考古学"]=88961;  
IgnoreSpellIds["勘测"]=80451;

IgnoreSpellIds["转化大师"]=28672;  
IgnoreSpellIds["生命之血(等级8)"]=74497;  
IgnoreSpellIds["采集草药"]=74519;
IgnoreSpellIds["制皮"]=51302;

IgnoreSpellIds["药剂大师"]=28677;

function BeeSpellIsAllClassIgnoreInf(name,inf)
	if IgnoreSpellIds[name] and inf == "ID错误"  or IgnoreSpellIds[name] and not inf then
		return false;
	else
		return true;
	end
end

function BeeTestSpellBook(SpellIds)
	
	local i = 1;
	local tbl={};
	
	while true do
	
		skillType, spellId = GetSpellBookItemInfo(i, "player")
		
		

		if not spellId then
		  do break end
		end
		
		local spellName, spellSubName =GetSpellInfo(spellId);
		
		if spellName then
		
			if not spellSubName then
				spellSubName="";
			end
			
			local s ;
			
			if spellSubName == "" then
				s=spellName;
			else
				s = spellName .. "(" .. spellSubName ..")";
			end
			
			
			if not IsPassiveSpell(i,BOOKTYPE_SPELL) and not SpellIds[s] then
				
				if BeeSpellIsAllClassIgnoreInf(spellName) then
				
					table.insert(tbl, spellId);
				end
			end
		end
		
		i = i + 1
   end
   
   return tbl;

end
