
02 Bee函数手册
--施法
--------------------------------------------------------------------------------------------------------------------------------------------
BeeRun("/cast 技能")                                            --   施法
BeeRun("技能", "target")                                     --     对目标施法
BeeRun("/stopcasting", "player")                         --    通过宏施法
BeeRun("/cancelaura 吸取灵魂", "player")                  --取消自己的引导性施法
BeeRun("风怒图腾","nogoal")                                --  没有目标施法
BeeRun(GetSpellInfo(6603),"target")                      -- 法术ID施法
BeeRun("/cast 技能名(等级 8)")                               带等级的法术
BeeRun("/cast [nochanneling] 吸取灵魂")                   施放引导法术
alan("CastSpellByName('技能名')")                             调用被禁用的函数
alan("CastSpellByID(686)")                                      调用被禁用的函数
IsShiftKeyDown()                                                  快捷键shift
IsLeftControlKeyDown()                                         快捷键Ctrl
BeeRun("/run UseItemByName('897602')","target")    技能
--------------------------------------------------------------------------------------------------------------------------------------------
--自己
----------------------------------------------------------------------------------------------------------------------------------------------
BeeIsRun("/cast 正义之怒")                                    可以释放正义之怒
BeeSpellCoolDown("奉献")==0                               已冷却可用，方式一
BeeSpellCD("奉献")==0                                            已冷却可用，方式二
BeeSpellCD("奉献")>0                                              技能不可用
BeeSpellCD("奉献")<5                                             技能的冷却还剩5秒可用
BeeSpellCD("冲锋")>13                                            技能不可用,冷却>11秒
GetItemCooldown("便捷服务使用手册")==0             背包的物品可用

GetItemCooldown(5512)==0                                背包的ID物品可用

GetItemCooldown("便捷服务使用手册") > 0             背包的物品不可用

ItemInBag("完美火焰石")                          自己背包有物品

GetItemCount(5512)>0                            自己背包有物品ID 

GetItemCount("灵魂碎片")>0                         自己背包有物品(Mop服不能用名字)
GetItemCount(22788) == 0                                 背包没有物品ID
UnitBuff("player", GetSpellInfo(117667))             自己有法术ID的技能
BeePlayerBuffCount("虚空之能") < 3                    自己有buff层数
BeeUnitBuffCount("漩涡武器","player",0,0)>=5     自己有buff层数
BeeUnitBuff("强效力量祝福","player",0,0)>0                 自己有自己释放的BUFF
BeeUnitBuff("强效力量祝福","player",1,0)>0                     自己有队友释放的BUFF
BeeUnitBuff("强效力量祝福","player",2,0) >0                    自己有任意人释放的BUFF
GetItemInfo(GetInventoryItemLink("player", 18)) == "残毁神像"        装备了"残毁神像
IsEquippableItem("极效治疗石")                物品是否可以装备
BeeTotem("火焰图腾")<3                                  火焰图腾时间＜3秒
BeeUnitHealth("player","%")<60                       自己生命值＜60%
BeeUnitMana("player","%")<60                        自己魔法量＜60%
UnitCastingInfo("player")                                  自己正在读条施法吟唱
UnitCastingInfo("player") == "雪色狮鹫"          自己正在施法坐骑
UnitChannelInfo("player") == "怒雷破"            自己正在施法引导法术怒雷破
UnitExists("target")                                       自己选中了目标

not UnitExists("target")                                   自己没有选中目标

GetUnitSpeed("player") > 0                             自己正在移动中
GetUnitSpeed("player") == 0                            自己处在静止中
BeeUnitAffectingCombat()                               自己正在战斗中
BeePlayerBuffTime("激怒")>0                         自己的激怒状态时间还有
BeePlayerDeBuffTime("死灵光环")>0                自己有恶意DeBuff
BeeGetComboPoints()>2                                 自己连击点>2星
BeeGetShapeshiftFormInfo(5)                        自己的形态是第5个
BeeUnitCastSpellName("player")=="宁静"     自己正在释放宁静
IsCurrentSpell("选矿")                                    自己正在释放宁静；也是待施法状态(如技能圈)
not IsCurrentSpell("宁静")                              自己当前没有释放宁静        
BeeRune("冰霜符文")>0                                冰霜符文可用
BeeRune("冰霜符文")<1                                冰霜符文不可用
BeeRune("冰霜符文")== 0                       有0个冰霜符文可用
BeeRune("冰霜符文")>= 2                        有2个冰霜符文可用
IsUsableSpell("符文打击")                   触发技亮起可用
BeeUnitCastSpellName("player")=="献祭"       自己正在读条献祭
BeeRun("/stopcasting", "player")                      自己停手
UnitPower("player")>10                                 自己的怒气＞10
LMonsterCount(15) >4                                  自己15码内＞4个怪

UnitExists("target")==1                                  自己选中了目标

BeeIsCombat()==0                                        自己不在战斗中
BeeIsCombat()==1                                        自己正在战斗中
BeeWeaponEnchantInfo(1)<3                      武器附魔信息   
BeeUnitHealth("pet","%")>0                          宠物的血
BeeRun("/targetenemy")                              随机选中目标
HasPetSpells()                                               有宠物(技能)存在
UnitExists("pet")                                               有宠物存在
UnitCreatureFamily("pet") ==  "食尸鬼"            有食尸鬼宠物
not BeeIsRun("亡者复生") and BeeSpellCD("亡者复生")<0        冰DK时有BB存在
BeeUnitBuff("治疗宠物","pet")<1                        自己宠物的BUff
BeeTotem( "净化图腾" )>0                              自己召唤有净化图腾
GetNumPartyMembers()==1                        自己在队伍中
GetNumRaidMembers()==1                             自己在团队中
BeeStringFind("战马",BeeUnitBuffList("player"))     自己存在无时限的Buff
IsStealthed("player")                                           自己是潜行状态
/run JumpOrAscendStart()                                  自己跳宏
BeeAttack(0,0)                                                       主动攻击
GetShapeshiftForm("target")==1                       -- 返回值：1=武器，2=防御，3=狂暴            
UnitPower("player", SPELL_POWER_ENERGY)  野兽形态下能力值
UnitPower("player", 3)                                                              野兽形态下能量值
UnitPower("player", 0)                                                              野兽形态下法力值

(UnitPower("player", 0)/UnitPowerMax("player", 0))*100 <40  野兽形态下法力值<40%

UnitPower("player", SPELL_POWER_MANA)                         野兽形态下法力值

--熊猫人
UnitPower("player", SPELL_POWER_CHI)>1                      武僧的真气>1 UnitPower("player", 13)                                                    武僧的真气>1

UnitPower("player") > 55                                                 武僧的能量>55
UnitPower("player", SPELL_POWER_HOLY_POWER)>1       骑士的圣能>1
(select(1, GetSpellCharges("压制")) or 0) < 1                  战士技能充能次数 <1(0避免报错)
UnitPower("player", 13)>=1                                     暗牧的暗影宝珠>=1 (13对应的是宝珠，还可以类推其他的种类)

UnitPower("player", 14)                   毁灭SS爆燃灰烬

UnitPower("player", 1)                   熊的怒气值

UnitPower("player")                      熊的怒气值，也是猫的能量值




--目标 
-----------------------------------------------------------------------------------------------------------------------------------
CheckInteractDistance("target", 3)                     目标在近战范围
CastTarGet()                                                      目标当前位置范围施法
BeeTargetBuffCount("技能buff")<3                    目标增益buff层数    
BeeTargetBuffTime("力量祝福")<3                     目标增益buff时间
BeeTargetDeBuffTime("破甲攻击")>3                目标减益时间>3秒
BeeTargetDeBuffCount("破甲攻击")>3              目标减益层数>3层
UnitIsDeadOrGhost("target")                               目标是死亡       
not UnitExists("target")                                          没选中任何单位
BeeUnitCanAttack("target")==1                      目标可以被攻击
UnitIsEnemy("player", "target")                             目标是敌人
not UnitIsEnemy("player", "target")                          目标不是敌人
BeeUnitUnitIsPlayer(0)                                             目标看的不是自己
BeeUnitPlayerControlled("target")                           目标是玩家
UnitReaction("player", "focus") == 2           目标是敌对
UnitReaction("player", "focus") == 4                   目标是中立
UnitIsPlayer("target")==1                       目标是玩家 UnitIsUnit("target", "mouseover")                          目标与鼠标悬停是同一单位 UnitGUID("target") == UnitGUID("mouseover")       目标与鼠标悬停是同一ID

not UnitIsPlayer("target")                                    目标不是玩家
IsSpellInRange("灼烧","target")==1                 目标在技能范围内
InLosTo(UnitGUID("target"))==1                             目标在视野内
InLosTo(guid) == 1                                                 单位在视野内
BeeTargetTargetIsPlayer()                            目标在看我
BeeUnitAffectingCombat("target")                   目标在战斗中
BeeRange("target")>6                                              目标距离>6码
IsSpellInRange("斩杀","target")==1                   目标在施法距离内
BeeUnitHealth("target","%")<60                       目标生命值＜60%
BeeUnitMana("target","%")<60                      目标魔法量＜60%
BeeUnitHealth("target",nil,0)>666              目标生命值>666滴血UnitHealthMax("target") > 4000        目标生命上限>4000

BeeUnitName("target") =="小明"                     目标的名字是小明

UnitName("target") =="小明"                      目标的名字是小明

not (BeeUnitName("target") =="小明")      --目标不叫小明

TargetUnit("小明")                               选中指定名字

BeeIsInterruptible("target")                        目标当前可被打断
LIsbehind(UnitGUID("target")) ==1            在目标背面
LIsbehind(UnitGUID("target")) ==0            在目标正面
LIsbehind() ==1                                        在目标背面
LIsbehind() ==0                                        在目标正面
UnitLevel("target") == -1                                     目标是一个骷髅级别BOSS 
UnitLevel("target") >=1                                        目标不是骷髅级别BOSS UnitCreatureType("target") == "元素"          目标的生物是元素怪
IsRareMonster("target")                          目标是稀有怪
UnitClassification("target")  == "elite"      目标是精英怪物目标
BeeStringFind("巨熊形态",BeeUnitBuffList("targettarget"))      目标的目标有T的状态
GetShapeshiftForm("target")==1           目标是武器姿态
GetShapeshiftForm("target")==2           目标是武器姿态	















GetShapeshiftForm("target")==3           目标是武器姿态



select(1, UnitClass("target"))=="打熊孩子"   获取目标的名称是打熊孩子
select(2, UnitClass("target")) ==  "DRUID"       目标的职业是德鲁伊
select(2, UnitClass("target")) ==  "WARRIOR"   目标的职业是战士
select(2, UnitClass("target")) ==  "PALADIN"    目标的职业是圣骑士

--团队
-----------------------------------------------------------------------------------------------------------------
BeeUnitBuff("回春术","Unit",0,0)<3                           单位的技能BUFF时间＜3
BeeUnitBuffCount("生命绽放","focus",0,0)<3            单位的技能BUFF层数＜3
BeeUnitBuffInfo("target",2,"Magic",1)>=2                --目标身上的魔法效果数量>2
BeeRange(unit)<40                                                  单位的距离<40码
UnitCanAssist("player",unit)                                     单位可以被自己协助
not UnitIsUnit(unit, "player")                                     团队单位排除是自己
not UnitIsUnit(unit, "target")                                     团队单位排除是目标
not UnitIsUnit(unit, "focus")                                     团队单位排除是焦点
UnitIsDeadOrGhost(unit)                                         单位已死亡
BeeUnitHealth(unit,"%")<90                                     单位生命值＜90%
UnitGUID(unit) ~= UnitGUID("focus")                       团队判定中剔除焦点单位(例如不给有道标的焦点 T直接加血)
not UnitIsUnit(unit, "focus")                                       团队判定中剔除焦点单位(例如不给有道标的焦点 T直接加血)
--启动,停止.
/bee auto  脚本名 片段1,片段2         --启动宏

/bee stop                                          --停止宏
--案例：不暂停插入技能
if BeeCastSpellFast() then return true end
--下面是写在游戏宏，做成按键
--#showtooltip 技能一     /run BeeSpellFast("/cast 技能一","Macro")

---------------------------------------------------------------------------
--目标 


name , time = BeeTotemtype(Type)


BeeWeaponEnchantInfo(1)<3               --主手武器附魔＜3分钟目标物种类型(如“机械”“动物”)      UnitCreatureType("target")UnitOnTaxi("unit")       --坐骑----------------------------------------------------------------
UnitClassification("unit") 
传参：目标，即：“player”或“target”。
返回：字符串，世界boss、稀有精英、精英、稀有、普通等
作用：判断指定目标性质。
备注：
local a=UnitCreatureType("target")
if a=="世界boss" or a=="稀有精英" 
-------------------------------------------------------------------
--待开发 换武器GetInventorySlotInfo（“MainHandSlot”）  --获取主手武器
GetInventorySlotInfo（“SecondaryHandSlot”）  --副手武器/ script PickupInventoryItem（GetInventorySlotInfo（“MainHandSlot”））
/ script PickupInventoryItem（GetInventorySlotInfo（“SecondaryHandSlot”））-------------------------------------------
--DZ涂毒
local zs=BeeWeaponEnchantInfo(1)
local fs=BeeWeaponEnchantInfo(2)
if zs<0 then BeeRun('/script UseItemByName("zhishang药膏")')
BeeRun('/IN 1 /script PickupInventoryItem (16)')
else
if fs<0 then
BeeRun('/script UseItemByName("mazui药膏")')
BeeRun('/IN 1 /script PickupInventoryItem (17)')
end end

--焦点篇
--------------------------------------------------------------------------------
BeeRun("/focus  打熊孩子")                                          将玩家设置为焦点
BeeRun("/focus target")                                                将目标设置为焦点
not BeeUnitPlayerControlled("focus")                           没设置队友为焦点
BeeUnitBuff("献祭","focus",2,0)>0                                焦点有自己的Debuff
BeeUnitBuff("圣光道标", "target", 0, 0) < 0
UnitIsFriend("player", "focus")                                      焦点是队友
UnitFactionGroup("focus") == "Alliance"                       焦点是联盟阵营
UnitExists("focus")                                           判断有没焦点 
UnitName(focusTarget.."target")                       如果焦点的目标有名字，可以变相判断焦点是否有目标
IsFacing() == 0                                                  判断是否面对目标
LFaceMelee()                                                    调整角色朝向
BeeRun("/target [@focustarget]","Macro")       选中焦点的目标
TerrainClickObject(UnitGUID("target"), 4)        移动至目标位置
MoveForwardStop()                                         停止前进
FollowUnit("focus")                                           跟随焦点
UnitIsUnit("target"), "focus")                                 目标是焦点
not UnitIsUnit("target"), "focus")                           目标不是焦点
--宏
----------------------------------------------
/run CustomName("InteractUnit('mouseover')") --目标互动 采矿 开箱子
/run CustomName("JumpOrAscendStart()") --跳
/run JumpOrAscendStart()                     自己跳宏
--坐骑
IsMounted()                                                          --自己在坐骑上
IsFlyableArea()                                      --当前地图可飞行
UnitCastingInfo("player") == "雪色狮鹫"             --自己正在施法坐骑
--载具
----------------------------------------------------------
UnitPower("vehicle", select(10, UnitVehicleSeatInfo("player"))) ==100                     载具的能量值
GetComboPoints("vehicle", "target")                                                     载具的连击点
local Speed0 = select(7, UnitAura("vehicle", "速度提高", nil, "HELPFUL")) or 0            载具的Buff

--对话面板
-------------------------------------------------------------
GossipFrame:IsShown() == 1                                                                                      对话框面板已打开
GetNumGossipOptions() == 5                                                                                            对话框面板有5个选项
select(1, GetGossipOptions()) and select(1, GetGossipOptions()):find("返回")                 对话框第1个选项包含“返回”字符
select(1, GetGossipOptions()) and select(1, GetGossipOptions()):match("返回")             对话框第1个选项包含“返回”字符(备选)
SelectGossipOption(1)                                                                                                   点对话框的第1个选项
GetCVar("autointeract") == "1"   --是鼠标移动状态
GetCVar("autointeract") == "0"   --是鼠标移动状态
SetCVar("autointeract", "1")        -- 开启鼠标移动
SetCVar("autointeract", "0")        -- 关闭鼠标移动




--弹窗面板
-------------------------------------------------------------


StaticPopup1:IsShown()                                                   --弹窗面板已打开(丢弃物品的面板)
StaticPopup1.text:GetText():find("是否穿越回")                --弹窗面板(非按钮上) 包含指定文

StaticPopup1.button1:GetText():find("接受")                     --弹窗面板的按钮包含指定文

StaticPopup1Button1:GetText():find("接受")                            --第1个弹窗的按钮1的文字包含“接受”

StaticPopup2Button1:GetText() == "接受"                                --第2个弹窗的按钮1的文字是“接受”                       


StaticPopup1.text:GetText():match("分解(.-)会将其摧毁")                                                              弹窗面板的按钮可以跳过装备名找两边的文字
StaticPopup1.text:GetText():find("分解") and StaticPopup1.text:GetText():find("会将其摧毁")    --面板上找2段文字
StaticPopup1:IsShown() and StaticPopup1.button1:GetText():find("是")                                        静态弹窗面板的按钮包含指定文(避免返回空值)
StaticPopup1Button1:Click()                --第1个弹窗的第1个按钮

StaticPopup2Button2:Click()                                        --第2个弹窗的第2个按钮

BeeRun("/run JumpOrAscendStart()", "player")        --解锁后能跳










