function WowBee_Message(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end;

function WowBee_OnLoad(self)
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	self:RegisterEvent("PLAYER_ENTER_COMBAT");
	self:RegisterEvent("PLAYER_LEAVE_COMBAT");
	self:RegisterEvent("PLAYER_LOGOUT")	;
	self:RegisterEvent("COMBAT_TEXT_UPDATE")	;
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("CHAT_MSG_WHISPER");
	self:RegisterEvent("COMBAT_LOG_EVENT");
	self:RegisterEvent("LFG_PROPOSAL_SHOW")	
	
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
	self:RegisterEvent("CHAT_MSG_ADDON");

	self:RegisterEvent("AUTOFOLLOW_BEGIN");
	self:RegisterEvent("AUTOFOLLOW_END");
	self:RegisterEvent("ACTIONBAR_UPDATE_STATE");
	self:RegisterEvent("ACTIONBAR_UPDATE_USABLE");

	self:RegisterEvent("PET_ATTACK_START");
    self:RegisterEvent("PET_ATTACK_STOP");
	
	self:RegisterEvent("UNIT_HEAL_PREDICTION"); -- 获得治疗目标
	self:RegisterEvent("UNIT_SPELLCAST_SENT"); -- 施放目标技能

	self:RegisterEvent("UNIT_SPELLCAST_STOP");
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	self:RegisterEvent("UNIT_SPELLCAST_FAILED");
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	self:RegisterEvent("UNIT_COMBAT");
	WowBee_Load();
end

function WowBee_OnEvent(self, event,...)
	WowBee_SpellMiss_OnEvent(self,event,...);
	WowBee_SpellFailed_OnEvent(self,event,...);

	if ( event == "PLAYER_ENTER_COMBAT" )  then
		WowBee.Spell.Event.Combat=1;
	elseif ( event == "PLAYER_LEAVE_COMBAT" )  then
		WowBee.Spell.Event.Combat=0;
	elseif ( event == "PET_ATTACK_START" )  then
        WowBee.Spell.Event.PetCombat=1;
    elseif ( event == "PET_ATTACK_STOP" )  then
        WowBee.Spell.Event.PetCombat=0;
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED")  then--?
	--[[
		if WowBee.Spell.Miss1 then
			if arg3 == UnitGUID("player") then
				local spellID = arg9
				local timpw = GetSpellInfo(spellID)
				print("技能ID对照",timpw,spellID)
			end
		end
		
		local _, _, prefix, suffix = string.find(arg2, "(.-)_(.+)")
		local src = arg4
		local time=GetTime()
				
		if src==WowBee.Player.Name then 
			--local spellname=select(10,...) or nil;
			local spellname=arg10
					
			if spellname=="风怒攻击" then
				WowBee.Spell.Event.Spell.Hot.Times[spellname]=GetTime() + 4;
			end
		end
		
		if (prefix=="SWING") then
			if suffix=="MISSED" then
				if (arg9)=="DODGE"  and arg4==WowBee.Player.Name then
					WowBee.Spell.Event.Combat.DODGE.Sleep = GetTime();
					WowBee.Spell.Event.Combat.DODGE.Start=1
				elseif (arg9)=="PARRY"  and arg7==WowBee.Player.Name  then
					WowBee.Spell.Event.Combat.PARRY.Sleep = GetTime();
					WowBee.Spell.Event.Combat.PARRY.Start=1
				end
			end
		elseif (prefix=="SPELL") then	
		end 
	]]
	end
	
	if (event=="CHAT_MSG_WHISPER" and WowBee.Spell.Event.PhraseText ~= "") then--WowBee.Sync.Verify > 0
		if UnitGUID("player")~=UnitGUID(arg2) then
			SendChatMessage(WowBee.Spell.Event.PhraseText,"WHISPER",nil,arg2)
		end
	end
	
	if (event == "LFG_PROPOSAL_SHOW" and WowBee.Spell.Event.Proposal) then--WowBee.Sync.Verify > 0
		BeeRun("/run AcceptProposal()");
	end
	
	if (event=="AUTOFOLLOW_BEGIN") then
		WowBee.Spell.Event.FollowUnit=arg1;
	elseif (event=="AUTOFOLLOW_END") then
		WowBee.Spell.Event.FollowUnit=nil;
	end
	

end

function WowBee_OnUpdate(arg1)
	if GetTime() - WowBee.Spell.Combat_Sleep >1 then
		local temp=UnitAffectingCombat("player");
		
		if  temp and not WowBee.Spell.Combat then
			WowBee.Spell.Combat=1;--print("进入战斗")
		elseif not temp and WowBee.Spell.Combat then
			WowBee.Spell.Combat=nil;--print("离开战斗")
		end
		WowBee.Spell.Combat_Sleep=GetTime();
	end
	
	if GetTime() - WowBee.Spell.Delay_Sleep >1 then
		if(WowBee.Spell.Delay and type(WowBee.Spell.Delay) == "table" )then
			for k, v in pairs(WowBee.Spell.Delay) do
				if type(v) == "table" then
					for k1, v1 in pairs(v) do
						if v1 and type(v1) == "table" and not v1["DelayTime"] and v1["Status"] and v1["Status"] == "End" and (not v1["EndTime"] or GetTime() - v1["EndTime"]>1)then
							WowBee.Spell.Delay[k][k1]=nil;
						end
					end
				end
				
				local  cc=0;
				table.foreach(WowBee.Spell.Delay[k], function(i2, v2) cc=cc+1; end);

				if( cc==0) then
					WowBee.Spell.Delay[k]=nil;
				end
			end
		end
		WowBee.Spell.Delay_Sleep=GetTime();
	end
end;

function WowBee_Load()
		
		if not WowBee.Config.OLDSPELL_STOP_TIME then
			WowBee.Config.OLDSPELL_STOP_TIME = WowBee.Config.SPELL_STOP_TIME;
			WowBee.Config.SPELL_STOP_TIME=0.5;
		end
		
		if not WowBee.Config.Formats or (WowBee.Config.Formats and not WowBee.Config.Formats["判断结果"]) then
			WowBee.Config.Formats={};
			WowBee.Config.Formats["判断结果"]="结果:%s";
			WowBee.Config.Formats["技能类型"]="类型:%s";
			WowBee.Config.Formats["说明"]="说明:%s";
			WowBee.Config.Formats["施放目标"]="目标:%s";
			WowBee.Config.Formats["技能名称"]="技能:%s";
			WowBee.Config.Formats["冷却时间"]="冷却:%.1f"
			WowBee.Config.Formats["过滤调试信息"]="";
		end
		
		if not WowBee.Config.IsShow or (WowBee.Config.IsShow and not WowBee.Config.IsShow["显示调试信息"]) then
			WowBee.Config.IsShow={};
			WowBee.Config.IsShow["显示调试信息"]=nil;
			WowBee.Config.IsShow["显示成功的调试信息"]=nil;
			WowBee.Config.IsShow["显示失败的调试信息"]=nil;
			WowBee.Config.IsShow["显示判断结果"]=true;
			WowBee.Config.IsShow["显示技能类型"]=true;
			WowBee.Config.IsShow["显示说明"]=true;
			WowBee.Config.IsShow["显示施放目标"]=true;
			WowBee.Config.IsShow["显示技能名称"]=true;
			WowBee.Config.IsShow["显示冷却时间"]=true;
			WowBee.Config.IsShow["过滤调试信息"]=nil;
		end
end


WowBee.cls={{101,112,100},{98,111,101},{112,110,110}}

function WowBee_SpellMiss_OnEvent(self, event,...) --//amtob
	--[[local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;
	arg1,arg2 = select(1, ...);
	arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);]]
	
	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;

	if tonumber((select(4, GetBuildInfo()))) >= 40200 then	
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,_,arg6,arg7,arg8,_,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	else
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	end
	
	if ( event == "COMBAT_LOG_EVENT_UNFILTERED" and arg2)  then
	
		local _, _, prefix, suffix = string.find(arg2, "(.-)_(.+)")
		local playerName = UnitName("player");
		local SMT= WowBee.Spell.Miss.MissType;
		
		if (playerName == arg4 or playerName == arg7) then
		
			if arg9=="DODGE" or arg9=="RESIST" or arg9=="PARRY" or arg9=="MISS" or arg9=="BLOCK"  or arg9=="REFLECT"  or arg9=="DEFLECT"  or arg9=="IMMUNE"  or arg9=="EVADE" then	
				local T = GetTime();
				SMT[arg9] = SMT[arg9] or {};
				
				if arg3 then
					SMT[arg9]["SourceGUID-" .. arg3] = T;
				end
				
				if arg6 then
					SMT[arg9]["DestGUID-" .. arg6] = T;
				end
				
				if arg3 and arg6 then
					SMT[arg9][arg3 .. "-" .. arg6] = T;
				end
				
				SMT[arg9]["Time"]=T;			
			end
			
			WowBee.Spell.Miss.Name[tostring(arg10)] = GetTime();
		end
		
		if suffix =="INTERRUPT" or suffix =="MISSED" or suffix =="CAST_SUCCESS" or suffix =="CAST_FAILED" or suffix =="CREATE" or suffix =="SUMMON" or suffix =="INSTAKILL" or suffix =="EXTRA_ATTACKS" or suffix =="ENERGIZE" or suffix =="HEAL" then
			WowBee.Spell.Miss.Name[arg3 .. "_" .. tostring(arg10)] = GetTime();
		end
	end
end

function WowBee_SpellFailed_OnEvent(self, event, ...)
	--[[local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;
	arg1,arg2 = select(1, ...);
	arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);]]
	
	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16;

	if tonumber((select(4, GetBuildInfo()))) >= 40200 then	
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,_,arg6,arg7,arg8,_,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	else
		arg1,arg2 = select(1, ...);
		arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16 = select(4, ...);
	end
	
	
	--[[if (event == "ACTIONBAR_UPDATE_COOLDOWN")  then
		print("<<",arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16);
		local gcd = BeeGCD();
		local spellName, spellSubName,skillType, spellId  ;
		if gcd==0 and BeeCastSpell and BeeCastUnit and UnitGUID(BeeCastUnit) and IsCurrentSpell(BeeCastSpell) then
			spellName, spellSubName =GetSpellInfo(BeeCastSpell);
			BeeCastInfo = BeeCastInfo or {};
			BeeCastInfo["SpellName"]=spellName;
			BeeCastInfo["Macro"]="";
			BeeCastInfo["Time"]=GetTime();
			BeeCastInfo["Unit"]=BeeCastUnit;
			BeeCastInfo["SpellId"]=BeeCastSpell;
			--print("<<",spellName,GetTime()-BeeCastTime)
		elseif gcd==0 and BeeCastUnit and BeeCastSpell and not IsCurrentSpell(BeeCastSpell) then
	
			local ac = BeeUnitCastSpellName("player");

			if BeeCastInfo and BeeCastInfo["SpellName"] and BeeCastInfo["Unit"] and not ac and BeeCastInfo["Time"] and GetTime() -BeeCastInfo["Time"]<1 and GetTime() -BeeCastInfo["Time"]>0 then
				BeeUnitCastSpellDelay(BeeCastInfo["SpellName"],0.5,BeeCastInfo["Unit"]);
			else
				BeeCastInfo={};
			end
		end
	end]]
	
	--[[if (event == "UNIT_HEAL_PREDICTION")  then
		--print("1>>",event,arg1,arg2,arg3,arg4)
		local guid = UnitGUID(arg1);
		if guid then
			WowBee.Spell.Cast=WowBee.Spell.Cast or {};
			WowBee.Spell.Cast["HEAL_PREDICTION"]=WowBee.Spell.Cast["HEAL_PREDICTION"] or {};
			WowBee.Spell.Cast["HEAL_PREDICTION"][guid]=WowBee.Spell.Cast["HEAL_PREDICTION"][guid] or {};
			WowBee.Spell.Cast["HEAL_PREDICTION"][guid]["heal"]=UnitGetIncomingHeals(arg1);
			WowBee.Spell.Cast["HEAL_PREDICTION"][guid]["name"]=arg1;
		end
	end]]
	
	
	--[[if (event == "ACTIONBAR_UPDATE_COOLDOWN")  then
		local gcd = BeeGCD();
		if(WowBee.Spell.Casting["Spell"])then
		print("-->>",gcd,WowBee.Spell.Casting["Spell"],IsCurrentSpell(WowBee.Spell.Casting["Spell"]))
		if gcd==0 and  not IsCurrentSpell(WowBee.Spell.Casting["Spell"]) then
		
			local ac = BeeUnitCastSpellName("player");
			print("----",ac,0.5,WowBee.Spell.Casting["Spell"])

		end
		end
	end
	]]
	if (event == "UNIT_SPELLCAST_SENT") then

		local guid = UnitGUID(arg3);
		local target=arg3;
		--print(">>",UnitGUID(arg3),event,arg1,arg2,arg3,arg4)	
		if not arg3 or arg3=="" or arg3==UnitName("player") then
			guid = UnitGUID("player");
			target ="player";
		elseif not guid and arg3==UnitName("target") then
			guid = UnitGUID("target");
			target ="target";
		elseif not guid and arg3==UnitName("focus") then
			guid = UnitGUID("focus");
			target="focus";
		end

		if guid then
			WowBee.Spell.Casting=WowBee.Spell.Casting or {};
			
			local tbl = WowBee.Spell.Casting;
			
			tbl["Time"] = GetTime();
			tbl["Index"] = arg4;
			tbl["GUID"] = guid;
			tbl["Unit"] = target;
			tbl["Spell"]=arg2;
			tbl["SpellId"]=arg4;
			
			if(WowBee.Spell.Delay and WowBee.Spell.Delay[arg2])then
				if(WowBee.Spell.Delay[arg2][guid])then
					WowBee.Spell.Delay[arg2][guid]["Status"] = "Star";
				end
				if(WowBee.Spell.Delay[arg2]["All"])then
					WowBee.Spell.Delay[arg2]["All"]["Status"] = "Star";
				end
			end
		end
	end
	
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local _, _, prefix, suffix = string.find(arg2, "(.-)_(.+)")
		if (suffix=="CAST_FAILED") and UnitGUID("player") == arg3 and arg11 and arg12 and WowBee.Spell.Casting and WowBee.Spell.Casting["Time"] then
			local TEXT = arg12;
			if TEXT==SPELL_FAILED_UNIT_NOT_INFRONT or TEXT==SPELL_FAILED_OUT_OF_RANGE or TEXT==SPELL_FAILED_BAD_IMPLICIT_TARGETS or TEXT==SPELL_FAILED_LINE_OF_SIGHT or TEXT==SPELL_FAILED_TARGETS_DEAD or TEXT==SPELL_FAILED_BAD_TARGETS or TEXT==SPELL_FAILED_NOT_BEHIND then
				if GetTime() - WowBee.Spell.Casting["Time"]< select(3, GetNetStats())*2 + 0.7 then
					local guid = UnitGUID(WowBee.Spell.Casting["Unit"]);
					if guid then		
						WowBee.Spell.Failed = WowBee.Spell.Failed or {};
						WowBee.Spell.Failed[guid] = WowBee.Spell.Failed[guid] or {};
						WowBee.Spell.Failed[guid]["Time"]=GetTime();
						WowBee.Spell.Failed[guid]["Text"]=arg12;
						WowBee.Spell.Failed[guid]["SpellId"]=arg9;
						WowBee.Spell.Failed[guid]["SpellName"]=arg10;
					end
				end
			end
		end
	end
	
	if arg1 and UnitGUID("player") == UnitGUID(arg1) and ((event=="UNIT_SPELLCAST_STOP") or (event=="UNIT_SPELLCAST_SUCCEEDED") or (event=="UNIT_SPELLCAST_FAILED") or (event=="UNIT_SPELLCAST_INTERRUPTED")) then
		
    	--print("<<",event,arg1,arg2,arg3,arg4)
				
		if WowBee.Spell.Casting and WowBee.Spell.Casting["GUID"] then
			local guid = WowBee.Spell.Casting["GUID"];
			
			if(WowBee.Spell.Delay and WowBee.Spell.Delay[arg2])then
				if(WowBee.Spell.Delay[arg2][guid])then
					if WowBee.Spell.Delay[arg2][guid]["DelayTime"] then
						WowBee.Spell.Delay[arg2][guid]["EndTime"] = WowBee.Spell.Delay[arg2][guid]["DelayTime"] + GetTime();
						WowBee.Spell.Delay[arg2][guid]["DelayTime"] = nil;
					end
					WowBee.Spell.Delay[arg2][guid]["Status"] = "End";
				end
				if(WowBee.Spell.Delay[arg2]["All"])then
					if WowBee.Spell.Delay[arg2]["All"]["DelayTime"] then
						WowBee.Spell.Delay[arg2]["All"]["EndTime"] = WowBee.Spell.Delay[arg2]["All"]["DelayTime"] + GetTime();
						WowBee.Spell.Delay[arg2]["All"]["DelayTime"] = nil;
					end
					WowBee.Spell.Delay[arg2]["All"]["Status"] = "End";
				end
			end
		end
		WowBee.Spell.Casting = {};
	end
end