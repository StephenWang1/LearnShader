package.path = package.path .. ";" .. CS.UnityEngine.Application.persistentDataPath .. "/?.lua"
---加载xlua
util = require 'xlua.util'
---加载协程相关
local cs_coroutine = require 'luaRes.common.cs_coroutine'
---lua协程中调用C#的yield return方式
yield_return = cs_coroutine.yield_return
---开启C#协程方法(Lua中定义,C#中运行)
StartCoroutine = cs_coroutine.StartCoroutine
---关闭Lua中定义,在C#中运行的协程的方法
StopCoroutine = cs_coroutine.StopCoroutine
---文件读写
file_util = require 'luaRes.common.file_util'
---@type luaStringBuilder
stringbuilder = require "luaRes.common.luaStringBuilder"
---加载全局方法
require "luaRes.common.GlobalMethod"
---Lua UI消息
require 'luaRes.enum.LuaClientEnum'
---lua类控制器
---@type classCtrl
classCtrl = require "luaRes.luaclass.luaclass"
---通用
Utility = require "luaRes.common.CommonUtils"
---装备的通用
require "luaRes.common.Utility.Utility_Equip"
---传送的通用
require "luaRes.common.Utility.Utility_Transfer"
---时间的通用
require "luaRes.common.Utility.Utility_Time"
---行会活动的通用
require "luaRes.common.Utility.Utility_UnionActivity"
---宝物的通用
require "luaRes.common.Utility.Utility_Gem"
---勋章的通用
require "luaRes.common.Utility.Utility_Medal"
---回收的通用
require "luaRes.common.Utility.Utility_Recycle"
---用来处理材质球的
require "luaRes.common.Utility.Utility_MaterialShader"
---用来人物的条件检测
require "luaRes.common.Utility.Utility_MainPlayerConditionCheck"
---用来灵兽的条件检测
require "luaRes.common.Utility.Utility_ServantConditionCheck"
---用来道具相关的拓展
require "luaRes.common.Utility.Utility_Item"
---锻造的通用
require "luaRes.common.Utility.Utility_Strength"
---战斗连击次数通用
require "luaRes.common.Utility.Utility_ComboCount"
---灵兽的通用
require "luaRes.common.Utility.Utility_Servant"
---仓库的通用
require "luaRes.common.Utility.Utility_Warehouse"
---交易行的通用
require "luaRes.common.Utility.Utility_Auction"
---阵法的通用
require "luaRes.common.Utility.Utility_ZhenFa"
---盾牌斗笠的通用
require "luaRes.common.Utility.Utility_ShieldAndHat"

---模板管理
templatemanager = require "luaRes.ui.TemplateManager"
---模板基类
templatebase = require "luaRes.ui.TemplateBase"
---UI管理
uimanager = require 'luaRes.ui.UIManager'
---protobuf管理
---@type protobufMgr
protobufMgr = require 'luaRes.protobufLua.protobufMgr'
---加载lua枚举
require 'luaRes.enum.LuaEnum'
---UI界面基类
uibase = require 'luaRes.ui.UIBase'
---@type LuaDebug LogUIForgePanel
luaDebug = require 'luaRes.common.LuaDebug'
---注入更新管理器
hotfixmgr = require "luaRes.hotfixcodes.hotfixmgr"
---客户端消息处理,用于lua端对无UI界面的客户端消息进行处理
clientMessageDeal = require 'luaRes.common.ClientMessageDeal'
---通用网络消息分发
---@type NetMsgManager
commonNetMsgDeal = require 'luaRes.common.NetMsgManager'
---lua事件管理,用于lua内部的事件分发,便于模块之间解耦合
---@type ClientMsgManager
luaEventManager = require 'luaRes.common.ClientMsgManager'
---通用表格加载
commonTableDeal = require 'luaRes.common.CommonTableLoadedDealManager'
---UI界面中使用到的静态变量
uiStaticParameter = require 'luaRes.ui.UIStaticParameter'
---LuaBehaviour进行特殊处理
xlua.private_accessible(CS.LuaBehaviour)
---UI界面配置
uipanelconfig = require 'luaRes.ui.UIPanelConfig'
---lua事件管理
eventHandler = require 'luaRes.common.EventHandler'
---本地测试标志位
isUnityEditor = false
---lua根目录路径
preMainPath = ''
---lua缓存路径
cachePath=''
---启动自动重载lua机制
require 'luaRes.common.ReloadLuaFile'
---内存泄露定位工具CSInterfaceSingletonMgr.Init();
memory = require "perf.memory"
---内存分析工具
memoryanalyze = require "luaRes.analyze.memoryanalyze"

--- UI跳转管理
uiTransferManager = require 'luaRes.ui.UITransferManager'
---@type GameMgr 游戏管理器
gameMgr = require "luaRes.game.GameMgr"

---通用杂项表数据处理
LuaGlobalTableDeal = require "luaRes.common.LuaGlobalTableDeal"

---热更检测
---@type HotCheckout
HotCheckout = require "luaRes.common.HotCheckout"

tableLoader = require 'luaRes.table.TableLoader'
tableManager = require 'luaRes.table.TableManager'
registerAllClientTable = require 'luaRes.table.registerAllClientTable'
---初始化lua
---在C#中调用,初始化lua
function InitRequire(isUE, path,cPath)
    isUnityEditor = isUE
    if isUnityEditor then
        local  applicationDataPath = CS.System.Environment.GetFolderPath(CS.System.Environment.SpecialFolder.ApplicationData);
        applicationDataPath = applicationDataPath..'/JetBrains/IdeaIC2020.1/plugins/intellij-emmylua/classes/debugger/emmy/windows/x64/?.dll'
        CS.UnityEngine.Debug.Log('EditorLog:'..applicationDataPath)
        package.cpath = package.cpath .. ';'..applicationDataPath
        try
        {
            main = function()
                local dbg = require('emmy_core')
                dbg.tcpConnect('localhost', 9966)
            end,
            catch = function(errors)
                CS.UnityEngine.Debug.Log("<color=#ff8400>catch : 调试连接错误，需要先启动IDEA调试(无需调试就不用管他)</color>:" .. errors)
            end
        }

    end
    preMainPath = path
    cachePath=cPath
    hotfixmgr.Initialize()
    protobufMgr.Init()
    classCtrl:Initialize()
    templatemanager.Initialize()
    uipanelconfig.Initialize()
    clientMessageDeal.Initialize()
    uiTransferManager:Initialize();
    gameMgr:Initialize()
    CS.UIDebugInfo.maxGroupNum = 200
    if (CS.CSGameState.RunPlatform ~= CS.ERunPlatform.Editor) then
        require "luaRes.localtest"
    end
    --if (CS.XLuaMgr.Instance.isLocalTest == true) then
    --    require "luaRes.localtest"
    --end
    ---日志开关
    isOpenLog = CS.CSDebug.developerConsoleVisible

    --CS.XLuaMgr.Instance.ScriptContentCache.IsOpenScriptContentCache = false
    CS.XLuaMgr.Instance.ScriptContentCache:AddFixedTargetPanelName("UIBagPanel")
    CS.XLuaMgr.Instance.ScriptContentCache:AddFixedTargetPanelName("UIRolePanel")
    CS.XLuaMgr.Instance.ScriptContentCache:AddFixedTargetPanelName("UIMonsterHeadPanel")
    ---摊位人物模型偏移量修改
    --CS.BoothModelLoad.boothPlayerOffsetPosition = CS.UnityEngine.Vector3.zero
    --[[Debug开关,解除封印的方式是行首再加一个'-'
    DebugSwitch(true)
    uimanager:CreatePanel("UIGMToolPanel", nil, LuaEnumGMPanelType.GMLogViewer)
    --]]
    --CS.Cfg_EffectIconTableManager.replaceIsOpened = false
end

---初始化UI界面
---在C#中调用,初始化UI界面
function InitUI()
    --if CS.LuaReferenceFindTool.Instance ~= nil and CS.StaticUtility.IsNull(CS.LuaReferenceFindTool.Instance) == false then
    -----Lua调试工具
    -----@type LuaDebugTool
    --luaDebugTool = require "luaRes.tool.luaDebugTool"
    --end
    --游戏进入时初始化UI界面,创建第一个UI界面登录面板
    uimanager:Initialize()
    uimanager:CreatePanel("UILoginPanel", nil)
end

---离开游戏场景时清空缓存
function ClearCacheBeforeLeaveGame()
    if uimanager then
        uimanager:GetUICacheLogic():ClearAllCaches()
    end
    if uiStaticParameter then
        uiStaticParameter.mIsNeedOpenAutoFightAfterDeliver = nil
        uiStaticParameter.mIsFCMTipsPanelOpenedByFCMStateChange = nil
        uiStaticParameter.mIsFCMTipPanelOpenedByLastTime = nil
        uiStaticParameter.UseItemAndOpenAppearancePanelItemID = nil
        uiStaticParameter.UseItemAndOpenAppearancePanelMaxTime = nil
        uiStaticParameter.isOpenDefendKingLeftRankInfo = false
        --region Union
        ---帮会打开查看玩家
        uiStaticParameter.mUnionOpenViewPerson = false
        ---帮会弹劾查看玩家
        uiStaticParameter.mUnionAccuseViewPerson = false
        ---帮会购买改名卡
        uiStaticParameter.mUnionInfoToShop = false
        ---首次登陆需要显示帮会推送
        uiStaticParameter.mNeedShowUnionPush = false
        --endregion
        uiStaticParameter.CurDefendKingTimeStamp = 0
        uiStaticParameter.CurHUANJINGTimeStamp = 0
        uiStaticParameter.CurUnionDartCarActivityTime = 0
        uiStaticParameter.CurGoddessActivityTime = 0
        uiStaticParameter.CurBuDouKaiActivityTime = 0
        ---正在修炼的灵兽位置
        uiStaticParameter.nowPracticeIndex = 0
        ---清空面巾之前是否装备过标志位
        uiStaticParameter.mIsFaceEquippedBefore = nil

        ---清空聚灵珠推送倒计时
        uiStaticParameter.UpdataCheckJuLingZhuPush = false
        uiStaticParameter.LastCheckJuLingZhu = 0
        uiStaticParameter.mIsBigJuLingZhuTipExist = false

        ---死亡掉落数据重置
        uiStaticParameter.mDeadAndDropItemParam = nil
        uiStaticParameter.mDeadAndDropItemTime = nil

        uiStaticParameter.mInitCombitServant = true

        ---清空自动组队提示登录不再提示的标识
        uiStaticParameter.mAutoTeamTipsDoNotHintAgain = nil
        ---清空
        --uiStaticParameter.IsReciveTaskWaitOpenMonsterArrestPanel = false

        if uiStaticParameter.ServantFlashCount ~= nil then
            if uiStaticParameter.ServantFlashCount ~= nil then
                CS.CSListUpdateMgr.Instance:Remove(uiStaticParameter.ServantFlashCount)
            end
            uiStaticParameter.ServantFlashCount = nil
        end
        ---首次登陆变强提示
        uiStaticParameter.isFirstStrongPrompt = false

        uiStaticParameter.CurXpSkillId = 0
        ---灵兽修炼红点标记
        uiStaticParameter.NeedCallServantPracticeRedPoint = false
        ---转移推送
        uiStaticParameter.NeedPushTransfer = true
        ---缓存闪烁气泡数据
        uiStaticParameter.flashCache = nil
        ---清理时间线
        luaclass.LuaTimeMgr:Clear()

        uiStaticParameter.mSealMarkNeedInfo = nil

        uiStaticParameter.PotentialRedPointInfo = nil

        uiStaticParameter.InitializedLCRedPoint = false

        uiStaticParameter.NeedPrintHeart = false

        uiStaticParameter.PersonalBossRedPointLock = false
        uiStaticParameter.mJuBaoPenBufferPos = nil
        uiStaticParameter.mDoctorCD = 0
    end
    uiTransferManager:TryResetLastTransfer();
    gameMgr:OnExitGameScene()
    uiStaticParameter.mIsStorageNeedTidyChecked = false
end

---切换Debug的开关
---@param isSetDebugOn boolean 是否开启Debug日志
---@param isExtraMessageShow boolean 是否显示额外的消息
function DebugSwitch(isSetDebugOn, isExtraMessageShow)
    print("日志开关: " .. tostring(isSetDebugOn) .. "  是否显示额外消息: " .. tostring(isExtraMessageShow))
    CS.CSLogManager.Instance.IsRecording = isSetDebugOn
    local isExtraMsgShowOn = isSetDebugOn == true and isExtraMessageShow == true
    isOpenLog = isExtraMsgShowOn
    CS.CSDebug.developerConsoleVisible = isExtraMsgShowOn
    CS.SDebug.developerConsoleVisible = isExtraMsgShowOn
    CS.CSLogManager.Instance.NetworkMsgLogger.IsOn = isExtraMsgShowOn
    CS.CSLogManager.Instance.ClientMsg.IsOn = isExtraMsgShowOn
    CS.CSLogManager.Instance.LocalLogLogger.IsOn = isExtraMsgShowOn
end