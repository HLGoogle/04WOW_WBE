local l=GetLocale()=="zhTW" 
if not l then 
	return;
end 

WowBeeLocale={};
local L=WowBeeLocale;
L["WOWBEE_TITLE"]="魔蜂";
L["WOWBEE_TOOLTIP"]="魔蜂核心插件" .. GetAddOnMetadata("WowBee", "Version");
L["WOWBEE_VERSION"]="魔蜂控制面板" .. GetAddOnMetadata("WowBee", "Version");
L["WOWBEE_CONNECTION"]="魔蜂連接成功！";
L["WOWBEE_DISCONNECT"]="魔蜂斷開連接！";
L["WOWBEE_DELAY"]="|cffffff00連接響應延時:|r|cffff0000 %.4f |r|cffffff00秒|r";
L["WOWBEE_COMERROR"]="|cffffff00注意:|r|cffff0000魔蜂連接成功！響應測試失敗！|cffEEAA22如不能使用，請重新打開《魔獸世界》！|r"
L["WOWBEE_ADDONS_NOINSTALL"]=" 沒安裝或者沒啟用！";
L["WOWBEE_BINDING_SHOW"]="打開/關閉運行界面";
L["WOWBEE_BINDING_STARTSTOP"] = "運行/停止自動腳本";
L["WOWBEE_BINDING_STOP"] = "停止自動腳本";

L["GUI_MAINFRAME_TITLE"]="魔蜂 - 控制面板";
L["GUI_MAINFRAME_TOOLTIP"]=L["WOWBEE_VERSION"];
L["GUI_MAINFRAME_LOCK"]="鎖定";
L["GUI_MAINFRAME_LOCK_STATUS1"]="界面已鎖定";
L["GUI_MAINFRAME_LOCK_STATUS2"]="界面已解鎖";
L["GUI_MAINFRAME_HIDE"]="隱藏";
L["GUI_MAINFRAME_SCHEMEDROPDOWN"]="方案";
L["GUI_BOXFRAME_TITLE"]="錯誤代碼";

L["SCRIPT_STRART"]="|cffffff00注意:|r|cff00ff00自動運行腳本已啟動!|r";
L["SCRIPT_STOP"]="|cffffff00注意:|r|cffff0000自動運行腳本已停止!|r";
L["SCRIPT_STRART_LIST"]="|cffffff00注意:|r|cff00ff00[%s]方案以[%s]方式啟動!|r";
L["SCRIPT_STRART_DEFAULT"]="默認";
L["SCRIPT_SCHEME_ERROER"]="|cffffff00注意:|cffEEAA22[%s]|r分類|cffff0000不存在!|r";
L["SCRIPT_NAME_ERROER"]="|cffffff00注意:|r|cffEEAA22腳本:[%s]|r|cffff0000不存在!|r";
L["SCRIPT_GUID_ERROER"]="|cffffff00注意:|r|cffEEAA22GUID:[%s]|r|cffff0000不存在!|r";
L["SCRIPT_BODY_ERROER"]="|cffffff00注意:|r|cffEEAA22腳本:[%s]|r|cffff0000正文錯誤!|r";
L["SCRIPT_LIST_ERROER"]="|cffffff00注意:|r|cffEEAA22[%s]|r|cffff0000參數2錯誤|r";

L["SCHEME_NOTFOUND_STATUS"]="無法運行當前方案，請選擇一個當前方案。";
L["SCHEME_NAME_EXAMPLE"]="範例";
L["SCHEME_TOOLTIP_TITLE"]="方案的名稱";
L["SCHEME_TOOLTIP_LINE1"]="按下右邊[↓]按鈕選擇方案";
L["SCHEME_TOOLTIP_LINE2"]="按下右邊[↓]按鈕選擇[新建]創建新方案!";
L["SCHEME_NEW_TITLE"]="新建方案名稱和圖標";
L["SCHEME_UPDATA_TITLE"]="發現新版[%s],是否升級方案?"
L["SCHEME_STATUS_NEW"]="新建方案“%s”";
L["SCHEME_STATUS_DELETE_CONFIRM"]="您真的要刪除方案“%s”嗎？";
L["SCHEME_STATUS_DELETE_FINISH"]="方案“%s”已刪除";
L["SCHEME_STATUS_CHANGE"]="切換到方案“%s”";

L["LIST_TOOLTIP_TITLE"]="動作項列表";
L["LIST_TOOLTIP_LINE1"]="添加：拖拽技能、拖拽可使用的物品、或右鍵建立腳本";
L["LIST_RIGHTCLICK_ADD"]="新建腳本";
L["LIST_RIGHTCLICK_ADD_BLANK"]="空腳本";
L["LIST_RIGHTCLICK_CONFIG_TITLE"]="方案設置";
L["LIST_RIGHTCLICK_CONFIG_CD_TITLE"]="設置運行間隔時間(秒)";
L["LIST_RIGHTCLICK_CONFIG_CD_STATUS"]="“%s”的運行間隔時間改為%.1f秒";
L["LIST_RIGHTCLICK_MACRO_TITLE"]="宏設置";
L["LIST_RIGHTCLICK_MACRO_RUN_TITLE"]="創建按鈕方案宏";
L["LIST_RIGHTCLICK_MACRO_AUTO_TITLE"]="創建自動方案宏";
L["LIST_RIGHTCLICK_MACRO_AUTOITEM_TITLE"]="以當前方配置自動方案宏";
L["LIST_RIGHTCLICK_MACRO_STOP_TITLE"]="創建停止宏";
L["LIST_RIGHTCLICK_ADVANCED_TITLE"]="高級";
L["LIST_RIGHTCLICK_VARIABLE_TITLE"]="常量設置";




L["CUSTOM_NEW_TITLE"]="新建腳本名稱和圖標";
L["CUSTOM_EDIT_TITLE"]="編輯腳本名稱和圖標";

L["LISTITEM_TOOLTIP_TITLE"]="腳本“%s”(ID：%s)";
L["LISTITEM_TOOLTIP_LINE1"]="Ctrl+鼠標左鍵可以排序";
L["LISTITEM_TOOLTIP_CD"]="自定義冷卻時間剩餘%.1f秒"
L["LISTITEM_DESCRIPTION"]="當滿足條件時自動施放";
L["LISTITEM_CHECK_TOOLTIP_TITLE"]="啟用/禁用“%s”";
L["LISTITEM_CHECK_TOOLTIP_LINE1"]="選中：啟用";
L["LISTITEM_CHECK_TOOLTIP_LINE2"]="未選：禁用";
L["LISTITEM_CHECK_STATUS_ENABLED"]="已啟用“%s”";
L["LISTITEM_CHECK_STATUS_DISABLED"]="已禁用“%s”";
L["LISTITEM_DELETE_CONFIRM"]="您真的要刪除當前方案中的“%s”嗎？";
L["LISTITEM_DELETE_FINISH"]="當前方案中的“%s”已刪除";
L["LISTITEM_DELETE_TOOLTIP_TITLE"]="刪除使用的%s“%s”";
L["LISTITEM_STATUS_ADD"]="已添加%s腳本“%s”";
L["LISTITEM_STATUS_ADD_ITEM"]="物品";
L["LISTITEM_STATUS_ADD_SPELL"]="技能";
L["LISTITEM_STATUS_ADD_CUSTOM"]="自定義";
L["LISTITEM_STATUS_ADD_FAILURE1"]="添加動作項失敗：“%s”不是一件可以使用的物品";
L["LISTITEM_RIGHTCLICK_TITLE"]="%s";
L["LISTITEM_RIGHTCLICK_DELETE_TITLE"]="|cffff0000刪除|r";
L["LISTITEM_RIGHTCLICK_TARGET_TITLE"]="作用目標";
L["LISTITEM_RIGHTCLICK_CONFIG_TITLE"]="參數設置";
L["LISTITEM_RIGHTCLICK_ADVANCED_TITLE"]="高級";
L["LISTITEM_RIGHTCLICK_EDITACTION_TITLE"]="編輯腳本";
L["LISTITEM_RIGHTCLICK_CD_TITLE"]="自定義冷卻時間(秒)";
L["LISTITEM_RIGHTCLICK_CD_STATUS"]="“%s”的自定義冷卻時間為%.1f秒";
L["LISTITEM_RIGHTCLICK_DESCRIPTION_TITLE"]="描述說明";
L["LISTITEM_RIGHTCLICK_DESCRIPTION_STATUS"]="已編輯“%s”的描述說明";
L["LISTITEM_RIGHTCLICK_GUID_TITLE"]="|cff33ccbb標識號：|cffffff00%s|r|r";
L["LISTITEM_RIGHTCLICK_ADVANCED_RUN_TITLE"]="創建按鍵宏";
L["LISTITEM_RIGHTCLICK_ADVANCED_AUTO_TITLE"]="創建自動宏";
L["LISTITEM_RIGHTCLICK_ADVANCED_STOP_TITLE"]="創建停止宏";

L["SCHEMECONTROL_INPUT_BUTTON"]="導入";
L["SCHEMECONTROL_INPUT_TOOLTIP_TITLE"]="分享方案";
L["SCHEMECONTROL_INPUT_TOOLTIP_LINE1"]="導入方案字符串";
L["SCHEMECONTROL_INPUT_MESSAGE"]="[導入方案]粘貼(CTRL+V)需導入的方案字符串：";
L["SCHEMECONTROL_INPUT_MESSAGE2"]="[導入方案]為該方案起名：";
L["SCHEMECONTROL_INPUT_STATUS1"]="導入失敗！存在同名方案“%s”";
L["SCHEMECONTROL_INPUT_STATUS2"]="導入失敗！無法識別的方案字符串";
L["SCHEMECONTROL_OUTPUT_BUTTON"]="導出";
L["SCHEMECONTROL_OUTPUT_MESSAGE"]="[導出方案]複製(CTRL+C)當前方案字符串：";
L["SCHEMECONTROL_OUTPUT_TOOLTIP_LINE1"]="導出當前方案字符串";
L["SCHEMECONTROL_START_TITLE"]="啟動";
L["SCHEMECONTROL_START_TOOLTIP_TITLE"]="啟動";
L["SCHEMECONTROL_START_TOOLTIP_LINE1"]="啟動自動執行當前方案";
L["SCHEMECONTROL_START_TOOLTIP_LINE2"]="您可以進入“按建設置”為該動作設置快捷鍵";
L["SCHEMECONTROL_STOP_TITLE"]="終止";
L["SCHEMECONTROL_STOP_TOOLTIP_TITLE"]="終止";
L["SCHEMECONTROL_STOP_TOOLTIP_LINE1"]="終止自動執行當前方案";
L["SCHEMECONTROL_STOP_TOOLTIP_LINE2"]="您可以進入“按建設置”為該動作設置快捷鍵";
L["KEYBINDING_RUNONCE"]="[手動]運行當前方案";
L["KEYBINDING_RUNSTART"]="[自動]連續式運行當前方案";
L["KEYBINDING_START"]="[啟動自動]運行當前方案";
L["KEYBINDING_STOP"]="[終止自動]運行當前方案";
L["ENVIRONMENT_PROMPT_START"]="|cff00ff00已開始自動執行|r當前方案|cff00ffff“%s”|r。";
L["ENVIRONMENT_PROMPT_STOP"]="|cffff0000已停止自動執行|r當前方案|cff00ffff“%s”|r。";
L["ENVIRONMENT_CASTING"]="正在施放[%s]:%s";
L["ENVIRONMENT_CASTING_CURRENT"]="正在施放%s";

L["EDITER_TITLE"]="編輯“%s”的腳本";
L["EDITER_MENU_SAVE_TITLE"]="保存";
L["EDITER_MENU_DEBUG_TITLE"]="調試";
L["EDITER_LINE_TITLE"]="Line %s";
L["EDITER_EXIT_SAVE_CONFIRM"]="在退出前您還未保存當前代碼，是否保存？";
L["EDITER_SAVE_FINISH"]="“%s”的腳本已保存！";
L["EDITER_DEBUG_FINISH"]="“%s”調試完成！";
L["MACRO_LENGTH_LONG"]="超過250字符限制，請縮短宏!"

L["VARIABLE"]="常量";
L["VARIABLE_TITLE"]="%s - "..L["VARIABLE"].."設置面板";
L["VARIABLE_EDIT"]="%s - "..L["VARIABLE"].."管理";
L["VARIABLE_NAME"]="常量名稱:";
L["VARIABLE_DESCRIPTION"]="常量描述:";
L["VARIABLE_TYPE"]="常量類型:";
L["VARIABLE_TYPERADIO1"]="無值";
L["VARIABLE_TYPERADIO2"]="單值";
L["VARIABLE_TYPERADIO3"]="雙值";
L["VARIABLE_SIZE"]="編輯框寬度:";
L["VARIABLE_SIZET"]="範圍: %s-%s 之間";
L["VARIABLE_EDITTYPE"]="編輯框類型:";
L["VARIABLE_EDITRADIO1"]="數字型";
L["VARIABLE_EDITRADIO2"]="字符型";
L["VARIABLE_EDITRADIO3"]="代碼型";
L["VARIABLE_VALUE"]="常量初始值:";
L["VARIABLE_SAVE"]="保存設置";
L["VARIABLE_RIGHTCLICK_EDIT_TITLE"]="編輯 -%s";
L["VARIABLE_RIGHTCLICK_ADD_TITLE"]="新建常量";
L["VARIABLE_RIGHTCLICK_DELETE_TITLE"]="|cffff0000刪除|r";
L["VARIABLE_RIGHTCLICK_DELETE_CONFIRM"]="您真的要刪除“%s”嗎？";
L["VARIABLE_RIGHTCLICK_SAME_CONFIRM"]="%s已經存在";



L["default"]="當前目標";
L["target"]="玩家目標";
L["targettarget"]="玩家目標的目標";
L["player"]="玩家自身";
L["nogoal"]="無需目標(如:堅韌禱言)";
L["focus"]="焦點";
L["focustarget"]="焦點的目標";
L["mouseover"]="鼠標指向目標";

L["CONDITION_CLASS_DEATHKNIGHT"]="死亡騎士";
L["CONDITION_CLASS_DRUID"]="德魯伊";
L["CONDITION_CLASS_HUNTER"]="獵人";
L["CONDITION_CLASS_MAGE"]="法師";
L["CONDITION_CLASS_PALADIN"]="聖騎士";
L["CONDITION_CLASS_PRIEST"]="牧師";
L["CONDITION_CLASS_ROGUE"]="潛行者";
L["CONDITION_CLASS_SHAMAN"]="薩滿祭司";
L["CONDITION_CLASS_WARLOCK"]="術士";
L["CONDITION_CLASS_WARRIOR"]="戰士";

L["CLASS_COLOR_DEATHKNIGHT"]="|cffc41f3b%s|r";
L["CLASS_COLOR_DRUID"]="|cffff7d0a%s|r";
L["CLASS_COLOR_HUNTER"]="|cffabd473%s|r";
L["CLASS_COLOR_MAGE"]="|cff69ccf0%s|r";
L["CLASS_COLOR_PALADIN"]="|cfff58cba%s|r";
L["CLASS_COLOR_PRIEST"]="|cffffffff%s|r";
L["CLASS_COLOR_ROGUE"]="|cfffff569%​​s|r";
L["CLASS_COLOR_SHAMAN"]="|cff2459ff%s|r";
L["CLASS_COLOR_WARLOCK"]="|cff9482c9%s|r";
L["CLASS_COLOR_WARRIOR"]="|cffc79c6e%s|r";


L["WOWBEE_ABOUT"]="|cffff7d0a"..L["WOWBEE_VERSION"].."\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."@|cff00ff00魔蜂|cff0055FF核心庫|r |cffffff00已加載\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."|cff55DD88提示:|r|cffEEAA22為保證魔蜂運行正常，請確保魔蜂主程序已正確連接|r\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."|cff55DD88提示:|r|cffffff00通過輸入|r".." |cffEE9922/Bee|r |cffffff00或使用小地圖按鈕來打開魔蜂專用編輯器，建立屬於您自己的宏腳本|r\n";
L["WOWBEE_ABOUT"]=L["WOWBEE_ABOUT"].."|cff55DD88提示:|r|cffffff00想更多了解魔蜂- 魔獸世界自動宏插件, 請訪問魔蜂中文論壇http://bbs. cnwowbee.com/|r\n";

L["WOWBEE_HELP"]="使用幫助:\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Helper\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."顯示運行助手\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Start\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."運行助手[啟動/關閉]\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Run 方案\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."運行一次[方案]中,勾選的腳本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Run 方案腳本1\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."運行一次[方案]中,[腳本1]的腳本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Auto 方案\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."循環運行[方案]中,勾選的腳本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Auto 方案腳本1,腳本2,腳本3\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."循環運行[方案]中,指定[腳本1,腳本2,腳本3]腳本. 腳本名可以為[腳本名]或者[腳本ID]如:[1,2,腳本4],當腳本名為數字時需要加單引號來區分腳本ID,如:['1',腳本2,3]\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."/Bee Stop\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."停止所有自動腳本\n";
L["WOWBEE_HELP"]=L["WOWBEE_HELP"].."---------------------------------- ----\n";