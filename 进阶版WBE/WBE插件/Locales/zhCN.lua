local l=GetLocale()=="zhCN"
if not l then 
	return;
end

WowBeeLocale={};
local L=WowBeeLocale;
L["WOWBEE_TITLE"]="魔峰";
L["WOWBEE_TOOLTIP"]="魔蜂极限版核心插件  " .. GetAddOnMetadata("WBE", "Version");
L["WOWBEE_VERSION"]="魔蜂极限版控制面板 & " .. GetAddOnMetadata("WBE", "Version");
L["WOWBEE_CONNECTION"]="魔蜂连接成功！";
L["WOWBEE_DISCONNECT"]="魔蜂断开连接！";
L["WOWBEE_DELAY"]="|cffffff00连接响应延时:|r|cffff0000 %.4f |r|cffffff00秒|r";
L["WOWBEE_COMERROR"]="|cffffff00注意:|r|cffff0000魔蜂连接成功！响应测试失败！|cffEEAA22如不能使用，请重新打开《魔兽世界》！|r"
L["WOWBEE_ADDONS_NOINSTALL"]=" 没安装或者没启用！";
L["WOWBEE_BINDING_SHOW"]="打开/关闭运行界面";
L["WOWBEE_BINDING_STARTSTOP"] = "运行/停止 自动脚本";
L["WOWBEE_BINDING_STOP"] = "停止自动脚本";

L["GUI_MAINFRAME_TITLE"]="魔蜂极限版 - 控制面板";
L["GUI_MAINFRAME_TOOLTIP"]=L["WOWBEE_VERSION"];
L["GUI_MAINFRAME_LOCK"]="锁定";
L["GUI_MAINFRAME_LOCK_STATUS1"]="界面已锁定";
L["GUI_MAINFRAME_LOCK_STATUS2"]="界面已解锁";
L["GUI_MAINFRAME_HIDE"]="隐藏";
L["GUI_MAINFRAME_SCHEMEDROPDOWN"]="方案";
L["GUI_BOXFRAME_TITLE"]="错误代码";

L["SCRIPT_STRART"]="|cffffff00注意:|r|cff00ff00自动运行脚本已启动!|r";
L["SCRIPT_STOP"]="";
L["SCRIPT_STRART_LIST"]="|cffffff00注意:|r|cff00ff00[%s]方案以[%s]方式启动!|r";
L["SCRIPT_STRART_DEFAULT"]="默认";
L["SCRIPT_SCHEME_ERROER"]="|cffffff00注意:|cffEEAA22[%s]|r分类|cffff0000不存在!|r";
L["SCRIPT_NAME_ERROER"]="|cffffff00注意:|r|cffEEAA22脚本:[%s]|r|cffff0000不存在!|r";
L["SCRIPT_GUID_ERROER"]="|cffffff00注意:|r|cffEEAA22GUID:[%s]|r|cffff0000不存在!|r";
L["SCRIPT_BODY_ERROER"]="|cffffff00注意:|r|cffEEAA22脚本:[%s]|r|cffff0000正文错误!|r";
L["SCRIPT_LIST_ERROER"]="|cffffff00注意:|r|cffEEAA22[%s]|r|cffff0000参数2错误|r";

L["SCHEME_NOTFOUND_STATUS"]="无法运行当前方案，请选择一个当前方案。";
L["SCHEME_NAME_EXAMPLE"]="范例";
L["SCHEME_TOOLTIP_TITLE"]="方案的名称";
L["SCHEME_TOOLTIP_LINE1"]="按下右边[↓]按钮选择方案";
L["SCHEME_TOOLTIP_LINE2"]="按下右边[↓]按钮选择[新建]创建新方案!";
L["SCHEME_NEW_TITLE"]="新建方案名称和图标";
L["SCHEME_UPDATA_TITLE"]="发现新版[%s],是否升级方案?"
L["SCHEME_STATUS_NEW"]="新建方案“%s”";
L["SCHEME_STATUS_DELETE_CONFIRM"]="您真的要刪除方案“%s”吗？";
L["SCHEME_STATUS_DELETE_FINISH"]="方案“%s”已刪除";
L["SCHEME_STATUS_CHANGE"]="切换到方案“%s”";

L["LIST_TOOLTIP_TITLE"]="动作项列表";
L["LIST_TOOLTIP_LINE1"]="添加：拖拽技能、拖拽可使用的物品、或右键建立脚本";
L["LIST_RIGHTCLICK_ADD"]="新建脚本";
L["LIST_RIGHTCLICK_ADD_BLANK"]="空脚本";
L["LIST_RIGHTCLICK_CONFIG_TITLE"]="方案设置";
L["LIST_RIGHTCLICK_CONFIG_CD_TITLE"]="设置运行间隔时间(秒)";
L["LIST_RIGHTCLICK_CONFIG_CD_STATUS"]="“%s”的运行间隔时间改为%.1f秒";
L["LIST_RIGHTCLICK_MACRO_TITLE"]="宏设置";
L["LIST_RIGHTCLICK_MACRO_RUN_TITLE"]="创建按钮方案宏";
L["LIST_RIGHTCLICK_MACRO_AUTO_TITLE"]="创建自动方案宏";
L["LIST_RIGHTCLICK_MACRO_AUTOITEM_TITLE"]="以当前方配置自动方案宏";
L["LIST_RIGHTCLICK_MACRO_STOP_TITLE"]="创建停止宏";
L["LIST_RIGHTCLICK_ADVANCED_TITLE"]="高级";
L["LIST_RIGHTCLICK_VARIABLE_TITLE"]="常量设置";




L["CUSTOM_NEW_TITLE"]="新建脚本名称和图标";
L["CUSTOM_EDIT_TITLE"]="编辑脚本名称和图标";

L["LISTITEM_TOOLTIP_TITLE"]="脚本“%s”(ID：%s)"; 
L["LISTITEM_TOOLTIP_LINE1"]="Ctrl+鼠标左键可以排序"; 
L["LISTITEM_TOOLTIP_CD"]="自定义冷却时间剩余%.1f秒"
L["LISTITEM_DESCRIPTION"]="當滿足條件時自動施放"; 
L["LISTITEM_CHECK_TOOLTIP_TITLE"]="启用/禁用“%s”";
L["LISTITEM_CHECK_TOOLTIP_LINE1"]="选中：启用";
L["LISTITEM_CHECK_TOOLTIP_LINE2"]="未选：禁用";
L["LISTITEM_CHECK_STATUS_ENABLED"]="已启用“%s”";
L["LISTITEM_CHECK_STATUS_DISABLED"]="已禁用“%s”";
L["LISTITEM_DELETE_CONFIRM"]="您真的要刪除当前方案中的“%s”吗？";
L["LISTITEM_DELETE_FINISH"]="當前方案中的“%s”已删除";
L["LISTITEM_DELETE_TOOLTIP_TITLE"]="删除使用的%s“%s”";
L["LISTITEM_STATUS_ADD"]="已添加%s脚本“%s”";
L["LISTITEM_STATUS_ADD_ITEM"]="物品";
L["LISTITEM_STATUS_ADD_SPELL"]="技能";
L["LISTITEM_STATUS_ADD_CUSTOM"]="自定义";
L["LISTITEM_STATUS_ADD_FAILURE1"]="添加动作项失败：“%s”不是一件可以使用的物品";
L["LISTITEM_RIGHTCLICK_TITLE"]="%s";
L["LISTITEM_RIGHTCLICK_DELETE_TITLE"]="|cffff0000删除|r";
L["LISTITEM_RIGHTCLICK_TARGET_TITLE"]="作用目标";
L["LISTITEM_RIGHTCLICK_CONFIG_TITLE"]="参数设置";
L["LISTITEM_RIGHTCLICK_ADVANCED_TITLE"]="高级";
L["LISTITEM_RIGHTCLICK_EDITACTION_TITLE"]="编辑脚本";
L["LISTITEM_RIGHTCLICK_CD_TITLE"]="自定义冷却时间(秒)";
L["LISTITEM_RIGHTCLICK_CD_STATUS"]="“%s”的自定义冷却时间为%.1f秒";
L["LISTITEM_RIGHTCLICK_DESCRIPTION_TITLE"]="描述说明";
L["LISTITEM_RIGHTCLICK_DESCRIPTION_STATUS"]="已编辑“%s”的描述说明";
L["LISTITEM_RIGHTCLICK_GUID_TITLE"]="|cff33ccbb标识号：|cffffff00%s|r|r";
L["LISTITEM_RIGHTCLICK_ADVANCED_RUN_TITLE"]="创建按键宏";
L["LISTITEM_RIGHTCLICK_ADVANCED_AUTO_TITLE"]="创建自动宏";
L["LISTITEM_RIGHTCLICK_ADVANCED_STOP_TITLE"]="创建停止宏";

L["SCHEMECONTROL_INPUT_BUTTON"]="导入";
L["SCHEMECONTROL_INPUT_TOOLTIP_TITLE"]="分享方案";
L["SCHEMECONTROL_INPUT_TOOLTIP_LINE1"]="导入方案字符串";
L["SCHEMECONTROL_INPUT_MESSAGE"]="[导入方案]粘贴(CTRL+V)需导入的方案字符串：";
L["SCHEMECONTROL_INPUT_MESSAGE2"]="[导入方案]为该方案起名：";
L["SCHEMECONTROL_INPUT_STATUS1"]="导入失败！存在同名方案“%s”";
L["SCHEMECONTROL_INPUT_STATUS2"]="导入失败！无法识别的方案字符串";
L["SCHEMECONTROL_OUTPUT_BUTTON"]="导出";
L["SCHEMECONTROL_OUTPUT_MESSAGE"]="[导出方案]复制(CTRL+C)当前方案字符串：";
L["SCHEMECONTROL_OUTPUT_TOOLTIP_LINE1"]="导出当前方案字符串";
L["SCHEMECONTROL_START_TITLE"]="启动";
L["SCHEMECONTROL_START_TOOLTIP_TITLE"]="启动";
L["SCHEMECONTROL_START_TOOLTIP_LINE1"]="启动自动执行当前方案";
L["SCHEMECONTROL_START_TOOLTIP_LINE2"]="您可以进入“按建设置”为该动作设置快捷键";
L["SCHEMECONTROL_STOP_TITLE"]="终止";
L["SCHEMECONTROL_STOP_TOOLTIP_TITLE"]="终止";
L["SCHEMECONTROL_STOP_TOOLTIP_LINE1"]="终止自动执行当前方案";
L["SCHEMECONTROL_STOP_TOOLTIP_LINE2"]="您可以进入“按建设置”为该动作设置快捷键";
L["KEYBINDING_RUNONCE"]="[手动]运行当前方案";
L["KEYBINDING_RUNSTART"]="[自动]连续式运行当前方案";
L["KEYBINDING_START"]="[启动自动]运行当前方案";
L["KEYBINDING_STOP"]="[终止自动]运行当前方案";
L["ENVIRONMENT_PROMPT_START"]="|cff00ff00已开始自动执行|r当前方案|cff00ffff“%s”|r。";
L["ENVIRONMENT_PROMPT_STOP"]="|cffff0000已停止自动执行|r当前方案|cff00ffff“%s”|r。";
L["ENVIRONMENT_CASTING"]="正在施放[%s]:%s";
L["ENVIRONMENT_CASTING_CURRENT"]="正在施放%s";

L["EDITER_TITLE"]="编辑“%s”的脚本";
L["EDITER_MENU_SAVE_TITLE"]="保存";
L["EDITER_MENU_DEBUG_TITLE"]="调试";
L["EDITER_LINE_TITLE"]="Line %s";
L["EDITER_EXIT_SAVE_CONFIRM"]="在退出前您还未保存当前代码，是否保存？";
L["EDITER_SAVE_FINISH"]="“%s”的脚本已保存！";
L["EDITER_DEBUG_FINISH"]="“%s”调试完成！";
L["MACRO_LENGTH_LONG"]="超过250字符限制，请缩短宏!"

L["VARIABLE"]="常量";
L["VARIABLE_TITLE"]="%s - "..L["VARIABLE"].."设置面板";
L["VARIABLE_EDIT"]="%s - "..L["VARIABLE"].."管理";
L["VARIABLE_NAME"]="常量名称:";
L["VARIABLE_DESCRIPTION"]="常量描述:";
L["VARIABLE_TYPE"]="常量类型:";
L["VARIABLE_TYPERADIO1"]="无值";
L["VARIABLE_TYPERADIO2"]="单值";
L["VARIABLE_TYPERADIO3"]="双值";
L["VARIABLE_SIZE"]="编辑框宽度:";
L["VARIABLE_SIZET"]="范围: %s-%s 之间";
L["VARIABLE_EDITTYPE"]="编辑框类型:";
L["VARIABLE_EDITRADIO1"]="数字型";
L["VARIABLE_EDITRADIO2"]="字符型";
L["VARIABLE_EDITRADIO3"]="代码型"; 
L["VARIABLE_VALUE"]="常量初始值:";
L["VARIABLE_SAVE"]="保存设置";
L["VARIABLE_RIGHTCLICK_EDIT_TITLE"]="编辑 -%s";
L["VARIABLE_RIGHTCLICK_ADD_TITLE"]="新建常量";
L["VARIABLE_RIGHTCLICK_DELETE_TITLE"]="|cffff0000删除|r";
L["VARIABLE_RIGHTCLICK_DELETE_CONFIRM"]="您真的要刪除“%s”吗？";
L["VARIABLE_RIGHTCLICK_SAME_CONFIRM"]="%s已经存在";



L["default"]="当前目标";
L["target"]="玩家目标";
L["targettarget"]="玩家目标的目标";
L["player"]="玩家自身";
L["nogoal"]="无需目标(如:坚韧祷言)";
L["focus"]="焦点";
L["focustarget"]="焦点的目标";
L["mouseover"]="鼠标指向目标";

L["CONDITION_CLASS_DEATHKNIGHT"]="死亡骑士";
L["CONDITION_CLASS_DRUID"]="德鲁伊";
L["CONDITION_CLASS_HUNTER"]="猎人";
L["CONDITION_CLASS_MAGE"]="法师";
L["CONDITION_CLASS_PALADIN"]="圣骑士";
L["CONDITION_CLASS_PRIEST"]="牧师";
L["CONDITION_CLASS_ROGUE"]="潜行者";
L["CONDITION_CLASS_SHAMAN"]="萨满祭司";
L["CONDITION_CLASS_WARLOCK"]="术士";
L["CONDITION_CLASS_WARRIOR"]="战士";
L["CONDITION_CLASS_MONK"]="武僧";

L["CLASS_COLOR_MONK"]="|cffabd4bb%s|r";
L["CLASS_COLOR_DEATHKNIGHT"]="|cffc41f3b%s|r";
L["CLASS_COLOR_DRUID"]="|cffff7d0a%s|r";
L["CLASS_COLOR_HUNTER"]="|cffabd473%s|r";
L["CLASS_COLOR_MAGE"]="|cff69ccf0%s|r";
L["CLASS_COLOR_PALADIN"]="|cfff58cba%s|r";
L["CLASS_COLOR_PRIEST"]="|cffffffff%s|r";
L["CLASS_COLOR_ROGUE"]="|cfffff569%s|r";
L["CLASS_COLOR_SHAMAN"]="|cff2459ff%s|r";
L["CLASS_COLOR_WARLOCK"]="|cff9482c9%s|r";
L["CLASS_COLOR_WARRIOR"]="|cffc79c6e%s|r";


L["WOWBEE_ABOUT"]="|cffff7d0a"..L["WOWBEE_VERSION"].."\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."@|cff00ff00魔蜂极限版 |cff0055FF核心库|r |cffffff00已加载\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."|cff55DD88提示:|r|cffEEAA22为保证魔蜂运行正常，请确保配套程序已正确注册并运行|r\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."|cff55DD88提示:|r|cffffff00通过输入|r".." |cffEE9922/Bee|r |cffffff00或使用小地图按钮来打开魔蜂专用编辑器，建立属于您自己的宏脚本|r\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."|cff55DD88提示:|r|cffffff00魔蜂极限版【新特性】:超快速【200%提速】,超稳定【0%错误】.|r\n";

L["WOWBEE_HELP"]="使用帮助:\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Helper\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."显示运行助手\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Start\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."运行助手[启动/关闭]\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Run 方案\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."运行一次[方案]中,勾选的脚本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Run 方案 脚本1\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."运行一次[方案]中,[脚本1]的脚本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Auto 方案\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."循环运行[方案]中,勾选的脚本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Auto 方案 脚本1,脚本2,脚本3\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."循环运行[方案]中,指定[脚本1,脚本2,脚本3]脚本. 脚本名可以为[脚本名]或者[脚本ID]如:[1,2,脚本4],当脚本名为数字时需要加单引号来区分脚本ID,如:['1',脚本2,3]\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Stop\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."停止所有自动脚本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."--------------------------------------\n";
