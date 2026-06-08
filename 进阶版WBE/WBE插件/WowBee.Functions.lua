-- --function GetNumRaidMembers()
-- --return GetNumGroupMembers()
-- --end
-- function GetNumPartyMembers()
-- return GetNumGroupMembers()
-- end
function SpellIsRun(spellName,target)
	if IsUsableSpell(spellName) and IsSpellInRange(spellName,target)==1 then
		if GetSpellCooldown(spellName) == 0 then
			return true
		end
	end
return false
end

function BeeIsRun(spell,unit,gcd,special,isRun,NOCD,EnergyDemand)--是否可以对此目标施放技能
	local A,B,C,D,E,F,G,H,I;
	
	if not spell then
		return;
	end
	
	unit=BeeUnit(unit,"target");
	
	if BeeSpellIsConversion then
		local scid,scname = BeeSpellIsConversion(spell);
		if scid then
			spell=scname;
		end
	end
	
	local t,text = Bee_IsFailed(spell,unit);
	if not t then
		
		WowBee.Spell.Property[spell] = WowBee.Spell.Property[spell] or {};
		
		A=t;
		B = WowBee.Spell.Property[spell]["Type"] or "";
		C=text;
		D=0;
		E="";
		F="";
		G="";
		H="";
	else
		A,B,C,D,E,F,G,H,I=Bee_IsRunSpell(spell,unit,gcd,special,NOCD,EnergyDemand);
	end
	

	if A then
		Bee_IsRunSpell_Result(spell,unit,A)
	end
	
	return A,B,C,D,E,F,spell,unit,I
end

function BeeRun(spell,unit,mouse) -- 施放技能
	
	--if (GetTime() - WowBee.Spell.Sleep )<=0.01 then
	--print("因为时间返回")
	--	return false;
	--end;

	unit=BeeUnit(unit,"target");
	
	local macroSpell = strsub(spell,1,1);
	local tspell="";
	
	if macroSpell == "/"  then
		tspell=spell;
		alan("RunMacroText('" .. tspell .."')")
	else
	--local t1,t2,_,spellId = true,true,true,true;
	local t1,t2,_,spellId = Bee_GetSpellInf(spell);
	--print(t1,t2,spellId)
	if not t1 then
		return false;
	end
		
	if t1 and t2==5 then
		alan("CastSpellByName('".. spell ..")")
		tspell=spell;
	elseif t1 and (t2 ==1 or t2==2 or t2==3) then
	
		if not spellId then
			spellId = "'" .. spell .. "'";
		end
		
		if unit == "nogoal" then
			tspell ="/cast " .. spell;
		else		
			tspell ="/cast [target=" .. unit .. "]" .. spell;
		end
		alan("RunMacroText('" .. tspell .."')")
	elseif t1 and t2 ==4 then
		local getMacroIndex = GetMacroIndexByName(spell)
		if getMacroIndex >0 then
			local sepll, rank ,body = GetMacroInfo(getMacroIndex);
			tspell=body;
		else
			return false;
		end
	end
	end
	if(tspell and tspell~="")then
		if mouse then
			WowBeeHelper_OnMacro(string.format("%s#%s",mouse,tspell),5)
		else
			WowBeeHelper_OnMacro(tspell)
		end
		return true;
	else
		return false;
	end
	
end

function BeePassPhrase(text) --消息密语
	if text then
		WowBee.Spell.Event.PhraseText=text;
		WowBee.Spell.Event.PassPhrase= true;
	else
		WowBee.Spell.Event.PassPhrase=false;
	end
end

function BeeUnitIsFollow() --跟随目标 
	return WowBee.Spell.Event.FollowUnit;
end

function BeeGCD(spellname) --获得某职业的公告CD
	local spellid;
	if spellname then
		spellid = GetSpellInfo(spellname)
	else
		if WowBee.Player.GCD==0 then
			return 0
		end
		spellid = GetSpellInfo(WowBee.Player.GCD)
	end
	
	if not spellid then
		return -1
	end
	
	local start, dur = GetSpellCooldown(spellid)
	if (start and dur and start>0 and dur>0) then
		return dur - (GetTime() - start) 
	end
	return 0
end

function BeeSpellCD(spell) --技能CD冷却时间

	local isname,typenumber,spellLevel = Bee_GetSpellInf(spell);
	
	if typenumber == -1 then
		return -1,false,typenumber,"無法識別的技能、物品";
	elseif typenumber==4 or typenumber==5 then
		return -1,false,typenumber,"無法獲得技能、物品以外的冷卻時間";
	end

	local n,is
	
	if typenumber == 1 then
		local spellId = WowBee.Spell.Property[spell]["SpellId"];
		n,is = BeeSpellCoolDown(spellId)
		if is then
			return n,is;
		end
	elseif typenumber == 2 or typenumber == 3 then
		
		local itemID = WowBee.Spell.Property[spell]["ItemID"];
		n,is = BeeItemCoolDown(itemID)
		if is then
			return n,is;
		end
	end
	
	return -1,is;
end

function BeeItemCoolDown(item) 
	local itemID;
	local isname = nil;
	if type(item) == "string" then
		itemID = BeeGetItemId(item)
		if not itemID then
			return -1,isname;
		end
		isname=1;
	else
		itemID =item;
		if GetItemInfo(itemID) then
			isname=1;
		else
			return -1,isname;
		end
	end

	local isEquipped = IsEquippedItem(itemID)
	local a,b,c = GetItemCooldown(itemID);
	local n;	
	if c ==0 or not a then
		return -1,isname,isEquipped,itemID;
	end
		
	n = a+b-GetTime()
	return IF(n < 0,0,n),isname,isEquipped,itemID;
end

function BeeSpellCoolDown(spell)
	local isname = nil;
	local a,b,c = GetSpellCooldown(spell) 
	
	if a then
		isname=1;
	else
		isname=nil;
		return -1,isname;
	end
	
	if c ==0 or not a then
		return -1,isname;
	end
	
	n = a+b-GetTime();
	return IF(n < 0,0,n),isname;
end

function BeeRange(unit1, unit2)-- 判断距离
	if not unit2 then
		unit1= BeeUnit(unit1,"target");
		if not UnitName(unit1) then
			return 100000000;
		end
		local jl;
		if( WowBee.Spell.RC) then
		_,jl = WowBee.Spell.RC:getRange(unit1)
		end
		return IF(jl,jl,100000000);
	else
		--参数类型格式化
		local i=0;
		if UnitInRaid("player") then
			if string.lower(string.sub(unit1,1,4))~="raid" or string.lower(string.sub(unit2,1,4))~="raid" then
				for i=1, GetNumRaidMembers() do
					local tempname, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);
					unit1= tempname==unit1 and "raid" .. tostring(i) or unit1;
					unit2= tempname==unit2 and "raid" .. tostring(i) or unit2;
				end
				if string.lower(string.sub(unit1,1,4))~="raid" or string.lower(string.sub(unit2,1,4))~="raid" then
					return 100000000;
				end
			end
		elseif UnitInParty("player") then
			if (string.lower(string.sub(unit1,1,5))~="party" and string.lower(unit1)~="player") or (string.lower(string.sub(unit2,1,5))~="party" and string.lower(unit2)~="player") then
				unit1= UnitName("player")==unit1 and "player" or unit1;
				unit2= UnitName("player")==unit2 and "player" or unit2;
		
				for i=1, GetNumPartyMembers() do
					local tempname=UnitName("party" .. tostring(i))
					unit1= tempname==unit1 and "party" .. tostring(i) or unit1;
					unit2= tempname==unit2 and "party" .. tostring(i) or unit2;
				end
				if (string.lower(string.sub(unit1,1,5))~="party" and string.lower(unit1)~="player") or (string.lower(string.sub(unit2,1,5))~="party" and string.lower(unit2)~="player") then
					return 100000000;
				end
			end
		else
			return 100000000;
		end
		--计算距离
		local _,mapheight,mapwidth=GetMapInfo();
		local unit1x, unit1y = GetPlayerMapPosition(unit1);
		local unit2x, unit2y = GetPlayerMapPosition(unit2);
		if mapheight and mapheight>0 and mapwidth and mapwidth>0 and unit1x and unit1x>0 and unit1y and unit1y>0 and unit2x and unit2x>0 and unit2y and unit2y>0 then
			local length=math.ceil(math.sqrt(math.pow((unit1x-unit2x)*mapwidth,2)+math.pow((unit1y-unit2y)*mapheight,2)));
			return length;
		else
			return 100000000;
		end
	end
end

function BeeTalentInfo(talentname)--獲得你的天賦某選項的信息
	--local i,k
	--for i=1, GetNumTalentTabs() do
	---	for k=1, GetNumTalents(i) do
		--	local name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(i,k)
		--	if name == talentname then
		--		return rank, maxRank
		--	end
	--	end
	--end
	return nil;
end

function BeeTalentName() --获得当前天赋名称
	local s;
	local m=0;
	for i=1,GetNumTalentTabs() do
		local _,_,_,_,p=GetTalentTabInfo(i);
		if p>m then
			m=p;
			s=i;
		end
	end
	local _,n=GetTalentTabInfo(s);
	return n
end

-- function BeeGetSpellId(name)
	-- if not name then
		-- return;
	-- end

	-- local skillType, spellId = GetSpellBookItemInfo(name);
	-- if spellId then
		-- local spellName,spellSubName =GetSpellInfo(spellId);
		-- return spellId,spellName,spellSubName,skillType;
	-- end
-- end

 function BeeGetSpellId(spellname) --獲得技能在技能書的ID
	local spellid = nil
	for tab = 1, 4 do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		for i = (1+offset), (offset+numSpells) do
			local spell = GetSpellBookItemName(i, BOOKTYPE_SPELL)
			
			if strlower(spell) == strlower(spellname) then
				spellid = i
				break
			end
		end
	end
	return spellid;
end

function BeeGetItemId(name)
	local itemId,spell,bagName;
	for i=1 , 23 do
		itemId = GetInventoryItemID("player",i)
		if itemId then
			spell = GetItemInfo(itemId)
			if spell == name then
				return itemId;
			end
		end
	end
	
	for i=0 , 10 do
		bagName = GetBagName(i);
		if bagName then
			local n = GetContainerNumSlots(i)
			for k=1 , n do		
				itemId = GetContainerItemID(i, k);
				if itemId then
					spell = GetItemInfo(itemId);
					if spell and spell == name then
						return itemId;
					end
				end
			end
		end
	end
	return nil;
end

function BeeGetSpellName(spellId)

	local spellName,spellRank = GetSpellInfo(spellId);
	if not spellRank then
		spellRank="";
	end
	
	if spellRank ~= "" then
		spellName = spellName .. "(" .. spellRank .. ")" ;
	end
	
	return spellName;
end

function BeeSpellBookId(spellname) --获得技能在技能书的ID
	if not spellname then
		spellname=GetSpellInfo(WowBee.Player.GCD)
	end

	local spellid = nil
	for tab = 1, 4 do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		for i = (1+offset), (offset+numSpells) do
			local spell = GetSpellBookItemName(i, BOOKTYPE_SPELL)
			if strlower(spell) == strlower(spellname) then
				spellid = i
				break
			end
		end
	end
	return spellid;
end

function BeeGetGlyphSocketInfo(GlyphName) --判断雕文
	local numGlyphSockets = GetNumGlyphSockets();
	for i = 1, numGlyphSockets do
		local enabled, glyphType, glyphTooltipIndex, glyphSpellID, icon = GetGlyphSocketInfo(i);
		if ( enabled and glyphSpellID) then
			local name = GetSpellInfo(glyphSpellID);
		
			if name and GlyphName == name then
				return i;
			end
		end
	end
end

function BeeGetShapeshiftId() ---'獲得当前姿態ID
	local a;
	for i=1 , 9 do
		_,name,a = GetShapeshiftFormInfo(i);
		if a then
			return i,name;
		end
	end

	return 0;
end

function BeeUnitCastSpellName(unit,interrupt,times) --获得指定目标正在施放的法术名称,Interrupt 为非0 只返回可以打断的技能
	unit=BeeUnit(unit,"target");
	local c,_,_,_,startTime,_,_,_,i = UnitCastingInfo(unit);
	
	if c then
		--print(GetTime() - startTime/1000,WowBee.Config.ACTime)
		if WowBee.Config.Arena.IsUnitCastSpellName and BeeIsArena() then
			times = IF(times,times,WowBee.Config.ACTime);
			if GetTime() - (startTime/1000) > times then
				if not interrupt then
					return c;
				else
					if not i then
						return c;
					end
				end
			end		
		else
			if not interrupt then
				return c;
			else
				if not i then
					return c;
				end
			end
		end
	else
		c,_,_,_,startTime,_,_,i = UnitChannelInfo(unit);
		if c then
				--print(GetTime() - startTime/1000,WowBee.Config.ACTime)
			if WowBee.Config.Arena.IsUnitCastSpellName and BeeIsArena() then
				times = IF(times,times,WowBee.Config.ACTime);
	
				if GetTime() - (startTime/1000) > times then
					if not interrupt then
						return c;
					else
						if not i then
							return c;
						end
					end
				end		
			else
				if not interrupt then
					return c;
				else
					if not i then
						return c;
					end
				end	
			end
		end
	end
	return false;
end	

function BeeUnitCastSpellTime(unit) --获得指定目标正在施放的法术剩馀时间

	unit = BeeUnit(unit,"target");

	if not UnitName(unit) then
		return -1,-1,"";
	end
	
	local spell, _, _, _, startTime, endTime = UnitCastingInfo(unit)
	
	if spell then 
		local finish = endTime/1000 - GetTime()
		return tonumber(format("%.2f",finish) ),tonumber(format("%.2f",(endTime -startTime) /1000)),spell
	end
	
	local spellch, _, _, _, startTime, endTimech = UnitChannelInfo(unit)
	if spellch then 
		local finishch = endTimech/1000 - GetTime()
		return tonumber(format("%.2f",finishch) ),tonumber(format("%.2f",(endTimech -startTime) /1000)),spellch
	end

	return -1,-1,"";
end


function BeeUnitCastSpellPassTime(spell,unit) --获得指定单位指定技能施放时间.
	unit=BeeUnit(unit,"player");
	if not BeeGetUnitName(unit) or not spell then
		return -2;
	end
	
	local str = UnitGUID(unit) .. "_" .. spell;
	local n = WowBee.Spell.Miss.Name[str];

	if n  then
		return GetTime() - n
	else
		return -1;
	end
end


---------------------------------HUGO-----------------------------------

function BeeSpellFast(spell,unit,stop,times,key) --快速技能
	local vname="Bee_SpellFast";
	BeeSetVariable(vname.."_Spell",spell)
	BeeSetVariable(vname.."_Unit",unit)
	BeeSetVariable(vname.."_Stop",stop)
	BeeSetVariable(vname.."_Time",GetTime() + IF(times,times,2))
	BeeSetVariable(vname.."_Key",key)
	
	--if stop and BeeUnitCastSpellName("player") then
	--	BeeRun("/stopcasting");
	--end
end

function BeeCastSpellFast() --运行快速技能
	local vname="Bee_SpellFast";
	if BeeGetVariable(vname.."_Time") and GetTime() >= BeeGetVariable(vname.."_Time") then
		BeeSetVariable(vname.."_Spell",nil)
		BeeSetVariable(vname.."_Unit",nil)
		BeeSetVariable(vname.."_Stop",nil)
		BeeSetVariable("AOE准备点亮",nil);
		BeeSetVariable("AOE已经点亮",nil);
		BeeSetVariable(vname.."_Key",nil)
		return 
	end
	
	local spell = BeeGetVariable(vname.."_Spell")
	local unit = BeeGetVariable(vname.."_Unit")

	if not unit or not spell then
		return;
	end

	if ("Macro" == unit or "macro" == unit or "MACRO" == unit or "M" == unit) then
		if BeeGCD()<=0  then
			BeeRun(spell)
			BeeSetVariable(vname.."_Spell",nil)
			BeeSetVariable(vname.."_Unit",nil)
			BeeSetVariable(vname.."_Stop",nil)
			BeeSetVariable(vname.."_Key",nil)
			return spell
		else
			return false;
		end
	end

	if strlower(unit) == "aoe" then
		
		if BeeUnitCastSpellName("player")== spell then
			return true;
		end
	
		if BeeGetVariable("AOE已经点亮") then
			if not IsCurrentSpell(spell) then
				BeeSetVariable("AOE已经点亮",nil);
				BeeSetVariable(vname.."_Spell",nil)
				BeeSetVariable(vname.."_Unit",nil)
				BeeSetVariable(vname.."_Stop",nil)
				BeeSetVariable(vname.."_Key",nil)
				--print("AOE结束");
				return false;
			else
				if BeeGetVariable(vname.."_Key") then
					BeeMouse(0,0,1);
				end
				return true;
			end
		end
	
		if BeeGetVariable("AOE准备点亮") then
			if IsCurrentSpell(spell) or BeeUnitCastSpellName("player")== spell then
				BeeSetVariable("AOE准备点亮",nil);
				BeeSetVariable("AOE已经点亮",true);
			--print("AOE已经点亮");
				return true;	
			end
		end

		if not IsCurrentSpell(spell) then		
			if BeeGetVariable(vname.."_Stop") then
				BeeRun("/stopcasting\n/cast !" .. spell);
				BeeSetVariable("AOE准备点亮",true)
				--print("AOE准备点亮");
				return spell;
			end
			
			if  BeeIsRun(spell,"nogoal") then
				BeeRun("/cast !" .. spell);
				BeeSetVariable("AOE准备点亮",true)
				--print("AOE准备点亮");
				return spell;
			end
		end
		--print("AOE");
		return false;
	end
	
	if BeeIsRun(spell,unit) then
		--BeeRun(spell,unit)
		if BeeGetVariable(vname.."_Stop") then
			BeeRun("/stopcasting\n/cast [target=" .. unit .. "]" .. spell );
		else
			BeeRun("/cast [target=" .. unit .. "]" .. spell );
		end

		BeeSetVariable(vname.."_Spell",nil)
		BeeSetVariable(vname.."_Unit",nil)
		BeeSetVariable(vname.."_Stop",nil)
		return spell
	end
end

function BeeIsBattle() --战斗中
	return WowBee.Spell.Combat;
end

function BeeIsCombat() --攻击姿态
	return WowBee.Spell.Event.Combat;
end

function BeePetIsCombat() --宠物是否是攻击姿态 
	return WowBee.Spell.Event.PetCombat;
end

function BeeGetComboPoints() --获取当前连击点  --Simplified
	return GetComboPoints("player")
end

function BeeGetShapeshiftFormInfo(index) --'获得指定姿态状态  --Simplified
	if index <= 0 then
		return false
	end
	local _,_,a = GetShapeshiftFormInfo(index);
	return a;
end

function BeeUnitCanAttack(unit) --是否可以攻击指定目标  --Simplified
	return UnitCanAttack("player", BeeUnit(unit,"target"))
end

function BeeAttack(Type,Auto)--攻擊最近的目標//BeeIsCombat
	Type =IF(Type,Type,0);
	Auto =IF(Auto,Auto,0);

	if Auto==1 then
		if not UnitName("target") then
			return ;
		end
	end
		
	if Type ==0 then
		if BeeIsCombat()==0 then
		BeeRun("/startattack");
		return true;
		end
	elseif Type ==1 then
		if BeeIsCombat()==1 then
		BeeRun("/stopattack");
		return true;
		end
	end
end

function BeeUnitAffectingCombat(unit) --判断指定单位是否在战斗状态,没参数默认自己  --Simplified
	return UnitAffectingCombat(BeeUnit(unit,"player"));
end

function BeeUnitPowerType(unit) --返回指定单位的能量的类型，没参数默认当前目标。 返回：数字，字符串  --Simplified
	return UnitPowerType(BeeUnit(unit,"target"));
end
-------------------------------------------------------------------------
function BeeUnitName(unit) --获得指定目标名称.  --string  --Simplified
	return UnitName(BeeUnit(unit,"target"));
end

function BeeUnitClass(unit) --获得指定目标英文职业名称 --string  --Simplified
	local playerClass, englishClass = UnitClass(BeeUnit(unit,"target"));
	return englishClass;
end

function BeeUnitClassBase(unit) --获得指定目标本地职业名称 --string  --Simplified
	local playerClass, englishClass = UnitClassBase(BeeUnit(unit,"target"));
	return playerClass;
end

function BeeUnitRace(unit) --获得指定的目标的种族，没参数默认当前目标。 --bool  --Simplified
	return UnitRace(BeeUnit(unit,"target"));
end

function BeeUnitPlayerControlled(unit) --判断指定目标是否是一名由玩家控制的角色，没参数默认当前目标。 --bool --Simplified
	return UnitPlayerControlled(BeeUnit(unit,"target"));
end

function BeeUnitClassification(unit,n) --判断一个指定的目标（只能是NPC）是否属于精英，没参数默认当前目标。 --edit
	--"normal" - 普通 
	--"rare" - 稀有 
	--"elite" - 精英 
	--"rareelite" - 稀有精英 
	--"worldboss" - 首领 

	local c = UnitClassification(BeeUnit(unit,"target"));
	if not c then return end
	n = IF(n,n,6);

	if n == 6 then
		return IF(c=="elite" or c =="rareelite" or c =="worldboss", c, nil);
	elseif n == 1 then
		return IF(c=="normal", c, nil);
	elseif n == 2 then
		return IF(c=="rare", c, nil);
	elseif n == 3 then
		return IF(c=="elite", c, nil);		
	elseif n == 4 then
		return IF(c=="rareelite", c, nil);	
	elseif n == 5 then
		return IF(c=="worldboss", c, nil);	
	elseif n == -1 then
		return c;
	end	
end

function BeeUnitIsDead(unit) --指定目标是否死了，是为真 --bool  --Simplified
	return IF(unit, UnitIsDeadOrGhost(unit), nil);
end
-------------------------------------------------------
function BeeUnitMana(unit,p,q) --目标的法力、怒气、能量 值或百分比等。
	
	unit = BeeUnit(unit,"player")
	if not UnitName(unit) then
		return -1;
	end
	
	local a,b,c;
	
	a = UnitMana(unit);
	b = UnitManaMax(unit);
	c= b-a;
	
	if q == nil or q == 0 then
		if p == "%" or p == 1 then
			return ((a / b) * 100);
		else
			return a;
		end
	else
		if p == "%" or p == 1 then
			return ((c / b) * 100);
		else
			return c;
		end
	end
end

function BeeUnitHealth(unit,p,q) --目标的生命值或百分比。
	unit = BeeUnit(unit,"player")
	
	if type(unit) ~= "string" then
		return -1;
	end
		
	if not UnitName(unit) then
		return -1;
	end
	
	local a,b,c;
	
	a = UnitHealth(unit);
	b = UnitHealthMax(unit);
	c= b-a;
	
	if q == nil or q == 0 then
		if p == "%" or p == 1 then
			return ((a / b) * 100);
		else
			return a;
		end
	else
		if p == "%" or p == 1 then
			return ((c / b) * 100);
		else
			return c;
		end
	end
end
------------------目標關係---------------------------------------------------
function BeeUnitIsPlayer(unit) --指定目标目是我.  --bool  --Simplified
	return UnitName(BeeUnit(unit,"target")) == UnitName("player");
end

function BeeUnitTargetIsPlayer(unit) --返回指定目标的目标是否自己 --bool  --Simplified
	return UnitName(BeeUnit(unit,"targettarget").. "-target") == UnitName("player")
end

function BeeUnitUnitIsPlayer(id) --目标的目标是否自己
	if id==0 then
		return IF(not UnitIsUnit("player","targettarget") and UnitCanAttack("player","target"), true, false);
	elseif id==1 then
		return IF(UnitIsUnit("targettarget", "player") and UnitCanAttack("player","target"), true, false);
	elseif id==2 then
		return IF(not UnitIsUnit("player","targettarget") and UnitCanAttack("player","target") and UnitName("targettarget"), true, false)
	end
end

function BeeFocusTargetIsPlayer() --返回焦点目标的目标是否自己 --bool  --Simplified
	return UnitName("focustarget") == UnitName("player")
end

function BeeTargetTargetIsPlayer() --返回目标的目标是否自己 --bool  --Simplified
	return UnitName("targettarget") == UnitName("player")
end
------------------Buff---------------------------------------
function BeeUnitBuffList(unit,t) --获得指定目标buff列表
	unit=BeeUnit(unit,"player");
	t = IF(t, t, 0);
	local name = {};
	local i,f,k;
	local c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId;
	k = 1;
	
	if WowBee.Config.Arena.BuffList and BeeIsArena() and WowBee.Config.Arena.BuffListTime and WowBee.Config.Arena.BuffListTime>0 and t==0 then
		t=WowBee.Config.Arena.BuffListTime;
	end

	for f = 0, 1 do 
		for i=1,MAX_TARGET_BUFFS do
			if (f == 0) then
				c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  =  UnitBuff(unit, i);
			else
				c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  =  UnitDebuff(unit, i);
			end
	
			if c then
				if WowBee.Config.Arena.BuffList  and t>0 and duration > 0 then
					if duration - (expirationTime - GetTime()) > t then
						name[k] = c ;
						k = k + 1;
					end
				else
					name[k] = c ;
					k = k + 1;
				end
			else
				break;
			end
		end
	end
	return name;
end

function BeeUnitBuffInfo(Unit,Nameid,BuffType,Categories) --获得指定目标buff数量及信息
	if Unit == nil then
		Unit="target";
	end
	
	if Nameid == nil then
		Nameid=0;
	end
	
	if Categories == nil then
		Categories=0;
	end
	
	if  not UnitName(Unit) then
		return -1;
	end
	
	if type(Nameid) ~= "number" then
		return -2;
	end
	
	if  type(BuffType) ~= "string" then
		return -3;
	end
	
	if type(Categories) ~= "number" then
		return -4;
	end
	
	local d,f;
	local n =0;
	local bufflist;
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable ;

	for i=1 , 40 do	
		if Categories == 1 then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(Unit, i)
		elseif Categories == 0 then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff(Unit, i)
		end
		
		if name then
			f = BeeStringFind(BuffType,debuffType);
			d=nil;
			
			if Nameid == 0 and unitCaster == "player" then
				d=1
			elseif Nameid == 1 and unitCaster ~= "player" then
				d=1
			elseif Nameid == 2 then
				d=1
			else
				d=nil;
			end
			
			if f and d then
				if bufflist == nil  then
					bufflist=name;
				else
					bufflist=bufflist .. "," .. name;
				end
				n = n + 1;
			end
		end
	end
	
	return n,bufflist;
end

function BeeUnitBuff(spell,unit,nameid,buffType,iconName) --获得指定目标buff剩馀时间
	unit=BeeUnit(unit,"player");
	nameid=IF(nameid, nameid, 0);
	buffType=IF(buffType, buffType, 0);

	if not spell then
		return -4;
	end
	
	if type(spell) ~= "string" or type(unit) ~= "string" or type(nameid) ~= "number" then
		return -2;
	end
	
	if not UnitName(unit) then
		return -3;
	end
	
	local n;
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable ;
	--local	name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, Spell,"HARMFUL") 
	if buffType == 0 then
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(unit, spell)
		if not name then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff(unit, spell)
		end
		
	elseif buffType == 1 then
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(unit, spell)
	elseif buffType == 2 then
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff(unit, spell)
	end
	

	--DEFAULT_CHAT_FRAME:AddMessage(tostring(name),192,0,192,0)
	if iconName and icon then
		local ls_icon = { strsplit("\\",icon) }
		if ls_icon[3] ~= iconName then
			return -1
		end
	end
	
	if name then
		n = expirationTime - GetTime()
		n = format("%.1f",IF(n < 0,0,n));
		n=tonumber(n);
		
		--DEFAULT_CHAT_FRAME:AddMessage(tostring(unitCaster),192,0,192,0)
		
		if nameid == 0 and unitCaster == "player" then
			return  n,rank,count,debuffType,icon,unitCaster,duration,expirationTime,isStealable;
		elseif nameid == 1 and unitCaster ~= "player" then
			return  n,rank,count,debuffType,icon,unitCaster,duration,expirationTime,isStealable;
		elseif nameid == 2 then
			return  n,rank,count,debuffType,icon,unitCaster,duration,expirationTime,isStealable;
		end
	end
	
	return -1;
end
--[[
function amaura(Spell,Unit,Nameid,BuffType,iconName) --(目標Buff剩餘時間)增加函数参数选项增强功能，增加返回值。


	if not Nameid  then
		Nameid=0;
	end
	
	if not BuffType  then
		BuffType=0;
	end
	
	if not Unit then
		Unit="player";
	end

	if not Spell  then
		return -4;
	end
	
	if type(Spell) ~= "string" or type(Unit) ~= "string" or type(Nameid) ~= "number" then
		return -2;
	end
	
	if not UnitName(Unit) then
		return -3;
	end
	
	
	local buff;
	local i = 1;
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable ;
	local UnitBuffId, UnitDebuffId;
	local IsBuff;
	if BuffType==1 or BuffType == 0 then
		while true do
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(Unit, i)
			
			if not name then
			  do break end
			end
			
			if Nameid == 0 and unitCaster == "player" and Spell == name then
				IsBuff=true;
			elseif Nameid == 1 and unitCaster ~= "player"  and Spell == name  then
				IsBuff=true;
			elseif Nameid == 2 and Spell == name  then
				IsBuff=true;
			end
			
			if IsBuff and iconName and icon then
				local ls_icon = { strsplit("\\",icon) }
				if ls_icon[3] ~= iconName then
					IsBuff = false;
				end
			end
			
			if IsBuff then
				UnitBuffId = i;
			  do break end
			end
			i = i + 1
	    end
	end
	 
	if not IsBuff and (BuffType==2 or BuffType == 0) then
		i=1;
		while true do
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff(Unit, i)
			
			if not name then
			  do break end
			end
			
			if Nameid == 0 and unitCaster == "player" and Spell == name then
				IsBuff=true;
			elseif Nameid == 1 and unitCaster ~= "player"  and Spell == name  then
				IsBuff=true;
			elseif Nameid == 2  and Spell == name  then
				IsBuff=true;
			end
			
			if IsBuff and iconName and icon then
				local ls_icon = { strsplit("\\",icon) }
				if ls_icon[3] ~= iconName then
					IsBuff = false;
				end
			end
			
			if IsBuff then
				UnitDebuffId = i;
			  do break end
			end
			
			i = i + 1
	    end
	end
	
	if BuffType==2 or BuffType==1 or BuffType == 0 then
		if IsBuff then
			local n = expirationTime - GetTime()
			if n < 0 then
				n= 0
			end
			n = format("%.1f",n);
			n=tonumber(n);
			return  n,rank,count,debuffType,icon,unitCaster,duration,expirationTime,isStealable;		
		end
	end
	
	return -1;
end
]]

function BeeUnitBuffTime(spell,unit,nameid,buffType,iconName) --获得当前目标buff剩馀时间
		
	local n,rank,count,debuffType,icon = BeeUnitBuff(spell,unit,nameid,buffType);
	if iconName and icon then
		local ls_icon = { strsplit("\\",icon) }
		if ls_icon[3] == iconName then
			return n
		else
			return -1
		end
	else
		return n;
	end
end

function BeeUnitBuffCount(spell,unit,nameid,buffType) --获得指定目标buff层数
	unit=BeeUnit(unit,"target");
	local n,rank,count,debuffType = BeeUnitBuff(spell,unit,nameid,buffType);
	
	if not count then
		return -1
	end
	
	return count;
end

function BeePlayerBuffTime(spell,iconName) --获得自己身上buff剩馀时间
	return BeeUnitBuffTime(spell,"player",2,1,iconName);
end

function BeePlayerDeBuffTime(spell,iconName) --获得自己身上Dbuff剩馀时间
	return BeeUnitBuffTime(spell,"player",2,2,iconName);
end

function BeeTargetBuffTime(spell,iconName) --获得当前目标buff剩馀时间
	return BeeUnitBuffTime(spell,"target",2,1,iconName);
end

function BeeTargetDeBuffTime(spell,iconName) --获得当前目标属于自己的Dbuff剩馀时间
	return BeeUnitBuffTime(spell,"target",0,2,iconName);
end

function BeePlayerBuffCount(spell) --获得自己身上buff层数
	return BeeUnitBuffCount(spell,"player",2,1);
end

function BeePlayerDeBuffCount(spell) --获得自己身上Dbuff层数
	return BeeUnitBuffCount(spell,"player",2,2);
end

function BeeTargetBuffCount(spell) --获得当前目标buff层数
	return BeeUnitBuffCount(spell,"target",2,1);
end

function BeeTargetDeBuffCount(spell) --获得当前目标身上的Dbuff层数
	return BeeUnitBuffCount(spell,"target",0,2);
end
----------------DK--------------
function BeeRuneId(rune) -- 获得指定符文ID，返回其id。return ID
	if "冰霜符文" == rune or "Frost Rune" == rune  then
		rune = 3 ;
	elseif "穢邪符文" == rune or "邪恶符文" == rune or "Unholy Rune" == rune then
		rune = 2 ;
	elseif "血魄符文" == rune or "鲜血符文" == rune or "Blood Rune" == rune  then
		rune = 1 ;
	elseif "死亡符文" == rune or "Death Rune" == rune then
		rune = 4 ;
	else
		rune = -1;
	end
	return rune;
end

function BeeRuneCount(runeid) --获得指定符文数量。 return N
	local runeType,i,n;
	n=0;
	for i=1, 6 do
		runeType = GetRuneType(i);
		if runeType == runeid then
			n = n+1;				
		end
	end
	return n;
end

function BeeRune(rune) --返回某种符文可用数量,及冷却时间。return N,CD1,CD2
	local id,cd;
	local cd1=-1;
	local cd2=-1;
	
	if type(rune) == "number" or type(rune) == "string" then
		if type(rune) == "string" then
			id = BeeRuneId(rune);
			if id == -1 then
				return -1,-1,-1;
			end
		else
			if rune>=1 and rune<=6 then
				id = rune;
			else
				return -1,-1,-1;
			end
		end
	else
		return -1,-1,-1;
	end
	
		
	local runeType,i,n;
	local start, duration, runeReady;
	
	n = 0;
	
	for i=1, 6 do
		runeType = GetRuneType(i);
		if runeType == id then
			start, duration, runeReady = GetRuneCooldown(i);
		
			cd = duration-(GetTime()-start);
			if cd <= 0 then
				cd = 0;
			end
			
			if cd <=0 then
				n = n +1;
			end
			
			if cd1 == -1 then
				cd1 = cd;
			else
				cd2 = cd;
			end
		end
	end
	return n,cd1,cd2;
end

function BeeRuneCD(rune) --返回某种符文其中最快冷却时间。return N,CD1,CD2
	local n,cd1,cd2 = BeeRune(rune);
	
	if n == 0 then
		return -1;
	end
	
	if  n == 1 and cd1 >= 0 then
		return cd1;
	elseif cd1 == 0 and cd2 == 0 then
		return 0;
	elseif (n == 2) and cd1 >0 and cd2 == 0 then
		return cd1;
	elseif (n == 2) and cd2 >0 and cd1 == 0 then
		return cd2;
	elseif (n == 2) and (cd1 <= cd2) and cd1 >0 and cd2>0 then
		return cd1;		
	elseif (n == 2) and (cd2 <= cd1) and cd1 >0 and cd2>0 then
		return cd2;	
	end
	return 0;
end

function BeeGetRuneCooldown(id)
	if id and id>=1 and id<=6 then
		local start, duration, runeReady = GetRuneCooldown(id);
		local cd = duration-(GetTime()-start);
		if cd <= 0 then
			cd = 0;
		end
		return cd;
	else
		return -1;
	end
end


----------------萨满----------------------------------------------
function BeeTotem(totem) --图腾CD
		if totem==nil or totem=="" then
			return -1;
		end
		
		for i = 1, 4 do
			local haveTotem, name, startTime, duration, icon = GetTotemInfo(i)
  			if name and haveTotem then
		  		if haveTotem and string.len(name) > 0 then
		  			if  totem == name  then
		  				return GetTotemTimeLeft(i);
		  			end
		  		end
		  	end
		end
	return -1;
end

function BeeTotemType(Type) -- 图腾类型
	if type(Type) ~= "number" then
		WowBee_Message(WowBee.Colors.RED.."错误：" .. WowBee.Colors.LGREEN .. "参数类型错误，请使用整数值");
		return nil,-1
	end

	local haveTotem, name = GetTotemInfo(Type)
  	if name and haveTotem then
		if haveTotem and string.len(name) > 0 then
			return name,GetTotemTimeLeft(Type)
		end
	end
	return nil,-1		
end
------------------------------------------------
function BeeEquip(mainHand,deputyHand,distance) --换上指定的武器
	local a,b,c=true,true,true;
	local h;
	local zd = BeeUnitAffectingCombat("player");
	if mainHand then
		if IsEquippableItem(mainHand) then
			if not IsEquippedItem(mainHand) then
				if zd then
					h = "/equipslot " .. 16 .. " " .. mainHand;
				else
					EquipItemByName(mainHand,16)
				end
				a=false;
			end
		end
	end	
	
	if deputyHand then
		if IsEquippableItem(deputyHand) then
			if not IsEquippedItem(deputyHand) then
				if zd then
					if h then
						h = h .. "\n/equipslot " .. 17 .. " " .. deputyHand;
					else
						h = "/equipslot " .. 17 .. " " .. deputyHand;
					end
				else
					EquipItemByName(deputyHand,17)
				end
				b=false;
			end
		end
	end	
	
	if distance then
		if IsEquippableItem(distance) then
			if not IsEquippedItem(distance) then
				if zd then
					if h then
						h = h .. "\n/equipslot " .. 18 .. " " .. deputyHand;
					else
						h = "/equipslot " .. 18 .. " " .. deputyHand;
					end
				else
					EquipItemByName(distance,18)
				end
				c=false;
			end
		end
	end	

	if zd and h and (a and b and c) then
		BeeRun(h);
		return false;
	end
	if a and b and c then
		return true;
	end
	return false;
end

function BeeUnitIsEquipped(equiped,unit)--該目標是否佩戴有指定物品（不能判断无法查看装备的目标、不能在观察距离以外）
	unit=BeeUnit(unit,"player");

	if not equiped then
		return false;
	end
	
	if UnitGUID(unit) == UnitGUID("player") then
		if IsEquippedItem(equiped) then
			return true;
		else
			return false;
		end
	end
	
	--[[
	if type(equiped) == "number" then 
		
		local mainHandLink = GetInventoryItemLink(Unit,equiped)
					
						if mainHandLink then
						local spell = GetItemInfo(mainHandLink)
							return 	spell,equiped;
								
						end
		return nil;
	
	end
	--]]
	--if type(equiped) == "string" then
		for i=1 , 23 do
			local mainHandLink = GetInventoryItemLink(unit,i)
			if mainHandLink then
				if GetItemInfo(mainHandLink) == equiped then
					return true;
				end
			end
		end
		return false;
	--end
	--return nil;
end

function BeeBatchRun(spells,unit) --批处理技能
	unit = BeeUnit(unit,"target");
	if  not UnitName(unit) then
		return nil;
	end
	
	if type(spells) == "string" then
		spells = { strsplit(",",spells) }
	elseif type(spells) == "table" then
	else
		return nil;
	end

	for k,va in ipairs(spells) do
		if BeeIsRun(va,unit) then
		  BeeRun(va,unit);
		  return va,unit;
		end
	end
end

function BeeUnitHealthSpells(unit,health,spells) --当目标血量少于设定时施放技能
	unit = BeeUnit(unit,"target");----
	if not UnitName(unit) or not spells or not health then
		return ;
	end
	
	if BeeUnitHealth(unit,"%")<health then
		return BeeBatchRun(spells,unit)
	end
end

function BeeUnitBuffsSpells(unit,buffs,spells,appear) --当出现列表里的BUFF时施放技能
	unit = BeeUnit(unit,"target");
	if not(buffs and unit and spells) then
		return
	end
	
	local k = BeeStringFind(buffs,BeeUnitBuffList(unit))
	
	if not appear and k then
		return BeeBatchRun(spells,unit)
	end
	
	if appear and not k then
		return BeeBatchRun(spells,unit)
	end	
end

---------------------------------------
function BeeMiss(missType,SourceUnit,DestUnit) --獲得未造成傷害的原因的技能過去時間秒數
--[[
	-------------參數：missType-----------------------------------------
	missType（未造成傷害類型），表示未造成該傷害的原因。
	原因 	中文 
	"DODGE" 被躲閃 
	"ABSORB" 被吸收 
	"RESIST" 被抵抗 
	"PARRY" 被招架 
	"MISS" 未擊中 
	"BLOCK" 被格擋 
	"REFLECT" 被反射 
	"DEFLECT" 偏斜 
	"IMMUNE" 免疫 
	"EVADE" 被閃避
	-----------參數：name---------------------
	"source"	你未造成傷害。 	如果 missType 是 【DODGE】 Name 是【target】的話，表示你的攻擊給當前目標【躲閃】了
	"dest"		對你未造成傷害。如果 missType 是 【DODGE】 Name 是【target】的話，表示你【躲閃】了當前目標的攻擊	
	
--]]

	if not missType or not (DestUnit and SourceUnit) then
		return nil;
	end
	
	local SMT= WowBee.Spell.Miss.MissType;
	
	if not SMT[missType]  then 
		return nil; 
	end
	
	local DESTGUID = false;
	local SOURCEGUID = false;
	
	if SourceUnit and not UnitGUID(SourceUnit) then
		return nil;
	elseif SourceUnit and UnitGUID(SourceUnit) then
		SOURCEGUID = UnitGUID(SourceUnit);
	end
	
	if DestUnit and not UnitGUID(DestUnit) then
		return nil;
	elseif DestUnit and  UnitGUID(DestUnit) then
		DESTGUID = UnitGUID(DestUnit);
	end
	

	local temp;
	
	if SOURCEGUID and not DESTGUID then
		temp = "SourceGUID-" .. SOURCEGUID;
	elseif not SOURCEGUID and DESTGUID then
		temp = "DestGUID-" .. DESTGUID;
	elseif SOURCEGUID and DESTGUID then
		temp = SOURCEGUID .. "-" .. DESTGUID;
	end

	if SMT[missType][temp] then
		return GetTime() - SMT[missType][temp]
	else
		return;
	end
end

-----------------------函数---------------------------------
function BeeUnit(unit,default) --Add
	default= IF(default,default,"target");
	return IF(unit, unit, default);
end

function BeeStringToByte(str) --字符转字节
	local tbl={};
	for i=1, strlen(str) do
		tbl[i]=strbyte(str,i)	
	end
	return tbl;
end

function BeeStringToNumber(data)  
	local n;
	if not data then
		return 0;
	else
		n = tonumber(data) 
		if n then
			return n;
		else
			return 0;
		end
	end
end

function BeeStringFind(String,Tbl,Type) --Tbl 在 String 中搜索指定的内容

	if (not String) or (not Tbl) then
		return nil;
	end
	
	if type(Tbl) == "string" then
	
		Tbl = { strsplit(",",Tbl) }

	elseif type(Tbl) == "table" then
	
	else
		return nil;
	end
	
	if type(String) == "string" then
	
		String = { strsplit(",",String) }

	elseif type(String) == "table" then
	
	else
		return nil;
	end
	
	if Type == nil then
	
		Type=0
	end
	
	local n;
	
	local Tbl_index=1;
	local String_index=1;
	
	for i,v in ipairs(Tbl) do
		String_index=1;
		for k,va in ipairs(String) do
			n = strfind(va,v,1,true);
			if not n then
				n = strfind(strlower(va),strlower(v),1,true);
			end			
				if n then
					if Type == -1 then
						return n,v,va,Tbl_index,String_index;
						
					elseif Type == 0  then
						if va == v then
							return n,v,va,Tbl_index,String_index;
						end
						
					elseif Type == n then
						return n,v,va,Tbl_index,String_index;
					end
				end
			String_index=String_index+1;
		end
		
		Tbl_index=Tbl_index+1;
	end
	
	return nil;
end

function BeeCopyTable(ori_tab) --复制表
    if (type(ori_tab) ~= "table") then
        return nil;
    end
    local new_tab = {};
    for i,v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            new_tab[i] = BeeCopyTable(v);
        elseif (vtyp == "thread") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        elseif (vtyp == "userdata") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end

function BeeEraseTable(tab) --清除表
	for i in pairs(tab) do tab[i] = nil end
end

function BeeSetVariable(variableName,value) --设定变量的值
	WowBee.Spell.Variable[variableName]=value;
	return WowBee.Spell.Variable[variableName]
end

function BeeGetVariable(variableName) --读取变量的值
	return IF(variableName, WowBee.Spell.Variable[variableName], nil);
end

function BeePrint(String) --打印
	local str ='local function TEMP_Print() return ' .. String .. '; end'
	
	RunScript(str);
	local ls_jn = {TEMP_Print() }

	for i,v in ipairs(ls_jn) do	
		WowBee_Message(WowBee.Colors.RED .. tostring(v))
	end				
end

function BeeMacroSplit(str)
	
	local t,p;
	for k, v in string.gmatch(str,"%[(.-)(.+)%]") do
		t=v
		break;
	end

	if not t then return false;end;

	for k, v in string.gmatch(t,"(.-)target=(.+)") do
		t=v
		break;
	end

	t={strsplit(",",t)}

	if #t==0 then return false;end;
	
	t=strtrim(t[1]);

	for k, v in string.gmatch(str,"%](.-)(.+)") do
		p=v
		break;
	end

	if not p then return false;end;

	p={strsplit(";",p)}

	if #p==0 then return false;end;

	p=strtrim(p[1])
	return t,p;
end

function BeeTob(c)
	local t="";
	for i,v in ipairs(c) do
		if type(v) == "number" then
			t= t .. strchar(v-1)
		end
	end
	return t;
end

function IF(a,b,c)
	if(a)then
		return b;
	else
		return c;
	end
end
--------------------------------------------
function BeeUnitSetRaid(unit,index)-- 給目標上標記
--0 - 取消标记 1 - 星星 
--2 - 太阳 3 - 菱形 4 - 三角 5 - 月亮 6 - 方块 7 - 红叉 8 - 骷髅 
	if GetNumRaidMembers()>0 or GetNumPartyMembers()>0 then
		if IsRaidLeader() or IsPartyLeader() or IsRaidOfficer() then
			if not GetRaidTargetIndex(unit) == index then
				SetRaidTarget(unit,index)
			end
			return true;
		end
	end
end
-------------------------------------------
function BeeUnitSubGroup(unit) --获得指定目标在团队中的小队编号
	unit=BeeUnit(unit,"player");
	local k = GetNumRaidMembers()	
	for i=1 , k do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
		if name and subgroup and UnitGUID(Unit) and UnitGUID(name) and UnitGUID(Unit) == UnitGUID(name) then
			return subgroup;		
		end
	end
	return 0;
end

function BeePartyScript(String) --獲得符合條件的小隊人物信息--UnitGUID
	local vname="BeePartyInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);

	 
	if not String then
		return false
	end
	
	local str ='function TEMP_BeeParty(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local num =GetNumPartyMembers()+1;

	for i=1, num do
		unit=IF(num == i, "player", "party" .. i);
		if UnitName(unit)then
			 --bufflist = BeeUnitBuffList(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = BeeUnitCastSpellName(unit);
			 spellcd = BeeUnitCastSpellTime(unit);
			 guid = UnitGUID(unit);

			if TEMP_BeeParty(name,class,race,spell,unit,guid,spellcd) then
				BeeSetVariable(vname.."_Name",name);
				BeeSetVariable(vname.."_Class",class);
				BeeSetVariable(vname.."_Race",race);
				BeeSetVariable(vname.."_Spell",spell);
				BeeSetVariable(vname.."_SpellCD",spellcd);
				BeeSetVariable(vname.."_Guid",guid);
				BeeSetVariable(vname.."_Unit",unit);
				return unit,name,class,race,spell,spellcd,guid;
			end 
		end
	end
	return false
end

function BeeRaidScript(String) --獲得符合條件的團隊人物信息--UnitGUID
	local vname="BeeRaidInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);

	if not String then
		return false
	end
	
	local str ='function TEMP_BeeRaid(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local num =GetNumRaidMembers();

	for i=1, num do
		unit="raid" .. i;
		if UnitName(unit)then
			-- bufflist = BeeUnitBuffList(unit);
			name = UnitName(unit);
			class = UnitClass(unit);
			race = UnitRace(unit);
			spell = BeeUnitCastSpellName(unit);
			spellcd = BeeUnitCastSpellTime(unit);
			guid = UnitGUID(unit);

			if TEMP_BeeRaid(name,class,race,spell,unit,guid,spellcd) then
				BeeSetVariable(vname.."_Name",name);
				BeeSetVariable(vname.."_Class",class);
				BeeSetVariable(vname.."_Race",race);
				BeeSetVariable(vname.."_Spell",spell);
				BeeSetVariable(vname.."_SpellCD",spellcd);
				BeeSetVariable(vname.."_Guid",guid);
				BeeSetVariable(vname.."_Unit",unit);
				return unit,name,class,race,spell,spellcd,guid;
			end 
		end
	end
	--	DEFAULT_CHAT_FRAME:AddMessage(v)
	return false
end

function BeePartyPetScript(String)--獲得符合條件的小隊寵物信息
	local vname="BeePartyPetInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);

	if not String then
		return false
	end
	
	local str ='function TEMP_BeePartyPet(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	local num =GetNumPartyMembers()+1;

	for i=1, num do
		unit=IF(num == i, "pet", "partypet".. i);
		if UnitName(unit)then
			 --bufflist = BeeUnitBuffList(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = BeeUnitCastSpellName(unit);
			 spellcd = BeeUnitCastSpellTime(unit);
			 guid = UnitGUID(unit);

			if TEMP_BeePartyPet(name,class,race,spell,unit,guid,spellcd) then
				BeeSetVariable(vname.."_Name",name);
				BeeSetVariable(vname.."_Class",class);
				BeeSetVariable(vname.."_Race",race);
				BeeSetVariable(vname.."_Spell",spell);
				BeeSetVariable(vname.."_SpellCD",spellcd);
				BeeSetVariable(vname.."_Guid",guid);
				BeeSetVariable(vname.."_Unit",unit);
					 
				return unit,name,class,race,spell,spellcd,guid;
			end
		end
	end
	return false
end

function BeeRaidPetScript(String)--獲得符合條件的團隊寵物信息
	local vname="BeeRaidPetInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);
	 
	if not String then
		return false
	end
	
	local str ='function TEMP_BeeRaidPet(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'

	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local num =GetNumRaidMembers();

	for i=1, num do
		unit="raidpet" .. i;
		if UnitName(unit)then
			--bufflist = BeeUnitBuffList(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = BeeUnitCastSpellName(unit);
			 spellcd = BeeUnitCastSpellTime(unit);
			 guid = UnitGUID(unit);

			if TEMP_BeeRaidPet(name,class,race,spell,unit,guid,spellcd) then
				BeeSetVariable(vname.."_Name",name);
				BeeSetVariable(vname.."_Class",class);
				BeeSetVariable(vname.."_Race",race);
				BeeSetVariable(vname.."_Spell",spell);
				BeeSetVariable(vname.."_SpellCD",spellcd);
				BeeSetVariable(vname.."_Guid",guid);
				BeeSetVariable(vname.."_Unit",unit);
				 
				return unit,name,class,race,spell,spellcd,guid;
			end	 
		end
	end
	return false
end

function BeeGroupMinScript(String,strReturn,group) --小队或者团队里最小的数值的人物信息

	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"   or group=="arenapet" ) then
		DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
		return false
	end
	
	local vname="BeeGroupMinInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);
	BeeSetVariable(vname.."_Value",nil);

	if String==nil or strReturn == nil then
		DEFAULT_CHAT_FRAME:AddMessage("String 或 strReturn 参数不能为空")
		return false
	end
	
	local str ='function TEMP_BeeGroupMin(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. strReturn .. '; else return false; end end'

	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers() ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end

	for i=1, Members do
		if i==Members and group == "party" then
			unit="player"
		elseif i==Members and group == "partypet" then
			unit="pet"
		else
			unit=group .. tostring(i);
		end
		
		if UnitName(unit)then
			 --bufflist = BeeUnitBuffList(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = BeeUnitCastSpellName(unit);
			 spellcd = BeeUnitCastSpellTime(unit);
			 guid = UnitGUID(unit);
			minimum = TEMP_BeeGroupMin(name,class,race,spell,unit,guid,spellcd);
		 
			if minimum then
				if temp_n == nil then
					temp_n =minimum;
					temp_unit = unit;
				elseif minimum < temp_n then
					temp_n =minimum;
					temp_unit = unit;
				end
			end	 
		end
	end
	
	if temp_unit then
			 --bufflist = BeeUnitBuffList(temp_unit);
			 name = UnitName(temp_unit);
			 class = UnitClass(temp_unit);
			 race = UnitRace(temp_unit);
			 spell = BeeUnitCastSpellName(temp_unit);
			 spellcd = BeeUnitCastSpellTime(temp_unit);
			 guid = UnitGUID(temp_unit);
			
			BeeSetVariable(vname.."_Name",name);
			BeeSetVariable(vname.."_Class",class);
			BeeSetVariable(vname.."_Race",race);
			BeeSetVariable(vname.."_Spell",spell);
			BeeSetVariable(vname.."_SpellCD",spellcd);
			BeeSetVariable(vname.."_Guid",guid);
			BeeSetVariable(vname.."_Unit",temp_unit);
			BeeSetVariable(vname.."_Value",temp_n);
			 return temp_unit,name,class,race,spell,spellcd,guid,temp_n;
	end
	return false
end

function BeeGroupMaxScript(String,StrReturn,group) --小队或者团队里最大的数值的人物信息
	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"  or group=="arenapet" ) then
		DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
		return false
	end

	local vname="BeeGroupMaxInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);
	BeeSetVariable(vname.."_Value",nil);

	if String==nil or StrReturn == nil then
		DEFAULT_CHAT_FRAME:AddMessage("String 或 StrReturn 参数不能为空")
		return false
	end
	
	local str ='function TEMP_BeeGroupMax(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers()+1 ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end

	for i=1, Members do
		if i==Members and (group == "party" or group=="raid") then
			unit="player"
		elseif i==Members and (group == "partypet" or group=="raidpet") then
			unit="pet"
		else
			unit=group .. tostring(i);
		end
		
		if UnitName(unit)then
			 --bufflist = BeeUnitBuffList(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = BeeUnitCastSpellName(unit);
			 spellcd = BeeUnitCastSpellTime(unit);
			 guid = UnitGUID(unit);
		 
			minimum = TEMP_BeeGroupMax(name,class,race,spell,unit,guid,spellcd);
		 
			if minimum then
				if temp_n == nil then
					temp_n =minimum;
					temp_unit = unit;
				elseif minimum > temp_n then
					temp_n =minimum;
					temp_unit = unit;
				end
			end	 
		end
	end
	
	if temp_unit then
			 --bufflist = BeeUnitBuffList(temp_unit);
			 name = UnitName(temp_unit);
			 class = UnitClass(temp_unit);
			 race = UnitRace(temp_unit);
			 spell = BeeUnitCastSpellName(temp_unit);
			 spellcd = BeeUnitCastSpellTime(temp_unit);
			 guid = UnitGUID(temp_unit);
			
			BeeSetVariable(vname.."_Name",name);
			BeeSetVariable(vname.."_Class",class);
			BeeSetVariable(vname.."_Race",race);
			BeeSetVariable(vname.."_Spell",spell);
			BeeSetVariable(vname.."_SpellCD",spellcd);
			BeeSetVariable(vname.."_Guid",guid);
			BeeSetVariable(vname.."_Unit",temp_unit);
			BeeSetVariable(vname.."_Value",temp_n);
			return temp_unit,name,class,race,spell,spellcd,guid,temp_n;
	end
	return false
end

function BeeGroupMinFastScript(String,StrReturn,group) --小队或者团队里最小的数值的人物信息
	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"   or group=="arenapet" ) then
		print("|cffff0000 group 参数不对")
		return false
	end

	if String==nil or StrReturn == nil then
		print("|cffff0000 String 或 StrReturn 参数不能为空")
		return false
	end
	--print(String,"----",StrReturn)
	
	local vname="BeeGroupMinFast";

	local str ='function TEMP_BeeGroupMinFast(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	
	if  BeeGetVariable(vname.."_Str",str) then
		if BeeGetVariable(vname.."_Str",str) ~= str then
			RunScript(str);
		end
	else
		RunScript(str);
		BeeSetVariable(vname.."_Str",str);
	end
	
	--RunScript(str);
	
	local unit;
	
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers() ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end

	for i=1, Members do
		if i==Members and group == "party" then
			unit="player"
		elseif i==Members and group == "partypet" then
			unit="pet"
		else
			unit=group .. tostring(i);
		end
		
		if UnitName(unit) then
							 
		 minimum = TEMP_BeeGroupMinFast(unit);
		 --print(UnitName(unit),minimum)	
			if minimum then
				if temp_n == nil then
					temp_n =minimum;
					temp_unit = unit;
				elseif minimum < temp_n then
					temp_n =minimum;
					temp_unit = unit;
				end
			end	
		end
	end
	
	if temp_unit then
		BeeSetVariable(vname.."_Unit",temp_unit); 
		return temp_unit;
	end
	return false
end

function BeeGroupCountScript(String,StrReturn,group) --小队或者团队里符合条件的人物信息数量
local count =0;
local u;

	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"  or group=="arenapet" ) then
	DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
	return false
	end
	 
	if String==nil or StrReturn == nil then
	
		DEFAULT_CHAT_FRAME:AddMessage("String 或 StrReturn 参数不能为空")
		return false
	end
	
	local str ='function TEMP_BeeGroupCount(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers() ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end

	for i=1, Members do
		if i==Members and group == "party" then
		unit="player"
		elseif i==Members and group == "partypet" then
		unit="pet"
		else
		unit=group .. tostring(i);
		end
		
		if UnitName(unit)then
		
			 --bufflist = BeeUnitBuffList(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = BeeUnitCastSpellName(unit);
			 spellcd = BeeUnitCastSpellTime(unit);
			 guid = UnitGUID(unit);
		 
			minimum = TEMP_BeeGroupCount(name,class,race,spell,unit,guid,spellcd);
		 
			if minimum then
			 u = unit;
				count = count +1;
			end	
		end
	end	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return count,u;
end

function BeeGroupMaxTargetScript(String,StrReturn,group)  ---、

	local count =0;
	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"  or group=="arenapet" ) then
		DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
		return false
	end
	if String==nil or StrReturn == nil then
		DEFAULT_CHAT_FRAME:AddMessage("String 或 StrReturn 参数不能为空")
		return false
	end
	local str ='function TEMP_BeeGroupMaxTarget(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	RunScript(str);
	local name,class,race,spell,unit,unit2,spellcd,guid;
	local Members,minimum,temp_unit ;
	local temp_n =nil;
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers() ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end
	for i=1,Members do
		if i==Members and group == "party" then
			unit="player"
		elseif i==Members and group == "partypet" then
			unit="pet"
		else
			unit=group .. tostring(i);
		end
		if UnitName(unit)then
			--bufflist = BeeUnitBuffList(unit);
			name = UnitName(unit);
			class = UnitClass(unit);
			race = UnitRace(unit);
			spell = BeeUnitCastSpellName(unit);
			spellcd = BeeUnitCastSpellTime(unit);
			guid = UnitGUID(unit);
			--内嵌循环
			if i<Members then
				for j=i+1,Members do
					if j==Members and group == "party" then
						unit2="player"
					elseif j==Members and group == "partypet" then
						unit2="pet"
					else
						unit2=group .. tostring(j);
					end
					if UnitGUID(unit .. "target")==UnitGUID(unit2 .. "target") then
						break;
					end
					if j==Members then
						minimum = TEMP_BeeGroupMaxTarget(name,class,race,spell,unit,guid,spellcd);
					end
				end
			end
			if i==Members then
				minimum = TEMP_BeeGroupMaxTarget(name,class,race,spell,unit,guid,spellcd);
			end
			 --内嵌循环
			--
			if minimum and minimum~=nil then  
				if temp_n == nil then  
					temp_n =minimum;
					temp_unit = unit;
				elseif minimum > temp_n then
					temp_n =minimum;
					temp_unit = unit;
				end
				count = count +1;
			end 
		end
	end
	return count,temp_unit;
end 

function BeeGroupMinHealthCast(DeBuffs,Buff,BuffOperator,BuffCd,Health,HealthOperator,Spell,Group)
	 
	 local Operator = "==,<=,>=,>,<,~=";
	 local GroupStr = "party,partypet,raid,raidpet,arena,arenapet";
	 local TEMP;

	 if DeBuffs and type(DeBuffs) ~= "string" then
		print("|cffff0000 DeBuffs 参数必须是字符串")
		return ;
	 end
	 
	 if Buff and type(Buff) ~= "string" then
		print("|cffff0000 Buff 参数必须是字符串")
		return ;
	 end
	 
	 if BuffCd and type(BuffCd) ~= "number" then
		print("|cffff0000 BuffCd 参数必须是数值")
		return ;
	 end
	 
	 if BuffOperator and type(BuffOperator) ~= "string" then
		print("|cffff0000 BuffOperator 参数必须是字符串")
		return ;
	 end
	 
	 
	 if Health and type(Health) ~= "number" then
		print("|cffff0000 Health 参数必须是数值")
		return ;
	 end
	 
	 if Spell and type(Spell) ~= "string" then
		print("|cffff0000 Spell 参数必须是字符串")
		return ;
	 end
	 
	 if Group and type(Group) ~= "string" then
		print("|cffff0000 Group 参数必须是字符串")
		return ;
	 end
	 
	 if HealthOperator and type(HealthOperator) ~= "string" then
		print("|cffff0000 HealthOperator 参数必须是字符串")
		return ;
	 end
	 
	 if BuffOperator and not BeeStringFind(BuffOperator,Operator) then
		print("|cffff0000 BuffOperator 参数格式必须是:" .. Operator )
		return ;
	 end
	 
	 if HealthOperator and not BeeStringFind(HealthOperator,Operator) then
		print("|cffff0000 HealthOperator 参数格式必须是:" .. Operator )
		return ;
	 end
	 
	 if Buff then
		if not (BuffOperator and BuffCd) then
			print("|cffff0000 BuffOperator,BuffCd 参数不能缺")
			return ;
		end
	 end
	 
	 if Health then
		if not (HealthOperator) then
			print("|cffff0000 HealthOperator 参数不能缺")
			return ;
		end
	 end
	 
	 if not Group then
		print("|cffff0000 Group 参数必须指定")
		return ;
	 end

	 if Group and not BeeStringFind(Group,GroupStr) then
		print("|cffff0000 Group 参数格式必须是:" .. GroupStr )
		return ;
	 end
	 
	if Spell and BeeSpellCD(Spell)>0 then
		return ;
	end

	local str ;
	 
	if DeBuffs then
		DeBuffs = 'BeeStringFind(BeeUnitBuffList(unit),"'.. DeBuffs .. '")';
		
		str = DeBuffs;
		
	end
	
	if Spell then
		TEMP = 'BeeIsRun("' .. Spell .. '",unit)';
		
		if str then
			str = str .. " and " .. TEMP;
		else
			str = TEMP;
		end
	end
	 
	if Buff and BuffCd then
		Buff = 'BeeUnitBuff("' .. Buff .. '",unit)' .. BuffOperator .. BuffCd ;
		
		if str then
			str = str .. " and " .. Buff;
		else
			str = Buff;
		end
		
	end
	 
	if Health then
		Health = 'BeeUnitHealth(unit,"%")' .. HealthOperator .. Health ;
		
		if str then
			str = str .. " and " .. Health;
		else
			str = Health;
		end
		
	end

	if not str then
		str = true;
		
	else
		local text = 'BeeIsRun("' .. Spell..'",unit) and UnitIsConnected(unit) and not UnitIsCorpse(unit) and not UnitIsDeadOrGhost(unit)';
		
		str = str .. " and " .. text;
	end
	 
	local Unit = BeeGroupMinFastScript(str,'BeeUnitHealth(unit,"%")',Group)

	if Spell and Unit then

		BeeRun(Spell,Unit);
		--print(Spell,Unit);
		return Unit; 
	else
	
		return Unit; 
	end
end

function BeeArenaCastScript(String)--獲得競技場敵方正在施法狀態及人物信息
	local vname="BeeArenaCastInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);

	if not String then
		return false
	end
	
	local str ='function TEMP_BeeArenaCast(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'

	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;

	for i=1, 5 do
		unit="arena" .. i;
		
		if BeeUnitCastSpellName(unit) then
		
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = BeeUnitCastSpellName(unit);
			 spellcd = BeeUnitCastSpellTime(unit);
			 guid = UnitGUID(unit);
		 

			if TEMP_BeeArenaCast(name,class,race,spell,unit,guid,spellcd) then
				BeeSetVariable(vname.."_Name",name);
				BeeSetVariable(vname.."_Class",class);
				BeeSetVariable(vname.."_Race",race);
				BeeSetVariable(vname.."_Spell",spell);
				BeeSetVariable(vname.."_SpellCD",spellcd);
				BeeSetVariable(vname.."_Guid",guid);
				BeeSetVariable(vname.."_Unit",unit);
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end 
		end
	end

	return false
end

function BeeArenaInfoScript(String)--【競技場專用】獲得敵方符合條件的人物信息--UnitGUID
	local vname="BeeArenaInfo";
	BeeSetVariable(vname.."_Name",nil);
	BeeSetVariable(vname.."_Class",nil);
	BeeSetVariable(vname.."_Race",nil);
	BeeSetVariable(vname.."_Spell",nil);
	BeeSetVariable(vname.."_SpellCD",nil);
	BeeSetVariable(vname.."_Guid",nil);
	BeeSetVariable(vname.."_Unit",nil);

	if not String then
		return false
	end
	
	local str ='function TEMP_BeeArena(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;

	for i=1, 5 do
		unit="arena" .. i;
		
		if UnitName(unit)then
		 --bufflist = BeeUnitBuffList(unit);
		 name = UnitName(unit);
		 class = UnitClass(unit);
		 race = UnitRace(unit);
		 spell = BeeUnitCastSpellName(unit);
		 spellcd = BeeUnitCastSpellTime(unit);
		 guid = UnitGUID(unit);
		 
			if TEMP_BeeArena(name,class,race,spell,unit,guid,spellcd) then
				BeeSetVariable(vname.."_Name",name);
				BeeSetVariable(vname.."_Class",class);
				BeeSetVariable(vname.."_Race",race);
				BeeSetVariable(vname.."_Spell",spell);
				BeeSetVariable(vname.."_SpellCD",spellcd);
				BeeSetVariable(vname.."_Guid",guid);
				BeeSetVariable(vname.."_Unit",unit);
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end
		end
	end
	return false
end

function BeeUnitTargetCastSpell(Spell,n,TargetClass,Spells,Unit,times)--獲得對你或隊友施放讀條技能的敵對目標信息
	if Spell then
		if not BeeIsRun(Spell,"nogoal") then
			return
		end
	end
	
	n = IF(n, n, 1);
	Unit = BeeUnit(Unit,"player")
	times=IF(times, times, 9999999);
	
	local group=""
	local Members,i,k,Target
	local Casting,Target_1,cd,ist
	local isClass=true;
	local IsSpells=true;
	
	local IsPlayer=true;
	
	local T_UnitGUID=UnitGUID(Unit);
	local P_UnitGUID=UnitGUID("player");
	
	
	if BeeIsArena() then
		for i=1, 5 do
			Target_1="arena" .. i;
			Target =Target_1 .. "-" .. "target"
			
			local IsUnitName_1 = UnitGUID(Target_1);
			local IsUnitName = UnitGUID(Target);
			
			if Unit == "player" then
				IsPlayer = IsUnitName == P_UnitGUID;
			elseif T_UnitGUID then
				IsPlayer = IsUnitName == T_UnitGUID;
			end

			if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
				if TargetClass then
					isClass = BeeStringFind(TargetClass,BeeUnitClassBase(Target_1)) or BeeStringFind(TargetClass,BeeUnitClass(Target_1));		
				end

				if isClass then
					cd,_,Casting = BeeUnitCastSpellTime(Target_1)							
					if cd ~=-1 and cd <= times then
						if Spells then
							IsSpells = BeeStringFind(Spells,Casting);
						end
						
						if IsSpells then
							if Spell then
								if BeeIsRun(Spell,Target_1) then
									return Target_1
								end
							else
								return Target_1
							end
						end
					end
				end	
			end
		end
		return;
	end

	Target ="targettarget"
	Target_1 ="target"
			
	local IsUnitName_1 = UnitGUID(Target_1);
	local IsUnitName = UnitGUID(Target);
			
	if Unit == "player" then
		IsPlayer = IsUnitName == P_UnitGUID;
	elseif T_UnitGUID then
		IsPlayer = IsUnitName == T_UnitGUID;
	end
		
	if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
		if TargetClass then
			isClass = BeeStringFind(TargetClass,BeeUnitClassBase(Target_1)) or BeeStringFind(TargetClass,BeeUnitClass(Target_1));
		end
				
				
		if isClass then
			cd,_,Casting = BeeUnitCastSpellTime(Target_1)							
			if cd ~=-1 and cd <= times then
				if Spells then
					IsSpells = BeeStringFind(Spells,Casting);
				end
						
				if IsSpells then
					if Spell then
						if BeeIsRun(Spell,Target_1) then
							return Target_1
						end
					else
						return Target_1
					end
				end
			end
		end	
	end

	Target ="focustarget"
	Target_1 ="focus"
			
	local IsUnitName_1 = UnitGUID(Target_1);
	local IsUnitName = UnitGUID(Target);
			
	if Unit == "player" then
		IsPlayer = IsUnitName == P_UnitGUID;
	elseif T_UnitGUID then
		IsPlayer = IsUnitName == T_UnitGUID;
	end

	if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
		if TargetClass then
			isClass = BeeStringFind(TargetClass,BeeUnitClassBase(Target_1)) or BeeStringFind(TargetClass,BeeUnitClass(Target_1));
		end
				
		if isClass then
			cd,_,Casting = BeeUnitCastSpellTime(Target_1)							
					
			if cd ~=-1 and cd <= times then
				if Spells then
					IsSpells = BeeStringFind(Spells,Casting);
				end
				if IsSpells then
					if Spell then
						if BeeIsRun(Spell,Target_1) then
							return Target_1
						end
					else
						return Target_1
					end
				end
			end
		end	
	end

	if GetNumRaidMembers()>0 then
		group="raid"
		Members =GetNumRaidMembers()
	elseif GetNumRaidMembers()==0 then
		return
	else
		group="party"
		Members =GetNumPartyMembers()
	end
	
	for i=1, Members do
		unit=group .. tostring(i);
		
		for k=2,n+1 do
			Target = unit .. strrep("target",k)
			Target_1=unit .. strrep("target",k-1)
					
			local IsUnitName_1 = UnitGUID(Target_1);
			local IsUnitName = UnitGUID(Target);
			if not IsUnitName then
				break;
			end
			
			if Unit == "player" then
				IsPlayer = IsUnitName == P_UnitGUID;
			elseif T_UnitGUID then
				IsPlayer = IsUnitName == T_UnitGUID;
			end

			if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
				if TargetClass then
					isClass = BeeStringFind(TargetClass,BeeUnitClassBase(Target_1)) or BeeStringFind(TargetClass,BeeUnitClass(Target_1));		
				end
				if isClass then
					cd,_,Casting = BeeUnitCastSpellTime(Target_1)							
					if cd ~=-1 and cd <= times then
						if Spells then
							IsSpells = BeeStringFind(Spells,Casting);
						end
						if IsSpells then
							if Spell then
								if BeeIsRun(Spell,Target_1) then
									return Target_1
								end
							else
								return Target_1
							end
						end
					end				
				end					
			end
		end
	end
	return 
end

function BeeArenaAttackCount() --獲得被競技場敵方集火的目標
	local name = {};
	local coun=0;
	local unittarget="";
	
	for i=1, 5 do
	local unit=UnitName("arena" .. i .. "-target");
		if unit then
			if name[unit] then
				name[unit] = name[unit] +1
			else
				name[unit]=1;
			end
			
			if name[unit] > coun then
				coun = name[unit];
				unittarget=unit;
			end	
		end
	end
	return coun,unittarget;
end	

function BeeIsArena() --是否處於競技場或者戰場
	return IsActiveBattlefieldArena();
end

function BeeArenaUnitCastSpellName(targetClass,spells,unit,times)
	if BeeIsArena() then
		local arena,arenaTarget,arenaName,arenaTargetName,name;
		local isarenaAc = true;
		if unit then
			name = UnitName(unit);
			if not name then
				return false;
			end
		end
	
		for i=1, 5 do
			arena = "arena" .. i;
			arenaTarget =arena .. "-target";
			arenaName = UnitName(arena);
			arenaTargetName = UnitName(arenaTarget);
			if arenaName and arenaTargetName then
			
				local acCd,_,spellName = BeeUnitCastSpellTime(arena);
				local isClass,isSpells,isTimes,isUnit ;
				
				isUnit =IF(unit,arenaTargetName == name,true);
				if acCd > 0 and isUnit then		
					isTimes=IF(times,IF(acCd <= times,true,false),true);
					if TargetClass then
						isClass = BeeStringFind(targetClass,BeeUnitClassBase(arenaTarget)) or BeeStringFind(targetClass,BeeUnitClass(arenaTarget));
						isClass=IF(isClass,true,false);
					else
						isClass = true;
					end

					if spells then
						isSpells=IF(BeeStringFind(spells,spellName),true,false);
					else
						isSpells = true;
					end
					isarenaAc = isClass and isSpells and isTimes and isUnit;
					if isarenaAc then
						return true,arenaName,arenaTargetName,spellName;
					end
				end
			end
		end
	end
	return false;
end	

function BeeArrangeBattle(Name,index)--自動進出戰場

	if BeePlayerDeBuffTime(GetSpellInfo(26013))>-1 then
		battleASque=false;
		battleASreq=false;
		return false;
	end

	battleASque=battleASque or false;
	battleASreg=battleASreq or false;
	for i=1, MAX_BATTLEFIELD_QUEUES do
		status, mapName = GetBattlefieldStatus(i);
		--print(mapName,status,i);
		if mapName==Name and status~="none" then
			if status=="queued" or status=="confirm" then
				battleASque=true;
				if status=="confirm" then
					if WowBee.Spell.ArrangeBattleSleep then
						if GetTime() - WowBee.Spell.ArrangeBattleSleep > 5 then
							BeeRun("/run AcceptBattlefieldPort(" .. i ..",1)")
							--StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
							WowBee.Spell.ArrangeBattleSleep=nil;
						end
					else
						WowBee.Spell.ArrangeBattleSleep=GetTime();
					end
				end
			elseif status=="active" then
				battleAS:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
				battleASque=true;
			end
		elseif mapName==Name and status=="none" then
			battleASque=false;
			battleASreq=false;
		end
	end
	
	--print(">>",battleASque)
	
	if not battleASque then
		if not battleAS then
			battleAS=CreateFrame("Frame");
			battleAS:SetScript("OnEvent",function(self,event)
				if event=="PVPQUEUE_ANYWHERE_SHOW" then
					WowBee_Message(WowBee.Colors.YELLOW .. "加入" .. Name .. "队列!");
					self:UnregisterEvent("PVPQUEUE_ANYWHERE_SHOW");
					JoinBattlefield(0,1);
				elseif event=="UPDATE_BATTLEFIELD_STATUS" and GetBattlefieldWinner() then
					self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS");
					LeaveBattlefield();
				end
			end);
			return false;
		end
		if not battleASreq then
			battleASreq=true;
			RequestBattlegroundInstanceInfo(index);
			battleAS:RegisterEvent("PVPQUEUE_ANYWHERE_SHOW");
			return false;
		end
	end
	return false;
end
------------------------------------------------------------
function BeeShowUnitBuffList(unit) --显示指定指定目标buff列表
	unit=BeeUnit(unit,"player");
	local name = {};
	local i,f,k,n,nn;
	local ls_icon={};
	local c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable;
	k = 1;
	if not UnitName(unit) then
		WowBee_Message(WowBee.Colors.RED..tostring(unit).." ID错误" )
		return nil;
	end
	
	WowBee_Message(WowBee.Colors.RED..UnitName(unit).." - Buff列表" )
	for f = 0, 1 do 
		WowBee_Message(WowBee.Colors.MAGENTA.. IF(f==0, "有益Buff", "无益Buff"))
		for i = 1,MAX_TARGET_BUFFS do 
			if (f == 0) then
				c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable,shouldConsolidate, spellId = UnitBuff(unit, i);
			else
				c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable,shouldConsolidate, spellId = UnitDebuff(unit, i);
			end
			
			if c then
				name[k] = c ;
			
				n = expirationTime - GetTime()
				n = format("%.1f",IF(n < 0, 0, n));
				nn = format("%.1f",duration);
				
				ls_icon = { strsplit("\\",icon) }
				
				WowBee_Message(WowBee.Colors.RED..tostring(k)..". ".. WowBee.Colors.LGREEN .. c )
				WowBee_Message(WowBee.Colors.YELLOW.."   等级:".. WowBee.Colors.LGREEN .. tostring(rank) )
				WowBee_Message(WowBee.Colors.YELLOW.."   类型:".. WowBee.Colors.LGREEN .. tostring(debuffType) )
				WowBee_Message(WowBee.Colors.YELLOW.."   层数:".. WowBee.Colors.LGREEN .. tostring(count) )
				WowBee_Message(WowBee.Colors.YELLOW.."   冷却:".. WowBee.Colors.LGREEN .. tostring(n) )
				WowBee_Message(WowBee.Colors.YELLOW.."   归属:".. WowBee.Colors.LGREEN .. tostring(unitCaster) )
				WowBee_Message(WowBee.Colors.YELLOW.."   图标:".. WowBee.Colors.LGREEN .. tostring(ls_icon[3]) )
				WowBee_Message(WowBee.Colors.YELLOW.."   其他:".. WowBee.Colors.LGREEN .. tostring(isStealable) )
				WowBee_Message(WowBee.Colors.YELLOW.."   技能时间:".. WowBee.Colors.LGREEN .. tostring(nn) )		
				WowBee_Message(WowBee.Colors.YELLOW.."   shouldConsolidate:".. wowam.Colors.CYAN .. tostring(shouldConsolidate) )
				WowBee_Message(WowBee.Colors.YELLOW.."   spellId:".. wowam.Colors.CYAN .. tostring(spellId))
				WowBee_Message(WowBee.Colors.YELLOW.."   spell:".. wowam.Colors.CYAN .. GetSpellLink(spellId) )
				k = k + 1;
			end
		end
	end
	
	return k-1;
end

function BeeShowEquipList(unit) --显示指定目标的装备列表及CD 
	unit=BeeUnit(unit,"player");
	local cd;
	for i=1 , 23 do
		local mainHandLink = GetInventoryItemLink(unit,i);
		if mainHandLink then
			local spell = GetItemInfo(mainHandLink);
			if spell then
				a, b, c = GetInventoryItemCooldown(unit, i);
				cd= a+b-GetTime();
				cd = format("%.1f",IF(cd<0, 0, cd));
				DEFAULT_CHAT_FRAME:AddMessage(WowBee.Colors.RED .. "编号:" .. WowBee.Colors.LGREEN .. tostring(i) .. WowBee.Colors.YELLOW .."  名称:" ..WowBee.Colors.LGREEN.. spell .. WowBee.Colors.YELLOW .."  冷却时间:" ..WowBee.Colors.LGREEN.. cd,192,0,192,0);
			end
		end
	end
end

function BeeShowSpellList(spell,index)
	if not index then
		index =200000
	end
	local k =1
	for i=1,index do
		local name = GetSpellInfo(i)
		
		if name ==	spell then
		WowBee_Message(WowBee.Colors.RED .. "(" .. k .. ") " ..  WowBee.Colors.YELLOW .. name .. ", " .. WowBee.Colors.LGREEN .. tostring(i) )
		print(GetSpellInfo(i))
		k=k+1
		end						
	end
end		
---------------------------------------------------------------------------------------------
function BeeWeaponEnchantInfo(n)--返回主手和副手武器附魔信息.
	local a,b,c,a1,b1,c1 = GetWeaponEnchantInfo() -- 返回主手和副手武器附魔信息.

	if n ==1 and a then
		return b/1000,a,c
	elseif n ==2 and a1 then
		return b1/1000,a1,c1
	end

	return -1;
end

function BeeSetSpellStopTime(times)
	times=IF(times, times, 3);
	if type(times) ~= "number" then
		WowBee_Message(WowBee.Colors.RED.."错误：" .. WowBee.Colors.LGREEN .. "参数类型错误，请使用数值");
		return false;
	end

	WowBee.Config.SPELL_STOP_TIME=times;
	return true;
end 

function Bee_IsFailed(spell,unit)

	if WowBee.Spell.Failed then
		local aunid = UnitGUID(unit);
		if aunid and WowBee.Spell.Failed[aunid] then
			if GetTime() - WowBee.Spell.Failed[aunid]["Time"] <=0 then
				if(WowBee.Spell.Failed[aunid]["Text"]==SPELL_FAILED_NOT_BEHIND)then
					if (WowBee.Spell.Failed[aunid]["SpellName"]==spell) then
						return false,"忽略目标(".. WowBee.Spell.Failed[aunid]["Text"]..")";
					end
				else
					return false,"忽略目标(".. WowBee.Spell.Failed[aunid]["Text"]..")";
				end
			end
		end
	end

	if WowBee.Spell.Delay then
		local unid =IF(unit=="nogoal",UnitGUID("player"),UnitGUID(unit))
		local tbl = WowBee.Spell.Delay[spell];
		if tbl and unid then
			if tbl["All"] and tbl["All"]["Status"] and tbl["All"]["Status"] == "Star" and tbl["All"]["DelayTime"] then
				return false,"技能延時施放,施放中..."..GetTime() -tbl["All"]["DelayTime"];
			elseif tbl[unid] and tbl[unid]["Status"] and tbl[unid]["Status"] == "Star" and tbl[unid]["DelayTime"] then
				return false,"技能延時施放,施放中..."..GetTime() -tbl[unid]["DelayTime"];
			elseif tbl["All"] and tbl["All"]["Status"] and tbl["All"]["Status"] == "End" and tbl["All"]["EndTime"] and (GetTime() < tbl["All"]["EndTime"]) then
				return false,"技能延時中..."..GetTime() - tbl["All"]["EndTime"];
			elseif tbl[unid] and tbl[unid]["Status"] and tbl[unid]["Status"] == "End" and tbl[unid]["EndTime"] and (GetTime() < tbl[unid]["EndTime"]) then
				return false,"技能延時中..."..GetTime() -tbl[unid]["EndTime"];	
			end
		end
	end
	
	--[[if WowBee.Spell.Failed and WowBee.Spell.Failed.Delay then
		local uid;
		if WowBee.Spell.Failed.Delay[spell] and WowBee.Spell.Failed.Delay[spell][spell] and WowBee.Spell.Failed.Delay[spell][spell]["SPELL_DELAY"] then
			uid=spell;
		else
			uid=UnitGUID(unit);
		end
		
		if uid then
			if WowBee.Spell.Failed.Delay[uid] and WowBee.Spell.Failed.Delay[uid][spell] and WowBee.Spell.Failed.Delay[uid][spell]["TIME"] then
				if WowBee.Spell.Failed.Delay[uid][spell]["SPELL_DELAY"] then
					local temp_act,_,temp_act_name = BeeUnitCastSpellTime("player");
					if temp_act ~= -1 and temp_act_name == spell then
						temp_act = IF(temp_act==-1, 0, temp_act);
						WowBee.Spell.Failed.Delay[uid][spell]["TIME"] = GetTime();
					else
						temp_act=0;
					end
					if GetTime() - WowBee.Spell.Failed.Delay[uid][spell]["TIME"] < WowBee.Spell.Failed.Delay[uid][spell]["SPELL_DELAY"] then
						return false,"技能延时施放";
					end
				else					
					local uida,text;
					uida=UnitGUID(unit);
					if uida and WowBee.Spell.Failed.Delay[uida] and WowBee.Spell.Failed.Delay[uida]["FAILED_TEXT"] then
						text = WowBee.Spell.Failed.Delay[uida]["FAILED_TEXT"]
						
						if text==SPELL_FAILED_OUT_OF_RANGE or text==SPELL_FAILED_BAD_IMPLICIT_TARGETS or text==SPELL_FAILED_LINE_OF_SIGHT or text==SPELL_FAILED_TARGETS_DEAD or text==SPELL_FAILED_BAD_TARGETS then
							if GetTime() - WowBee.Spell.Failed.Delay[uida]["TIME"] > WowBee.Config.SPELL_STOP_TIME then
								return true,text;
							else
								return false,text;
							end
						end
					end
				
					local ftext = WowBee.Spell.Failed.Delay[uid][spell]["FAILED_TEXT"];
					
					local failed_on = SPELL_FAILED_NOT_BEHIND==ftext or SPELL_FAILED_ONLY_STEALTHED==ftext or SPELL_FAILED_AURA_BOUNCED==ftext or  SPELL_FAILED_NO_COMBO_POINTS==ftext or SPELL_FAILED_ONLY_OUTDOORS==ftext or SPELL_FAILED_ONLY_SHAPESHIFT==ftext or SPELL_FAILED_ONLY_STEALTHED==ftext  ;
					--print("2>>",ftext,failed_on)
					if failed_on then
						if GetTime() - WowBee.Spell.Failed.Delay[uid][spell]["TIME"] < WowBee.Config.SPELL_STOP_TIME then
							return false,WowBee.Spell.Failed.Delay[uid][spell]["FAILED_TEXT"];
						end
					else
						if WowBee.Spell.Failed.Delay[spell] and WowBee.Spell.Failed.Delay[spell]["TIME"] then
					--print("3>>",GetTime() - WowBee.Spell.Failed.Delay[spell]["TIME"] < WowBee.Config.SPELL_STOP_TIME,GetTime() -WowBee.Spell.Failed.Delay[spell]["TIME"] , WowBee.Config.SPELL_STOP_TIME)
							if GetTime() - WowBee.Spell.Failed.Delay[spell]["TIME"] < WowBee.Config.SPELL_STOP_TIME then
								return false,WowBee.Spell.Failed.Delay[spell]["FAILED_TEXT"];
							end
						end
					end
				end

				WowBee.Spell.Failed.Delay[uid]=nil;
				WowBee.Spell.Failed.Delay[spell]=nil;
				return true,"";
			end
		else
			return true,"";
		end
	end]]
	return true,"";
end

function Bee_IsItem(name,tunit,gcd,Special,isname,NOCD,typenumber,SpellLevel,temp_UnitGUID,unitguid,EnergyDemand)
	local itemID = WowBee.Spell.Property[name]["ItemID"];
	local itemCD = BeeItemCoolDown(itemID);
		
	if  WowBee.Spell.Property[name]["ItemEquipLoc"] ~= "" and not IsEquippedItem(itemID) then
		return false,typenumber,"请装备/佩戴该物品";
	end


	if  WowBee.Spell.Property[name]["HasRange"] and tunit ~= "nogoal" then
		if not temp_UnitGUID then
			return false,typenumber,"需要个目标(如有问题请尝试用“无目标”(”normal”)参数或联系技术支持)";
		end
	end


	
	if itemCD >0 then
		return false,typenumber,"物品冷却中",itemCD;
	end
	
	local usable, nomana = IsUsableItem(itemID);
	if (not usable) then
		return false,typenumber,"物品不可用",itemCD;
	end
	
	if tunit == "nogoal" or not WowBee.Spell.Property[name]["HasRange"] then
		return true,typenumber,"",itemCD;
	end
	
	local Isa =IsItemInRange(itemID,tunit)
	
	if  not (UnitCanAssist("player", tunit)  or  UnitCanAttack("player", tunit))  and tunit ~= "nogoal" then	
		return false,typenumber,"物品距离太远",itemCD;
	end
	
	if not Isa then
		return false,typenumber,"不能对此目标施法(请尝试用“无目标”(”normal”)参数或联系技术支持)",itemCD;
	end
	
	return true,typenumber,"",itemCD;
end

function Bee_IsSpell(name,tunit,gcd,Special,isname,NOCD,typenumber,SpellLevel,temp_UnitGUID,unitguid,EnergyDemand)

	if Bee_IsSpell_Conversion then
		local ASSC1,ASSC2,ASSC3,ASSC4,ASSC5,ASSC6 = Bee_IsSpell_Conversion(name,tunit,gcd,Special,isname,typenumber,SpellLevel,temp_UnitGUID,unitguid);
		if ASSC1 then
			return ASSC1,ASSC2,ASSC3,ASSC4,ASSC5,ASSC6;
		elseif not ASSC1 and ASSC2 ~= -100 then
			return ASSC1,ASSC2,ASSC3,ASSC4,ASSC5,ASSC6;
		end
	end

	local Cooldown = BeeSpellCoolDown(name);
	
	if WowBee.Config.SetGCD and not gcd then
		if BeeGCD()> WowBee.Config.SetGCD_Time then
			return false,typenumber,"公共CD未冷却",Cooldown;
		end
	end

	local spellId = WowBee.Spell.Property[name]["SpellId"]
	--local slotID = WowBee.Spell.Property[name]["SlotID"];
	
	--if GetSpellBookItemInfo(slotID, "player") == "FUTURESPELL" then
	--	return false,typenumber,"技能沒學習不可用",Cooldown;
	--end
	
	if BeeSpellIsShapeshift and not BeeSpellIsShapeshift(spellId) then
		return false,typenumber,"技能姿態不符合",Cooldown;
	end
	
	local _Activation
	if BeeSpellIsActivation then
	
		local  temp_Activation,temp_Activation_1,temp_Activation_2,temp_Activation_3 = BeeSpellIsActivation(spellId,tunit,name);
		
		if not temp_Activation_2 then
			if temp_Activation then
				if temp_Activation_1 then
					--return true,typenumber,"技能激活",Cooldown;
					_Activation="技能激活";
				end
			else
				if temp_Activation_1 then
					return false,typenumber,temp_Activation_1,Cooldown;
				else
					return false,typenumber,"技能沒激活不可用",Cooldown;
				end
			end
		elseif temp_Activation_3 then
			return false,typenumber,"技能沒激活不可用",Cooldown;
		end
	end
	
	if WowBee.Spell.Property[name]["RaidSpell"] and tunit ~= "nogoal" then
		if WowBee.Spell.Property[name]["RaidSpell"] ==3 then
			if not(UnitPlayerOrPetInParty(tunit) or UnitPlayerOrPetInRaid(tunit) or UnitGUID(tunit) == UnitGUID("player")) then
				return false,typenumber,"目标只能是小队或者团队";
			end
		elseif not (WowBee.Spell.Property[name]["RaidSpell"] ==2 and (UnitPlayerOrPetInParty(tunit) or UnitGUID(tunit) == UnitGUID("player"))) then
			return false,typenumber,"目标只能是小队";
		elseif not (WowBee.Spell.Property[name]["RaidSpell"] ==1 and  UnitGUID(tunit) == UnitGUID("player")) then
			return false,typenumber,"目标只能是自己";
		end
	end	
	--print(BeeSpellIsMove(spellId,tunit,name))
	if (not(BeeSpellIsMoveAll and BeeSpellIsMoveAll(spellId,tunit,name))) and (not(BeeSpellIsMove and BeeSpellIsMove(spellId,tunit,name))) then
		local T_temp1 = GetUnitSpeed("player")
		--local T_temp2 = WowBee.Spell.Property[name]["CastTime"] --select(7,GetSpellInfo(name))
		local T_temp2 = select(7,GetSpellInfo(name))
		
		if T_temp1 and T_temp2 and T_temp2 and T_temp2 >0 and T_temp1>0 then
			return false,typenumber,"你移動中",Cooldown;
		end
	end	
	
	if (WowBee.Spell.Property[name]["HasRange"] and tunit ~= "nogoal") then
		if not temp_UnitGUID then
			return false,typenumber,"需要个目标(如有问题请尝试用“无目标”(”normal”)参数或联系技术支持)";
		end

		
		local spellInRange =IsSpellInRange(name,tunit)
		
		if WowBee.Spell.Property[name]["IsSpellInRange"] and not spellInRange then
			return false,typenumber,"目标死亡或者不能对其施放",Cooldown;
		end
		
		if spellInRange and not WowBee.Spell.Property[name]["IsSpellInRange"] then
			WowBee.Spell.Property[name]["IsSpellInRange"]=spellInRange;
		end

		if UnitCanAssist("player", tunit) or UnitCanAttack("player", tunit) then
			if spellInRange == 0 then
				return false,typenumber,"超距离",Cooldown;
			elseif spellInRange==nil then
				return false,typenumber,"不能对此目标施法(请尝试用“无目标”(”normal”)参数或联系技术支持)",Cooldown;
			end	
		else
			return false,typenumber,"技能距离太远",Cooldown;
		end
	end


	local act_timp =0;

	if WowBee.Spell.Property[name]["CastTime"] and WowBee.Spell.Property[name]["CastTime"]<=0 then
		Cooldown=Cooldown-WowBee.Config.PromptSpellAttackTime;--?
	else
		act_timp,_,acc =BeeUnitCastSpellTime("player")

		--if acc == name and act_timp > WowBee.Config.SpellAttackTime and not NOCD then
		if act_timp ~= -1 and act_timp > WowBee.Config.SpellAttackTime and not NOCD then--?
			return false,typenumber,"施放技能中",Cooldown;
		end
		
		Cooldown=Cooldown-WowBee.Config.SpellAttackTime;
	end

	if Cooldown >0 and not NOCD then
		return false,typenumber,"技能冷却中",Cooldown;
	end
	
	if IsCurrentSpell(name) and act_timp<=0  and not NOCD then
		return false,typenumber,"正在或者准备施放技能中",Cooldown;
	end

	local usable, nomana = IsUsableSpell(spellId);--C
	local _,_, _, powerCost = GetSpellInfo(spellId);---C
	
	if BeeSpellIsPowerNumber and BeeSpellIsPowerNumber(spellId) then
		local n = BeeSpellIsPowerNumber(spellId);
		if BeeUnitMana("player") < n  then
			return false,typenumber,"能量不足",Cooldown;
		end	
	elseif EnergyDemand then
		if BeeUnitMana("player") < EnergyDemand  then
			return false,typenumber,"能量不足",Cooldown;
		end	
	elseif Special ==1 or (BeeSpellIsPowerCost and BeeSpellIsPowerCost(name)) then
		if BeeUnitMana("player") < powerCost  then
		  return false,typenumber,"能量不足",Cooldown;
		end	
	elseif not usable and not nomana then
		if BeeSpellIsShapeshift and not BeeSpellIsShapeshift(spellId) then
			return false,typenumber,"技能姿態不符合",Cooldown;
		elseif(_Activation)then 
			return true,typenumber,_Activation,Cooldown;
		else
			return false,typenumber,"该技能目前无法判断,请参考BeeIsRun第四参数或联系技术支持.",Cooldown;
		end
	elseif nomana then
		return false,typenumber,"能量不足",Cooldown;
	end
	return true,typenumber,"",Cooldown;
end

function Bee_GetSpellInf(spell)

	if strsub(spell,1,1) == "/" then
		return true,5;
	end
	
	if WowBee.Spell.Property[spell] then
		if WowBee.Spell.Property[spell]["Type"] then
			return true,WowBee.Spell.Property[spell]["Type"];
		end
	end

	if BeeSpellIsEx then
		
		 local SSE1,SSE2,SSE3 = BeeSpellIsEx(spell);
		 if SSE1 then
			return SSE1,SSE2,SSE3;
		 end
	end
	--极限版修改
	--local skillType, spellId = GetSpellBookItemInfo(spell);
	local spellId = spell;
	
	--local spellId,slotID,_,_,skillType = BeeGetSpellId(spell); --?
		
	if spellId then
	
		local spellname,level, _, powerCost,_,_,castTime = GetSpellInfo(spellId);
		WowBee.Spell.Property = WowBee.Spell.Property or {};
		WowBee.Spell.Property[spell]={};
		WowBee.Spell.Property[spell]["Type"] = 1;
		WowBee.Spell.Property[spell]["TypeName"] = "Spell";
		WowBee.Spell.Property[spell]["SpellId"]=spellId;
		--WowBee.Spell.Property[spell]["SlotID"]=slotID;
		
		WowBee.Spell.Property[spell]["Time"]= GetTime();
		WowBee.Spell.Property[spell]["PowerCost"]= powerCost;
		WowBee.Spell.Property[spell]["CastTime"]= castTime;
		WowBee.Spell.Property[spell]["SpellName"]= spellname;
		WowBee.Spell.Property[spell]["Level"]= level;
		WowBee.Spell.Property[spell]["Spell"]= spell;
		WowBee.Spell.Property[spell]["SkillType"]=skillType;
		
		WowBee.Spell.Property[spell]["HasRange"] = BeeSpellIsNoTarget and not BeeSpellIsNoTarget(spellId);  
		
		if BeeSpellIsRaid then
			WowBee.Spell.Property[spell]["RaidSpell"]= BeeSpellIsRaid(spell); 
		else
			WowBee.Spell.Property[spell]["RaidSpell"]=nil;
		end

		return true,1,spell,spellId;
	end
	
	local itemID = BeeGetItemId(spell);
	if itemID then
	
		local isEquipped = IsEquippedItem(itemID)
		local itemSpell = GetItemSpell(itemID);

		local exist, _, _, _, _, _, _, _,itemEquipLoc = GetItemInfo(itemID);
		if exist then
			local itemtype= IF(isEquipped,3,2);
		
			WowBee.Spell.Property[spell]={};
			WowBee.Spell.Property[spell]["Type"]=itemtype;
			WowBee.Spell.Property[spell]["TypeName"]=IF(isEquipped,"Equipped","Item");
			
			if itemEquipLoc == "INVTYPE_TRINKET"  and not WowBee.Config.TRINKET_TARGET then
				WowBee.Spell.Property[spell]["HasRange"]=nil;
			else
				WowBee.Spell.Property[spell]["HasRange"]=ItemHasRange(itemID);
			end
			
			if WowBee.Spell.Property[spell]["HasRange"] and BeeSpellIsNoTarget and BeeSpellIsNoTarget(itemID) then 
				WowBee.Spell.Property[spell]["HasRange"] = nil;
			end
			
			WowBee.Spell.Property[spell]["Time"]= GetTime();
			WowBee.Spell.Property[spell]["ItemID"]=itemID;
			WowBee.Spell.Property[spell]["Spell"]= itemSpell;
			WowBee.Spell.Property[spell]["ItemEquipLoc"]= itemEquipLoc;
		
			if BeeSpellIsRaid then
				WowBee.Spell.Property[spell]["RaidSpell"]= BeeSpellIsRaid(spell);
			else
				WowBee.Spell.Property[spell]["RaidSpell"]=nil;
			end
			
			return true,itemtype;
		end
	end

	if GetMacroIndexByName(spell) >0 then
		return true,4;
	end

	return false,-1;
end

function Bee_IsRunSpell(name,tunit,gcd,special,NOCD,EnergyDemand)

	special = IF(special, special, 0);

	local isname,typenumber,spellLevel = Bee_GetSpellInf(name);
	
	if typenumber == -1 then
		return false,typenumber,"无法识别的技能、物品、宏";
	end
	
	if typenumber == 5 then
		return true,typenumber,name .. "(只判断宏是否存在,忽略宏内容)";
	end
	
	if isname and typenumber == 4 then
		local getMacroIndex = GetMacroIndexByName(name)
		if getMacroIndex >0 then
			local sepll, rank ,body = GetMacroInfo(getMacroIndex)
			return true,4,sepll,getMacroIndex,body;
		end
	end

	tunit = BeeUnit(tunit,"target")
	
	local temp_UnitGUID,unitguid;
	temp_UnitGUID = UnitGUID(tunit);
	
	if tunit=="nogoal" then
		unitguid ="3";
	elseif not WowBee.Spell.Property[name]["HasRange"] then
		unitguid ="1";
	elseif not temp_UnitGUID then
		unitguid ="0";
	else
		unitguid=temp_UnitGUID;
	end
	
	if typenumber>=1 and typenumber<=3  and WowBee.Spell.Property[name]["Result"] and WowBee.Spell.Property[name]["Unitguid"] == unitguid then
	
		local temp_GetTime=GetTime();
		local temp_istime = WowBee.Spell.PropertyTime - (temp_GetTime - WowBee.Spell.Property[name]["Time"]);--?
	
		if temp_istime > 0 then
			return true,typenumber,"是记忆判断",nil,nil,nil,nil,nil,temp_istime;
		end
	end
	
	if typenumber==1 then
		return Bee_IsSpell(name,tunit,gcd,special,isname,NOCD,typenumber,spellLevel,temp_UnitGUID,unitguid,EnergyDemand)
	elseif typenumber==2 or typenumber==3 then
		return Bee_IsItem(name,tunit,gcd,special,isname,NOCD,typenumber,spellLevel,temp_UnitGUID,unitguid,EnergyDemand)
	end
	
	return false,typenumber,"判断出错，请联系技术支持";
end

function Bee_IsRunSpell_Result(name,tunit,Result)

	if not WowBee.Spell.Property[name] then
		return;	
	end
	
	local temp_UnitGUID,unitguid;
	temp_UnitGUID = UnitGUID(tunit);
	
	if tunit=="nogoal" then
		unitguid ="3";
	elseif not WowBee.Spell.Property[name]["HasRange"] then
		unitguid ="1";
	elseif not temp_UnitGUID then
		unitguid ="0";
	else
		unitguid=temp_UnitGUID;
	end
	
		
	WowBee.Spell.Property[name]["Unitguid"]=unitguid;
	WowBee.Spell.Property[name]["Time"]= GetTime();
	WowBee.Spell.Property[name]["Result"]=Result;
		
end

function BeeApiDecursive()
	if not Dcr  then
		WowBee_Message(WowBee.Colors.RED.."错误：" .. WowBee.Colors.LGREEN .. "无法使用BeeApiDecursive()函数,需要安装或启动Decursive插件");
		return
	end
	local n = Dcr["Status"]["UnitNum"]
	local i;
	for i=1, n do
		local unit,spell,IsCharmed,Debuff1Prio = BeeApiDecursive_EX(i)
		if unit then
			if UnitName(unit) and spell then 
				if BeeIsRun(spell,unit) then
					BeeRun(spell,unit)
					return true
				end
			end
		end
	end
end

function BeeApiDecursive_EX(id)
	local unit = Dcr.Status.Unit_Array[id]
	local f = Dcr["MicroUnitF"]["UnitToMUF"][unit]

	if not f then
		return
	end
	local isDebuffed = f["IsDebuffed"]

	if isDebuffed then
		local DebuffType = f["FirstDebuffType"]
		local spell = Dcr.Status.CuringSpells[DebuffType]
		local isCharmed = f["IsCharmed"]
		local debuff1Prio = f["Debuff1Prio"]
		return unit,spell,isCharmed,debuff1Prio
	end
--MicroUnitF:UpdateMUFUnit
end

function BeeKey(spell,on)
	if on then
		WowBeeHelper_OnMacro(string.format("%s",spell),6)
	else
		WowBeeHelper_OnMacro(string.format("%s",spell),4)
	end
end

function BeeMouse(x,y,b,spell,unit)
	BeeRun(spell,BeeUnit(unit,"nogoal"),string.format("%s|%s|%s",x,y,b))
end

function BeeHolyPower(unit)-- 神圣能量
	return UnitPower(BeeUnit(unit,"player"), SPELL_POWER_HOLY_POWER);
end

function BeePower()-- 特殊能量
	local _, englishClass = UnitClass("player");
	if englishClass == "PALADIN" then
		return UnitPower("player", SPELL_POWER_HOLY_POWER);
	elseif englishClass == "DRUID" then
		return UnitPower("player", SPELL_POWER_ECLIPSE);
	elseif englishClass == "WARLOCK" then
		local tf = GetSpecialization();
		if tf == 2 then
			return UnitPower("player", SPELL_POWER_DEMONIC_FURY);
		elseif tf == 3 then
			return UnitPower("player", SPELL_POWER_BURNING_EMBERS);
		else
			return UnitPower("player", SPELL_POWER_SOUL_SHARDS);
		end
	elseif englishClass == "PRIEST" then
		return UnitPower("player", SPELL_POWER_SHADOW_ORBS);
	elseif englishClass == "MONK" then
		return UnitPower("player", 12);
		
		
	end
	return -1;
end

function BeePettext()
	local str="";
	for i=1, NUM_PET_ACTION_SLOTS do
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if not name then
			break;
		end
		str =str .. "(".. i .. ")" ..  name .. ",".. texture .. ",";
    end
	amtext=str;
	return str;
end	

function BeeIsActivePet(v)-- 宠物状态按钮
	for i=1, NUM_PET_ACTION_SLOTS do
      local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if not name then
			break;
		end
		if name == v then
			return isActive;
		end
    end
	return false;
end

function BeeAutoCastEnabledPet(v)-- 宠物技能是否能激活状态
	for i=1, NUM_PET_ACTION_SLOTS do
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if not name then
			break;
		end
		if name == v then
			return autoCastEnabled;
		end
    end
	return false;
end

function BeeAutoCastAllowedet(v)-- 宠物技能是否能激活
	for i=1, NUM_PET_ACTION_SLOTS do
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
      
		if not name then
			break;
		end
	  
		if name == v then
			return autoCastAllowed;
		end
    end
	return false;
end

function BeeIsCurrentMouse(Spell)-- 技能正在执行时按下鼠标左键
	if IsCurrentSpell(Spell) then
		BeeMouse(0,0,1, Spell);
		return true;
	end
	return false;
end

function BeeCancelUnitBuff(unit,buff) --取消指定的BUFF BeeCancelUnitBuff(unit,spell)
	if BeeUnitBuff(buff,unit,2,0)>0 then
		CancelUnitBuff(unit,buff);
		return true;
	end
	return false;
end

function BeeIsInterruptible(unit) -- 判断法术能否被打断,注意,此函数仅仅只判断法术本身是否能被打断,不会判断受无敌保护光环掌握等免打断影响造成的不能打断.--墨者提供
    local _, _, _, _, _, _,_,_, notInterruptibleCast = UnitCastingInfo(unit);
    local _, _, _, _, _, _,_, notInterruptibleChannel = UnitChannelInfo(unit);
    if notInterruptibleCast ~= nil or notInterruptibleChannel ~=nil then
        return not notInterruptibleCast or not notInterruptibleChannel;
    end
    return false;
end

function BeeStopCasting()
	BeeRun("/StopCasting");
	return true;
end

function BeeUnitFollow(unit)--跟随目标
	if not unit or not BeeUnitIsFollow() then
		return false;
	end
	
	if BeeUnitIsFollow() == unit then
		return false,"正在跟随";
	elseif UnitName(unit) and BeeRange(unit)<=25 then
		FollowUnit(unit);
		return true;
	end
	return false;
end

function BeeGetInventoryItemDurability(invSlot) --装备持久度
	local L,H = GetInventoryItemDurability(invSlot);
	return tonumber(format("%.0f", L/H *100));
end

function BeeGetMainTank(index)
	
	if not (index and type()=="number") then
		return "";
	end
	
	local k = GetNumRaidMembers();
	
	local MtIndex =0;	
	
	for i=1 , k do
	
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
			
		if name and role == "MAINTANK" then
			MtIndex = MtIndex +1;
			if MtIndex==index then
				return name;
			end
		end
	end
	return "";
end

function BeeUnitClassification(unit,classification)
	if unit and classification then
		return UnitClassification(unit) == classification;
	else
		return false;
	end
end	


function BeeGetSIlink(Name)
	local itemName, itemLink= GetItemInfo(Name)
	if itemName then
		return itemName;
	end
	
	local itemName= GetSpellLink(Name)

	if itemName then
		return itemName;
	end
	return Name;
end

function BeeSetFocus(unit,Name)

	local mouseover = UnitName("mouseover");
	local focus = UnitName("focus");
	
	if not Name or not unit or not mouseover then return false; end;
	
	if mouseover == Name and focus ~= Name then
	
		BeeRun("/focus mouseover");
		return true;
	end
	
	return false;
end 

function BeeAutoResume(Type,n,Buff,Spell,Battle) --自动恢复能量或者生命 
	
	if Battle and BeeUnitAffectingCombat() then
	
	elseif not Battle and not BeeUnitAffectingCombat() then

	else
		return false;
	end
	
	if Type == 0 then
		Type = BeeUnitHealth("player","%") < n ;
	elseif Type == 1 then
		Type = BeeUnitMana("player","%") < n ;
	elseif Type == 2 then
		Type = BeeUnitHealth("player","%") < n or BeeUnitMana("player","%") < n ;
	end
	
	local T = BeeUnitBuff(Buff,"player",2,0)<=0 and Type;

	if T and BeeIsRun(Spell,"player") then
	
		BeeRun(Spell,"player");
		BeeUnitCastSpellDelay(Spell,2,"player");
		return true;
		
	end

end

function BeeGetSpellCastTarget(spell)
	if not WowBee.Spell.Casting or not WowBee.Spell.Casting[spell] then
		return "";
	end
	
	local tbl = WowBee.Spell.Casting[spell];
	
	if GetTime() - tbl["Time"] >30 then
		tbl = nil;
		return "";
	end
	return tbl["Unit"];
end

function BeeGetCastInf()
	
	if not WowBee.Spell.Casting then
		return "";
	end
	
	local tbl = WowBee.Spell.Casting;
	
	if tbl["Spell"] then
		if GetTime() - tbl["Time"] >30 then
			WowBee.Spell.Casting = {};
			return "";
		end
		return 	tbl["Spell"],tbl["Unit"], GetTime() - tbl["Time"];
	end
	
	return "";
end

function BeeIsPlayerCastSpell()

	if not WowBee.Spell.Casting then
		return false;
	end
	local tbl = WowBee.Spell.Casting;
	
	if tbl["Spell"] then
		if GetTime() - tbl["Time"] >30 then
			WowBee.Spell.Casting = {};
			return false;
		end
		return 	true;
	end
	return false;
end

function BeeUnitGetIncomingHeals(unit) --治療量預測函數
	
	local guid = UnitGUID(unit);
	
	if guid then
		local Health = UnitHealth(unit);
		local HealthMax = UnitHealthMax(unit);
		--UnitIsPlayer
		local HEAL_PREDICTION = UnitGetIncomingHeals(unit);
		local Player_HEAL_PREDICTION = UnitGetIncomingHeals(unit,"player");
		local HealthExcess	=  Health + HEAL_PREDICTION - HealthMax;

		return HEAL_PREDICTION,HealthExcess,Player_HEAL_PREDICTION;
	end
	return -1,-1,-1;
end


function BeeGetDkInfectionTargetInf()
	print("|cffff0000BeeGetDkInfectionTargetInf |r死亡骑士专用函数，其他职业不能使用。")
end

function BeeGetDKPetCD()
	local haveTotem, name, startTime, duration, icon = GetTotemInfo(1);
	
	if not haveTotem then
		return -1;
	end
	
	local cd = duration - (GetTime()-startTime) ;
	
	if cd <0 then
		--cd=0;
	end
	
	return cd;
end
	


function BeeFindSpellItemInf(info1)

	local infoType;
	
	if GetSpellInfo(info1) then
		infoType = "spell";
	elseif GetItemInfo(info1) then
		infoType = "item";
	else
		local spellid = BeeSpellId(info1)
		if spellid then
			_,rank,Texture=GetSpellInfo(spellid)
			return spellid,"",rank,Texture,"";
		end
		return;
	end
	
	if infoType=="item" then
		local spellId;
		local name,itemLink,itemRarity,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,Texture,itemSellPrice;
		
		name,itemLink,itemRarity,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,Texture,itemSellPrice=GetItemInfo(info1);
		_,_,_,_,spellId,_,_,_,_,_,_,_,_,_=string.find(itemLink,"|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	
		--print("Item",spellId);
		
		if type(spellId) == "string" then
			spellId = tonumber(spellId);
		end
		return spellId,itemLink,itemSubType,Texture,infoType;
	elseif infoType=="spell"  then
		
		local spellLink,spellName,spellRank,spellId,Texture;
		_,spellId = GetSpellBookItemInfo(info1,"player");
		spellName,spellRank,Texture = GetSpellInfo(spellId);
		spellLink,_=GetSpellLink(spellId);
			
		if not spellLink then
			return;
		end
			
		if type(spellId) == "string" then
			spellId = tonumber(spellId);
		end
		
		return spellId,spellLink,spellRank,Texture,infoType;
		--print("Spell",spellId);	
	end
end


local BeeUnitAuraGameTooltip;

function BeeUnitAuraFindText(unit,BuffName,index,FindText,Type) --搜索目标的Buff中的信息。
	
	if unit and BuffName and index and FindText then
		local text = BeeUnitAuraText(unit,BuffName,index,Type);
		return text and BeeStringFind(text,FindText,-1) and true;
	end
	
	return false;	
end

function BeeUnitAuraText(unit,BuffName,index,Type)	
	
	if not index then
		index = 2;
	end
	
	if (not Type)  or (Type and Type == "buff") then
		for i=1, MAX_TARGET_BUFFS do
		  local name = UnitBuff(unit, i)
		  if (not name) then break end
		  if  (name == BuffName) then
			BeeUnitAuraGameTooltip = CreateFrame("GameTooltip", "BeeUnitAuraNumberGameTooltipFrame" .. "Tooltip", nil, "GameTooltipTemplate")
			BeeUnitAuraGameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
			BeeUnitAuraGameTooltip:ClearLines()  
			BeeUnitAuraGameTooltip:SetUnitBuff(unit, i) 
			
			local text = _G[BeeUnitAuraGameTooltip:GetName() .. "TextLeft" .. index]:GetText();
			return text or "";
		  end
		end
	end
	
	if (not Type)  or (Type and Type == "debuff") then
	
		for i=1, MAX_TARGET_BUFFS do
		
		  local name = UnitDebuff(unit, i)
		  if (not name) then break end
		  
		  if (name == BuffName) then
			BeeUnitAuraGameTooltip = CreateFrame("GameTooltip", "BeeUnitAuraNumberGameTooltipFrame" .. "Tooltip", nil, "GameTooltipTemplate")
			BeeUnitAuraGameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

			BeeUnitAuraGameTooltip:ClearLines()  
			BeeUnitAuraGameTooltip:SetUnitDebuff(unit, i) 
			
			local text = _G[BeeUnitAuraGameTooltip:GetName() .. "TextLeft" .. index]:GetText();
			return text or "";
		  end
		end
	end
   return "";
end
	
function BeeUnitAuraNumber(unit,BuffName,index,FormatText,Type)	
	if not index then
		index = 2;
	end
	
	local text = BeeUnitAuraText(unit,BuffName,index,Type);
	
	local v={};
	local i = 1;
	if text then
		if not FormatText or FormatText == "" then
			FormatText = "%d+";	
		end
		for k, val in string.gmatch(text, FormatText) do
			v[i]=tonumber(k);	
			i=i+1;
		end	
	end
	
   return v[1] or -1,v[2] or -1,v[3] or -1,v[4] or -1,v[5] or -1,v[6] or -1,v[7] or -1,v[8] or -1;
end


InternalCDTbl={};
function BeeInternalCD(name)
	if InternalCDTbl[name] then
		if InternalCDTbl[name]["time"] then
			local Cycle = InternalCDTbl[name]["Cycle"];
			local cd = Cycle - (GetTime() - InternalCDTbl[name]["time"]);
			
			if cd<=0 then
				cd =0;
			end
			
			return cd;
		else
			return 0;
		end
	end
	return 0;
end



-----------------------------------------------------------------HUGO------------------------------------------------------------------------------
function BeeUnitCastSpellDelay_old(Spell,Time,Unit) --设定读条技能施放后延时时间. 
	
	--print(Spell,Time,Unit)
	
	if Spell and Time and Unit then
		if not  UnitGUID(Unit) or type(Time) ~= "number" then
			return false;
		end
	
		local guid = UnitGUID(Unit);
		
		if not WowBee.Spell.Delay[Spell] then
			WowBee.Spell.Delay[Spell]={};
		end
		
		if not WowBee.Spell.Delay[Spell][guid] then
			WowBee.Spell.Delay[Spell][guid]={};
		end

		local tbl = WowBee.Spell.Delay[Spell][guid];
		tbl["DelayTime"]=Time;
		return true;
	elseif Spell and Time and not Unit then
		if type(Time) ~= "number" then
			return false;
		end
		
		if not WowBee.Spell.Delay[Spell] then
			WowBee.Spell.Delay[Spell]={};
		end
			
		local tbl = WowBee.Spell.Delay[Spell];
		tbl["DelayTime"]=Time;
		return true;
	else	
		return false;
	end
end

function BeeUnitCastSpellDelay(spell,times,unit) --设定读条技能施放后延时时间. 
	unit=BeeUnit(unit,"target");
	if (unit=="all") then --all为全部目标
		unit=nil;
	end
	if (not spell or not times or type(times) ~= "number" )then
		return false;
	end

	local guid = "All";
	if(unit)then
		if(not UnitGUID(unit))then
			return false;
		end
		guid=UnitGUID(unit);
	end
		
	WowBee.Spell.Delay = WowBee.Spell.Delay or {};
	WowBee.Spell.Delay[spell] = WowBee.Spell.Delay[spell] or {};
	WowBee.Spell.Delay[spell][guid] = WowBee.Spell.Delay[spell][guid] or {};
	WowBee.Spell.Delay[spell][guid]["DelayTime"]=times;
	return true;
end


---------------------------------------------HUGO----------------------------------------------------------
local SPELL_ACTIVATION_OVERLAY_GLOW={};
	SPELL_ACTIVATION_OVERLAY_GLOW.SpellName={};
	SPELL_ACTIVATION_OVERLAY_GLOW.SpellId={};
function BeeSpellActive(value) --判断自己的技能是否被点亮 BeeSpellActive(7384) 可以使用法术ID，也可 BeeSpellActive("压制")
	if not value then
		return nil;
	end
	
	if type(value) == "string" then
		
		local spell,rank = GetSpellInfo(value);
		if spell then
			return SPELL_ACTIVATION_OVERLAY_GLOW.SpellName[spell][rank];
		else
			return nil;
		end
		
	elseif type(value) == "number" then
	
		return SPELL_ACTIVATION_OVERLAY_GLOW.SpellId[value];
	
	else
		
		return nil;
		
	end
	
end

function SPELL_ACTIVATION_OVERLAY_GLOW.OnEvent(self, event, ...)
	
	local arg1,arg2 = select(1, ...);
		
	if ( event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" )  then
		
		local spell,rank = GetSpellInfo(arg1);
		if spell then
			rank = rank or "";
			if not SPELL_ACTIVATION_OVERLAY_GLOW.SpellName[spell] then
				SPELL_ACTIVATION_OVERLAY_GLOW.SpellName[spell]={};
			end
			
			SPELL_ACTIVATION_OVERLAY_GLOW.SpellName[spell][rank] = true;
			SPELL_ACTIVATION_OVERLAY_GLOW.SpellId[arg1] = true;
			--print(1,arg1);
		end
		
	elseif ( event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" )  then
		
		local spell,rank = GetSpellInfo(arg1);
		if spell then
			rank = rank or "";
			if not SPELL_ACTIVATION_OVERLAY_GLOW.SpellName[spell] then
				SPELL_ACTIVATION_OVERLAY_GLOW.SpellName[spell]={};
			end
			
			SPELL_ACTIVATION_OVERLAY_GLOW.SpellName[spell][rank] = false;
			SPELL_ACTIVATION_OVERLAY_GLOW.SpellId[arg1] = false;
			--print(1,arg1);
		end
		
	end
	
end


SPELL_ACTIVATION_OVERLAY_GLOW.Frame = CreateFrame("Frame");
SPELL_ACTIVATION_OVERLAY_GLOW.Frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
SPELL_ACTIVATION_OVERLAY_GLOW.Frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
SPELL_ACTIVATION_OVERLAY_GLOW.Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
SPELL_ACTIVATION_OVERLAY_GLOW.Frame:SetScript("OnEvent", SPELL_ACTIVATION_OVERLAY_GLOW.OnEvent);

-----------------------------------------------HUGO--------------------------------------------------


function BeeSIlink(Name)

	local itemName, itemLink= GetItemInfo(Name)
	
	--print(11,itemName)
	
	if itemName then
	
		return itemLink;
	end
	
	local itemName= GetSpellLink(Name)
	
	--print(22,itemName)
	
	if itemName then
	
		return itemName;
	end

	return Name;

end

function BeeToLink(String)
	
	String=string.gsub(String,"%[","' .. BeeSIlink('")
	String=string.gsub(String,"%]","') .. '")
	
	String = "'" .. String .. "'";
	--print(0,String)
	if strfind(String,"'' .. ") ==1 then
	--print(1,String)
		String=string.gsub(String,"'' .. ","",1)
	--	print(2,String)
	end
	
	--print(3,String)
	String=string.reverse(String)
	
	if strfind(String,"'' .. ") ==1 then
	--print(4,String)
		String=string.gsub(String,"'' .. ","",1)
		
	end
	
	String=string.reverse(String)
	
	--print(5,String)
	
	--print(BeeSIlink(String))
	
	String ="return " .. String
	
	local a =loadstring(String)
	
	local b,c=a();
	
	if b then
		return b;
	else
		print("脚本错误",c)
	end
	
		
end





----------------------------------

function BeeGetUnitName(unit)
	
	local temp = GetUnitName(unit,true);
	
	if temp then
		temp =gsub(temp," ","");
	end
	
	
	return temp;
	
end


-------------新增函数 by ATM 2013-7-13--------------------
--转换技能
function convert(spell)
	local spell = GetSpellInfo(spell)
	return spell
end
--施法 等同BeeRun
function Cast(spell, unit)
	local spell = convert(spell)
	if IsUsableSpell(spell)
			and GetSpellCooldown(spell) == 0 then
		--SIN_CastTarget = unit 
				CastSpellByName(spell, unit)
	end
end
--停止施法
function StopCast(spell)
	local spell = convert(spell)
	if UnitCastingInfo("player") == spell
			or UnitChannelInfo("player") == spell then
		SpellStopCasting()
	end
end
--能否施法 等同 BeeIsRun
function CanCast(spell, unit)
	local spell = convert(spell)
	local target = unit or "target"
	if UnitCanAttack("player", target)
			and PQR_UnitFacing("player", target)
			and IsSpellInRange(spell) == 1 then
		return true
	end
end
--BUFF层数
function UnitBuffCount(unit, spell, filter)
	local spell = convert(spell)
	local buff = { UnitBuff(unit, spell, nil, filter) }
	if buff[1] then
		return buff[4]
	else
		return 0
	end
end
--DEBUFF层数
function UnitDebuffCount(unit, spell, filter)
	local spell = convert(spell)
	local debuff = { UnitDebuff(unit, spell, nil, filter) }
	if debuff[1] then
		return debuff[4]
	else
		return 0
	end
end
--BUFF剩余时间
function UnitBuffTime(unit, spell, filter)
	local spell = convert(spell)
	local buff = { UnitBuff(unit, spell, nil, filter) }
	if buff[1] then
		return buff[7] - GetTime()
	else
		return 0
	end
end
--DEBUFF剩余时间
function UnitDebuffTime(unit, spell, filter)
	local spell = convert(spell)
	local debuff = { UnitDebuff(unit, spell, nil, filter) }
	if debuff[1] then
		return debuff[7] - GetTime()
	else
		return 0
	end
end
--血量半分比
function UnitHP(unit)
	return UnitHealth(unit) / UnitHealthMax(unit) * 100
			or 0
end
--能量或蓝百分比
function UnitMP(unit)
	return UnitPower(unit, 0) / UnitPowerMax(unit, 0) * 100
			or 0
end
--是否是T
function HasThreat(unit)
	local threat = UnitThreatSituation(unit)
	if UnitAffectingCombat("player")
			and threat then
		if threat >= 2 then
			return unit
		end
	else
		return nil
	end
end

--------------------------------
--- Time to Die 死亡时间计算
function ttd(unit)
	unit = unit or "target";
	if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			currtar = UnitGUID(unit)
		end
		if thpstart==0 and timestart==0 then
			thpstart = UnitHealth(unit)
			timestart = GetTime()
		else
			thpcurr = UnitHealth(unit)
			timecurr = GetTime()
			if thpcurr >= thpstart then
				thpstart = thpcurr
				timeToDie = 999
			else
				timeToDie = round2(thpcurr/((thpstart - thpcurr) / (timecurr - timestart)),2)
			end
		end
	elseif not UnitExists(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0 
		thpstart = 0
		timestart = 0
		timeToDie = 0
	end
	return timeToDie
end

-- Self Explainatory 雕文检测
--GlyphCheck = nil
function GlyphCheck(glyphid)
	for i=1, 6 do
		if select(4, GetGlyphSocketInfo(i)) == glyphid then
			return true
		end
	end
	return false
end

-----------------------------

function DelayCast(spellid, dtime) -- SpellID of Spell To Check, delay time
	if not CheckCastTime then  CheckCastTime = {} end
	local mtime = dtime + 5 --max expire time
	local spellexist = false
	if dtime > 0 then
		if #CheckCastTime >0 then
			for i=1, #CheckCastTime do
				if CheckCastTime[i].SpellID == spellid then
					spellexist = true
					if ((GetTime() - CheckCastTime[i].CastTime) > mtime) then
						
						CheckCastTime[i].CastTime = GetTime()
						return false
					elseif ((GetTime() - CheckCastTime[i].CastTime) > dtime) then
						
						CheckCastTime[i].CastTime = GetTime()
						return true
					else
						
						return false
					end
				end
			end
			if not spellexist then
				table.insert(CheckCastTime, { SpellID = spellid, CastTime = GetTime() } )	
				return false	
			end
		else
			
			table.insert(CheckCastTime, { SpellID = spellid, CastTime = GetTime() } )	
			return false	
		end
	else
		return true
	end
end
-----------------------
function LineOfSight(target)
if not tLOS then tLOS={} end
if not fLOS then fLOS=CreateFrame("Frame") end
    local updateRate=3
    fLOS:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    function fLOSOnEvent(self,event,...)
        if event=="COMBAT_LOG_EVENT_UNFILTERED" then
            local _, subEvent, _, sourceGUID, _, _, _, _, _, _, _, _, _, _, spellFailed  = ...                
            if subEvent ~= nil then
                if subEvent=="SPELL_CAST_FAILED" then
                    local player=UnitGUID("player") or ""
                    if sourceGUID ~= nil then
                        if sourceGUID==player then 
                            if spellFailed ~= nil then
                                if spellFailed==SPELL_FAILED_LINE_OF_SIGHT 
                                or spellFailed==SPELL_FAILED_NOT_INFRONT 
                                or spellFailed==SPELL_FAILED_OUT_OF_RANGE 
                                or spellFailed==SPELL_FAILED_UNIT_NOT_INFRONT 
                                or spellFailed==SPELL_FAILED_UNIT_NOT_BEHIND 
                                or spellFailed==SPELL_FAILED_NOT_BEHIND 
                                or spellFailed==SPELL_FAILED_MOVING 
                                or spellFailed==SPELL_FAILED_IMMUNE 
                                or spellFailed==SPELL_FAILED_FLEEING 
                                or spellFailed==SPELL_FAILED_BAD_TARGETS 
                                --or spellFailed==SPELL_FAILED_NO_MOUNTS_ALLOWED 
                                or spellFailed==SPELL_FAILED_STUNNED 
                                or spellFailed==SPELL_FAILED_SILENCED 
                                or spellFailed==SPELL_FAILED_NOT_IN_CONTROL 
                                or spellFailed==SPELL_FAILED_VISION_OBSCURED
                                or spellFailed==SPELL_FAILED_DAMAGE_IMMUNE
                                or spellFailed==SPELL_FAILED_CHARMED                                
                                then                        
                                    tLOS={}
                                    tinsert(tLOS,{unit=target,time=GetTime()})            
                                end
                            end
                        end
                    end
                end
            end
            
            if #tLOS > 0 then                
                table.sort(tLOS,function(x,y) return x.time>y.time end)
                if (GetTime()>(tLOS[1].time+updateRate)) then
                    tLOS={}
                end
            end
        end
    end
    fLOS:SetScript("OnEvent",fLOSOnEvent)
    if #tLOS > 0 then
        if tLOS[1].unit==target 
        then
            
            return true
        end
    end
end

local SPELLTYPE={};
SPELLTYPE[1]="技能";
SPELLTYPE[2]="物品";
SPELLTYPE[3]="装备";
SPELLTYPE[4]="宏名";
SPELLTYPE[5]="宏";
SPELLTYPE[-1]="";
function SpellIsRun(spellName,target)---------对在攻击范围的目标释放法术，
	if IsUsableSpell(spellName) and IsSpellInRange(spellName,target)==1 then
		if GetSpellCooldown(spellName) == 0 then
			return true
		end
	end
return false
end

 
function amisr(Spell,Unit,GCD,Special,IsAmRun,NOCD)--是否可以对此目标施放技能
	local A,B,C,D,E,F,G,H,I;
	
	if not Spell then
		return;
	end
	
	if not Unit  then
			Unit = "target";
	end
	
	local T_amsft,T_amsft1 = amsft(Spell,Unit)
	if not T_amsft then
	
		A=T_amsft;
		
		if wowam.spell.Property[Spell] then
			B=wowam.spell.Property[Spell]["type"];
		else
			B=""
		end
		
		C=T_amsft1;
		D=0;
		E="";
		F="";
		G="";
		H="";
	
	else
		A,B,C,D,E,F,G,H,I=isrunspell(Spell,Unit,GCD,Special,NOCD);
	end
	
	
	
	
	
	--if "是记忆判断" == C then
	--	print(A,B,C,D,E,F,Spell,Unit,I)
	--end
	if  wowam_config.Amisr["显示调试信息"] and not IsAmRun then
		
		local new_version;
		if wowam_config.new_version then
			new_version=wowam.Colors.MAGENTA .."旧版本信息|r"
		else
			new_version=wowam.Colors.GREEN .. "新版本信息|r"
		end
		
		local A1;
		
		if A then
			A1="通过" 
		else
			A1="拒绝"
		end	

		if not C then
			C="" 
		end	
		
		if not Spell then
			Spell="" 
		
		end	
		
		if not D then
			D="-1" 
		
		end	
		
		
		local A1=format(wowam_config.Formats["判断结果"],A1) .. ";";
		local A2=format(wowam_config.Formats["技能类型"],amiif(SPELLTYPE[B],SPELLTYPE[B],"")) .. ";";
		local A3=format(wowam_config.Formats["说明"],C) .. ";";
		local A4=format(wowam_config.Formats["施放目标"],Unit) .. ";";
		local A5=format(wowam_config.Formats["技能名称"],Spell) .. ";";
		local A6=format(wowam_config.Formats["冷却时间"],D);
		
		local index=1;
		local inf={};
	
		if wowam_config.Amisr["显示判断结果"] then
			inf[index]=A1;
			index=index+1;
		end
		
		if wowam_config.Amisr["显示技能类型"] then
			inf[index]=A2;
			index=index+1;
		end
		
		if wowam_config.Amisr["显示说明"] then
			inf[index]=A3;
			index=index+1;
		end
		
		if wowam_config.Amisr["显示施放目标"] then
			inf[index]=A4;
			index=index+1;
		end
		
		if wowam_config.Amisr["显示技能名称"] then
			inf[index]=A5;
			index=index+1;
		end
		
		if wowam_config.Amisr["显示冷却时间"] then
			inf[index]=A6;
			index=index+1;
		end
		
		
		if wowam_config.Amisr["显示成功的调试信息"] and A then
			if wowam_config.Amisr["过滤调试信息"] then
				local strtemp=A1..A2..A3..A4..A5..A6;
				
				if wowam_config.Formats["过滤调试信息"]~="" and amfind(strtemp,wowam_config.Formats["过滤调试信息"],-1) then
				
				
					print(wowam.Colors.RED .. date("%H:%M:%S"),new_version)
					
					for i,v in ipairs(inf) do
					
						print(i,wowam.Colors.GREEN..v)
									
						
					end
	
					--print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
				end
			
			else
			
				print(wowam.Colors.RED .. date("%H:%M:%S"),new_version)
					
					for i,v in ipairs(inf) do
					
						print(i,wowam.Colors.GREEN..v)
									
						
					end
			
			
				--print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
			--date("%a %b %d %H:%M:%S %Y")
			end
		end
		
		if wowam_config.Amisr["显示失败的调试信息"] and not A then
		
			if wowam_config.Amisr["过滤调试信息"] then
				local strtemp=A1..A2..A3..A4..A5..A6;
				
				if wowam_config.Formats["过滤调试信息"]~="" and amfind(strtemp,wowam_config.Formats["过滤调试信息"],-1) then
				
				
					print(wowam.Colors.RED .. date("%H:%M:%S"),new_version)
					
					for i,v in ipairs(inf) do
					
						print(i,wowam.Colors.GREEN..v)
									
						
					end
					
					--print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
				end
			
			else
			
				print(wowam.Colors.RED .. date("%H:%M:%S"),new_version)
					
					for i,v in ipairs(inf) do
					
						print(i,wowam.Colors.GREEN..v)
									
						
					end
					
				--print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
			end
		end
	end
	
	
	
	if A then
		isrunspell_Result(Spell,Unit,A)
	end
	
	return A,B,C,D,E,F,Spell,Unit,I
end

	
	
function amisr_bak(Spell,Unit,GCD,Special)--是否可以对此目标施放技能
	local A,B,C,D,E,F,G,H,I;
	
	if not Spell then
		return;
	end
	
	if not Unit  then
			Unit = "target";
	end
	
	local T_amsft,T_amsft1 = amsft(Spell,Unit)
	if not T_amsft then
	
		A=T_amsft;
		B=wowam.spell.Property[Spell]["type"];
		C=T_amsft1;
		D=0;
		E="";
		F="";
		G="";
		H="";
	
	else
		A,B,C,D,E,F,G,H,I=isrunspell(Spell,Unit,GCD,Special);
	end
	
	
	
	
	
	--if "是记忆判断" == C then
	--	print(A,B,C,D,E,F,Spell,Unit,I)
	--end
	if  wowam_config.Amisr["显示调试信息"] then
		local A1;
		
		if A then
			A1="通过" 
		else
			A1="拒绝"
		end	

		if not C then
			C="" 
		end	
		
		if not Spell then
			Spell="" 
		
		end	
		
		if not D then
			D="-1" 
		
		end	
		
		
		local A1=format(wowam_config.Formats["判断结果"],A1) .. ";";
		local A2=format(wowam_config.Formats["技能类型"],amiif(SPELLTYPE[B],SPELLTYPE[B],"")) .. ";";
		local A3=format(wowam_config.Formats["说明"],C) .. ";";
		local A4=format(wowam_config.Formats["施放目标"],Unit) .. ";";
		local A5=format(wowam_config.Formats["技能名称"],Spell) .. ";";
		local A6=format(wowam_config.Formats["冷却时间"],D);
		
	
	
		if not wowam_config.Amisr["显示判断结果"] then
			A1="";
		end
		
		if not wowam_config.Amisr["显示技能类型"] then
			A2="";
		end
		
		if not wowam_config.Amisr["显示说明"] then
			A3="";
		end
		
		if not wowam_config.Amisr["显示施放目标"] then
			A4="";
		end
		
		if not wowam_config.Amisr["显示技能名称"] then
			A5="";
		end
		
		if not wowam_config.Amisr["显示冷却时间"] then
			A6="";
		end
		
		
		if wowam_config.Amisr["显示成功的调试信息"] and A then
			if wowam_config.Amisr["过滤调试信息"] then
				local strtemp=A1..A2..A3..A4..A5..A6;
				
				if wowam_config.Formats["过滤调试信息"]~="" and amfind(strtemp,wowam_config.Formats["过滤调试信息"],-1) then
					print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
				end
			
			else
				print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
			--date("%a %b %d %H:%M:%S %Y")
			end
		end
		
		if wowam_config.Amisr["显示失败的调试信息"] and not A then
		
			if wowam_config.Amisr["过滤调试信息"] then
				local strtemp=A1..A2..A3..A4..A5..A6;
				
				if wowam_config.Formats["过滤调试信息"]~="" and amfind(strtemp,wowam_config.Formats["过滤调试信息"],-1) then
					print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
				end
			
			else
				print(date("%H:%M:%S"),wowam.Colors.RED .. A1..wowam.Colors.GREEN..A2..wowam.Colors.WHITE..A3..wowam.Colors.MAGENTA..A4..wowam.Colors.YELLOW..A5..wowam.Colors.CYAN ..A6)
			end
		end
	end
	
	
	
	if A then
		isrunspell_Result(Spell,Unit,A)
	end
	
	return A,B,C,D,E,F,Spell,Unit,I
end

function amgj() --攻击姿态
return wowam.player.Combat;
end

function amIsAttack() --攻击姿态
return wowam.player.Combat ==1;
end


function amuca(Unit) --是否可以攻击指定目标
	if Unit then
	return UnitCanAttack("player", Unit)
	else
	return UnitCanAttack("player", "target")
	end
end

function amut(ut)
	if ut~=nil then
		
		if not (Wowam_Ut(ut)) then
			return false;
		end	
		return 	true;	
	end
	
	
	
end


function amisspell(name,tunit,gcd,Special,isname,NOCD,typenumber,SpellLevel,temp_UnitGUID,unitguid) -----物品技能释放
	
	
	if wowam_config.SetGCD and not gcd then
		
		if amGCD()> wowam_config.SetGCD_Time then
			
			return false,typenumber,"公共CD没好",Cooldown;
		end
		
	end
	--print(1,wowam.spell.Property[name]["HasRange"])
	--print("t",wowam.spell.Property[name]["RaidSpell"])
	
	if wowam.spell.Property[name]["RaidSpell"]  and tunit ~= "nogoal" then
		if wowam.spell.Property[name]["RaidSpell"] ==3 then
			if not(UnitPlayerOrPetInParty(tunit) or UnitPlayerOrPetInRaid(tunit) or UnitGUID(tunit) == UnitGUID("player")) then
			return false,typenumber,"目标只能是小队或者团队";
			end
		
		
		elseif not (wowam.spell.Property[name]["RaidSpell"] ==2 and (UnitPlayerOrPetInParty(tunit) or UnitGUID(tunit) == UnitGUID("player"))) then
			return false,typenumber,"目标只能是小队";
		
		elseif not (wowam.spell.Property[name]["RaidSpell"] ==1 and  UnitGUID(tunit) == UnitGUID("player")) then
			return false,typenumber,"目标只能是自己";
		end
		
		
		
		
	end
	
	
	
	
	
	local T_temp1 = GetUnitSpeed("player")
	local T_temp2 = wowam.spell.Property[name]["castTime"] --select(7,GetSpellInfo(name))
		
	if T_temp2 >0 and T_temp1>0 then
		
		return false,typenumber,"你移动中",Cooldown;
	end
	
	if not unitfr then return true,typenumber,"";end
	
	if  wowam.spell.Property[name]["HasRange"] and tunit ~= "nogoal" then
		
		
		if not temp_UnitGUID and not wowam_config.new_version then
			
			return false,typenumber,"需要个目标(如有问题请尝试用“无目标”参数或联繫作者)";
		end
		
		
		local UnitCan_a,amIsSpellInRange,amSpellHasRange
		

		UnitCan_a = UnitCanAssist("player", tunit)  or  UnitCanAttack("player", tunit)
		amIsSpellInRange =IsSpellInRange(name,tunit)
		--print(name,tunit,amIsSpellInRange)
		--amSpellHasRange=wowam.spell.Property[name]["HasRange"]
		if wowam.spell.Property[name]["IsSpellInRange"] and not amIsSpellInRange then
			return false,typenumber,"目标死亡或者不能对其施放",Cooldown;
		end
		
		if amIsSpellInRange and not wowam.spell.Property[name]["IsSpellInRange"] then
		
			wowam.spell.Property[name]["IsSpellInRange"]=amIsSpellInRange;
			
		end

		if  not UnitCan_a then
			
			return false,typenumber,"技能距离太远",Cooldown;
		end

		if UnitCan_a then
		
			if amIsSpellInRange==0  then
				
				return false,typenumber,"超距离",Cooldown;
			elseif amIsSpellInRange==nil then
				
				if not wowam_config.new_version then
				return false,typenumber,"不能对此目标施法(请尝试用“无目标”参数或联繫作者)",Cooldown;
				end
			end
				
		end
	
	
	end
	
	
	
	
	
	local Cooldown = amSpellCooldown(name);
	local amact_timp =0;

	if wowam.spell.Property[name]["castTime"]<=0 then
		Cooldown=Cooldown-wowam_config.PromptSpellAttackTime;
	else
		amact_timp,_,acc =amact("player")
		
		
		
		--if acc == name and amact_timp > wowam_config.SpellAttackTime and not NOCD then
		if amact_timp ~= -1 and amact_timp > wowam_config.SpellAttackTime and not NOCD then
		
		return false,typenumber,"施放技能中",Cooldown;
		end
		
		Cooldown=Cooldown-wowam_config.SpellAttackTime;
	
	end
		

	
	if Cooldown >0 and not NOCD then
		
		return false,typenumber,"技能冷却中",Cooldown;
	end
	
	if IsCurrentSpell(name) and amact_timp<=0  and not NOCD then
		
		return false,typenumber,"正在或者准备施放技能中",Cooldown;
	end
	
	
	local usable, nomana = IsUsableSpell(name);
	
		
	
		if Special ==1 or amSpellIsPowerCost(name) then
			if amr("player") < wowam.spell.Property[name]["powerCost"]  then
				
			  return false,typenumber,"能量不足",Cooldown;
			
			end	
		else
		
			if not amSpellSpecial(name,tunit,gcd) then
			
				if not usable and not nomana then
				
				
				
						if not wowam_config.new_version then		
						
							return false,typenumber,"该技能目前无法判断,请参考amisr第四参数或联系开发者.",Cooldown;
						end
						
				
				
				
			
				elseif not usable and nomana then
				
					return false,typenumber,"可能能量不足",Cooldown;
				
				end
				
			end
		end
		
		
		
			
	
	
	

	
	
	return true,typenumber,"",Cooldown;
	
	
	

end


function amisItem(name,tunit,gcd,Special,isname,NOCD,typenumber,SpellLevel,temp_UnitGUID,unitguid)-------物品的释放对目标的释放
	
	
	if  wowam.spell.Property[name]["HasRange"] and tunit ~= "nogoal" then
		
		
		if not temp_UnitGUID  and not wowam_config.new_version then
			
			return false,typenumber,"需要个目标(如有问题请尝试用“无目标”参数或联繫作者)";
		end
	
	
	end
	
	local Cooldown = amItemCooldown(name);
	if Cooldown >0 then
		
		return false,typenumber,"物品冷却中",Cooldown;
	end
	
	
	local usable, nomana = IsUsableItem(name);
	if (not usable) then
		
		return false,typenumber,"物品不可用",Cooldown;
 
	end
	
	
	if tunit == "nogoal" or not wowam.spell.Property[name]["HasRange"] then
		return true,typenumber,"",Cooldown;
	end
	
	
 
	
	Isa =IsItemInRange(name,tunit)
	
	if  not (UnitCanAssist("player", tunit)  or  UnitCanAttack("player", tunit))  and tunit ~= "nogoal" then
				
		return false,typenumber,"物品距离太远",Cooldown;
	end
	
	if not Isa then
		return false,typenumber,"不能对此目标施法(请尝试用“无目标”参数或联繫作者)",Cooldown;
	end
	
	
	
	
	return true,typenumber,"",Cooldown;
		

end




function amr(Unit,p,q) --目标的法力、怒气、能量 值或百分比等。
	
	if Unit == nil or Unit == "p"  or Unit == 0 then
		Unit = "player"
	
	elseif Unit == 1 or Unit == "t" then
		Unit = "target"
	
	elseif Unit == 3 or Unit == "f" then
		Unit = "focus"
	
	elseif Unit == 4 or Unit == "pet" then
		Unit = "pet"
	
	end
	
	if not UnitName(Unit) then
		return -1;
	end
	
	
	local a,b,c;
	
	a = UnitMana(Unit);
	b = UnitManaMax(Unit);
	c= b-a;
	
	if q == nil or q == 0 then
	
		
		if p == "%" or p == 1 then
			return ((a / b) * 100);
		else
			return a;
		end
	else
		
		if p == "%" or p == 1 then
			return ((c / b) * 100);
		else
			return c;
		end
	
	end
	

end

function aml(Unit,p,q) --目标的生命值或百分比。
	
	if not Unit  then
		Unit = "player"
	end
	
	if  type(Unit) ~= "string" then
		return -1;
	end
		
	if not UnitName(Unit) then
		return -1;
	end
	
	
	local a,b,c;
	
	a = UnitHealth(Unit);
	b = UnitHealthMax(Unit);
	c= b-a;
	
	if q == nil or q == 0 then
	
		if p == "%" or p == 1 then
			return ((a / b) * 100);
		else
			return a;
		end
	else
		
		if p == "%" or p == 1 then
			return ((c / b) * 100);
		else
			return c;
		end
	
	end
	

end

function amruneid(rune) -- 获得指定符文ID，返回其id。return ID
	if "冰霜符文" == rune or "Frost Rune" == rune  then
		rune = 3 ;
		
	elseif "邪恶符文" == rune  or "Unholy Rune" == rune then
		rune = 2 ;
		
	elseif "鲜血符文" == rune or "Blood Rune" == rune  then
		rune = 1 ;
		
	elseif "死亡符文" == rune  or "Death Rune" == rune then
		rune = 4 ;
		
	else
		rune = -1;
		
	end
	return rune;
end

function amstrbyte(str) --字符转字节
	local n=strlen(str);
	local tbl={};
	for i=1, n do
			
			tbl[i]=strbyte(str,i)
				
	end
	
	return tbl;
end
	
function amrunecount(runeid) --获得指定符文数量。 return N

	local runeType,i,n;
	
	n=0;
	
	for i=1, 6 do
		runeType = GetRuneType(i);
		if runeType ==runeid then
		n = n+1;				
		end
			
	end
	return n;
end

function amen(rune) --返回某种符文可用数量,及冷却时间。return N,CD1,CD2
	local id,cd;
	local cd1=-1;
	local cd2=-1;
	
	if type(rune) == "number" or type(rune) == "string" then
		if type(rune) == "string" then
			id = amruneid(rune);
			if id == -1 then
				return -1,-1,-1;
			end
		else
			if rune>=1 and rune<=6 then
				id = rune;
			else
				return -1,-1,-1;
			end
			
		end
	else
	return -1,-1,-1;
	
	end
	
		
	local runeType,i,n;
	local start, duration, runeReady;
	
	n = 0;
	
	for i=1, 6 do
		runeType = GetRuneType(i);
		if runeType == id then
			start, duration, runeReady = GetRuneCooldown(i);
		
			cd = duration-(GetTime()-start);
			if cd <= 0 then
				cd = 0;
			end
			
			if cd <=0 then
				n = n +1;
			end
			if cd1 == -1 then
				cd1 = cd;
			else
				cd2 = cd;
			end
		end
		
	end
	
	return n,cd1,cd2;
	
end

function amecd(rune) --返回某种符文其中最快冷却时间。return N,CD1,CD2
	local n,cd1,cd2 = amen(rune);
	
	if n == 0 then
		return -1;
	end
	
	
	if  n == 1 and cd1 >= 0 then
		return cd1;
	elseif cd1 == 0 and cd2 == 0 then
		return 0;
	elseif (n == 2) and cd1 >0 and cd2 == 0 then
		return cd1;
	elseif (n == 2) and cd2 >0 and cd1 == 0 then
		return cd2;
	elseif (n == 2) and (cd1 <= cd2) and cd1 >0 and cd2>0  then
		return cd1;		
	elseif (n == 2) and (cd2 <= cd1) and cd1 >0 and cd2>0  then
		return cd2;	
	end
	
	return 0;
	
end

function amtotem(totem) --图腾CD
		if totem==nil then
			return -1;
		end
		
		if totem=="" then
			return -1;
		end
		
		for i = 1, 4 do
			local seconds
  		local haveTotem, name, startTime, duration, icon = GetTotemInfo(i)
  			if name and haveTotem then
		  		if haveTotem and string.len(name) > 0 then
		  				
		  				
		  				
		  				if  totem == name  then
		  					seconds=GetTotemTimeLeft(i)
		  					
		  					return seconds;
		  					
		  				end
		  			
				
				
					
		  		end
		  		
		  	end
  
  
		end
	return -1;
end


function amtotemtype(Type) -- 图腾类型
if type(Type) ~= "number" then
Wowam_Message(wowam.Colors.RED.."错误：" .. wowam.Colors.CYAN .. "参数类型错误，请使用整数值");
return nil,-1
end

	local haveTotem, name = GetTotemInfo(Type)
  			if name and haveTotem then
		  		if haveTotem and string.len(name) > 0 then
				return name,GetTotemTimeLeft(Type)
				end
			end
		
return nil,-1		
end

function amtmiss(missType) --你的攻击给当前目标【missType】了。过去时间秒数
	
	return ammiss(missType,"source","target")
end

function ampmiss(missType) --你【missType】了当前目标的攻击	。过去时间秒数
	return ammiss(missType,"dest","target")
end

function ammiss(missType,TargeType,Unit) --获得未造成伤害的原因的技能过去时间秒数


--[[
	-------------参数：missType-----------------------------------------
	missType（未造成伤害类型），表示未造成该伤害的原因。
	原因 	中文 
	"DODGE" 被躲闪 
	"ABSORB" 被吸收 
	"RESIST" 被抵抗 
	"PARRY" 被招架 
	"MISS" 未击中 
	"BLOCK" 被格挡 
	"REFLECT" 被反射 
	"DEFLECT" 偏斜 
	"IMMUNE" 免疫 
	"EVADE" 被闪避
	-----------参数：name---------------------
	"source"	你未造成伤害。 	如果 missType 是 【DODGE】 Name 是【target】的话，表示你的攻击给当前目标【躲闪】了
	"dest"		对你未造成伤害。如果 missType 是 【DODGE】 Name 是【target】的话，表示你【躲闪】了当前目标的攻击	
	
--]]
	local timetemp,GUID,destGUID,sourceGUID;
	GUID = UnitGUID(Unit)
	
	if GUID and missname and (TargeType == "source" or TargeType == "dest") then
		
		sourceGUID = wowam.spell.Event_SpellInfo.missType[TargeType .. "_" ..GUID.. missType]["sourceGUID"]
		destGUID = wowam.spell.Event_SpellInfo.missType[TargeType .. "_" .. GUID..missType]["destGUID"]
		timetemp = wowam.spell.Event_SpellInfo.missType[TargeType .. "_" .. GUID..missType]["STARTTIME"]
		
		if timetemp and (sourceGUID == GUID or destGUID == GUID )then
			
			return GetTime() - timetemp;
		end
	end
	
	return -1;
end

function amjl_old1(Unit)-- 判断距离
	if not Unit then
		Unit = "target";
	end
	if not UnitName(Unit) then
		return 99999;
	end
	

	
	
local _,jl = wowam_rc:getRange(Unit)

	if not jl  then
		return 99999;
	end
	
	return jl;
	
end

function amjl_old(Target)-- 判断距离
	--local c = TargetRangeWatchFrameStatusBar1String1:GetText()
	local c=nil;
	local j=0;
	local rdf=nil;
	local rdt=nil;


	rdt = RangeDisplayFrameText_playertarget
	rdf = RangeDisplayFrameText_focus
	
	if rdt == nil or rdf == nil then
	
		return -2;
	end

	--if not RangeDisplayFrameText_playertarget:IsVisible()  then
	
	--	return -3;
	--end
	
	if not Target then
		Target = "target";
	end

	if Target == "focus" and RangeDisplayFrameText_focus then
	c = RangeDisplayFrameText_focus:GetText()

	elseif Target == "target" and RangeDisplayFrameText_playertarget then
	c = RangeDisplayFrameText_playertarget:GetText()
	
	elseif Target == "pet" and RangeDisplayFrameText_pet then
	c = RangeDisplayFrameText_pet:GetText()
	else
	return -1;
	
	end
	
	--DEFAULT_CHAT_FRAME:AddMessage("A2--" .. tostring(c),192,0,192,0)
	
	if c == nil then
		return -1;
	end
	
	_, _, j = strfind(c, " - (%d+)");
	if j==nil then
		_, _, j = strfind(c, "(%d+)");
	end
	
		
	return tonumber(j);

end

function amfind(String,Tbl,Type) --Tbl 在 String 中搜索指定的内容

	if (not String) or (not Tbl) then
		return nil;
	end
	
	if type(Tbl) == "string" then
	
		Tbl = { strsplit(",",Tbl) }

	elseif type(Tbl) == "table" then
	
	else
		return nil;
	end
	
	
	if type(String) == "string" then
	
		String = { strsplit(",",String) }

	elseif type(String) == "table" then
	
	else
		return nil;
	end
	
	if Type == nil then
	
		Type=0
	end
	
	
	local n;
	
	local Tbl_index=1;
	local String_index=1;
	
	for i,v in ipairs(Tbl) do
		String_index=1;
		for k,va in ipairs(String) do
		
			n = strfind(va,v,1,true);
			if not n then
				n = strfind(strlower(va),strlower(v),1,true);
			end
			
			
				if n then
					if Type == -1 then
						return n,v,va,Tbl_index,String_index;
						
					elseif Type == 0  then
						if va == v then
							return n,v,va,Tbl_index,String_index;
						end
						
					elseif Type == n then
						return n,v,va,Tbl_index,String_index;
					end
				end
			String_index=String_index+1;
		end
		
		Tbl_index=Tbl_index+1;
	end
	
	return nil;
end

function amac(Unit,Interrupt,Time) --获得指定目标正在施放的法术名称,Interrupt 为非0 只返回可以打断的技能
	local c,i;
		if Unit == nil then
			Unit = "target";
		end
		
		
		c,_,_,_,startTime,_,_,_,i = UnitCastingInfo(Unit);
		
		
		if c then
		--print(GetTime() - startTime/1000,wowam_config.amac_time)
			if wowam_config.amac_arena and wowam.sys.isarena then
				if not Time then
					Time = wowam_config.amac_time;
				end
						
					if GetTime() - (startTime/1000) > Time then
			
						if not Interrupt then
							return c;
						else
							if not i then
								return c;
							end
						end
					end
						
			else
				
				if not Interrupt then
					return c;
				else
					if not i then
						return c;
					end
				end
				
				
			end
			
			
			
		else
			c,_,_,_,startTime,_,_,i = UnitChannelInfo(Unit);
			
			if c then
				--print(GetTime() - startTime/1000,wowam_config.amac_time)
				if wowam_config.amac_arena and wowam.sys.isarena then
				
					if not Time then
						Time = wowam_config.amac_time;
					end
					
					if GetTime() - (startTime/1000) > Time then
			
						if not Interrupt then
							return c;
						else
							if not i then
								return c;
							end
						end
					end
						
				else
					
					if not Interrupt then
						return c;
					else
						if not i then
							return c;
						end
					end
					
					
				end
			end
		end
		
	return false;

	
	
end	

function amact(Unit) --获得指定目标正在施放的法术剩馀时间

	if Unit==nil then
		 Unit = "target";
	end
	
	
	
	if not UnitName(Unit) then
		return -1,-1,"";
	end
	
	local spell, _, _, _, startTime, endTime = UnitCastingInfo(Unit)
	
	
	if spell then 
	 local finish = endTime/1000 - GetTime()
		return tonumber(format("%.2f",finish) ),tonumber(format("%.2f",(endTime -startTime) /1000)),spell
	end
	
	local spellch, _, _, _, startTime, endTimech = UnitChannelInfo(Unit)
	if spellch then 
	 local finishch = endTimech/1000 - GetTime()
		return tonumber(format("%.2f",finishch) ),tonumber(format("%.2f",(endTimech -startTime) /1000)),spellch
	end
	
	
	
	return -1,-1,"";
	
end
--[[
local function ambufflist_Event(self,event,...)

	if ( event == "COMBAT_LOG_EVENT_UNFILTERED" ) and wowam.sys.isarena then
	
	--if ( event == "COMBAT_LOG_EVENT_UNFILTERED" )  then
	
		
		local _, _, prefix, suffix = string.find(arg2, "(.-)_(.+)");
		
		if not wowam.sys.bufftime then
			wowam.sys.bufftime={};
		end
		
		if "AURA_APPLIED" == suffix then
			
			wowam.sys.bufftime[arg3 .. "_" .. arg10]=GetTime();
			--print("附加>>",arg4,arg10)
		
		elseif "AURA_REMOVED" == suffix then
			wowam.sys.bufftime[arg3 .. "_" .. arg10]=nil;
			--print("移除>>",arg4,arg10)
		end
	
	end
end

local function ambufflist_OnUpdate()
	
	if not wowam.sys.isarena_time then
		wowam.sys.isarena_time = GetTime();
	end
	
	if  GetTime() - wowam.sys.isarena_time > 1 then
	
		wowam.sys.isarena = amisarena();
		wowam.sys.isarena_time=GetTime();
		if not wowam.sys.isarena then
			wowam.sys.bufftime=nil;
		end
		--print(wowam.sys.isarena_time)
	end
		
end

local ambufflist_Frame = CreateFrame("Frame");
ambufflist_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
ambufflist_Frame:SetScript("OnEvent",ambufflist_Event);
ambufflist_Frame:SetScript("OnUpdate",ambufflist_OnUpdate)

--]]
		
function ambufflist(Unit,t) --获得指定目标buff列表
	local name = {};
	local i,k;
	
	if not t then
		t=0;
	end
	
	if wowam_config.ambufflist_arena and amisarena() and wowam_config.ambufflist_time and wowam_config.ambufflist_time>0 and t==0 then
	 
		t=wowam_config.ambufflist_time;
	end
	
	
	k = 1;
	
	if Unit == nil then
		Unit="player";
	end
	
	
	
	for i=1,MAX_TARGET_BUFFS do
	
		local c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  =  UnitBuff(Unit, i)
		
		
	
		if c then
		--print(duration, expirationTime)
		--print(c,duration - (expirationTime - GetTime()) ,t)
			if wowam_config.ambufflist_arena  and t>0 and duration > 0 then
				
				--print(c,duration - (expirationTime - GetTime()) ,t)
				if duration - (expirationTime - GetTime()) > t then
					name[k] = c ;
					k = k + 1;
				
				end
				
				
			else
				name[k] = c ;
				k = k + 1;
			end
		else
			break;
		end
		
		
	end
	
	for i=1,MAX_TARGET_BUFFS do
	
		local c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  =  UnitDebuff(Unit, i)
		
		
	
		if c then
		--print(duration, expirationTime)
		--print(c,duration - (expirationTime - GetTime()) ,t)
			if wowam_config.ambufflist_arena  and t>0 and duration > 0 then
				
				--print(c,duration - (expirationTime - GetTime()) ,t)
				if duration - (expirationTime - GetTime()) > t then
					name[k] = c ;
					k = k + 1;
				
				end
				
				
			else
				name[k] = c ;
				k = k + 1;
			end
		else
			break;
		end
		
		
	end
	
	return name;
	
	
	
end

function TargetDebuffTime(Spell)
	local name, _, _, _, _, duration, expirationTime = UnitDebuff('target', Spell)
	if name then
		return expirationTime - GetTime()
	else
		return 0
	end
end

function amaura(Spell,Unit,Nameid,BuffType,iconName) --获得指定目标buff剩馀时间

	if Nameid == nil then
		Nameid=0;
	end
	
	if BuffType == nil then
		BuffType=0;
	end
	
	if Unit == nil then
		Unit="player";
	end

	if Spell == nil  then
		return -4;
	end
	
	if type(Spell) ~= "string" or type(Unit) ~= "string" or type(Nameid) ~= "number" then
		return -2;
	end
	
	if not UnitName(Unit) then
		return -3;
	end
	
	
local n;
local	name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable ;
	
	--local	name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(Unit, Spell,"HARMFUL") 
	if BuffType == 0 then
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(Unit, Spell)
		if not name then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff(Unit, Spell)
		end
		
	elseif BuffType == 1 then
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(Unit, Spell)
	elseif BuffType == 2 then
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff(Unit, Spell)
	end
	

	--DEFAULT_CHAT_FRAME:AddMessage(tostring(name),192,0,192,0)
	if iconName and icon then
		local ls_icon = { strsplit("\\",icon) }
		if ls_icon[3] ~= iconName then
			return -1

		end
	
	end
	
	
	if name then
		n = expirationTime - GetTime()
		if n < 0 then
			n= 0
		end
		n = format("%.1f",n);
		n=tonumber(n);
		
		--DEFAULT_CHAT_FRAME:AddMessage(tostring(unitCaster),192,0,192,0)
		
		if Nameid == 0 and unitCaster == "player" then
			return  n,rank,count,debuffType,icon,unitCaster,duration,expirationTime,isStealable;
		elseif Nameid == 1 and unitCaster ~= "player" then
			return  n,rank,count,debuffType,icon,unitCaster,duration,expirationTime,isStealable;
		elseif Nameid == 2 then
			return  n,rank,count,debuffType,icon,unitCaster,duration,expirationTime,isStealable;
		end
		
		
	end
	
	return -1;
end


function amtb(Spell,iconName) --获得当前目标buff剩馀时间
		
	local	n,rank,count,debuffType,icon = amaura(Spell,"target",2,1);
	if iconName and icon then
		local ls_icon = { strsplit("\\",icon) }
		if ls_icon[3] == iconName then
			return n
		else
			return -1

		end
	else
		return n;
	end
end

function ampb(Spell,iconName) --获得自己身上buff剩馀时间
		
	local	n,rank,count,debuffType,icon = amaura(Spell,"player",2,1);
	
	
	if iconName and icon then
		local ls_icon = { strsplit("\\",icon) }
		if ls_icon[3] == iconName then
			return n
		else
			return -1

		end
	else
		return n;
	end
	
end


function amtdb(Spell,iconName) --获得当前目标属于自己的Dbuff剩馀时间
		
	local	n,rank,count,debuffType,icon = amaura(Spell,"target",0,2);
	if iconName and icon then
		local ls_icon = { strsplit("\\",icon) }
		if ls_icon[3] == iconName then
			return n
		else
			return -1

		end
	else
		return n;
	end
end

function ampdb(Spell,iconName) --获得自己身上Dbuff剩馀时间
		
	local	n,rank,count,debuffType,icon = amaura(Spell,"player",2,2);
	if iconName and icon then
		local ls_icon = { strsplit("\\",icon) }
		if ls_icon[3] == iconName then
			return n
		else
			return -1

		end
	else
		return n;
	end
end

function ambn(Spell,Unit,Nameid,BuffType) --获得指定目标buff层数

	if Unit == nil then
			Unit = "target";
	end
	
	local	n,rank,count,debuffType = amaura(Spell,Unit,Nameid,BuffType);
	
	if not count then
		return -1
	end
	
	return count;
end

function amtdbn(Spell) --获得当前目标自己的Dbuff层数
		
	local	n,rank,count,debuffType = amaura(Spell,"target",0,2);
	if count then
	return count;
	end
	return -1;
end

function ampdbn(Spell) --获得自己身上Dbuff层数
		
	local	n,rank,count,debuffType = amaura(Spell,"player",2,0);
	
	if not count then
		return -1
	end
	
	return count;
end


function amtbn(Spell) --获得当前目标buff层数
		
	local	n,rank,count,debuffType = amaura(Spell,"target",2,1);
	if not count then
		return -1
	end
	return count;
end

function amBuffCount(Spell,unit) --获得当前目标buff层数
		
	local	n,rank,count,debuffType = amaura(Spell,unit,2,1);
	if not count then
		return -1
	end
	return count;
end


function ampbn(Spell) --获得自己身上buff层数
		
	local	n,rank,count,debuffType = amaura(Spell,"player",2,1);
	
	if not count then
		return -1
	end
	
	return count;
end



function amcf(id) --目标的目标是否自己
	if id==0 then
		if not UnitIsUnit("player","targettarget") and UnitCanAttack("player","target") then 
				return true
		else
				return false

		end;

	elseif id==1 then

				if UnitIsUnit("targettarget", "player") and UnitCanAttack("player","target") then

						return true
				else
						return false

				end;

	elseif id==2 then
		
			if not UnitIsUnit("player","targettarget") and UnitCanAttack("player","target") and UnitName("targettarget") then 
							return true
					else
							return false

					end;

			return false

		end

end

function amzt(index) ---'获得指定姿态状态
	if index <= 0 then
		return false
	end
	local _,_,a = GetShapeshiftFormInfo(index);

	return a;
end

function amzd(Unit) --判断指定单位是否在战斗状态,没参数默认自己
	if Unit then
		return UnitAffectingCombat(Unit);
	else
		return UnitAffectingCombat("player");
	end
end

function amtrt(Unit) --返回指定单位的能量的类型，没参数默认当前目标。 返回：数字，字符串
	if Unit then
		return UnitPowerType(Unit)
	else
		return UnitPowerType("target")
	end
end


function amsv(VariableName,Value) --设定变量的值
 wowam.player.Custom.Variable[VariableName]=Value;
 return wowam.player.Custom.Variable[VariableName]
end

function amgv(VariableName) --读取变量的值
	if VariableName == nil  then 
	return nil; 
	end;
	
 return wowam.player.Custom.Variable[VariableName];
end

function amfttp() --返回焦点目标的目标是否自己
 return UnitName("focustarget") == UnitName("player")

end

function amttp() --返回目标的目标是否自己
 return UnitName("targettarget") == UnitName("player")
end

function amctp(Unit) --返回指定目标的目标是否自己
	if Unit == nil then
		Unit = "targettarget";
	end
	
 return UnitName(Unit .. "-target") == UnitName("player")
end

function amun(Unit) --获得指定目标名称. 
	if Unit==nil then
		return UnitName("target")
	else
		return UnitName(Unit)
	end

end

function amtnm(Unit) --指定目标目不是我. 
	if Unit==nil then
		return nil
	end
	
		return UnitName("player") ~= UnitName(Unit)
	
end

function amlive(Unit) --指定目标是否活着，是为真
	if Unit==nil then
		return nil
	end
	
	return not UnitIsDeadOrGhost(unit)
end

function amezy(Unit) --获得指定目标英文职业名称
	if Unit == nil then
		Unit = "target"
	end
	local playerClass, englishClass = UnitClass(Unit);
	return englishClass
end


function amzy(Unit) --获得指定目标本地职业名称
	if Unit == nil then
		Unit = "target"
	end
	local playerClass, englishClass = UnitClassBase(Unit);
	
	return playerClass;
	
end

function amuipm_old(Unit) --判断一个指定的目标（只能是NPC）是否属于精英，没参数默认当前目标。
	if Unit == nil then
		Unit = "target"
	end
	return UnitIsPlusMob(Unit);
	
end

function amuipm(Unit,n) --判断一个指定的目标（只能是NPC）是否属于精英，没参数默认当前目标。
	--"normal" - 普通 
	--"rare" - 稀有 
	--"elite" - 精英 
	--"rareelite" - 稀有精英 
	--"worldboss" - 首领 

	if Unit == nil then
		Unit = "target"
	end
	
	
	
	local c = UnitClassification(Unit);
	
	if not c then return end
	
	if not n then n=6 end
	
	if n == 6 then
		if c=="elite" or c =="rareelite" or c =="worldboss" then
			return c;
		else
			return;
		end
	
	elseif n == 1 then
		if c=="normal"  then
			return c;
		else
			return;
		end
		
	elseif n == 2 then
		if c=="rare"  then
			return c;
		else
			return;
		end
		
	elseif n == 3 then
		if c=="elite"  then
			return c;
		else
			return;
		end
		
	elseif n == 4 then
		if c=="rareelite"  then
			return c;
		else
			return;
		end
		
	elseif n == 5 then
		if c=="worldboss"  then
			return c;
		else
			return;
		end
		
	elseif n == -1 then
		
		return c;
		
		
	end	
end


function amur(Unit) --获得指定的目标的种族，没参数默认当前目标。
	if Unit == nil then
		Unit = "target"
	end
	return UnitRace(Unit)
	
end

function amupc(Unit) --判断指定目标是否是一名由玩家控制的角色，没参数默认当前目标。
	if Unit == nil then
		Unit = "target"
	end
	return UnitPlayerControlled(Unit)
	
end

function amljd() --获取当前连击点
	return GetComboPoints("player")
end


function amcasttime(Spell) --获得指定技能施放时间. 
	local t = wowam.spell.Event_SpellInfo.name[Spell]
	if t then
		return GetTime() -t ;
	end
	
	return -1 ;
end



function amdelay_OLD(Spell,Time) --设定读条技能施放后延时时间. 
wowam.spell.Dot.time[Spell]=Time;
return Time;
end


function amdelay(Spell,Time,Unit) --设定读条技能施放后延时时间. 
	local SPELL_UNIT;
	if not Unit  then
		--return amdelay_OLD(Spell,Time);
		--wowam.sys.SPELL_FAILED.SPELL_NOUNIT=Spell;
		SPELL_UNIT=Spell;
	else
		--wowam.sys.SPELL_FAILED.SPELL_NOUNIT=nil;
		SPELL_UNIT=UnitGUID(Unit);
	end
	
	if not SPELL_UNIT then
		return false;
	end
		
			
	if wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT] then
					
			if not wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT][Spell] then
				wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT][Spell]={};
			end
			
	else
		wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT]={};
		wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT][Spell]={};
		
	end
	
		wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT][Spell]["FAILED_TEXT"]="延时施放技能";
		wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT][Spell]["TIME"]=GetTime();
		wowam.sys.SPELL_FAILED.SPELLINF[SPELL_UNIT][Spell]["SPELL_DELAY"]=Time;
	
	
end


function amyjqs_Excluded(Unit,Excluded,debuff_name)-------团队外的驱散
if Excluded == nil then
	return nil;
end

local playerClass, englishClass = UnitClass(Unit);
local race, raceEn = UnitRace(Unit)
local name, realm = UnitName(Unit);

if playerClass == nil or race == nil or name == nil then
	return nil;
end

debuff_name = playerClass .. "," .. englishClass .. "," .. debuff_name
debuff_name = race .. "," .. raceEn .. "," .. debuff_name
debuff_name = name .. "," .. Unit .. "," .. debuff_name

return amfind(strlower(debuff_name),strlower(Excluded),0)

end

function amyjqs(SPELL,buff_type,units,Excluded,StrExpression)--------YJ驱散魔法，疾病，诅咒，中毒
	local i , t_name, rank, subgroup, level, t_class, fileName, zone, online, isDead, role, isML;
	local name,class,race,spell,unit,spellcd,guid;
	local tempn,temptype;
	
	if not SPELL then
		return;
	end
	
	if not amisr(SPELL,"nogoal") then
	--print("e")
		return;
	end
	
	if not buff_type then
		buff_type = "Magic,Curse,Disease,Poison"
	end
	
	local str
	
	if StrExpression then
		str ='function TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) if ' .. StrExpression .. ' then return true; else return false; end end'
	else
		str ='function TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) return false; end'
	end
	
	
	
	RunScript(str);
	
	
	
	local playergroup,k,debuff_name,debuffType,Dtype,Dtype_Z
	
	Dtype_Z = { strsplit(",",buff_type) }
	
	for i,Dtype_v in ipairs(Dtype_Z) do
	
		buff_type = Dtype_v;
	
			if units then
			
			
			--unit=gsub(unit," ",",")
				
				
					
					
					
				
				local jn = { strsplit(",",units) }
			
			
					for i,v in ipairs(jn) do
					
							
				
							t_name = v
					--DEFAULT_CHAT_FRAME:AddMessage("1" .. t_name);
							if UnitExists(t_name) then
								tempn,temptype = isrunspell(SPELL,t_name)
								name = UnitName(t_name);
								
								if not UnitIsDeadOrGhost(t_name) and UnitIsConnected(t_name) and tempn and name then
									
											
											
											for k=1 , 40 do
											
												debuff_name, _, _, _, debuffType =  UnitDebuff(t_name, k, 1);
												if debuffType and debuff_name then
													if	strlower(buff_type) == strlower(debuffType) or strlower(buff_type) == strlower(debuff_name) then
													unit = t_name;
													
													 class = UnitClass(unit);
													 race = UnitRace(unit);
													 spell = amac(unit);
													 spellcd = amact(unit);
													 guid = UnitGUID(unit);
													
														if not (amyjqs_Excluded(t_name,Excluded,debuff_name) or TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) ) then
														
															
															
															
															--DEFAULT_CHAT_FRAME:AddMessage("temptype--" .. tostring(temptype),192,0,192,0)
															
															if tempn then
															--DEFAULT_CHAT_FRAME:AddMessage("tempn--" .. tostring(t_name),192,0,192,0)
																if temptype == 1 then
																amrun("/cast [target=" .. t_name.. "]" .. SPELL)
																else
																amrun("/use [target=" .. t_name.. "]" .. SPELL)
																end
																
																return true;
															else
																break;
															end
															
														end
														
													end
													
												else
													break;
												
												end
												
											end
											
								end
								
							end
							
					end
						
				
			end
			
			t_name = "player";
			tempn,temptype = isrunspell(SPELL,t_name)
			
			if not UnitIsDeadOrGhost(t_name) and UnitIsConnected(t_name) and tempn then
					
					--DEFAULT_CHAT_FRAME:AddMessage(tostring(SPELL) .. " - " .. tostring(buff_type).. " - ") -- .. tostring(a3),192,0,192,0);		
							
							
							for k=1 , 40 do
							
								debuff_name, _, _, _, debuffType =  UnitDebuff(t_name, k, 1);
								if debuffType and debuff_name then
									if	strlower(buff_type) == strlower(debuffType) or strlower(buff_type) == strlower(debuff_name) then
													
													unit = t_name;
													name = UnitName(unit);
													 class = UnitClass(unit);
													 race = UnitRace(unit);
													 spell = amac(unit);
													 spellcd = amact(unit);
													 guid = UnitGUID(unit);
													
														if not (amyjqs_Excluded(t_name,Excluded,debuff_name) or TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) ) then
														
														
															 
															if tempn then
															--DEFAULT_CHAT_FRAME:AddMessage("2--" .. tostring(t_name),192,0,192,0)
																if temptype == 1 then
																amrun("/cast [target=" .. t_name.. "]" .. SPELL)
																else
																amrun("/use [target=" .. t_name.. "]" .. SPELL)
																end
																
																return true;
															else
																break;
															end
															
														end
														
									end
									
								else
									
									break;
								
								end
								
							end
							
			end
			--[[
			t_name = "target";
			
			if UnitExists(t_name) then
				
				if not UnitIsDeadOrGhost(t_name) and UnitIsConnected(t_name) then
					
							
							
							for k=1 , 40 do
							
								debuff_name, _, _, _, debuffType =  UnitDebuff(t_name, k, 1);
								if debuffType and debuff_name then
									if	strlower(buff_type) == strlower(debuffType) or strlower(buff_type) == strlower(debuff_name) then
													
													unit = t_name;
													name = UnitName(unit);
													 class = UnitClass(unit);
													 race = UnitRace(unit);
													 spell = amac(unit);
													 spellcd = amact(unit);
													 guid = UnitGUID(unit);
													
														if not (amyjqs_Excluded(t_name,Excluded,debuff_name) or TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) ) then
														
														
															local tempn,temptype = isrunspell(SPELL,t_name)
															if tempn then
																if temptype == 1 then
																amrun("/cast [target=" .. t_name.. "]" .. SPELL)
																else
																amrun("/use [target=" .. t_name.. "]" .. SPELL)
																end
																
																return true;
															else
																break;
															end
															
														end
														
									end
									
								else
									break;
								
								end
								
							end
							
				end
				
			end
			
			
			t_name = "focus";
			
			if UnitExists(t_name) then
				
				if not UnitIsDeadOrGhost(t_name) and UnitIsConnected(t_name) then
					
							
							
							for k=1 , 40 do
							
								debuff_name, _, _, _, debuffType =  UnitDebuff(t_name, k, 1);
								if debuffType and debuff_name then
									if	strlower(buff_type) == strlower(debuffType) or strlower(buff_type) == strlower(debuff_name) then
													
														unit = t_name;
													name = UnitName(unit);
													 class = UnitClass(unit);
													 race = UnitRace(unit);
													 spell = amac(unit);
													 spellcd = amact(unit);
													 guid = UnitGUID(unit);
													
														if not (amyjqs_Excluded(t_name,Excluded,debuff_name) or TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) ) then
														
														
															local tempn,temptype = isrunspell(SPELL,t_name)
															if tempn then
																if temptype == 1 then
																amrun("/cast [target=" .. t_name.. "]" .. SPELL)
																else
																amrun("/use [target=" .. t_name.. "]" .. SPELL)
																end
																
																return true;
															else
																break;
															end
															
														end
														
									end
									
								else
									break;
								
								end
								
							end
							
				end
				
			end
			
			--]]
			
			for i=1 , GetNumPartyMembers() do
					t_name	= "party" .. tostring(i)
					 tempn,temptype = isrunspell(SPELL,t_name)
						if not UnitIsDeadOrGhost(t_name) and UnitIsConnected(t_name) and tempn then
							
							for k=1 , 40 do
					
							debuff_name, _, _, _, debuffType =  UnitDebuff(t_name, k, 1); 
								if debuffType and debuff_name then
									--DEFAULT_CHAT_FRAME:AddMessage("3P >> " .. tostring(t_name),192,0,192,0)
									if	strlower(buff_type) == strlower(debuffType) or strlower(buff_type) == strlower(debuff_name) then
												
												unit = t_name;
												name = UnitName(unit);
												 class = UnitClass(unit);
												 race = UnitRace(unit);
												 spell = amac(unit);
												 spellcd = amact(unit);
												 guid = UnitGUID(unit);
												
													if not (amyjqs_Excluded(t_name,Excluded,debuff_name) or TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) ) then
													
													
														
														if tempn then
														--DEFAULT_CHAT_FRAME:AddMessage("P >> " .. tostring(t_name),192,0,192,0)
															if temptype == 1 then
															amrun("/cast [target=" .. t_name.. "]" .. SPELL)
															else
															amrun("/use [target=" .. t_name.. "]" .. SPELL)
															end
															
															return true;
														else
															break;
														end
														
													end
													
									end
									
								else
									
									break;
								
								end
								
							end
								
						end
								
				end
					
			
				
									
								
					
					for i=1 , GetNumRaidMembers() do
						t_name, rank, subgroup, level, t_class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
						if not t_name then
							break;
						end
						
						tempn,temptype = isrunspell(SPELL,t_name)
						
						--DEFAULT_CHAT_FRAME:AddMessage("1R >> " .. tostring(t_name).."-".. tostring(tempn).."-".. tostring(isDead).."-".. tostring(online),192,0,192,0)
						
						if not UnitIsDeadOrGhost(t_name) and UnitIsConnected(t_name) and tempn then
						--if tempn and isDead and online then
						
								
								for k=1 , 40 do
									
																			
					
											debuff_name, _, _, _, debuffType =  UnitDebuff(t_name, k, 1);
											if debuffType and debuff_name then
												--DEFAULT_CHAT_FRAME:AddMessage("3R >> " .. tostring(t_name),192,0,192,0)
												if	strlower(buff_type) == strlower(debuffType) or strlower(buff_type) == strlower(debuff_name) then
													--print(tostring(i))
													unit = "raid" .. tostring(i);
													name = UnitName(unit);
													 class = UnitClass(unit);
													 race = UnitRace(unit);
													 spell = amac(unit);
													 spellcd = amact(unit);
													 guid = UnitGUID(unit);
													
														if not (amyjqs_Excluded(t_name,Excluded,debuff_name) or TEMP_amayjqs(name,class,race,spell,unit,guid,spellcd) ) then
														
														
															 
															if tempn then
															--DEFAULT_CHAT_FRAME:AddMessage("R >> " .. tostring(t_name),192,0,192,0)
																if temptype == 1 then
																amrun("/cast [target=" .. t_name.. "]" .. SPELL)
																else
																amrun("/use [target=" .. t_name.. "]" .. SPELL)
																end
																
																return true;
															else
																break;
															end
															
														end
														
												end
											else
												break;
											
											end
											
									
										
								end
							
							
						end
					end

				
						
				
				
				
				
				
				
				
				
			
	end		
			return false;

end


function amacarena(String) --【競技場專用】獲得敵方符合條件的人物信息--UnitGUID
--UnitGUID


	 wowam.player.Custom.Variable["amarena_name"] = nil
	 wowam.player.Custom.Variable["amarena_class"] = nil
	 wowam.player.Custom.Variable["amarena_race"] = nil
	 wowam.player.Custom.Variable["amarena_spell"] = nil
	 wowam.player.Custom.Variable["amarena_spellcd"] = nil
	 wowam.player.Custom.Variable["amarena_guid"] = nil
	 wowam.player.Custom.Variable["amarena_unit"] = nil
	 
	if not String then
		return false
	end
	
	local str ='function TEMP_amacarena(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
		

	for i=1, 5 do
		unit="arena" .. i;
		
		if amac(unit) then
		
		 name = UnitName(unit);
		 class = UnitClass(unit);
		 race = UnitRace(unit);
		 spell = amac(unit);
		 spellcd = amact(unit);
		 guid = UnitGUID(unit);
		 
		 
		 
			if TEMP_amacarena(name,class,race,spell,unit,guid,spellcd) then
			
			 wowam.player.Custom.Variable["amarena_name"] = name
			 wowam.player.Custom.Variable["amarena_class"] = class
			 wowam.player.Custom.Variable["amarena_race"] = race
			 wowam.player.Custom.Variable["amarena_spell"] = spell
			 wowam.player.Custom.Variable["amarena_spellcd"] = spellcd
			 wowam.player.Custom.Variable["amarena_guid"] = guid
			 wowam.player.Custom.Variable["amarena_unit"] = unit
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end
				 
		end
		
		
	end
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end



function amarenainf(String)--【競技場專用】獲得敵方符合條件的人物信息--UnitGUID
--UnitGUID


	 wowam.player.Custom.Variable["amarenainf_name"] = nil
	 wowam.player.Custom.Variable["amarenainf_class"] = nil
	 wowam.player.Custom.Variable["amarenainf_race"] = nil
	 wowam.player.Custom.Variable["amarenainf_spell"] = nil
	 wowam.player.Custom.Variable["amarenainf_spellcd"] = nil
	 wowam.player.Custom.Variable["amarenainf_guid"] = nil
	 wowam.player.Custom.Variable["amarenainf_unit"] = nil
	 
	if not String then
		return false
	end
	
	local str ='function TEMP_amarenainf(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
		

	for i=1, 5 do
		unit="arena" .. i;
		
		if UnitName(unit)then
		
		 --bufflist = ambufflist(unit);
		 name = UnitName(unit);
		 class = UnitClass(unit);
		 race = UnitRace(unit);
		 spell = amac(unit);
		 spellcd = amact(unit);
		 guid = UnitGUID(unit);
		 
		 
		 
			if TEMP_amarenainf(name,class,race,spell,unit,guid,spellcd) then
			
			 wowam.player.Custom.Variable["amarenainf_name"] = name
			 wowam.player.Custom.Variable["amarenainf_class"] = class
			 wowam.player.Custom.Variable["amarenainf_race"] = race
			 wowam.player.Custom.Variable["amarenainf_spell"] = spell
			 wowam.player.Custom.Variable["amarenainf_spellcd"] = spellcd
			 wowam.player.Custom.Variable["amarenainf_guid"] = guid
			 wowam.player.Custom.Variable["amarenainf_unit"] = unit
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end
				 
		end
		
		
	end
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end







function amyjzl(spells,Treatment,StrExcluded) -----------YJ治疗

-- {3000;1000;治疗波}

	if type(spells) == "table" then
		Wowam_Message("类型错误: 参数1不是数组" )
		return false
	end
	
	if type(Treatment) == "table" then
		Wowam_Message("类型错误: 参数2不是数组" )
		return false
	end
	
	if type(StrExcluded) == "table" then
		Wowam_Message("类型错误: 参数3不是数组" )
		return false
	end
	
	str ='function TEMP_amyjzl_E(name,class,race,spell,unit,guid,spellcd,subgroup,unitinf) if ' .. StrExcluded .. ' then return true; else return false; end end'
	RunScript(str);
	
	
	local Health,StopHealth,Spell;
	local Inf={};
	local temp_jn;
	local name,class,race,spell,unit,spellcd,guid,subgroup;
	local str,z,n,names,index;
	
		for i,spells_v in ipairs(spells) do
			
			temp_jn = { strsplit(";",spells_v) }
			
			if temp_jn[1] and temp_jn[2] and temp_jn[3] then
			
				Health[i] = temp_jn[1]
				StopHealth[i] = temp_jn[2]
				Spell[i] = temp_jn[3]
				
			else
			
				Wowam_Message("格式错误:" .. spells_v)
				return false;
			end
				
		end
		
		
		
		-- player --
		
		if GetNumRaidMembers()==0 and GetNumPartyMembers()==0 then
			names ={"player","pet"}
			for i,names_v in ipairs(names) do
				unit = names_v;
				health = UnitHealthMax(unit) - UnitHealth(unit);
				index = 0;
				
				for e,Health_v in ipairs(Health) do
					if Health_v >= health then
					
					name = UnitName(unit);
					class = UnitClass(unit);
					race = UnitRace(unit);
					spell = amac(unit);
					spellcd = amact(unit);
					guid = UnitGUID(unit);
					subgroup = amsubgroup(unit)
					index = e;
					break;
					end
				end
				
				if index >0 then
				 
	
					 unitinf = {["name"]=name,["class"]=class,["race"]=race,["spell"]=spell,["spellcd"]=spellcd,["guid"]=guid,["subgroup"]=subgroup}
					 z=0;
					 n=0;
					for k,Treatment_v in ipairs(Treatment) do
				
					
						str ='function TEMP_amyjzl(name,class,race,spell,unit,guid,spellcd,subgroup,unitinf) if ' .. Treatment_v .. ' then return true; else return false; end end'
						RunScript(str);

						if TEMP_amyjzl(name,class,race,spell,unit,guid,spellcd,subgroup,unitinf) then
							z = z + 1;
						end
				
						n = n+1;
					end
					
					if z == n then
					
						 z=0;
						 n=0;
						 
						for k,StrExcluded_v in ipairs(StrExcluded) do
					
						
							str ='function TEMP_amyjzl_E(name,class,race,spell,unit,guid,spellcd,subgroup,unitinf) if ' .. StrExcluded_v .. ' then return true; else return false; end end'
							RunScript(str);

							if TEMP_amyjzl_E(name,class,race,spell,unit,guid,spellcd,subgroup,unitinf) then
								z = z + 1;
							end
					
							n = n + 1;
						end

					
							if z ~= n then
								
								return true;
							
							end
					end
					
				end
				
			end	
		end
		
	
			return false;

end



function ampartyinf(String)--獲得符合條件的队伍人物信息
--UnitGUID


	 wowam.player.Custom.Variable["ampartyinf_name"] = nil
	 wowam.player.Custom.Variable["ampartyinf_class"] = nil
	 wowam.player.Custom.Variable["ampartyinf_race"] = nil
	 wowam.player.Custom.Variable["ampartyinf_spell"] = nil
	 wowam.player.Custom.Variable["ampartyinf_spellcd"] = nil
	 wowam.player.Custom.Variable["ampartyinf_guid"] = nil
	 wowam.player.Custom.Variable["ampartyinf_unit"] = nil
	 
	if not String then
		return false
	end
	
	local str ='function TEMP_ampartyinf(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members =GetNumPartyMembers()+1;

	for i=1, Members do
		if Members == i then
			unit="player"
		else
			unit="party" .. i;
		end
		
		if UnitName(unit)then
		
		 --bufflist = ambufflist(unit);
		 name = UnitName(unit);
		 class = UnitClass(unit);
		 race = UnitRace(unit);
		 spell = amac(unit);
		 spellcd = amact(unit);
		 guid = UnitGUID(unit);
		 
		 
		 
			if TEMP_ampartyinf(name,class,race,spell,unit,guid,spellcd) then
			
			 wowam.player.Custom.Variable["ampartyinf_name"] = name
			 wowam.player.Custom.Variable["ampartyinf_class"] = class
			 wowam.player.Custom.Variable["ampartyinf_race"] = race
			 wowam.player.Custom.Variable["ampartyinf_spell"] = spell
			 wowam.player.Custom.Variable["ampartyinf_spellcd"] = spellcd
			 wowam.player.Custom.Variable["ampartyinf_guid"] = guid
			 wowam.player.Custom.Variable["ampartyinf_unit"] = unit
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end
				 
		end
		
		
	end
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end



function amraidinf(String)--獲得符合條件的團隊人物信息
--UnitGUID


	 wowam.player.Custom.Variable["amraidinf_name"] = nil
	 wowam.player.Custom.Variable["amraidinf_class"] = nil
	 wowam.player.Custom.Variable["amraidinf_race"] = nil
	 wowam.player.Custom.Variable["amraidinf_spell"] = nil
	 wowam.player.Custom.Variable["amraidinf_spellcd"] = nil
	 wowam.player.Custom.Variable["amraidinf_guid"] = nil
	 wowam.player.Custom.Variable["amraidinf_unit"] = nil
	 
	if not String then
		return false
	end
	
	local str ='function TEMP_amraidinf(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members =GetNumRaidMembers();

	for i=1, Members do
		unit="raid" .. i;
		
		if UnitName(unit)then
		
		-- bufflist = ambufflist(unit);
		 name = UnitName(unit);
		 class = UnitClass(unit);
		 race = UnitRace(unit);
		 spell = amac(unit);
		 spellcd = amact(unit);
		 guid = UnitGUID(unit);
		 
		 
		 
			if TEMP_amraidinf(name,class,race,spell,unit,guid,spellcd) then
			
			 wowam.player.Custom.Variable["amraidinf_name"] = name
			 wowam.player.Custom.Variable["amraidinf_class"] = class
			 wowam.player.Custom.Variable["amraidinf_race"] = race
			 wowam.player.Custom.Variable["amraidinf_spell"] = spell
			 wowam.player.Custom.Variable["amraidinf_spellcd"] = spellcd
			 wowam.player.Custom.Variable["amraidinf_guid"] = guid
			 wowam.player.Custom.Variable["amraidinf_unit"] = unit
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end
				 
		end
		
		
	end
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end


function ampartypetinf(String)--獲得符合條件的队伍寵物信息
--UnitGUID


	 wowam.player.Custom.Variable["ampartypetinf_name"] = nil
	 wowam.player.Custom.Variable["ampartypetinf_class"] = nil
	 wowam.player.Custom.Variable["ampartypetinf_race"] = nil
	 wowam.player.Custom.Variable["ampartypetinf_spell"] = nil
	 wowam.player.Custom.Variable["ampartypetinf_spellcd"] = nil
	 wowam.player.Custom.Variable["ampartypetinf_guid"] = nil
	 wowam.player.Custom.Variable["ampartypetinf_unit"] = nil
	 
	if not String then
		return false
	end
	
	local str ='function TEMP_ampartypetinf(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members =GetNumPartyMembers()+1;

	for i=1, Members do
		
		
		if Members == i then
			unit="pet"
		else
			unit="partypet" .. i;
		end
		
		
		if UnitName(unit)then
		
		 --bufflist = ambufflist(unit);
		 name = UnitName(unit);
		 class = UnitClass(unit);
		 race = UnitRace(unit);
		 spell = amac(unit);
		 spellcd = amact(unit);
		 guid = UnitGUID(unit);
		 
		 
		 
			if TEMP_ampartypetinf(name,class,race,spell,unit,guid,spellcd) then
			
			 wowam.player.Custom.Variable["ampartypetinf_name"] = name
			 wowam.player.Custom.Variable["ampartypetinf_class"] = class
			 wowam.player.Custom.Variable["ampartypetinf_race"] = race
			 wowam.player.Custom.Variable["ampartypetinf_spell"] = spell
			 wowam.player.Custom.Variable["ampartypetinf_spellcd"] = spellcd
			 wowam.player.Custom.Variable["ampartypetinf_guid"] = guid
			 wowam.player.Custom.Variable["ampartypetinf_unit"] = unit
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end
				 
		end
		
		
	end
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end




function amraidpetinf(String)--獲得符合條件的團隊寵物信息
--UnitGUID


	 wowam.player.Custom.Variable["amraidpetinf_name"] = nil
	 wowam.player.Custom.Variable["amraidpetinf_class"] = nil
	 wowam.player.Custom.Variable["amraidpetinf_race"] = nil
	 wowam.player.Custom.Variable["amraidpetinf_spell"] = nil
	 wowam.player.Custom.Variable["amraidpetinf_spellcd"] = nil
	 wowam.player.Custom.Variable["amraidpetinf_guid"] = nil
	 wowam.player.Custom.Variable["amraidpetinf_unit"] = nil
	 
	if not String then
		return false
	end
	
	local str ='function TEMP_amraidpetinf(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return true; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members =GetNumRaidMembers();

	for i=1, Members do
		unit="raidpet" .. i;
		
		if UnitName(unit)then
		
		 --bufflist = ambufflist(unit);
		 name = UnitName(unit);
		 class = UnitClass(unit);
		 race = UnitRace(unit);
		 spell = amac(unit);
		 spellcd = amact(unit);
		 guid = UnitGUID(unit);
		 
		 
		 
			if TEMP_amraidpetinf(name,class,race,spell,unit,guid,spellcd) then
			
			 wowam.player.Custom.Variable["amraidpetinf_name"] = name
			 wowam.player.Custom.Variable["amraidpetinf_class"] = class
			 wowam.player.Custom.Variable["amraidpetinf_race"] = race
			 wowam.player.Custom.Variable["amraidpetinf_spell"] = spell
			 wowam.player.Custom.Variable["amraidpetinf_spellcd"] = spellcd
			 wowam.player.Custom.Variable["amraidpetinf_guid"] = guid
			 wowam.player.Custom.Variable["amraidpetinf_unit"] = unit
				 
			 return unit,name,class,race,spell,spellcd,guid;
			end
				 
		end
		
		
	end
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end


function amisequiped(equiped,Unit)--該目標是否佩戴有指定物品不能判断无法查看装备的目标、不能在观察距离以外

	if Unit == nil then
		Unit = "player"
	end
	
	if not equiped then
		return false;
	end
	
	if UnitGUID(Unit) == UnitGUID("player") then
	
		if IsEquippedItem(equiped) then
			return true;
			
		else
			return false;
		end
		
	
	end
	
	--[[
	if type(equiped) == "number" then 
		
		local mainHandLink = GetInventoryItemLink(Unit,equiped)
					
						if mainHandLink then
						local spell = GetItemInfo(mainHandLink)
							return 	spell,equiped;
								
						end
		return nil;
	
	end
	--]]
	
	--if type(equiped) == "string" then

		for i=1 , 23 do
					
					
					local mainHandLink = GetInventoryItemLink(Unit,i)
					
						if mainHandLink then
						local spell = GetItemInfo(mainHandLink)
						
						--print(spell)
						
							if spell == equiped then
								
								return 	true;
								
							end
						end


		end
		
		return false;
		
	--end
	
	--return nil;
	
end


function amminimum(String,StrReturn,group) --小队或者团队里最小的数值的人物信息
--UnitGUID

	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"   or group=="arenapet" ) then
	DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
	return false
	end


	 wowam.player.Custom.Variable["amminimum_name"] = nil
	 wowam.player.Custom.Variable["amminimum_class"] = nil
	 wowam.player.Custom.Variable["amminimum_race"] = nil
	 wowam.player.Custom.Variable["amminimum_spell"] = nil
	 wowam.player.Custom.Variable["amminimum_spellcd"] = nil
	 wowam.player.Custom.Variable["amminimum_guid"] = nil
	 wowam.player.Custom.Variable["amminimum_unit"] = nil
	 wowam.player.Custom.Variable["amminimum_Value"] = nil
	 
	 
	if String==nil or StrReturn == nil then
	
		DEFAULT_CHAT_FRAME:AddMessage("String 或 StrReturn 参数不能为空")
		return false
	end
	
	local str ='function TEMP_amminimum(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers() ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end

	for i=1, Members do
		if i==Members and group == "party" then
		unit="player"
		elseif i==Members and group == "partypet" then
		unit="pet"
		else
		unit=group .. tostring(i);
		end
		
		if UnitName(unit)then
		
			 --bufflist = ambufflist(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = amac(unit);
			 spellcd = amact(unit);
			 guid = UnitGUID(unit);
		 
		 minimum = TEMP_amminimum(name,class,race,spell,unit,guid,spellcd);
		 
			if minimum then
			 
				if temp_n == nil then
				 
					temp_n =minimum;
					temp_unit = unit;
				elseif minimum < temp_n then
					temp_n =minimum;
					temp_unit = unit;
				end
			end	
				 
		end
		
		
		
	end
	
	if temp_unit then
	
			 
			 
			 --bufflist = ambufflist(temp_unit);
			 name = UnitName(temp_unit);
			 class = UnitClass(temp_unit);
			 race = UnitRace(temp_unit);
			 spell = amac(temp_unit);
			 spellcd = amact(temp_unit);
			 guid = UnitGUID(temp_unit);
			
			 wowam.player.Custom.Variable["amminimum_name"] = name
			 wowam.player.Custom.Variable["amminimum_class"] = class
			 wowam.player.Custom.Variable["amminimum_race"] = race
			 wowam.player.Custom.Variable["amminimum_spell"] = spell
			 wowam.player.Custom.Variable["amminimum_spellcd"] = spellcd
			 wowam.player.Custom.Variable["amminimum_guid"] = guid
			 wowam.player.Custom.Variable["amminimum_unit"] = temp_unit
			 wowam.player.Custom.Variable["amminimum_Value"] = temp_n
				 
			 return temp_unit,name,class,race,spell,spellcd,guid,temp_n;
	end
	
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end


function amshowbufflist(Unit) --获得指定目标buff列表
	local name = {};
	local i,c,k,n,nn;
	local ls_icon={};
	
	k = 1;
	
	if Unit == nil then
		Unit="player";
	end
	
	if not UnitName(Unit) then
		Wowam_Message(wowam.Colors.RED..tostring(Unit).." ID不正确" )
		return nil;
	end
	
	Wowam_Message(wowam.Colors.RED..UnitName(Unit).." - Buff列表" )
	Wowam_Message(wowam.Colors.MAGENTA.."有益Buff" )
	for i=1,40 do 
		c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable =  UnitBuff(Unit, i)
		if c then
		name[k] = c ;
		
		n = expirationTime - GetTime()
		if n < 0 then
			n= 0
		end
		n = format("%.1f",n);
		nn = format("%.1f",duration);
		
		ls_icon = { strsplit("\\",icon) }
		
		Wowam_Message(wowam.Colors.RED..tostring(k)..". ".. wowam.Colors.CYAN .. c )
		Wowam_Message(wowam.Colors.YELLOW.."   等级:".. wowam.Colors.CYAN .. tostring(rank) )
		Wowam_Message(wowam.Colors.YELLOW.."   类型:".. wowam.Colors.CYAN .. tostring(debuffType) )
		Wowam_Message(wowam.Colors.YELLOW.."   层数:".. wowam.Colors.CYAN .. tostring(count) )
		Wowam_Message(wowam.Colors.YELLOW.."   冷却:".. wowam.Colors.CYAN .. tostring(n) )
		Wowam_Message(wowam.Colors.YELLOW.."   归属:".. wowam.Colors.CYAN .. tostring(unitCaster) )
		Wowam_Message(wowam.Colors.YELLOW.."   图标:".. wowam.Colors.CYAN .. tostring(ls_icon[3]) )
		Wowam_Message(wowam.Colors.YELLOW.."   其他:".. wowam.Colors.CYAN .. tostring(isStealable) )
		Wowam_Message(wowam.Colors.YELLOW.."   技能时间:".. wowam.Colors.CYAN .. tostring(nn) )		
		k = k + 1;
		end
		
		
	end
	
	
	Wowam_Message(wowam.Colors.MAGENTA.."无益Buff" )
	ls_icon={}
	for i=1,40 do 
		c, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable=  UnitDebuff(Unit, i)
		
		if c then
		name[k] = c ;
		
		
		
		n = expirationTime - GetTime()
		if n < 0 then
			n= 0
		end
		n = format("%.1f",n);
		nn = format("%.1f",duration);
		
		ls_icon = { strsplit("\\",icon) }
		
		Wowam_Message(wowam.Colors.RED..tostring(k)..". ".. wowam.Colors.CYAN .. c )
		Wowam_Message(wowam.Colors.YELLOW.."   等级:".. wowam.Colors.CYAN .. tostring(rank) )
		Wowam_Message(wowam.Colors.YELLOW.."   类型:".. wowam.Colors.CYAN .. tostring(debuffType) )
		Wowam_Message(wowam.Colors.YELLOW.."   层数:".. wowam.Colors.CYAN .. tostring(count) )
		Wowam_Message(wowam.Colors.YELLOW.."   冷却:".. wowam.Colors.CYAN .. tostring(n) )
		Wowam_Message(wowam.Colors.YELLOW.."   归属:".. wowam.Colors.CYAN .. tostring(unitCaster) )
		Wowam_Message(wowam.Colors.YELLOW.."   图标:".. wowam.Colors.CYAN .. tostring(ls_icon[3]) )
		Wowam_Message(wowam.Colors.YELLOW.."   其他:".. wowam.Colors.CYAN .. tostring(isStealable) )
		Wowam_Message(wowam.Colors.YELLOW.."   技能时间:".. wowam.Colors.CYAN .. tostring(nn) )	
		k = k + 1;
		end
		
		
	end
	
	return k-1;
	
end
function amwbuff(n)   -- 返回主手和副手武器附魔信息.

	local a,b,c,a1,b1,c1 = GetWeaponEnchantInfo() -- 返回主手和副手武器附魔信息.

	if n ==1 and a then
		return b/1000,a,c
	elseif n ==2 and a1 then
		return b1/1000,a1,c1
	end

	return -1;
end


function amzblist(Unit)  --显示指定目标的装备列表及CD 
	if Unit == nil then
		Unit="player";
	end
	
	local cd;

			for i=1 , 18 do
			
			
			local mainHandLink = GetInventoryItemLink(Unit,i)
			
				if mainHandLink then
				local spell = GetItemInfo(mainHandLink)
				
					if spell then
						
						a, b, c = GetInventoryItemCooldown(Unit, i)
						
						cd= a+b-GetTime()
						if cd<0 then
							cd = 0
						end
						
						cd = format("%.1f",cd)
						
						DEFAULT_CHAT_FRAME:AddMessage(wowam.Colors.RED .. "编号:" .. wowam.Colors.CYAN .. tostring(i) .. wowam.Colors.YELLOW .."  名称:" ..wowam.Colors.CYAN.. spell .. wowam.Colors.YELLOW .."  冷却时间:" ..wowam.Colors.CYAN.. cd,192,0,192,0)
						
						
					
					end
				end


			end
			
end

function amprint(String)

local str ='function TEMP_amprint() return ' .. String .. '; end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
local ls_jn = {TEMP_amprint() }
	
			 
			for i,v in ipairs(ls_jn) do
			
				Wowam_Message(wowam.Colors.RED .. tostring(v))
			end
		
				
					
end

function amdc() ------ DPSCycle 插件



if not UnitName("target") then
return nil
end
local a = DPSCycleIconFrame1
if a ==nil then
	Wowam_Message(wowam.Colors.RED.."注意："..wowam.Colors.CYAN.."没检测到 DPSCycle 插件!")
	return nil
end

local spell=DPSCycleIconFrame1.spellName

if amac("player") ~= spell then

amrun(spell)
end

--DEFAULT_CHAT_FRAME:AddMessage(tostring(amac("player")))

return spell
end


function ammaximum(String,StrReturn,group) --小队或者团队里最大的数值的人物信息
--UnitGUID

	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"  or group=="arenapet" ) then
	DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
	return false
	end
	


	 wowam.player.Custom.Variable["ammaximum_name"] = nil
	 wowam.player.Custom.Variable["ammaximum_class"] = nil
	 wowam.player.Custom.Variable["ammaximum_race"] = nil
	 wowam.player.Custom.Variable["ammaximum_spell"] = nil
	 wowam.player.Custom.Variable["ammaximum_spellcd"] = nil
	 wowam.player.Custom.Variable["ammaximum_guid"] = nil
	 wowam.player.Custom.Variable["ammaximum_unit"] = nil
	 wowam.player.Custom.Variable["ammaximum_Value"] = nil
	 
	 
	if String==nil or StrReturn == nil then
	
		DEFAULT_CHAT_FRAME:AddMessage("String 或 StrReturn 参数不能为空")
		return false
	end
	
	local str ='function TEMP_ammaximum(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	
	--DEFAULT_CHAT_FRAME:AddMessage(str)
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers()+1 ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
		
		
	end

	for i=1, Members do
		if i==Members and (group == "party" or group=="raid") then
		unit="player"
		elseif i==Members and (group == "partypet" or group=="raidpet") then
		unit="pet"
		else
		unit=group .. tostring(i);
		end
		
		if UnitName(unit)then
		
			 --bufflist = ambufflist(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = amac(unit);
			 spellcd = amact(unit);
			 guid = UnitGUID(unit);
		 
		 minimum = TEMP_ammaximum(name,class,race,spell,unit,guid,spellcd);
		 
			if minimum then
			 
				if temp_n == nil then
				 
					temp_n =minimum;
					temp_unit = unit;
				elseif minimum > temp_n then
					temp_n =minimum;
					temp_unit = unit;
				end
			end	
				 
		end
		
		
		
	end
	
	if temp_unit then
	
			 
			 
			 --bufflist = ambufflist(temp_unit);
			 name = UnitName(temp_unit);
			 class = UnitClass(temp_unit);
			 race = UnitRace(temp_unit);
			 spell = amac(temp_unit);
			 spellcd = amact(temp_unit);
			 guid = UnitGUID(temp_unit);
			
			 wowam.player.Custom.Variable["ammaximum_name"] = name
			 wowam.player.Custom.Variable["ammaximum_class"] = class
			 wowam.player.Custom.Variable["ammaximum_race"] = race
			 wowam.player.Custom.Variable["ammaximum_spell"] = spell
			 wowam.player.Custom.Variable["ammaximum_spellcd"] = spellcd
			 wowam.player.Custom.Variable["ammaximum_guid"] = guid
			 wowam.player.Custom.Variable["ammaximum_unit"] = temp_unit
			 wowam.player.Custom.Variable["ammaximum_Value"] = temp_n
				 
			 return temp_unit,name,class,race,spell,spellcd,guid,temp_n;
	end
	
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return false
end

function amnewspelltime(Unit,Spell) --获得单元法术释放时间

	if not UnitName(Unit) or Spell == nil then
		return;
	end
	
	local str = UnitGUID(Unit) .. "_" .. Spell;
	local n = wowam.spell.Event_SpellInfo.name[str];

	if n  then
		return GetTime() - n
		
	else
		return -1;
	
	end



end


function amcount(String,StrReturn,group) --小队或者团队里符合条件的人物信息数量
--UnitGUID

local count =0;
local u;

	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"  or group=="arenapet" ) then
	DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
	return false
	end


	 
	 
	if String==nil or StrReturn == nil then
	
		DEFAULT_CHAT_FRAME:AddMessage("String 或 StrReturn 参数不能为空")
		return false
	end
	
	local str ='function TEMP_amcount(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	
	
	
	RunScript(str);
	
	local name,class,race,spell,unit,spellcd,guid;
	
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers() ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end

	for i=1, Members do
		if i==Members and group == "party" then
		unit="player"
		elseif i==Members and group == "partypet" then
		unit="pet"
		else
		unit=group .. tostring(i);
		end
		
		if UnitName(unit)then
		
			 --bufflist = ambufflist(unit);
			 name = UnitName(unit);
			 class = UnitClass(unit);
			 race = UnitRace(unit);
			 spell = amac(unit);
			 spellcd = amact(unit);
			 guid = UnitGUID(unit);
		 
		 minimum = TEMP_amcount(name,class,race,spell,unit,guid,spellcd);
		 
			if minimum then
			 u = unit;
				count = count +1;
			end	
				 
		end
		
		
		
	end
	
	
	
	
	
	
	--	DEFAULT_CHAT_FRAME:AddMessage(v)

	return count,u;
end



function amautoscript(Script,Loop,Tips) -----------自动运行脚本

	if Tips==nil then
		Tips =0;
	end

	if not Script then
		wowam.sys.automacro.Loop = nil
		wowam.sys.automacro.id =0
		wowam.sys.automacro.tbl=nil;
		if Tips ~=2 then
		Wowam_Message(wowam.Colors.RED .. "自动运行脚本已经停止!" )
		end
		return nil;
	end
	
	if type(Script) == "string" then
	
		Script = { strsplit(",",Script) }

	elseif type(Script) == "table" then
	
	else
		Wowam_Message(wowam.Colors.CYAN .. tostring(Script) .. wowam.Colors.RED.." ,参数1错误!" )
		return nil;
	end
	
	if type(Loop) ~= "number" then
	
		Wowam_Message(wowam.Colors.CYAN .. tostring(Loop) .. wowam.Colors.RED.." 错误!,参数2应该是个整数" )
		return nil;
	end
	
	if type(Tips) ~= "number" then
	
		Wowam_Message(wowam.Colors.CYAN .. tostring(Tips) .. wowam.Colors.RED.." 错误!,参数3应该是个整数" )
		return nil;
	end
	
	local n=0;
	local t=0;
	for i,h in ipairs(Script) do
		
		local _, _, a, b = string.find(h, "(.-)=(.+)")
		
			
			
			if not a or not b or tostring(tonumber(b)) ~= b  then
				Wowam_Message(wowam.Colors.CYAN .. tostring(h) .. wowam.Colors.RED.." 错误!" )
				wowam.sys.automacro.tbl=nil;
				return  nil;
			end
			
			if not amisscript(a)  then
			
				wowam.sys.automacro.tbl=nil;
				return  a;
			end
			n=n+1;
			t=t+tonumber(b);
		
		
	end
	wowam.sys.automacro.Loop = Loop
	wowam.sys.automacro.id =1;
	wowam.sys.automacro.tbl=Script;
	wowam.sys.automacro.Tips=Tips;
	
	if Tips ~=2 then
	Wowam_Message(wowam.Colors.RED .. "自动运行脚本已经启动，" .. wowam.Colors.CYAN .."脚本完成时间约" .. wowam.Colors.RED .. tostring(t) .. wowam.Colors.CYAN .. "秒")
	end
	return Script;
end

function amisscript(name)-----------运行脚本名称
local luaText = nil
	for i,v in pairs(sdm_macros) do
		if v.type=="s" and v.name==name and sdm_UsedByThisChar(v) then
			luaText=v.text
			break
		end
	end
	if luaText then
		return true;
	else
		Wowam_Message(wowam.Colors.CYAN .. tostring(name) .. wowam.Colors.RED.." 脚本名称错误!" )
		return nil;
	end
	
end
	

	
function ambuffcount(Unit,Nameid,BuffType,Categories) --获得指定目标buff数量及信息
	
	if Unit == nil then
		Unit="target";
	end
	
	if Nameid == nil then
		Nameid=0;
	end
	
	if Categories == nil then
		Categories=0;
	end
	
	
	if  not UnitName(Unit) then
		return -1;
	end
	
	if type(Nameid) ~= "number" then
		return -2;
	end
	
	if  type(BuffType) ~= "string" then
		return -3;
	end
	
	if type(Categories) ~= "number" then
		return -4;
	end

	
	
	
	local d,f;
	local n =0;
	local bufflist;
	local	name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable ;

	for i=1 , 40 do	
		if Categories == 1 then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(Unit, i)
		elseif Categories == 0 then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff(Unit, i)
		end
		
		if name then
		
			f = amfind(BuffType,debuffType);
			d=nil;
			
			if Nameid == 0 and unitCaster == "player" then
				d=1
			elseif Nameid == 1 and unitCaster ~= "player" then
				d=1
			elseif Nameid == 2 then
				d=1
			else
				d=nil;
			end
			
			if f and d then
				if bufflist == nil  then
					bufflist=name;
				else
					bufflist=bufflist .. "," .. name;
				end
				n = n + 1;
			end
		end
		
	end
	
	return n,bufflist;
	
end


function ambrun(Spells,Unit) --批处理技能

	
	if type(Spells) == "string" then
	
		Spells = { strsplit(",",Spells) }

	elseif type(Spells) == "table" then
	
	else
		return nil;
	end
	
	if not Unit then
		Unit = "target"
	end
	
	if  not UnitName(Unit) then
		return nil;
	end
	
	
	for k,va in ipairs(Spells) do
	
		if amisr(va,Unit) then
		  amrun(va,Unit);
		  return va,Unit;
		end
	
	end

end


--团队有成员血量少于50%并且自己血量大于50%，就援护
function amIntervene(UnitHealth,MeHealth)
local spell_ex={}
spell_ex["援护"]=GetSpellInfo(3411)
spell_ex["防御姿态"]=GetSpellInfo(71)

local Spell= spell_ex["援护"] --援护
local ZT = spell_ex["防御姿态"]  -- 防御姿态


	if aml("player","%")>MeHealth and amisr(Spell,"nogoal") then
	
		local YuanHu = amraidinf('IsSpellInRange("' .. Spell .. '",unit)==1 and  and amlive(unit) and aml(unit,"%",0)<' .. UnitHealth .. ' and amtnm(unit)')
		if YuanHu and not amzt(2) then
			amrun("/cast " .. ZT)
			return true;
		elseif YuanHu and amzt(2) and amisr(Spell,YuanHu) then
			amrun(Spell,YuanHu)
			return true;
		end
		
	end
	
	return nil;
end

function amBerserkerRage(Buffs) --当出现列表里的BUFF时施放狂暴之怒
local spell_ex = wowam.sys.spell_ex

if not Buffs then
	if GetLocale()=="zhCN" then
		Buffs = "恐惧,心灵尖啸,恐惧嚎叫,闷棍,瘫痪,破胆怒吼,恐惧术"
		
	elseif GetLocale()=="zhTW" then
	return
	else
	return
	
	end
	
end

	if amfind(Buffs,ambufflist("player")) and amcd(spell_ex["狂暴之怒"])<=0 then
		amrun(spell_ex["狂暴之怒"]);
		return true;
	end
end

function amequip(MainHand,DeputyHand,Distance) --换上指定的武器

local a,b,c=true,true,true;
local zd = amzd("player");
local h ;
	if MainHand and MainHand ~= "" then

		if IsEquippableItem(MainHand) then
		
			
			local mainHandLink = GetInventoryItemLink("player",16)
			local spell;
			
				if mainHandLink then
				
			
					spell = GetItemInfo(mainHandLink);
					if spell == MainHand then
						
						spell=true;
					else
						spell=false;
					end
					
				end
				
			--if not IsEquippedItem(MainHand) then
			if not spell then
			
				
				
				if zd then
					h = "/equipslot " .. 16 .. " " .. MainHand;
				else
					EquipItemByName(MainHand,16)
				end
				a=false;
			end
		
		end
			
	end	
	
	if DeputyHand and DeputyHand ~= "" then

		if IsEquippableItem(DeputyHand) then
		
			
			local mainHandLink = GetInventoryItemLink("player",17)
			local spell;
			
				if mainHandLink then
				
			
					spell = GetItemInfo(mainHandLink);
					if spell == DeputyHand then
						
						spell=true;
					else
						spell=false;
					end
					
				end
				
		
			if not spell then
			
			
			--if not IsEquippedItem(DeputyHand) then
				
				if zd then
					if h then
						h = h .. "\n/equipslot " .. 17 .. " " .. DeputyHand;
					else
						h = "/equipslot " .. 17 .. " " .. DeputyHand;
					end
				else
					EquipItemByName(DeputyHand,17)
				end
			
				b=false;
			end
		
		end
	
		
	end	
	
	if Distance then

		if IsEquippableItem(Distance) then
			
			if not IsEquippedItem(Distance) then
				
				if zd then
					
					if h then
						h = h .. "\n/equipslot " .. 18 .. " " ..Distance;
					else
						h = "/equipslot " .. 18 .. " " .. Distance;
					end
					
				else
					EquipItemByName(Distance,18)
				end
				
				c=false;
			end
		
		end
		
	
	end	
	
	if zd and h and not(a and b and c) then
		amrun(h);
		return false;
	end
	if a and b and c then
		return true;
	end
	
	return false;

end


function amcure(Unit,Health,Spells) --当目标血量少于设定时施放技能
	if not UnitName(Unit) or not Spells or not Health then
		return ;
	end
	
 if aml(Unit,"%")<Health then
 
	return ambrun(Spells,Unit)
 end
 
end

function amchase(Unit) --战士冲锋拦截

local spell_ex = wowam.sys.spell_ex
	
	if Unit == nil then
		Unit = "target"
	end
	if not UnitName(Unit) then
		return ;
	end

	local _,_,_,_,zstf = GetTalentInfo(3,22)

-- 0 到 5 码
 --local amjl_0_5 = IsSpellInRange(spell_ex["拳击"],Unit)==1

 -- 8 到 25 码
 local amjl_8_25 = IsSpellInRange(spell_ex["冲锋"],Unit)==1
 
 -- 0 到 10 码
 --local amjl_0_10 = CheckInteractDistance(Unit, 3)==1
 
 local xskb ;
 
 
 
 
 
	if amjl_8_25 then
	  if amgv("战斗姿态设定时间") then
	   if GetTime() - amgv("战斗姿态设定时间") <0.5 then
		 return true,1;
	   
	   end
	  end
	  if amgv("狂暴状态设定时间") then
	   if GetTime() - amgv("狂暴状态设定时间") <0.5 then
		 return true,2;
		else
		amsv("狂暴状态设定时间",nil)
	   end
	  end
	  if amgv("冲锋锁定直到结束") then
	   if GetTime() - amgv("冲锋锁定直到结束") <2 and amjl_8_25 then
	   --Wowam_Message("3")
		 return true,3;
	   else
		amsv("冲锋锁定直到结束",nil)
		--Wowam_Message("0")
	   end
	  end

	  if amisr(spell_ex["冲锋"],Unit) then
	   amrun(spell_ex["冲锋"],Unit);
	   amsv("血性狂暴设定时间",nil);
	   amsv("冲锋锁定直到结束",GetTime())
	   return true,4;
	  end

	  if amgv("血性狂暴设定时间") then
	   xskb = GetTime() - amgv("血性狂暴设定时间")<=3;
	  else
	   xskb = nil;
	  end
	  
	  

		if amgv("狂暴状态设定时间")==nil and amcd(spell_ex["冲锋"])<1 and ( amzt(1) or amzt(2) or amcd(spell_ex["拦截"])>2 ) then
		  --Wowam_Message("1")
			if amjl_8_25 then
				if amzt(1) or xskb then
				  if amisr(spell_ex["冲锋"],Unit) then
					amrun(spell_ex["冲锋"],Unit);
				  end
				else
					
					amrun(spell_ex["战斗姿态"])
					amsv("战斗姿态设定时间",GetTime());
					
				
				end
			 return true,5;
		    end
		end
	  if amcd(spell_ex["拦截"])<1 and amjl_8_25 and (amr()>=10 or amcd(spell_ex["血性狂暴"])<=0.7) or xskb then
	  --Wowam_Message("2")
	   if amzt(3) or xskb then
		 
		 if amisr(spell_ex["拦截"],Unit) then
		  amrun(spell_ex["拦截"],Unit);
		  amsv("狂暴状态设定时间",nil);
		 else
		  amrun(spell_ex["血性狂暴"]);
		  amsv("血性狂暴设定时间",GetTime());
		 end
		 
	   else
		 if amr()>=5 then
		 amrun(spell_ex["狂暴姿态"]);
		 amsv("狂暴状态设定时间",GetTime());
		 
		 
		 end
	   end
		return true,6;
	  end
	end


end
	
	
function amrunIsBuffs(Unit,Buffs,Spells,Appear) --当出现列表里的BUFF时施放技能

	if not(Buffs and Unit and Spells) then

	return
	
	end
	
	local k = amfind(Buffs,ambufflist(Unit))
	
	if not Appear and k then
		return ambrun(Spells,Unit)
	end
	
	if Appear and not k then
		return ambrun(Spells,Unit)
	end

	
end

function amat() --攻击计时

local t = AttackTimerBar

if not t then

	Wowam_Message(wowam.Colors.RED.."错误：" .. wowam.Colors.CYAN .. "无法使用AttackTimer()函数,需要安装或启动AttackTimer插件");
	return -1
end
if AttackTimerBar:IsShown() then
local min, max = AttackTimerBar:GetMinMaxValues();
	
	local status = GetTime();
	if status > max then
		status = max;
	end
	return tonumber(format("%0.1f", max-status)), tonumber(format("%0.1f",max-min))

end

return -1

end

function amattack(Type,Auto)--攻擊最近的目標//BeeIsCombat
if not Type then
Type =0
end

if not Auto then
Auto =0
end

if Auto==1 then
	if not UnitName("target") then
		return ;
	end
end
	
if Type ==0 then
	if amgj()==0 then
	amrun("/startattack");
	return true;
	end
elseif Type ==1 then
	if amgj()==1 then
	amrun("/stopattack");
	return true;
	end
end


end


function amDecursive()


	if not Dcr  then
	Wowam_Message(wowam.Colors.RED.."错误：" .. wowam.Colors.CYAN .. "无法使用amDecursive()函数,需要安装或启动Decursive插件");
	return
	end
	local n = Dcr["Status"]["UnitNum"]
	local i;
		for i=1, n do
		
			local unit,Spell,IsCharmed,Debuff1Prio = amDecursive_EX(i)
			
			if unit then
				if UnitName(unit) and Spell then 
					if amisr(Spell,unit) then
						amrun(Spell,unit)
						return true
					end
				end
				
			end

		end
end



function amDecursive_EX(id) ----------傻瓜一鍵驱散

local unit = Dcr.Status.Unit_Array[id]
local f = Dcr["MicroUnitF"]["UnitToMUF"][unit]

if not f then
return
end
local IsDebuffed = f["IsDebuffed"]


if IsDebuffed then

local DebuffType = f["FirstDebuffType"]
local Spell = Dcr.Status.CuringSpells[DebuffType]
local IsCharmed = f["IsCharmed"]
local Debuff1Prio = f["Debuff1Prio"]
return unit,Spell,IsCharmed,Debuff1Prio
end



--MicroUnitF:UpdateMUFUnit
end

function amShockAndAwe()
	local s = ShockAndAwe

	if not s then
		return
	end

	 local temp = ShockAndAwe.PriorityFrame:GetBackdrop()
	 local icon = temp["bgFile"]
	 local SPELL
	 for i,v in pairs(ShockAndAwe.constants) do
		if icon == v then
			SPELL =strsub(i,1,strlen(i)-5)
			SPELL =ShockAndAwe.constants[SPELL]
			if amisr(SPELL) then
				amrun(SPELL)
				return true
			end
		
		end
	 end
end



function amsetsft(Time)------------设置法术停止时间
	if not Time then
	Time =3
	end

	if type(Time) ~= "number" then
	Wowam_Message(wowam.Colors.RED.."错误：" .. wowam.Colors.CYAN .. "参数类型错误，请使用数值");
	return false;
	end

	wowam_config.SPELL_STOP_TIME=Time;
	return true;
end 

function amsft_bak(Spell,Unit)

	if wowam.sys.SPELL_FAILED.SPELLINF then
		
		local UID;
		
		if wowam.sys.SPELL_FAILED.SPELL_NOUNIT then
			UID=0;
		else
			UID=UnitGUID(Unit);
		end
		
				
		if UID then
			
			--print(">>",wowam.sys.SPELL_FAILED.SPELLINF[UID],UID)
			
			if wowam.sys.SPELL_FAILED.SPELLINF[UID] and wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell] and wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] then
			
				if wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"] then
				
				local temp_act = 0;
				
					
						temp_act,_,temp_act_name = amact("player");
						
					if temp_act ~= -1 and temp_act_name == Spell then
					
						temp_act = amiif(temp_act==-1,0,temp_act);
						wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] = GetTime();
					else
						temp_act=0;
					end
					
				
				--print(Spell,wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"],wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"]+temp_act,GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] > wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"]+temp_act)
				
					if GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] > wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"]+temp_act then
						wowam.sys.SPELL_FAILED.SPELL_NOUNIT=nil;
						return true;
					else
						return false;
					
					end
				
				else
					if GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] > wowam_config.SPELL_STOP_TIME then
						wowam.sys.SPELL_FAILED.SPELL_NOUNIT=nil;
						return true;
					else
						return false;
					
					end
				
				end
				
				--print(GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] > wowam_config.SPELL_STOP_TIME,Spell,Unit)
				
			end
			
		
		else
			wowam.sys.SPELL_FAILED.SPELL_NOUNIT=nil;
			return true;
		end
		
	
	
	end
	

	return true;

end




function amsft(Spell,Unit)-----------释放法术失败，延迟释放或者忽略目标

	local aunid = UnitGUID(Unit);
	if aunid then
		if wowam["FAILED_StopUnit"] and wowam["FAILED_StopUnit"][aunid] then
		
			if GetTime() - wowam["FAILED_StopUnit"][aunid]["time"] <=2 then
				return false,"忽略目标(".. wowam["FAILED_StopUnit"][aunid]["text"]..")";
			end
			
		end
	end


	if wowam.sys.SPELL_FAILED.SPELLINF then
		
		local UID;
		
	
			
			if wowam.sys.SPELL_FAILED.SPELLINF[Spell] and wowam.sys.SPELL_FAILED.SPELLINF[Spell][Spell] and wowam.sys.SPELL_FAILED.SPELLINF[Spell][Spell]["SPELL_DELAY"] then
			
				UID=Spell;
			else
			
				UID=UnitGUID(Unit);
			
			end
		
				--print("A>>",wowam.sys.SPELL_FAILED.SPELLINF and 1 )
		
			
			
			
		if UID then
		
			--print("1>>",wowam.sys.SPELL_FAILED.SPELLINF[UID],UID)
		
			if wowam.sys.SPELL_FAILED.SPELLINF[UID] and wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell] and wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] then
			
				if wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"] then
				
					local temp_act = 0;
				
					
						temp_act,_,temp_act_name = amact("player");
						
					if temp_act ~= -1 and temp_act_name == Spell then
					
						temp_act = amiif(temp_act==-1,0,temp_act);
						wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] = GetTime();
						--print("1>>",GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"])
					else
						temp_act=0;
					end
					
				
				--print(Spell,wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"],wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"]+temp_act,GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] > wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"]+temp_act)
				--print(GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"])
					if GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] < wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["SPELL_DELAY"] then
						
						return false,"技能延时施放";
					
					
					end
				
				else
				
					
					local UIDA,TIME,TEXT;
					UIDA=UnitGUID(Unit);
					
				
					
					if UIDA and wowam.sys.SPELL_FAILED.SPELLINF[UIDA] and wowam.sys.SPELL_FAILED.SPELLINF[UIDA]["FAILED_TEXT"] then
						
						
						
						TEXT = wowam.sys.SPELL_FAILED.SPELLINF[UIDA]["FAILED_TEXT"]
						
						if TEXT==SPELL_FAILED_OUT_OF_RANGE or TEXT==SPELL_FAILED_BAD_IMPLICIT_TARGETS or TEXT==SPELL_FAILED_LINE_OF_SIGHT or TEXT==SPELL_FAILED_TARGETS_DEAD or TEXT==SPELL_FAILED_BAD_TARGETS then
							
							TIME = wowam.sys.SPELL_FAILED.SPELLINF[UIDA]["TIME"]
						
						
							if GetTime() - TIME > wowam_config.SPELL_STOP_TIME then
								return true,TEXT;
							else
								return false,TEXT;
							end
						end
						
					end
				
				
				
				
					local FAILED_TEXT = wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["FAILED_TEXT"];
					
					local FAILED_ON = SPELL_FAILED_NOT_BEHIND==FAILED_TEXT or SPELL_FAILED_ONLY_STEALTHED==FAILED_TEXT or SPELL_FAILED_AURA_BOUNCED==FAILED_TEXT or  SPELL_FAILED_NO_COMBO_POINTS==FAILED_TEXT or SPELL_FAILED_ONLY_OUTDOORS==FAILED_TEXT or SPELL_FAILED_ONLY_SHAPESHIFT==FAILED_TEXT or SPELL_FAILED_ONLY_STEALTHED==FAILED_TEXT  ;
					--print("2>>",FAILED_TEXT,FAILED_ON)
					if FAILED_ON then
						if GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] < wowam_config.SPELL_STOP_TIME then
							
						
							return false,wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["FAILED_TEXT"];
						
						end
						
					else
					
						if wowam.sys.SPELL_FAILED.SPELLINF[Spell] and wowam.sys.SPELL_FAILED.SPELLINF[Spell]["TIME"] then
					--print("3>>",GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[Spell]["TIME"] < wowam_config.SPELL_STOP_TIME,GetTime() -wowam.sys.SPELL_FAILED.SPELLINF[Spell]["TIME"] , wowam_config.SPELL_STOP_TIME)
							if GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[Spell]["TIME"] < wowam_config.SPELL_STOP_TIME then
								
							
								return false,wowam.sys.SPELL_FAILED.SPELLINF[Spell]["FAILED_TEXT"];
							
							end
						end
					
					end
				
				end
				
				
				wowam.sys.SPELL_FAILED.SPELLINF[UID]=nil;
				wowam.sys.SPELL_FAILED.SPELLINF[Spell]=nil;
				return true,"";
				--print(GetTime() - wowam.sys.SPELL_FAILED.SPELLINF[UID][Spell]["TIME"] > wowam_config.SPELL_STOP_TIME,Spell,Unit)
				
			end
			
			
						
			
			
			
			
			
			
			
			
			
		
		else
			--wowam.sys.SPELL_FAILED.SPELL_NOUNIT=nil;
			return true,"";
		end
		
	
	
	end
	

	return true,"";

end



function amjl(Unit1, Unit2)-- 判断距离
if not Unit2 then
  if not Unit1 then
   Unit1 = "target";
  end
  if not UnitName(Unit1) then
   return 100000000;
  end
  local _,jl = wowam_rc:getRange(Unit1)
  if not jl then
   return 100000000;
  end
  return jl;
else
  --参数类型格式化
  local i=0;
  if UnitInRaid("player") then
   if string.lower(string.sub(Unit1,1,4))~="raid" or string.lower(string.sub(Unit2,1,4))~="raid" then
    for i=1, GetNumRaidMembers() do
     local tempname, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);
     if tempname==Unit1 then
      Unit1="raid" .. tostring(i);
     end
     if tempname==Unit2 then
      Unit2="raid" .. tostring(i);
     end
    end
    if string.lower(string.sub(Unit1,1,4))~="raid" or string.lower(string.sub(Unit2,1,4))~="raid" then
     return 100000000;
    end
   end
  elseif UnitInParty("player") then
   if (string.lower(string.sub(Unit1,1,5))~="party" and string.lower(Unit1)~="player") or (string.lower(string.sub(Unit2,1,5))~="party" and string.lower(Unit2)~="player") then
    if UnitName("player")==Unit1 then
     Unit1="player";
    end
    if UnitName("player")==Unit2 then
     Unit2="player";
    end
    for i=1, GetNumPartyMembers() do
     local tempname=UnitName("party" .. tostring(i))
     if tempname==Unit1 then
      Unit1="party" .. tostring(i);
     end
     if tempname==Unit2 then
      Unit2="party" .. tostring(i);
     end
    end
    if (string.lower(string.sub(Unit1,1,5))~="party" and string.lower(Unit1)~="player") or (string.lower(string.sub(Unit2,1,5))~="party" and string.lower(Unit2)~="player") then
     return 100000000;
    end
   end
  else
   return 100000000;
  end
  --计算距离
  local _,mapheight,mapwidth=GetMapInfo();
  local unit1x, unit1y = GetPlayerMapPosition(Unit1);
  local unit2x, unit2y = GetPlayerMapPosition(Unit2);
  if mapheight and mapheight>0 and mapwidth and mapwidth>0 and unit1x and unit1x>0 and unit1y and unit1y>0 and unit2x and unit2x>0 and unit2y and unit2y>0 then
   local length=math.ceil(math.sqrt(math.pow((unit1x-unit2x)*mapwidth,2)+math.pow((unit1y-unit2y)*mapheight,2)));
   return length;
  else
   return 100000000;
  end
end
end



function amacp_bak(Spell,n,TargetClass,Spells,Unit,times)-------獲得對你或隊友施放讀條技能的敵對目標信息备份
	if Spell then
		if not amisr(Spell,"nogoal") then
			return
		end
	end
	
	if not n then
		n=1
	end
	
	if not Unit then
	
		Unit ="player"
	end
	
	if not times then
		times=9999999
	end
	
	local group=""
	local Members,i,k,Target
	local Casting,Target_1,cd,ist
	
	if amisarena() then
		for i=1, 5 do
		Target_1="arena" .. i;
		Target =Target_1 .. "-" .. "target"
		
			if UnitName(Target) or (Unit=="all" and UnitName(Target_1) )then
				if UnitGUID(Target)==UnitGUID(Unit) or Unit=="all" then
						
						
						
							if UnitCanAttack("player",Target_1) then
							
							
							
								if TargetClass then
														
									if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then
									
									--print(amzy(Target_1),Target_1,1)

										Casting = amac(Target_1)
										cd = amact(Target_1)							
										
										if cd ~=-1 then
										ist = (cd <= times)
										else
										ist = nil
										end
										
										if Casting and ist then
										
										
										
											if Spells then
											
											--print(Casting,0)
												if amfind(Spells,Casting) then
												--print(Target_1,Casting,2)
													if Spell then
														if amisr(Spell,Target_1) then
															return Target_1
														end
													else
														return Target_1
													end
												end
											else
												--print(Target_1,Casting)
												if Spell then
														if amisr(Spell,Target_1) then
															return Target_1
														end
												else
													return Target_1
												end
											
											end
										
										
										end
									end
								
								else
								
														
									if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then

										Casting = amac(Target_1)
										cd = amact(Target_1)							
										
										if cd ~=-1 then
										ist = (cd <= times)
										else
										ist = nil
										end
										
										if Casting and ist then
										
											if Spells then
												if amfind(Spells,Casting) then
												--print(Target_1,Casting,4)
													if Spell then
														if amisr(Spell,Target_1) then
															return Target_1
														end
													else
														return Target_1
													end
												end
											else
											--print(Target_1,Casting,5)
												if Spell then
														if amisr(Spell,Target_1) then
															return Target_1
														end
												else
													return Target_1
												end
											
											end
										
										
										end
									end
								
								end
							end
							
							
				end
					
			end
		end
	 return
	end
	
	
	
	Target ="targettarget"
	Target_1 ="target"
if UnitName(Target) or (Unit=="all" and UnitName(Target_1) )then
	if UnitGUID(Target)==UnitGUID(Unit) or Unit=="all" then
			
			
			
				if UnitCanAttack("player",Target_1) then
				
				
				
					if TargetClass then
											
						if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then
						
						--print(amzy(Target_1),Target_1,1)

							Casting = amac(Target_1)
							cd = amact(Target_1)							
							
							if cd ~=-1 then
							ist = (cd <= times)
							else
							ist = nil
							end
							
							if Casting and ist then
							
							
							
								if Spells then
								
								--print(Casting,0)
									if amfind(Spells,Casting) then
									--print(Target_1,Casting,2)
										if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
										else
											return Target_1
										end
									end
								else
									--print(Target_1,Casting)
									if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
									else
										return Target_1
									end
								
								end
							
							
							end
						end
					
					else
					
											
						if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then

							Casting = amac(Target_1)
							cd = amact(Target_1)							
							
							if cd ~=-1 then
							ist = (cd <= times)
							else
							ist = nil
							end
							
							if Casting and ist then
							
								if Spells then
									if amfind(Spells,Casting) then
									--print(Target_1,Casting,4)
										if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
										else
											return Target_1
										end
									end
								else
								--print(Target_1,Casting,5)
									if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
									else
										return Target_1
									end
								
								end
							
							
							end
						end
					
					end
				end
				
				
	end
		
end
	
	Target ="focustarget"
	Target_1 ="focus"
if UnitName(Target) or (Unit=="all" and UnitName(Target_1) )then
	if UnitGUID(Target)==UnitGUID(Unit) or Unit=="all" then
			
			
			
				if UnitCanAttack("player",Target_1) then
				
				
				
					if TargetClass then
											
						if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then
						
						--print(amzy(Target_1),Target_1,1)

							Casting = amac(Target_1)
							cd = amact(Target_1)							
							
							if cd ~=-1 then
							ist = (cd <= times)
							else
							ist = nil
							end
							
							if Casting and ist then
							
							
							
								if Spells then
								
								--print(Casting,0)
									if amfind(Spells,Casting) then
									--print(Target_1,Casting,2)
										if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
										else
											return Target_1
										end
									end
								else
									--print(Target_1,Casting)
									if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
									else
										return Target_1
									end
								
								end
							
							
							end
						end
					
					else
					
											
						if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then

							Casting = amac(Target_1)
							cd = amact(Target_1)							
							
							if cd ~=-1 then
							ist = (cd <= times)
							else
							ist = nil
							end
							
							if Casting and ist then
							
								if Spells then
									if amfind(Spells,Casting) then
									--print(Target_1,Casting,4)
										if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
										else
											return Target_1
										end
									end
								else
								--print(Target_1,Casting,5)
									if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
									else
										return Target_1
									end
								
								end
							
							
							end
						end
					
					end
				end
				
				
	end
		
end
	
	if GetNumRaidMembers()>0 then
		  group="raid"
		 Members =GetNumRaidMembers()
	elseif GetNumRaidMembers()==0 then
		return
	else
		group="party"
		Members =GetNumPartyMembers()
	end

	

	for i=1, Members do
		
		unit=group .. tostring(i);
		
		for k=2,n+1 do
		
			Target = unit .. strrep("target",k)
			Target_1=unit .. strrep("target",k-1)
			
			if not UnitName(Target) then
				break;
			end
			
			if UnitGUID(Target)==UnitGUID(Unit) or Unit=="all" then
			
			
	
			
			
			
				if UnitCanAttack("player",Target_1) then
				
				
				
					if TargetClass then
											
						if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then
						
						--print(amzy(Target_1),Target_1,1)

							Casting = amac(Target_1)
							cd = amact(Target_1)							
							
							if cd ~=-1 then
							ist = (cd <= times)
							else
							ist = nil
							end
							
							if Casting and ist then
							
							
							
								if Spells then
								
								--print(Casting,0)
									if amfind(Spells,Casting) then
									--print(Target_1,Casting,2)
										if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
										else
											return Target_1
										end
									end
								else
									--print(Target_1,Casting)
									if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
									else
										return Target_1
									end
								
								end
							
							
							end
						end
					
					else
					
											
						if amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1)) then

							Casting = amac(Target_1)
							cd = amact(Target_1)							
							
							if cd ~=-1 then
							ist = (cd <= times)
							else
							ist = nil
							end
							
							if Casting and ist then
							
								if Spells then
									if amfind(Spells,Casting) then
									--print(Target_1,Casting,4)
										if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
										else
											return Target_1
										end
									end
								else
								--print(Target_1,Casting,5)
									if Spell then
											if amisr(Spell,Target_1) then
												return Target_1
											end
									else
										return Target_1
									end
								
								end
							
							
							end
						end
					
					end
				end
				break;
				
			end
		
		
		end
	
	
	end
	
	
	return 


end



function amacp(Spell,n,TargetClass,Spells,Unit,times)--獲得對你或隊友施放讀條技能的敵對目標信息
	if Spell then
		if not amisr(Spell,"nogoal") then
			return
		end
	end
	
	if not n then
		n=1
	end
	
	if not Unit then
	
		Unit ="player"
	end
	
	if not times then
		times=9999999
	end
	
	local group=""
	local Members,i,k,Target
	local Casting,Target_1,cd,ist
	local isClass=true;
	local IsSpells=true;
	
	local IsPlayer=true;
	
	local T_UnitGUID=UnitGUID(Unit);
	local P_UnitGUID=UnitGUID("player");
	
	
	if amisarena() then
	
		for i=1, 5 do
		
			Target_1="arena" .. i;
			Target =Target_1 .. "-" .. "target"
			
			local IsUnitName_1 = UnitGUID(Target_1);
			local IsUnitName = UnitGUID(Target);
			
			if Unit == "player" then
				IsPlayer = IsUnitName == P_UnitGUID;
			elseif T_UnitGUID then
				IsPlayer = IsUnitName == T_UnitGUID;
			end
		
		
		
			if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
				
				
				if TargetClass then
				
					isClass = amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1));
								
				end
				
				
				if isClass then
				
					
					cd,_,Casting = amact(Target_1)							
					
					if cd ~=-1 and cd <= times then
					
						if Spells then
						
							IsSpells = amfind(Spells,Casting);
						end
						
						if IsSpells then
						
							if Spell then
								if amisr(Spell,Target_1) then
									return Target_1
								end
							else
								return Target_1
							end
						end
							
					
					end
					
				
				end
				
				
				
				
						
			end
		
		
	
		end
	
		return;
	
	end
	
	
	
	
	
	Target ="targettarget"
	Target_1 ="target"
			
			local IsUnitName_1 = UnitGUID(Target_1);
			local IsUnitName = UnitGUID(Target);
			
			if Unit == "player" then
				IsPlayer = IsUnitName == P_UnitGUID;
			elseif T_UnitGUID then
				IsPlayer = IsUnitName == T_UnitGUID;
			end
		
		
		
			if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
				
				
				if TargetClass then
				
					isClass = amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1));
								
				end
				
				
				if isClass then
				
					
					cd,_,Casting = amact(Target_1)							
					
					if cd ~=-1 and cd <= times then
					
						if Spells then
						
							IsSpells = amfind(Spells,Casting);
						end
						
						if IsSpells then
						
							if Spell then
								if amisr(Spell,Target_1) then
									return Target_1
								end
							else
								return Target_1
							end
						end
							
					
					end
					
				
				end
				
				
				
				
						
			end
		
	
	
	
	Target ="focustarget"
	Target_1 ="focus"
			
			local IsUnitName_1 = UnitGUID(Target_1);
			local IsUnitName = UnitGUID(Target);
			
			if Unit == "player" then
				IsPlayer = IsUnitName == P_UnitGUID;
			elseif T_UnitGUID then
				IsPlayer = IsUnitName == T_UnitGUID;
			end
		
		
		
			if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
				
				
				if TargetClass then
				
					isClass = amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1));
								
				end
				
				
				if isClass then
				
					
					cd,_,Casting = amact(Target_1)							
					
					if cd ~=-1 and cd <= times then
					
						if Spells then
						
							IsSpells = amfind(Spells,Casting);
						end
						
						if IsSpells then
						
							if Spell then
								if amisr(Spell,Target_1) then
									return Target_1
								end
							else
								return Target_1
							end
						end
							
					
					end
					
				
				end
				
				
				
				
						
			end
		
	
	
	

	if GetNumRaidMembers()>0 then
		  group="raid"
		 Members =GetNumRaidMembers()
	elseif GetNumRaidMembers()==0 then
		return
	else
		group="party"
		Members =GetNumPartyMembers()
	end

	

	for i=1, Members do
		
		unit=group .. tostring(i);
		
		for k=2,n+1 do
		
			Target = unit .. strrep("target",k)
			Target_1=unit .. strrep("target",k-1)
			
									
			local IsUnitName_1 = UnitGUID(Target_1);
			local IsUnitName = UnitGUID(Target);
			
			if not IsUnitName then
				break;
			end
			
			if Unit == "player" then
				IsPlayer = IsUnitName == P_UnitGUID;
			elseif T_UnitGUID then
				IsPlayer = IsUnitName == T_UnitGUID;
			end
		
		
		
			if IsUnitName_1 and IsUnitName and UnitCanAssist("player", Target) and IsPlayer then
				
				
				if TargetClass then
				
					isClass = amfind(TargetClass,amzy(Target_1)) or amfind(TargetClass,amezy(Target_1));
								
				end
				
				
				if isClass then
				
					
					cd,_,Casting = amact(Target_1)							
					
					if cd ~=-1 and cd <= times then
					
						if Spells then
						
							IsSpells = amfind(Spells,Casting);
						end
						
						if IsSpells then
						
							if Spell then
								if amisr(Spell,Target_1) then
									return Target_1
								end
							else
								return Target_1
							end
						end
							
					
					end
					
				
				end
				
				
				
				
						
			end
		
	
	
		
		
		end
	
	
	end
	
	
	return 


end




function amTalentInfo(Name)--獲得你的天賦某選項的信息
local Tabs = GetNumTalentTabs();
local i,k
	for i=1, Tabs do
		local Talents = GetNumTalents(i)
		for k=1, Talents do
			local Talentname, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(i,k)
			
			if Name == Talentname then
			
				return rank, maxRank
			
			end
		end
		
	
	
	end


	return nil;


end


function amTalentName() --获得当前天赋名称

local Tabs = GetNumTalentTabs();
local i,index,num

	for i=1, Tabs do
		local name, iconTexture, pointsSpent, background = GetTalentTabInfo(i)
		
		if num then
			if pointsSpent > num then
				num = pointsSpent
				index = i
			end
		else
		
			num = pointsSpent
			index = i
		end
			
	
	end
	
	local name, iconTexture, pointsSpent, background = GetTalentTabInfo(index)
	
	local _, _, pointsSpent1 = GetTalentTabInfo(1)
	local _, _, pointsSpent2 = GetTalentTabInfo(2)
	local _, _, pointsSpent3 = GetTalentTabInfo(3)
	local _, _, pointsSpent4 = GetTalentTabInfo(4)
	local _, _, pointsSpent5 = GetTalentTabInfo(5)
	
	return name,pointsSpent,pointsSpent1,pointsSpent2,pointsSpent3,pointsSpent4,pointsSpent5
	

end



 function amGetSpellID(spellname) --获得技能在技能书的ID
	local spellid = nil
	for tab = 1, 4 do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		for i = (1+offset), (offset+numSpells) do
			local spell = GetSpellName(i, BOOKTYPE_SPELL)
			if strlower(spell) == strlower(spellname) then
				spellid = i
				break
			end
		end
	end
	return spellid;
end

 function amGCD(spellname) --获得某职业的公告CD

	local spellid
	
	if spellname then
	spellid = GetSpellInfo(spellname)
	else
	
		if wowam.sys.GCDspellid==0 then
			return 0
		end
		spellid = GetSpellInfo(wowam.sys.GCDspellid)
	end
	
	if not spellid then
		return -1
	end
	
	
	local start, dur = GetSpellCooldown(spellid)

	if start>0 and dur>0 then
		--print(start,dur)
		 --print((GetTime() - start) , dur)
		 
		 return dur - (GetTime() - start) 
	end
	
	return 0
		 
end

 function amGCDFast(spellname) --获得某职业的公告CD
	
	
		if spellname then 
		
			return amGCD(spellname);
		else
			return wowam.sys.GCD;
		end
	
		
end

function amGetSpellID(spellname) -----获得技能ID
	if not spellname then
		spellname=GetSpellInfo(wowam.sys.GCDspellid)
	end

	local spellid = nil
	for tab = 1, 4 do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		for i = (1+offset), (offset+numSpells) do
			local spell = GetSpellName(i, BOOKTYPE_SPELL)
			if strlower(spell) == strlower(spellname) then
				spellid = i
				break
			end
		end
	end
	return spellid;
end


function amRAID_CLASS_COLORS()-------团队中职业颜色

for key,value in pairs(RAID_CLASS_COLORS) do
print(key,value)
end

end

function amtonumber(data)
local n;
	if not data then
		return 0;
	else
		n = tonumber(data) 
		if n then
			return n;
		else
			return 0;
		end
	end
end



function amIsActionInRange(Spell) ---执行在射程之内的法术技能
	local i = amfindbutton(Spell)
	
	if i >0 then
		return IsActionInRange(i)
	
	end
end


function amIsCurrentAction(Spell) ---执行当前法术技能
	local i = amfindbutton(Spell)
	
	if i >0 then
		return IsCurrentAction(i)
	
	end
end



function amGetRaidTargetIndex(Unit) --------获取团队成员的头标（大饼，星星）
	local i = GetRaidTargetIndex(Unit)
	if i then
		return i;
	else
		return 0;
	end
end


function amfindbutton(Spell) -------查找技能按钮
local i;
local name, rank
local gtype, pid

	if not Spell then
		return 0;
	end

	if not GetSpellInfo(Spell) then
	
		return 0;
	end

		
		for i=1,100 do
					
				gtype, pid = GetActionInfo(i)
		
					if gtype == "spell" then
						 name, rank  = GetSpellName(pid, BOOKTYPE_SPELL)
		
							if name then
								local sp = GetSpellInfo(name)
								local sp1 = GetSpellInfo(Spell) 
								
								if sp == sp1 then
									return i;
								end
												
							end
					end
		end					
					
return 0;
end


function amSetRaidTarget(Unit,Index) ---建立目标团队标识


--0 - 取消标记 1 - 星星 
--2 - 太阳 3 - 菱形 4 - 三角 5 - 月亮 6 - 方块 7 - 红叉 8 - 骷髅 
	if GetNumRaidMembers()>0 or GetNumPartyMembers()>0 then
		if IsRaidLeader() or IsPartyLeader() or IsRaidOfficer() then
			if not amGetRaidTargetIndex(Unit) == Index then
			SetRaidTarget(Unit,Index)
			end
			return true;
		end
	end
	
	
	


end

function amArenaDisperse(buffs,index)  ------牧师竞技场群体驱散
--local sysdb = Yjwow_Discipline_priest_db_SysSet
--local buffs = sysdb["群体驱散_EDIT1"]
local p = wowam.sys.spell_ex["暗言术：痛"]
local b = wowam.sys.spell_ex["群体驱散"]
local Unit
local sp
if not index then
	index=7
end

	if IsCurrentSpell(b) or amac("player")== b then
		return true;
	end

	if amisr(b,"nogoal") and (not IsCurrentSpell(b)) then
		Unit ="target"
		if amfind(buffs,ambufflist(Unit)) and amisr(p,Unit) then
			sp = "/stopcasting\n/cast [target=" .. Unit .. "]!" .. b
			amrun(sp);
			--amSetRaidTarget(Unit,index)
			return true;
		end
		
		Unit ="focus"
		if amfind(buffs,ambufflist(Unit)) and amisr(p,Unit) then
			sp = "/stopcasting\n/cast [target=" .. Unit .. "]!" .. b
			amrun(sp);
			--amSetRaidTarget(Unit,index)
			return true;
		end
		
		Unit = amarenainf("amisr('" .. p .."',unit) and amfind('" .. buffs .. "',ambufflist(unit))")
		
		
		if Unit then
			sp = "/stopcasting\n/cast [target=" .. Unit .. "]!" .. b
			amrun(sp);
			--amSetRaidTarget(Unit,index)
			return true;
		end
	end

	


end



function amArrangeBattle(Name,index)--自動進出戰場

	if ampdb(wowam.sys.spell_ex["逃亡者"])>-1 then
		battleASque=false;
		battleASreq=false;
		return false;
	end

	battleASque=battleASque or false;
	battleASreg=battleASreq or false;
	for i=1, MAX_BATTLEFIELD_QUEUES do
		status, mapName = GetBattlefieldStatus(i);
		
		--print(mapName,status,i);
		if mapName==Name and status~="none" then
			if status=="queued" or status=="confirm" then
				battleASque=true;
				
				
				if status=="confirm" then
				--print(status,i)
				
					if amArrangeBattle_in_time then
						
						if GetTime() - amArrangeBattle_in_time>5 then
					
							amrun("/run AcceptBattlefieldPort(" .. i ..",1)")
							--StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
							amArrangeBattle_in_time=nil;
						end
						
					else
						amArrangeBattle_in_time=GetTime();
					end
				end
			elseif status=="active" then
				battleAS:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
				battleASque=true;
			end
		elseif mapName==Name and status=="none" then
			battleASque=false;
			battleASreq=false;
		end
	end
	
	--print(">>",battleASque)
	
	if not battleASque then
		if not battleAS then
			battleAS=CreateFrame("Frame");
			battleAS:SetScript("OnEvent",function(self,event)
				if event=="PVPQUEUE_ANYWHERE_SHOW" then
					
						Wowam_Message(wowam.Colors.YELLOW .. "加入" .. Name .. "队列!");
						self:UnregisterEvent("PVPQUEUE_ANYWHERE_SHOW");
						JoinBattlefield(0);
						
					
				elseif event=="UPDATE_BATTLEFIELD_STATUS" and GetBattlefieldWinner() then
					self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS");
					LeaveBattlefield();
				end
			end);
			return false;
		end
		if not battleASreq then
			battleASreq=true;
			RequestBattlegroundInstanceInfo(index);
			battleAS:RegisterEvent("PVPQUEUE_ANYWHERE_SHOW");
			return false;
		end
	end
	return false;

end



function amlistSpellInfo(spell,index) -----查找技能、BUFF等等的 唯一ID

local k =1
	if not index then
		index =200000
	end

	for i=1,index do
						
				
		local name = GetSpellInfo(i)
		
		if name ==	spell then
		Wowam_Message(wowam.Colors.RED .. "(" .. k .. ") " ..  wowam.Colors.YELLOW .. name .. ", " .. wowam.Colors.CYAN .. tostring(i) )
		print(GetSpellInfo(i))
		k=k+1
		end
									
	end


end							
							


function amCountAttack_bak(Count,index)--獲得被競技場敵方集火的目標

	local name = {};
	local k,p;
	
	k =0;
	p = "";
	
	

	for i=1, 5 do
		unit="arena" .. i .. "target";
		if UnitCanAssist("player",unit) then
			 local n = name[UnitName(unit)]
			if n then
				name[UnitName(unit)] = name[UnitName(unit)] +1
			else
			
				name[UnitName(unit)]=1;
			end
			 
					
		end
	end
	
	for key,value in pairs(name) do
		if k then
			if value > k then
				k = value
				p = key
			end
		else
			k = value
			p = key
		end
	
	end
	
	
	
	return k,p


end		 




function ammpy(times) --------------牧师灭破羊
	local spell = {};
	
	spell["灭"] = 	GetSpellInfo(32996)
	spell["变形术"] = 	GetSpellInfo(118)
	
	if not times then
		times=1
	end
	
	local UNIT = amacp(spell["灭"],4,"MAGE",spell["变形术"],"player",times ) 
	 
	
			if UNIT then
				amrun("/stopcasting\n/cast [target=" .. UNIT .. "]" .. spell["灭"] )
				return spell["灭"];
			end
		
	 
	
 
end

function amisarena()--是否處於競技場或者戰場
local n = IsActiveBattlefieldArena()
return n
end

function aminspell(Spell,Unit,Stop,Time,key)------快速技能

	if not Time then
		Time=2;
	end
	
	amsv("sv_aminspell_Spell",Spell)
	amsv("sv_aminspell_Unit",Unit)
	amsv("sv_aminspell_Stop",Stop)
	amsv("sv_aminspell_Time",GetTime() + Time)
	amsv("sv_aminspell_key",key)
	
		--if Stop and amac("player") then
		--	amrun("/stopcasting");
		--end
	
end

function amruninspell()-----------运行快速技能


	if amgv("sv_aminspell_Time") and GetTime() >= amgv("sv_aminspell_Time") then
	
		amsv("sv_aminspell_Spell",nil)
		amsv("sv_aminspell_Unit",nil)
		amsv("sv_aminspell_Stop",nil)
		amsv("AOE准备点亮",nil);
		amsv("AOE已经点亮",nil);
		amsv("sv_aminspell_key",nil)
		return 
	end
	
	local Spell = amgv("sv_aminspell_Spell")
	local Unit = amgv("sv_aminspell_Unit")
	
	
	if not Unit or not Spell then
		return;
	end
	
	
	if ("Macro" == Unit or "macro" == Unit or "MACRO" == Unit or "M" == Unit) then
		
		if amGCD()<=0  then
			amrun(Spell)
			
			amsv("sv_aminspell_Spell",nil)
			amsv("sv_aminspell_Unit",nil)
			amsv("sv_aminspell_Stop",nil)
			amsv("sv_aminspell_key",nil)
			return Spell
		else
			return false;
		end

	end
	
	
	
	if strlower(Unit) == "aoe" then
		
		if amac("player")== spell then
		
			return true;
		
		end
	
		if amgv("AOE已经点亮") then
				
				if not IsCurrentSpell(Spell) then
				
					amsv("AOE已经点亮",nil);
					amsv("sv_aminspell_Spell",nil)
					amsv("sv_aminspell_Unit",nil)
					amsv("sv_aminspell_Stop",nil)
					amsv("sv_aminspell_key",nil)
					--print("AOE结束");
					return false;
				else
					if amgv("sv_aminspell_key") then
						ammouse(0,0,1);
					end
					return true;
				end
			
			
		end
	
		if amgv("AOE准备点亮") then
			if IsCurrentSpell(Spell) or amac("player")== spell then
				amsv("AOE准备点亮",nil);
				amsv("AOE已经点亮",true);
			
			--print("AOE已经点亮");
			return true;	
			end
			
			
			
			
		end
	
		
		
		if not IsCurrentSpell(Spell) then
			
						
			if amgv("sv_aminspell_Stop") then
				amrun("/stopcasting\n/cast !" .. Spell);
				
				amsv("AOE准备点亮",true)
				--print("AOE准备点亮");
				return Spell;
			end
			
			if  amisr(Spell,"nogoal") then
				amrun("/cast !" .. Spell);
				
				amsv("AOE准备点亮",true)
				--print("AOE准备点亮");
				return Spell;
			end
			
			
			
			
		end
		
		--print("AOE");
		return false;
	
	end
	
	if amisr(Spell,Unit) then
		--amrun(Spell,Unit)
		if amgv("sv_aminspell_Stop") then
			amrun("/stopcasting\n/cast [target=" .. Unit .. "]" .. Spell );
		else
			amrun("/cast [target=" .. Unit .. "]" .. Spell );
		end
		
		
		
		amsv("sv_aminspell_Spell",nil)
		amsv("sv_aminspell_Unit",nil)
		amsv("sv_aminspell_Stop",nil)
		return Spell
	end



end


function amiif(t,t1,t2)---------判断语句

	if t then
		return t1;
	else
		return t2;
	end

end


function amEraseTable(t) --清除表
	for i in pairs(t) do t[i] = nil end
end


function amequipped(name) ----获取自己是否佩戴有指定物品
	
	local n=1;
	local n1=18;
	local a, b, c;
	local isname = nil;
	local t = type(name);
	
	if t == "number" or t == "string" then
	
		if t == "number" then
			n=t;
			n1=t;
		end
	
		for i=n , n1 do
			
			
			local mainHandLink = GetInventoryItemLink("player",i)
				if mainHandLink then
					local spell = GetItemInfo(mainHandLink)
			
					if spell == name then
					
						isname =1;
						
						a, b, c = GetInventoryItemCooldown("player", i)
						
						if c ==0 or not a then
							return -1,isname;
						end
						
						n = a+b-GetTime()
		
						if n<0 then
							n=0
						end
						
						--n = format("%.2f",n);
						--n=tonumber(n);
						return n,isname;
					
						
					
					end
				end
	
	
		end
	end

	return -1,isname;
	
end



function amItemCooldown(Item)    -----------获得物品冷却CD

	local isname = nil;
	if GetItemInfo(Item) then
		isname=1;
	else
		return -1,isname;
	end
	
	local Equipped = IsEquippedItem(Item)
	
	
	
	local a,b,c = GetItemCooldown(Item);
		
		if c ==0 or not a then
			return -1,isname,Equipped;
		end
		
		n = a+b-GetTime()
	
		if n<0 then
			n=0
		end
		
		return n,isname,Equipped;
		
end


function amSpellCooldown(spell)------获得技能冷却CD

	local isname = nil;

	local a,b,c = GetSpellCooldown(spell) 
	
	if a then
		isname=1;
	else
		isname=nil;
		return -1,isname;
	end
	
	if c ==0 or not a then
		return -1,isname;
	end
		
		n = a+b-GetTime()
	
		if n<0 then
			n=0
		end
		
		return n,isname;
end

function amKey(key)

	Wowam_RunCommand(key);
end

function amcd(spell,Type) --技能CD冷却时间

	local n,is
	if Type then
		if Type ==1  then
		
			n,is = amItemCooldown(spell)
			
			if is then
				return n,is;
			end
		
		elseif Type ==0  then
		
		
			n,is = amSpellCooldown(spell)
			
			if is then
				return n,is;
			end
		
		else
			print("无法识别的技能或者物品，请和作者联繫解决问题。")
		end
		
		
	else
		n,is = amSpellCooldown(spell)
		
		if is then
			return n,is;
		end
		
		n,is = amItemCooldown(spell)
		
		if is then
			return n,is;
		end
		
		print("无法识别的技能或者物品，请和作者联繫解决问题。")
	
	end
	
	return -1,is;
	
	
	
	
	
	--[[
	
	

local i,n;
local d = GetItemSpell(spell)
local a,b,c = GetSpellCooldown(spell) 

              

	if d then
	
		a,b,c = GetItemCooldown(spell);
		
		n = a+b-GetTime()
	
		if n<0 then
			n=0
		end
		
		n = format("%.2f",n);
		n=tonumber(n);
		return n;
		
	
	elseif a  then
		
		a,b,c = GetSpellCooldown(spell) 
		n = a+b-GetTime()
	
		if n<0 then
			n=0
		end
		
			n = format("%.2f",n);
			n=tonumber(n);
			return n;
		
	else
		
			for i=13 , 18 do
			
			
			local mainHandLink = GetInventoryItemLink("player",i)
				if mainHandLink then
					local spell = GetItemInfo(mainHandLink)
			
					if spell == name then
						
						a, b, c = GetInventoryItemCooldown("player", i)
						
						n = a+b-GetTime()
		
						if n<0 then
							n=0
						end
						
						n = format("%.2f",n);
						n=tonumber(n);
						return n;
					
						
					
					end
				end
	
	
			end
		
		
		
		
		
	end
	--Wowam_Message(wowam.Colors.RED..spell..wowam.Colors.CYAN.." 名称错误，请检查！");
	return -1;
	
	--]]
end


function amcs(channel,String,Time) ------搜索频道内的信息

	local id, ChannelName =GetChannelName(channel)
	
	if not ChannelName then
		print("频道错误！")
		return;
	end
	
	if not String then
		print("日，没内容哦")
		return;
	end
	
	local s = amToLink(String)
	
	--print("a",s)
	if not s then
	
		return;
	end
	--print("b",s)
	--SendChatMessage(s , "CHANNEL", nil, id)
	
	amps_SCID=id;
	amps_s=s;
	
	amps_Time=Time;
	
	amps_T,amps_F=amps_T or 0,amps_F or CreateFrame("frame")
	
	if amps_X then 
		amps_X=nil 
	else 
		amps_X=function()
			local t=GetTime()
			if t- amps_T > amps_Time then 
				SendChatMessage(amps_s,"channel",nil,amps_SCID)
				amps_T=t 
			end 
		end 
	end amps_F:SetScript("OnUpdate",amps_X)
	
	
	
	
	
end

function amSIlink(Name) ---获得物品的和法术的名称然后发送的聊天框中

	local itemName, itemLink= GetItemInfo(Name)
	
	--print(11,itemName)
	
	if itemName then
	
		return itemLink;
	end
	
	local itemName, itemLink= GetSpellLink(Name) ---获得物品的
	
	--print(22,itemName)
	
	if itemName then
	
		return itemName;
	end
	
	return Name;

end


function amToLink(String) ---发送内容到聊天框
	
	String=string.gsub(String,"%[","' .. amSIlink('")
	String=string.gsub(String,"%]","') .. '")
	
	String = "'" .. String .. "'";
	--print(0,String)
	if strfind(String,"'' .. ") ==1 then
	--print(1,String)
		String=string.gsub(String,"'' .. ","",1)
	--	print(2,String)
	end
	
	--print(3,String)
	String=string.reverse(String)
	
	if strfind(String,"'' .. ") ==1 then
	--print(4,String)
		String=string.gsub(String,"'' .. ","",1)
		
	end
	
	String=string.reverse(String)
	
	--print(5,String)
	
	String ="return " .. String
	
	local a =loadstring(String)
	
	local b,c=a();
	
	if b then
		return b;
	else
		print("脚本错误",c)
	end
	
		
end

function amGetFollowUnit() --获得跟随目标  都是为了跟随目标函数服务的。

		
	
		return wowam.amisFollowUnit_Event
	
end

function amisFollowUnit_Event(event,...) --跟随目标事件
	if event=="AUTOFOLLOW_BEGIN" then
	
	wowam.amisFollowUnit_Event=arg1;
	
	elseif event=="AUTOFOLLOW_END" then
	wowam.amisFollowUnit_Event=nil;
	end
		
end


function amPassphrase(text)--消息密语

	if text then
		wowam_config.Passphrase_text=text;
		wowam_config.Passphrase= true;
	else
	
		wowam_config.Passphrase=false;
		
	
	
	end


end



function th_table_dup(ori_tab) --复制表
    if (type(ori_tab) ~= "table") then
        return nil;
    end
    local new_tab = {};
    for i,v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            new_tab[i] = th_table_dup(v);
        elseif (vtyp == "thread") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        elseif (vtyp == "userdata") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end



function ammaxtarget(String,StrReturn,group)----------目标小隊或者團隊裡最大的數值的人物信息
	local count =0;
	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"  or group=="arenapet" ) then
	DEFAULT_CHAT_FRAME:AddMessage("group 参数不对")
	return false
	end
	if String==nil or StrReturn == nil then
	DEFAULT_CHAT_FRAME:AddMessage("String 或 StrReturn 参数不能为空")
	return false
	end
	local str ='function TEMP_amcount(name,class,race,spell,unit,guid,spellcd) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	RunScript(str);
	local name,class,race,spell,unit,unit2,spellcd,guid;
	local Members,minimum,temp_unit ;
	local temp_n =nil;
	if group == "party" or group=="partypet"   then
	Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
	Members =GetNumRaidMembers() ;
	elseif group=="arena" then
	Members =5;
	elseif group=="arenapet" then
	Members =5;
	end
	for i=1,Members do
	if i==Members and group == "party" then
	unit="player"
	elseif i==Members and group == "partypet" then
	unit="pet"
	else
	unit=group .. tostring(i);
	end
	if UnitName(unit)then
	 --bufflist = ambufflist(unit);
	 name = UnitName(unit);
	 class = UnitClass(unit);
	 race = UnitRace(unit);
	 spell = amac(unit);
	 spellcd = amact(unit);
	 guid = UnitGUID(unit);
	 --内嵌循环
	if i<Members then
	 for j=i+1,Members do
	  if j==Members and group == "party" then
	   unit2="player"
	  elseif j==Members and group == "partypet" then
	   unit2="pet"
	  else
	   unit2=group .. tostring(j);
	  end
	  if UnitGUID(unit .. "target")==UnitGUID(unit2 .. "target") then
	   break;
	  end
	  if j==Members then
	   minimum = TEMP_amcount(name,class,race,spell,unit,guid,spellcd);
	  end
	 end
			end
			if i==Members then
	 minimum = TEMP_amcount(name,class,race,spell,unit,guid,spellcd);
	end
	 --内嵌循环
	--
	if minimum and minimum~=nil then  
	if temp_n == nil then  
	temp_n =minimum;
	temp_unit = unit;
	elseif minimum > temp_n then
	temp_n =minimum;
	temp_unit = unit;
	end
		count = count +1;
	end 
	--
	end
	end
	-- DEFAULT_CHAT_FRAME:AddMessage(v)
	return count,temp_unit;
end 



function amfindSpellId(spell) -----找法术ID数值


	for i=1,200000 do
						
				
		local name = GetSpellInfo(i)
		
		if name ==	spell then
			
			return i;
		end
									
	end


end	


function amArenaAc(TargetClass,Spells,Unit,times) ---获取竞技场里指定目標职业正在施放的法術名稱

	if amisarena() then
	
		local Arena,ArenaTarget,ArenaName,ArenaTargetName,Name;
		local IsamArenaAc = true;
	
		
		if Unit then
			Name = UnitName(Unit);
			if not Name then
				return false;
			end
		end
	
		for i=1, 5 do
		
			Arena = "arena" .. i;
			ArenaTarget =Arena .. "-target";
			
			ArenaName = UnitName(Arena);
			ArenaTargetName = UnitName(ArenaTarget);
			
			if ArenaName and ArenaTargetName then
			
				local AcCd,_,SpellName = amact(Arena);
				local isClass,IsSpells,IsTimes,IsUnit ;
				
				if Unit then
				
					IsUnit = ArenaTargetName == Name;
									
					
				else
				
					IsUnit = true;
				
				end
				
				
				if AcCd > 0 and IsUnit then
				
									
					if times then
						if AcCd <= times then
							IsTimes = true;
							
						else
							IsTimes =false;
						end
					else
						IsTimes = true;
					end
				
					if TargetClass then
					
						isClass = amfind(TargetClass,amzy(ArenaTarget)) or amfind(TargetClass,amezy(ArenaTarget));
						if not isClass then 
							isClass = false;
						else
							isClass = true;
						end
						
					else
					
						isClass = true;
					end
					
					
					if Spells then
					
						IsSpells = amfind(Spells,SpellName);
						if not IsSpells then 
							IsSpells = false;
						else
							IsSpells = true;
						end
						
					else
					
						IsSpells = true;
						
					end
				
					IsamArenaAc = isClass and IsSpells and IsTimes and IsUnit;
					
					if IsamArenaAc then
						return true,ArenaName,ArenaTargetName,SpellName;
					end
					
				end
			end
			
		end
	end
	
	return false;
	
end	
	

function amCountAttack() --2010-10-28 9:13 --------獲得被競技場敵方集火的目標

	local name = {};
	local Coun=0;
	local unittarget="";
	
	
	for i=1, 5 do
		unit=UnitName("arena" .. i .. "-target");
		if unit then
			
			if name[unit] then
				name[unit] = name[unit] +1
			else
			
				name[unit]=1;
			end
			
			if name[unit] > Coun then
			
				Coun = name[unit];
				unittarget=unit;
			end
			 
					
		end
	end
	
	return Coun,unittarget;
	
	

end	




function amAOE(spell)  ----------AOE释放
	
	
	
	if IsCurrentSpell(spell) or amac("player")== spell then
	
		amsv("AOE就能点亮",true)
		
		return true;
	else

		amsv("AOE就能点亮",nil)
		
		
	end
	
	if amisr(spell,"nogoal") and (not IsCurrentSpell(spell)) then
		
		
			local sp = "/stopcasting\n/cast !" .. spell ;
			amrun(sp);
			
			return true;
		
	end
	
	
	return false;


end


function ammouse(x,y,b)-----指定空间位置

	local k = "900" .. string.format("%04d", x) .. string.format("%04d", y) .. string.format("%01d", b) ;
	
	Wowam_Run_Key_Command("4",k)

end

	 
	 
function amMinHealthCast(DeBuffs,Buff,BuffOperator,BuffCd,Health,HealthOperator,Spell,Group)----傻瓜式获得小隊或團隊裡最小數值的人物或者对其施放技能
	 
	 local Operator = "==,<=,>=,>,<,~=";
	 local GroupStr = "party,partypet,raid,raidpet,arena,arenapet";
	 local TEMP;
	
	 
	 if DeBuffs and type(DeBuffs) ~= "string" then
		print("|cffff0000 DeBuffs 参数必须是字符串")
		return ;
	 end
	 
	 if Buff and type(Buff) ~= "string" then
		print("|cffff0000 Buff 参数必须是字符串")
		return ;
	 end
	 
	 if BuffCd and type(BuffCd) ~= "number" then
		print("|cffff0000 BuffCd 参数必须是数值")
		return ;
	 end
	 
	 if BuffOperator and type(BuffOperator) ~= "string" then
		print("|cffff0000 BuffOperator 参数必须是字符串")
		return ;
	 end
	 
	 
	 if Health and type(Health) ~= "number" then
		print("|cffff0000 Health 参数必须是数值")
		return ;
	 end
	 
	 if Spell and type(Spell) ~= "string" then
		print("|cffff0000 Spell 参数必须是字符串")
		return ;
	 end
	 
	 if Group and type(Group) ~= "string" then
		print("|cffff0000 Group 参数必须是字符串")
		return ;
	 end
	 
	 if HealthOperator and type(HealthOperator) ~= "string" then
		print("|cffff0000 HealthOperator 参数必须是字符串")
		return ;
	 end
	 
	 if BuffOperator and not amfind(BuffOperator,Operator) then
		print("|cffff0000 BuffOperator 参数格式必须是:" .. Operator )
		return ;
	 end
	 
	 if HealthOperator and not amfind(HealthOperator,Operator) then
		print("|cffff0000 HealthOperator 参数格式必须是:" .. Operator )
		return ;
	 end
	 
	 if Buff then
		if not (BuffOperator and BuffCd) then
			print("|cffff0000 BuffOperator,BuffCd 参数不能缺")
			return ;
		end
	 end
	 
	 if Health then
		if not (HealthOperator) then
			print("|cffff0000 HealthOperator 参数不能缺")
			return ;
		end
	 end
	 
	 if not Group then
		print("|cffff0000 Group 参数必须指定")
		return ;
	 end
	 
	 
	 if Group and not amfind(Group,GroupStr) then
		print("|cffff0000 Group 参数格式必须是:" .. GroupStr )
		return ;
	 end
	 
	 
	 
	if Spell and amcd(Spell)>0 then
		return ;
	end
	 
	 
	 
	local str ;
	 
	if DeBuffs then
		DeBuffs = 'amfind(ambufflist(unit),"'.. DeBuffs .. '")';
		
		str = DeBuffs;
		
	end
	
	
	if Spell then
			
		TEMP = 'amisr("' .. Spell .. '",unit)';
		
		if str then
			str = str .. " and " .. TEMP;
		else
			str = TEMP;
		end
		
	end
	 
	if Buff and BuffCd then
		Buff = 'amaura("' .. Buff .. '",unit)' .. BuffOperator .. BuffCd ;
		
		if str then
			str = str .. " and " .. Buff;
		else
			str = Buff;
		end
		
	end
	 
	if Health then
		Health = 'aml(unit,"%")' .. HealthOperator .. Health ;
		
		if str then
			str = str .. " and " .. Health;
		else
			str = Health;
		end
		
	end
	
	
	 
	if not str then
		str = true;
		
	else
		local text = 'amisr("' .. Spell..'",unit) and UnitIsConnected(unit) and not UnitIsCorpse(unit) and not UnitIsDeadOrGhost(unit)';
		
		str = str .. " and " .. text;
	end
	 
	 
	local Unit = amminimumFast(str,'aml(unit,"%")',Group)
	
	
	if Spell and Unit then

		amrun(Spell,Unit);
		--print(Spell,Unit);
		return Unit; 
	else
	
		return Unit; 
	end
end



function amminimumFast(String,StrReturn,group) --小队或者团队里最小的数值的人物信息


	if not(group == "party" or group=="partypet"  or group=="raid"  or group=="raidpet" or group=="arena"   or group=="arenapet" ) then
	print("|cffff0000 group 参数不对")
	return false
	end

 
	if String==nil or StrReturn == nil then
	
		print("|cffff0000 String 或 StrReturn 参数不能为空")
		return false
	end
	--print(String,"----",StrReturn)
	local str ='function TEMP_amminimum(unit) if ' .. String .. ' then return ' .. StrReturn .. '; else return false; end end'
	
	if wowam.player.Custom.Variable["amminimumFast_str"] then
		
		if wowam.player.Custom.Variable["amminimumFast_str"] ~= str then
			RunScript(str);
		end
	else
	
		RunScript(str);
		wowam.player.Custom.Variable["amminimumFast_str"] = str;
	end
	
	
	--RunScript(str);
	
	local unit;
	
	local Members ,minimum,temp_unit ;
	local temp_n =nil;
	
	if group == "party" or group=="partypet"   then
		Members =GetNumPartyMembers()+1 ;
	elseif group=="raid"  or group=="raidpet" then
		Members =GetNumRaidMembers() ;
	elseif group=="arena" then
		Members =5;
	elseif group=="arenapet" then
		Members =5;
	end

	for i=1, Members do
		if i==Members and group == "party" then
		unit="player"
		elseif i==Members and group == "partypet" then
		unit="pet"
		else
		unit=group .. tostring(i);
		end
		
		if UnitName(unit) then
							 
		 minimum = TEMP_amminimum(unit);
		 --print(UnitName(unit),minimum)	
			if minimum then
			 
				if temp_n == nil then
				 
					temp_n =minimum;
					temp_unit = unit;
				elseif minimum < temp_n then
					temp_n =minimum;
					temp_unit = unit;
				end
			end	
				 
		end
		
		
		
	end
	
	if temp_unit then
	
	 wowam.player.Custom.Variable["amminimumFast_unit"] = temp_unit;
				 
	 return temp_unit;
	end


	return false
end


function MouseDisperse() ----鼠标指向驱散

	local b = wowam.sys.spell_ex["群体驱散"]
	local Unit ="mouseover"
	local sp
	local buffs = amMouseDisperse_buffs;
	local stop = amMouseDisperse_stop;
	local Delay = amMouseDisperse_Delay;
	
	if not buffs then
		return ;
	end
	
	if amMouseDisperse_DelayTime then
	--print(GetTime() - amMouseDisperse_DelayTime,amMouseDisperse_Delay)
		if GetTime() - amMouseDisperse_DelayTime < amMouseDisperse_Delay then
			return ;
		else
			amMouseDisperse_DelayTime = nil ;
		end
	end
	
	if amMouseDisperse_time then

		if GetTime() - amMouseDisperse_time <0.05 then
			return ;
		else
			amMouseDisperse_time = GetTime();
		end
	else
		amMouseDisperse_time = GetTime();
	end
	
	
	
	if not UnitName(Unit) then
		return true;
	end
	
	if amac("player")==b then
		amMouseDisperse_AC=true;
		amMouseDisperse_DelayTime=nil;
	else
		if amMouseDisperse_AC then
			amMouseDisperse_DelayTime = GetTime();
			amMouseDisperse_AC=nil;
		end
	end
	
	

		if IsCurrentSpell(b) then
			
			if not amMouseDisperse_Insert then
				ammouse(0,0,1);
			end
			return true;
		end

		if amisr(b,"nogoal") and (not IsCurrentSpell(b)) then
	--print("dd>",amfind(buffs,ambufflist(Unit)),amjl(Unit))		
			if amfind(buffs,ambufflist(Unit)) and amjl(Unit)<=30 then
				
				if stop then
					sp = "/cast [target=" .. Unit .. "]!" .. b
				else
					sp = "/stopcasting\n/cast [target=" .. Unit .. "]!" .. b
				end
				
				if amMouseDisperse_Insert then
					aminspell(b,"aoe",1,nil,1)
				else
					amrun(sp);
				end
				return true;
			end
			
		end	

		

end

function amMouseDisperse(buffs,stop,Delay,Insert) ---鼠标指向驱散拓展
	
	if not Delay then
		Delay=0;
	end
	amMouseDisperse_buffs=buffs;
	amMouseDisperse_stop=stop;
	amMouseDisperse_Delay=Delay;
	amMouseDisperse_Insert = Insert;
	if not buffs and not stop then
		amMouseDisperse_Frame:UnregisterEvent("OnUpdate");
		amMouseDisperse_Frame=nil;
		return true;
	end

	if not amMouseDisperse_Frame then
		amMouseDisperse_Frame = CreateFrame("Frame");
		amMouseDisperse_Frame:SetScript("OnUpdate",MouseDisperse)
	end

	


end





function amOvale()--------Ovale：全职业输出助手插件
   
	if not Ovale then

		print("|cffff0000Ovale全职业输出助手插件没有安装！")

	else
		
		local spellName = Ovale["frame"]["actions"][1]["spellName"];
		
		if not amac() and amisr(spellName,"target") then
			amrun(spellName,"target");
			
			if SuperTreatmentInf then
				
				local ST = SuperTreatmentInf;
				ST.showruninf(amGetSIlink(spellName),"target");
				
			end
				
			return true;
		end

	end
   
    
end


--[[
function zcgj(index)
battleASque=battleASque or false;
battleASreq=battleASreq or false;
if index==4 then amsv("zcgj_zcname","奥特兰克山谷");
elseif index==2 then amsv("zcgj_zcname","战歌峡谷");
elseif index==3 then amsv("zcgj_zcname","阿拉希盆地");
elseif index==5 then amsv("zcgj_zcname","风暴之眼");
elseif index==6 then amsv("zcgj_zcname","远古海滩");
elseif index==7 then amsv("zcgj_zcname","征服之岛");
elseif index==1 then amsv("zcgj_zcname","随机战场");
end
	if ampdb("逃亡者")>0 then
		battleASque=false;
		battleASreq=false;
		return false;
	end
for i=1, MAX_BATTLEFIELD_QUEUES do
    status, mapName = GetBattlefieldStatus(i);
    if (mapName=="奥特兰克山谷" or mapName=="战歌峡谷" or mapName=="阿拉希盆地" or mapName=="风暴之眼" or mapName=="远古海滩"  or mapName=="征服之岛" or mapName=="随机战场") and status~="none" then
        if status=="queued" or status=="confirm" then
            battleASque=true;
            if status=="confirm" then
					if amgv("zcgj_time") then
						if GetTime() - amgv("zcgj_time")>5 and not IsFalling() then
                            amrun("/run AcceptBattlefieldPort(".. i ..",1)")
--							StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY");
							amsv("zcgj_time",nil)
							print(status,i);
						end
					else
						amsv("zcgj_time",GetTime());
					end
            end
        elseif status=="active" then
            battleAS:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
            battleASque=true;
        end
    elseif (mapName=="奥特兰克山谷" or mapName=="战歌峡谷" or mapName=="阿拉希盆地" or mapName=="风暴之眼" or mapName=="远古海滩"  or mapName=="征服之岛" or mapName=="随机战场") and status=="none" then
        battleASque=false;
        battleASreq=false;
    end
end
if not battleASque then
    if not battleAS then
        battleAS=CreateFrame("Frame");
        battleAS:SetScript("OnEvent",function(self,event)
            if event=="PVPQUEUE_ANYWHERE_SHOW" then
                self:UnregisterEvent("PVPQUEUE_ANYWHERE_SHOW");
                JoinBattlefield(0);
                Wowam_Message(wowam.Colors.YELLOW .. "加入" .. amgv("zcgj_zcname") .. "队列!");
            elseif event=="UPDATE_BATTLEFIELD_STATUS" and GetBattlefieldWinner() then
                self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS");
                LeaveBattlefield();
            end
        end);
        return false;
    end
    if not battleASreq and (select(2,IsInInstance()) == "none") then
        battleASreq=true;
			battleAS:RegisterEvent("PVPQUEUE_ANYWHERE_SHOW");
			RequestBattlegroundInstanceInfo(index);
			return false;
		end
	end
	return false;
end

--]]


function amrs()-- 特殊能量
	
	
	
	return -1;
	
end

function ampettext()
	
	local str="";
	
	for i=1, NUM_PET_ACTION_SLOTS do
      local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
      
      if not name then
      	break;
      	
      end
     
	 str =str .. "(".. i .. ")" ..  name .. ",".. texture .. ",";
      
    end
	
	amtext=str;
	return str;
	
end	


function amisActivePet(v)-- 宠物状态按钮
	
	for i=1, NUM_PET_ACTION_SLOTS do
      local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
      
      if not name then
      	break;
      	
      end
	  
	  if name == v then
      	
      	return isActive;
      end
    
      
    end
	
	return false;
	
end

function amautoCastEnabledPet(v)-- 宠物技能是否能激活状态
	
	for i=1, NUM_PET_ACTION_SLOTS do
      local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
      
      if not name then
      	break;
      	
      end
	  
	  if name == v then
      	
      	return autoCastEnabled;
      end
    
      
    end
	
	return false;
	
end

function amautoCastAllowedet(v)-- 宠物技能是否能激活
	
	for i=1, NUM_PET_ACTION_SLOTS do
      local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
      
      if not name then
      	break;
      	
      end
	  
	  if name == v then
      	
      	return autoCastAllowed;
      end
    
      
    end
	
	return false;
	
end


function amIsCurrentMouse(Spell)-- 技能正在执行时按下鼠标左键

	if IsCurrentSpell(Spell) then
		ammouse(0,0,1);
		return true;
	end
	return false;
end

function amSdmRun(name,unit) -------超级宏脚本命令 SuperMacro
	local luaText = nil
	for i,v in pairs(sdm_macros) do
		if v.type=="s" and v.name==name and sdm_UsedByThisChar(v) then
			luaText=v.text;
			break;
		end
	end
	if luaText then
	
						
		luaText=gsub(luaText,"*unit",unit);
				
		local func = assert(loadstring(luaText));
		local v= func();
		
		return v;
		--RunScript(luaText)
	else
		print("找不到["..name.."]脚本.")
	end
	
	return false;
	
end

function amCancelUnitBuff(unit,buff)--取消指定的BUFF 
	
	if amaura(buff,unit,2,0)>0 then
		CancelUnitBuff(unit,buff);
		return true;
	end
	return false;
end

function amGetSIlink(Name)

	local itemName, itemLink= GetItemInfo(Name)
	
	--print(11,itemName)
	
	if itemName then
	
		return itemName;
	end
	
	local itemName, itemLink= GetSpellLink(Name)
	
	--print(22,itemName)
	
	if itemName then
	
		return itemName;
	end
	
	return Name;

end	 


function amSetFocus(unit,Name) --指向焦点宏

	local mouseover = UnitName("mouseover");
	local focus = UnitName("focus");
	
	if not Name or not unit or not mouseover then return false; end;
	
	if mouseover == Name and focus ~= Name then
	
		amrun("/focus mouseover");
		return true;
	end
	
	return false;
	
	

end 



function amFollowUnit(unit)--跟随目标
		
	if not unit or not amGetFollowUnit() then
	
		return false;
	
	end
	
	if amGetFollowUnit() == unit then
	
	
	elseif UnitName(unit) and amjl(unit)<=25 then
		
		FollowUnit(unit);
		
		return true;
	end
		
	
		return false;
	
end



function amsubgroup(Unit) --获得指定目标在团队中的小队编号

	if Unit == nil then
	Unit = "player"
	end
	local k = GetNumRaidMembers()
					
		for i=1 , k do
			local name, _, subgroup = GetRaidRosterInfo(i);
			if UnitGUID(Unit) == UnitGUID(name) then
				return subgroup;
							
			end
		end
	
	
	return 0;
end

function amGetInventoryItemDurability(invSlot)----装备持久度
	
	local L,H = GetInventoryItemDurability(invSlot);
	
	return tonumber(format("%.0f", L/H *100));

end

function amIsCurrentMouse(Spell)-- 技能正在执行时按下鼠标左键
	if IsCurrentSpell(Spell) then
		BeeMouse(0,0,1,Spell);
		return true;
	end
	return false;
end



