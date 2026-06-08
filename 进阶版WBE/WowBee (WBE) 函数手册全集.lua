--[[
====================================================================================
【 WowBee (WBE) 对应的函数施法手册全集 】
====================================================================================
使用说明：
1. 本文件已完美适配 Notepad 记事本黑白单色排版，等宽对齐，清晰易读。
2. 语法已做健壮性校验，全面兼容标准 Lua 格式，可直接用作脚本参考或放入插件库中。
====================================================================================
]]

-- [ 一、 施法与宏指令 (Casting & Actions) ] ----------------------------------------

-- 1. 基础施法
BeeRun("/cast 技能")                                        -- 正常施法
BeeRun("技能", "target")                                    -- 对目标施法
BeeRun("/stopcasting", "player")                            -- 通过宏断条/停手
BeeRun("/cancelaura 吸取灵魂", "player")                    -- 取消自己的引导性施法
BeeRun("风怒图腾","nogoal")                                 -- 没有目标施法(原地/指定区域)
BeeRun(GetSpellInfo(6603),"target")                         -- 法术ID施法
BeeRun("/cast 技能名(等级 8)")                              -- 施放带等级的法术
BeeRun("/cast [nochanneling] 吸取灵魂")                     -- 施放引导法术(防打断)
BeeRun("/run UseItemByName('897602')","target")             -- 使用指定名字/ID的物品

-- 2. 解锁底层 (强行调用暴雪禁用函数)
alan("CastSpellByName('技能名')")                           -- 调用被禁用的底层函数(按名字)
alan("CastSpellByID(686)")                                  -- 调用被禁用的底层函数(按ID)

-- 3. 辅助快捷键
IsShiftKeyDown()                                            -- 判定快捷键 Shift 是否按住
IsLeftControlKeyDown()                                      -- 判定快捷键 左Ctrl 是否按住

-- 4. 动作与交互
/run CustomName("InteractUnit('mouseover')")                -- 目标互动(采矿/开箱子)
/run JumpOrAscendStart()                                    -- 自己跳跃宏
BeeRun("/run JumpOrAscendStart()", "player")                -- 解锁后能跳跃


-- [ 二、 自身状态 (玩家/背包/Buff/技能CD) ] -----------------------------------------

-- 1. 冷却与物品可用性判断
BeeIsRun("/cast 正义之怒")                                  -- 判断当前是否可释放该技能
BeeSpellCoolDown("奉献") == 0                               -- 技能已冷却可用(方式一)
BeeSpellCD("奉献") == 0                                     -- 技能已冷却可用(方式二)
BeeSpellCD("奉献") > 0                                      -- 技能不可用(CD中)
BeeSpellCD("奉献") < 5                                      -- 技能CD还剩不到5秒
BeeSpellCD("冲锋") > 13                                     -- 技能不可用且CD>13秒
GetItemCooldown("便捷服务使用手册") == 0                    -- 背包内某名字物品可用
GetItemCooldown("便捷服务使用手册") > 0                     -- 背包内某名字物品不可用
GetItemCooldown(5512) == 0                                  -- 背包内某ID物品可用
ItemInBag("完美火焰石")                                     -- 判定自己背包有该物品
GetItemCount(5512) > 0                                      -- 背包有物品(按ID判断)
GetItemCount("灵魂碎片") > 0                                -- 背包有物品(Mop服不能用名字)
GetItemCount(22788) == 0                                    -- 背包没有该ID物品
GetItemInfo(GetInventoryItemLink("player", 18)) == "残毁神像" -- 判断是否装备了指定物品
IsEquippableItem("极效治疗石")                              -- 判断物品是否可以装备

-- 2. Buff 与自身状态
UnitBuff("player", GetSpellInfo(117667))                    -- 自己身上有指定法术ID的Buff
BeePlayerBuffCount("虚空之能") < 3                          -- 判断自己Buff层数<3
BeeUnitBuffCount("漩涡武器","player",0,0) >= 5              -- 判断自己Buff层数>=5
BeeUnitBuff("强效力量祝福","player",0,0) > 0                -- 自己有自己释放的Buff
BeeUnitBuff("强效力量祝福","player",1,0) > 0                -- 自己有队友释放的Buff
BeeUnitBuff("强效力量祝福","player",2,0) > 0                -- 自己有任意人释放的Buff
BeePlayerBuffTime("激怒") > 0                               -- 自己的激怒Buff时间还有剩余
BeePlayerDeBuffTime("死灵光环") > 0                         -- 自己身上有指定恶意DeBuff
BeeStringFind("战马",BeeUnitBuffList("player"))             -- 自己存在无时限的Buff

-- 3. 生命/魔法/能量系统
BeeUnitHealth("player","%") < 60                            -- 自己生命值百分比 < 60%
BeeUnitMana("player","%") < 60                              -- 自己魔法值百分比 < 60%
BeeGetComboPoints() > 2                                     -- 自己连击点 > 2星
UnitPower("player") > 10                                    -- 自己怒气/能量 > 10

-- 4. 职业专属能量 (德鲁伊/武僧/骑士/术士等)
UnitPower("player", SPELL_POWER_ENERGY)                     -- 野兽形态下的能量值
UnitPower("player", 3)                                      -- 野兽形态下的能量值(数字版)
UnitPower("player", 0)                                      -- 野兽形态下的法力值
(UnitPower("player", 0)/UnitPowerMax("player", 0))*100 < 40 -- 野兽形态下法力值 < 40%
UnitPower("player", SPELL_POWER_MANA)                       -- 野兽形态下的法力值
UnitPower("player", SPELL_POWER_CHI) > 1                    -- 武僧的真气 > 1
UnitPower("player", 13) > 1                                 -- 武僧的真气 > 1 / 暗牧的暗影宝珠>=1
UnitPower("player", 13) >= 1                                -- 暗牧的暗影宝珠>=1
UnitPower("player") > 55                                    -- 武僧的能量 > 55
UnitPower("player", SPELL_POWER_HOLY_POWER) > 1             -- 骑士的圣能 > 1
UnitPower("player", 14)                                     -- 毁灭术士爆燃灰烬
UnitPower("player", 1)                                      -- 熊的怒气值
UnitPower("player")                                         -- 熊的怒气值，也是猫的能量值

-- 5. DK 符文与战士充能
BeeRune("冰霜符文") > 0                                     -- 冰霜符文可用
BeeRune("冰霜符文") < 1                                     -- 冰霜符文不可用
BeeRune("冰霜符文") == 0                                    -- 有0个冰霜符文可用
BeeRune("冰霜符文") >= 2                                    -- 有2个冰霜符文可用
IsUsableSpell("符文打击")                                   -- 触发类技能亮起可用
(select(1, GetSpellCharges("压制")) or 0) < 1               -- 战士技能充能次数 < 1 (加or 0避免报错)

-- 6. 施法/战斗/移动状态
UnitCastingInfo("player")                                   -- 自己正在读条施法吟唱
UnitCastingInfo("player") == "雪色狮鹫"                     -- 自己正在施法坐骑
UnitChannelInfo("player") == "怒雷破"                       -- 自己正在施法引导法术怒雷破
BeeUnitCastSpellName("player") == "宁静"                    -- 自己正在释放宁静
BeeUnitCastSpellName("player") == "献祭"                    -- 自己正在读条献祭
IsCurrentSpell("选矿")                                      -- 自己正在释放选矿；也是待施法状态(如技能圈)
not IsCurrentSpell("宁静")                                  -- 自己当前没有释放宁静
GetUnitSpeed("player") > 0                                  -- 自己正在移动中
GetUnitSpeed("player") == 0                                 -- 自己处在静止中
BeeUnitAffectingCombat()                                    -- 自己正在战斗中
BeeIsCombat() == 0                                          -- 自己不在战斗中
BeeIsCombat() == 1                                          -- 自己正在战斗中
IsStealthed("player")                                       -- 自己是潜行状态
BeeGetShapeshiftFormInfo(5)                                 -- 自己的形态是第5个

-- 7. 宠物与图腾控制
HasPetSpells()                                              -- 有宠物(技能)存在
UnitExists("pet")                                           -- 有宠物存在
UnitCreatureFamily("pet") == "食尸鬼"                       -- 有食尸鬼宠物
not BeeIsRun("亡者复生") and BeeSpellCD("亡者复生") < 0     -- 冰DK时有BB存在
BeeUnitBuff("治疗宠物","pet") < 1                           -- 自己宠物的Buff判定
BeeUnitHealth("pet","%") > 0                                -- 宠物的血量百分比
BeeTotem("火焰图腾") < 3                                    -- 火焰图腾时间 < 3秒
BeeTotem("净化图腾") > 0                                    -- 自己召唤有净化图腾
name, time = BeeTotemtype(Type)                             -- 获取图腾类型及时间

-- 8. 武器附魔
BeeWeaponEnchantInfo(1) < 3                                 -- 主手武器附魔 < 3分钟


-- [ 三、 目标状态 (Target Conditions) ] -------------------------------------------

-- 1. 目标基础判定
UnitExists("target")                                        -- 自己选中了目标 (存在)
UnitExists("target") == 1                                   -- 自己选中了目标 (严格对比)
not UnitExists("target")                                    -- 自己没有选中目标 / 没选中任何单位
BeeRun("/targetenemy")                                      -- 随机选中目标
TargetUnit("小明")                                          -- 选中指定名字
BeeUnitName("target") == "小明"                             -- 目标的名字是小明
UnitName("target") == "小明"                                -- 目标的名字是小明
not (BeeUnitName("target") == "小明")                       -- 目标不叫小明
UnitIsDeadOrGhost("target")                                 -- 目标是死亡
UnitIsPlayer("target") == 1                                 -- 目标是玩家
not UnitIsPlayer("target")                                  -- 目标不是玩家
BeeUnitPlayerControlled("target")                           -- 目标是玩家控制的单位
UnitIsEnemy("player", "target")                             -- 目标是敌人
not UnitIsEnemy("player", "target")                         -- 目标不是敌人
UnitReaction("player", "focus") == 2                        -- 目标是敌对
UnitReaction("player", "focus") == 4                        -- 目标是中立
BeeUnitCanAttack("target") == 1                             -- 目标可以被攻击
BeeUnitAffectingCombat("target")                            -- 目标在战斗中
UnitIsUnit("target", "mouseover")                           -- 目标与鼠标悬停是同一单位
UnitGUID("target") == UnitGUID("mouseover")                 -- 目标与鼠标悬停是同一ID

-- 2. 距离/视野/位置判定
CheckInteractDistance("target", 3)                          -- 目标在近战范围
CastTarGet()                                                -- 目标当前位置范围施法
IsSpellInRange("灼烧","target") == 1                        -- 目标在技能范围内
IsSpellInRange("斩杀","target") == 1                        -- 目标在施法距离内
BeeRange("target") > 6                                      -- 目标距离 > 6码
InLosTo(UnitGUID("target")) == 1                            -- 目标在视野内
InLosTo(guid) == 1                                          -- 单位在视野内
LMonsterCount(15) > 4                                       -- 自己15码内 > 4个怪
BeeUnitUnitIsPlayer(0)                                      -- 目标看的不是自己
BeeTargetTargetIsPlayer()                                   -- 目标在看我
IsFacing() == 0                                             -- 判断是否面对目标
LFaceMelee()                                                -- 调整角色朝向
LIsbehind(UnitGUID("target")) == 1                          -- 在目标背面
LIsbehind(UnitGUID("target")) == 0                          -- 在目标正面
LIsbehind() == 1                                            -- 在目标背面(缺省版)
LIsbehind() == 0                                            -- 在目标正面(缺省版)

-- 3. 目标属性与血量控制
BeeUnitHealth("target","%") < 60                            -- 目标生命值 < 60%
BeeUnitMana("target","%") < 60                              -- 目标魔法量 < 60%
BeeUnitHealth("target",nil,0) > 666                         -- 目标生命值 > 666滴血
UnitHealthMax("target") > 4000                              -- 目标生命上限 > 4000
BeeTargetBuffCount("技能buff") < 3                          -- 目标增益buff层数 < 3
BeeTargetBuffTime("力量祝福") < 3                           -- 目标增益buff时间 < 3秒
BeeTargetDeBuffTime("破甲攻击") > 3                         -- 目标减益时间 > 3秒
BeeTargetDeBuffCount("破甲攻击") > 3                        -- 目标减益层数 > 3层
BeeIsInterruptible("target")                                -- 目标当前可被打断
UnitLevel("target") == -1                                   -- 目标是一个骷髅级别BOSS
UnitLevel("target") >= 1                                    -- 目标不是骷髅级别BOSS
UnitCreatureType("target") == "元素"                        -- 目标的生物是元素怪
UnitCreatureType("target")                                  -- 目标物种类型(如“机械”“动物”)
IsRareMonster("target")                                     -- 目标是稀有怪
UnitClassification("target") == "elite"                     -- 目标是精英怪物目标
BeeStringFind("巨熊形态",BeeUnitBuffList("targettarget"))   -- 目标的目标有T的状态

-- 4. 目标职业姿态判断
select(1, UnitClass("target")) == "打熊孩子"                -- 获取目标的名称是打熊孩子
select(2, UnitClass("target")) == "DRUID"                   -- 目标的职业是德鲁伊
select(2, UnitClass("target")) == "WARRIOR"                 -- 目标的职业是战士
select(2, UnitClass("target")) == "PALADIN"                 -- 目标的职业是圣骑士
GetShapeshiftForm("target") == 1                            -- 返回值：1=武器，2=防御，3=狂暴
GetShapeshiftForm("target") == 2                            -- 返回值：2=防御姿态
GetShapeshiftForm("target") == 3                            -- 返回值：3=狂暴姿态


-- [ 四、 团队、小队与焦点 (Party & Focus) ] ------------------------------------------

-- 1. 团队小队基础
GetNumPartyMembers() == 1                                   -- 自己在队伍中
GetNumRaidMembers() == 1                                    -- 自己在团队中
BeeUnitBuff("回春术","Unit",0,0) < 3                        -- 单位的技能BUFF时间 < 3秒
BeeUnitBuffCount("生命绽放","focus",0,0) < 3                -- 单位的技能BUFF层数 < 3
BeeUnitBuffInfo("target",2,"Magic",1) >= 2                  -- 目标身上的魔法效果数量 > 2
BeeRange(unit) < 40                                         -- 单位的距离 < 40码
UnitCanAssist("player",unit)                                -- 单位可以被自己协助
not UnitIsUnit(unit, "player")                              -- 团队单位排除是自己
not UnitIsUnit(unit, "target")                              -- 团队单位排除是目标
not UnitIsUnit(unit, "focus")                               -- 团队单位排除是焦点
UnitIsDeadOrGhost(unit)                                     -- 单位已死亡
BeeUnitHealth(unit,"%") < 90                                -- 单位生命值 < 90%
UnitGUID(unit) ~= UnitGUID("focus")                         -- 团队判定中剔除焦点单位(例如不给有道标的焦点 T直接加血)
not UnitIsUnit(unit, "focus")                               -- 团队判定中剔除焦点单位(例如不给有道标的焦点 T直接加血)

-- 2. 焦点功能篇
BeeRun("/focus  打熊孩子")                                  -- 将指定名字的玩家设置为焦点
BeeRun("/focus target")                                     -- 将当前目标设置为焦点
UnitExists("focus")                                         -- 判断有没焦点
UnitIsFriend("player", "focus")                             -- 焦点是队友
UnitFactionGroup("focus") == "Alliance"                     -- 焦点是联盟阵营
not BeeUnitPlayerControlled("focus")                        -- 没设置队友为焦点(焦点是NPC)
BeeUnitBuff("献祭","focus",2,0) > 0                         -- 焦点有自己的Debuff
BeeUnitBuff("圣光道标", "target", 0, 0) < 0                 -- 目标没有自己的圣光道标Buff
UnitName(focusTarget.."target")                             -- 如果焦点的目标有名字，可以变相判断焦点是否有目标
BeeRun("/target [@focustarget]","Macro")                    -- 选中焦点的目标
FollowUnit("focus")                                         -- 跟随焦点
UnitIsUnit("target", "focus")                               -- 目标是焦点
not UnitIsUnit("target", "focus")                           -- 目标不是焦点


-- [ 五、 环境、坐骑、载具与面板交互 ] -------------------------------------------------

-- 1. 坐骑与载具状态
IsMounted()                                                 -- 自己在坐骑上
IsFlyableArea()                                             -- 当前地图可飞行
UnitOnTaxi("unit")                                          -- 目标/自己在公共坐骑路线上
UnitPower("vehicle", select(10, UnitVehicleSeatInfo("player"))) == 100 -- 载具的能量值
GetComboPoints("vehicle", "target")                         -- 载具的连击点
local Speed0 = select(7, UnitAura("vehicle", "速度提高", nil, "HELPFUL")) or 0 -- 载具的Buff

-- 2. NPC 对话面板控制 (Gossip)
GossipFrame:IsShown() == 1                                  -- 对话框面板已打开
GetNumGossipOptions() == 5                                  -- 对话框面板有5个选项
select(1, GetGossipOptions()) and select(1, GetGossipOptions()):find("返回")  -- 对话框第1个选项包含“返回”字符
select(1, GetGossipOptions()) and select(1, GetGossipOptions()):match("返回") -- 对话框第1个选项包含“返回”字符(备选)
SelectGossipOption(1)                                       -- 点对话框的第1个选项
GetCVar("autointeract") == "1"                              -- 是鼠标移动状态开启
GetCVar("autointeract") == "0"                              -- 是鼠标移动状态关闭
SetCVar("autointeract", "1")                                -- 开启鼠标移动
SetCVar("autointeract", "0")                                -- 关闭鼠标移动

-- 3. 系统静态弹窗控制 (StaticPopup)
StaticPopup1:IsShown()                                      -- 弹窗面板已打开(丢弃物品的面板)
StaticPopup1.text:GetText():find("是否穿越回")              -- 弹窗面板(非按钮上) 包含指定文本
StaticPopup1.button1:GetText():find("接受")                 -- 弹窗面板的按钮包含指定文本
StaticPopup1Button1:GetText():find("接受")                  -- 第1个弹窗的按钮1的文字包含“接受”
StaticPopup2Button1:GetText() == "接受"                     -- 第2个弹窗的按钮1的文字是“接受”
StaticPopup1.text:GetText():match("分解(.-)会将其摧毁")     -- 弹窗面板的按钮可以跳过装备名找两边的文字
StaticPopup1.text:GetText():find("分解") and StaticPopup1.text:GetText():find("会将其摧毁") -- 面板上找2段文字
StaticPopup1:IsShown() and StaticPopup1.button1:GetText():find("是") -- 静态弹窗面板的按钮包含指定文(避免返回空值)
StaticPopup1Button1:Click()                                 -- 点击第1个弹窗的第1个按钮
StaticPopup2Button2:Click()                                 -- 点击第2个弹窗的第2个按钮


-- [ 六、 WBE 核心指令与控制案例 ] ----------------------------------------------------

-- 1. 运行指令
-- 指令： /bee auto 脚本名 片段1,片段2                       -- 启动宏
-- 指令： /bee stop                                          -- 停止宏

-- 2. 案例：不暂停插入技能
if BeeCastSpellFast() then return true end
-- 说明：下面写在游戏宏内做成按键：
-- #showtooltip 技能一      /run BeeSpellFast("/cast 技能一","Macro")

--[[
-- 3. 案例：高级目标物种类型判定与多维分析
UnitClassification("unit")
    传参：目标标识，即：“player”或“target”。
    返回：字符串，世界boss、稀有精英、精英、稀有、普通等
    作用：判断指定目标性质。
--]]
local checkType = UnitCreatureType("target")
if checkType == "世界boss" or checkType == "稀有精英" then
    -- 这里编写对应高危怪物的挂机应对逻辑
end

--[[
-- 4. 案例：换武器逻辑 (待开发模板)
GetInventorySlotInfo("MainHandSlot")                        -- 获取主手武器栏位
GetInventorySlotInfo("SecondaryHandSlot")                   -- 获取副手武器栏位
/script PickupInventoryItem(GetInventorySlotInfo("MainHandSlot"))
/script PickupInventoryItem(GetInventorySlotInfo("SecondaryHandSlot"))
--]]

--[[
-- 5. 案例：盗贼(DZ)自动主副手武器涂毒控制
--]]
local zs = BeeWeaponEnchantInfo(1)
local fs = BeeWeaponEnchantInfo(2)
if zs < 0 then 
    BeeRun('/script UseItemByName("zhishang药膏")')
    BeeRun('/IN 1 /script PickupInventoryItem (16)')
else
    if fs < 0 then
        BeeRun('/script UseItemByName("mazui药膏")')
        BeeRun('/IN 1 /script PickupInventoryItem (17)')
    end 
end