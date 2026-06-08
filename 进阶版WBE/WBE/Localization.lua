WowBee = {};
WowBee.Addons={};

WowBee.Player={};
WowBee.Player.Name=UnitName("player");
WowBee.Player.Class,WowBee.Player.EClass  = UnitClass("player")
WowBee.Player.GCD=0


WowBee.Config={};
WowBee.Config.SetGCD = false;
WowBee.Config.SetGCD_Time=0;
WowBee.Config.SpellAttackTime=0;
WowBee.Config.PromptSpellAttackTime=0;
WowBee.Config.SPELL_STOP_TIME=3;

--WowBee.Config.IsShow={};
--WowBee.Config.Formats={};
--WowBee.Config.TRINKET_TARGET
--WowBee.Config.ACTime
WowBee.Config.Arena={};
--WowBee.Config.Arena.BuffList
--WowBee.Config.Arena.BuffListTime
--WowBee.Config.Arena.IsUnitCastSpellName
--WowBee.Sys.IsArena

WowBee.Colors={};
WowBee.Colors.RED = "|cffff0000";
WowBee.Colors.GREEN = "|cff00ff00";
WowBee.Colors.BLUE = "|cff0000ff";
WowBee.Colors.MAGENTA = "|cffff00ff";
WowBee.Colors.YELLOW = "|cffffff00";
WowBee.Colors.LGREEN = "|cffEEAA22";
WowBee.Colors.WHITE = "|cffffffff";

WowBee.AutoMacro={};

WowBee.Spell={}

WowBee.Spell.Sleep=GetTime(); --技能施放成功后宏停止时间
WowBee.Spell.Variable={};
WowBee.Spell.Event={}
WowBee.Spell.Event.FollowUnit=false;
WowBee.Spell.Event.Combat=0;
WowBee.Spell.Event.PetCombat=0;
WowBee.Spell.Event.Proposal=false;
WowBee.Spell.Event.PhraseText="";

WowBee.Spell.Combat=nil;
WowBee.Spell.Combat_Sleep=GetTime();

WowBee.Spell.Property={};
WowBee.Spell.PropertyTime=0.003;------+


WowBee.Spell.Failed={};
WowBee.Spell.Casting={};
WowBee.Spell.Delay ={};
WowBee.Spell.Delay_Sleep=GetTime();
WowBee.Spell.Miss={};
WowBee.Spell.Miss.MissType={};
WowBee.Spell.Miss.Name={};



WowBee.Spell.ArrangeBattleSleep=GetTime();


WowBee.Spell.Class={};
WowBee.Spell.Class["WARLOCK"] = "术士" ;	
WowBee.Spell.Class["WARRIOR"] = "战士" ;	
WowBee.Spell.Class["HUNTER"] = "猎人" ;	
WowBee.Spell.Class["MAGE"] = "法师" ;	
WowBee.Spell.Class["PRIEST"] = "牧师" ;	
WowBee.Spell.Class["DRUID"] = "德鲁伊" ;	
WowBee.Spell.Class["PALADIN"] = "圣骑士" ;	
WowBee.Spell.Class["SHAMAN"] = "萨满祭司" ;	
WowBee.Spell.Class["ROGUE"] = "盗贼" ;	
WowBee.Spell.Class["DEATHKNIGHT"] = "死亡骑士" ;	
WowBee.Spell.Class["MONK"] = "武僧" ;

if(WowBee.Player.EClass=="WARRIOR") then 
	WowBee.Player.GCD=25208 --撕裂
elseif(WowBee.Player.EClass=="PRIEST") then 
	WowBee.Player.GCD=585  --恢复
elseif(WowBee.Player.EClass=="PALADIN") then 
	WowBee.Player.GCD=20154 --正义圣印
elseif(WowBee.Player.EClass=="MAGE" ) then 
	WowBee.Player.GCD=168 --霜甲术
elseif(WowBee.Player.EClass=="ROGUE") then 
	WowBee.Player.GCD=1752 --影袭
elseif(WowBee.Player.EClass=="DRUID") then 
	WowBee.Player.GCD=5176 --愤怒
elseif(WowBee.Player.EClass=="SHAMAN") then 
	WowBee.Player.GCD=403 --闪电箭
elseif(WowBee.Player.EClass=="WARLOCK") then 
	WowBee.Player.GCD=687 --恶魔皮肤
elseif(WowBee.Player.EClass=="HUNTER") then 
	WowBee.Player.GCD=14318 --雄鹰守护
elseif(WowBee.Player.EClass=="DEATHKNIGHT") then
	WowBee.Player.GCD=49896 --冰结之触
elseif(WowBee.Player.EClass=="MONK") then
	WowBee.Player.GCD=100780 --贯日击
else

	WowBee.Player.GCD=0
end 

WowBee.Spell.RC = RC;
