---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2021/8/2 15:58
--- 一个快捷键对应一个LuaCEvent消息
---@class LuaShortcutKeyMgr:luaclass
local LuaShortcutKeyMgr = {}
function LuaShortcutKeyMgr:Init()
    LuaShortcutKeyMgr.InitShortcutKeysInfo()
end

function LuaShortcutKeyMgr.GetMsgMgr()
    if(LuaShortcutKeyMgr.msgMgr== nil) then
        LuaShortcutKeyMgr.msgMgr= luaclass.LuaShortcutKeyMsgMgr:New()
    end
    return LuaShortcutKeyMgr.msgMgr
end

function LuaShortcutKeyMgr.InitShortcutKeysInfo()
    local info = LuaShortcutKeyMgr.ReadInfo()
    if (Utility.IsNullTable(info)) then
        return
    end

    for i = 1, #info do
        if (not Utility.IsNullTable(info[i])) then
            LuaShortcutKeyMgr.GetInfos()[info[i].id] = info[i]
        end
    end
end

---按键按下时判断是否有快捷键响应
function LuaShortcutKeyMgr.CheckShortcutKeyInput()
    if (not CS.UnityEngine.Input.anyKeyDown) then
        return
    end

    for i, v in pairs(LuaShortcutKeyMgr.GetInfos()) do
        if not Utility.IsNullTable(v) and v.IsInput(v) then
            LuaShortcutKeyMgr.BroadCast(v.id)
        end
    end
end

--region 增删改查
---@class AddShortResult
---@field isSuccess boolean 添加是否成功
---@field result string 添加不成功原因
---@param info LuaShortcutKeyInfo
---@param isCover boolean 如果已存在是否覆盖
---@return AddShortResult
function LuaShortcutKeyMgr.AddShortcut(info, isCover)

    if (Utility.IsNullTable(info) or not info:IsValid()) then
        return  { isSuccess = false, result = "添加的快捷键无效" }
    end

    if (LuaShortcutKeyMgr.GetInfos()[info.id]) then
        if (isCover == nil or not isCover) then
            return  { isSuccess = false, result = "按键已存在" }
        else

            return  { isSuccess = true, result = "覆盖成功" }
        end
    end

    for i, v in pairs(LuaShortcutKeyMgr.GetInfos()) do
        if (v:IsSameKeyByInfo(info)) then
            return  { isSuccess = false, result = "快捷键冲突" }
        end
    end

    LuaShortcutKeyMgr.WriteInfo()
    LuaShortcutKeyMgr.GetInfos()[info.id] = info

    return  { isSuccess = true, result = "添加成功" }
end

---@param listKeyCode table<number,table<number,UnityEngine.KeyCode>> 例如{{leftCtrl,rightCtrl},{leftAlt,rightAlt},{A}}
---@param msgId number 快捷键消息类型
---@param name string 快捷键名字
---@param isCover boolean 是否替换已有的快捷键信息
---@return AddShortResult
function LuaShortcutKeyMgr.AddShortcutSimple(listKeyCode, msgId, name, isCover)
    if (Utility.IsNullTable(listKeyCode) or msgId == nil or msgId == 0) then
        return  { isSuccess = false, result = "添加信息有误" }

    end
    ---@type LuaShortcutKeyInfo
    local shortcutInfo = luaclass.LuaShortcutKeyInfo:New()
    shortcutInfo.id = msgId
    shortcutInfo.name = name
    shortcutInfo.currKeyCodes={}
    for i = 1, #listKeyCode do
        if (listKeyCode ~= nil) then
            ---@type LuaShortcutKeyItem
            local keyItem = luaclass.LuaShortcutKeyItem:New()
            keyItem.keyCodes = listKeyCode[i]
            table.insert(shortcutInfo.currKeyCodes, keyItem)
        end
    end

    return  LuaShortcutKeyMgr.AddShortcut(shortcutInfo, false)
end

---@param info LuaShortcutKeyInfo
function LuaShortcutKeyMgr.ModifyShortcut(info)
    local selfInfo = LuaShortcutKeyMgr.GetInfos()[info.id]
    if (selfInfo) then
        LuaShortcutKeyMgr.GetInfos()[info.Name] = info
        LuaShortcutKeyMgr.WriteInfo()
    else
        print(string.CSFormat("快捷键:{0}未发现", info.id))
    end
end
---@param  info LuaShortcutKeyInfo
function LuaShortcutKeyMgr.RemoveShortcut(info)
    self.RemoveShortcutById(info.id)
end

function LuaShortcutKeyMgr.RemoveShortcutById(id)
    local selfInfo = LuaShortcutKeyMgr.GetInfos()[id]
    if (selfInfo) then
        table.remove(id)
        LuaShortcutKeyMgr.RemoveMsg(id)
    else
        print(string.CSFormat("快捷键:{0}未发现", id))
    end
end
---@param id LuaCEvent
---@return ShortCutKeyInfo
function LuaShortcutKeyMgr.GetShortcutById(id)
    return LuaShortcutKeyMgr.GetInfos()[id]
end

function LuaShortcutKeyMgr.GetInfos()
    if(LuaShortcutKeyMgr.shortCutKeysInfoDic== nil) then
        LuaShortcutKeyMgr.shortCutKeysInfoDic={}
    end
    return LuaShortcutKeyMgr.shortCutKeysInfoDic
end

--endregion
--region 消息处理
---@param msgId LuaCEvent
function LuaShortcutKeyMgr.BroadCast(msgId, data)
    luaEventManager.DoCallback(msgId)
end

function LuaShortcutKeyMgr.RemoveMsg(msgId)
    luaEventManager.ClearCallback(msgId)
end
--endregion

--region 快捷键储存管理
---读取存储的快捷建信息
---@return table<number,LuaShortcutKeyInfo>
function LuaShortcutKeyMgr.ReadInfo()
    --todo:将信息存到服务器或本地
end

---储存快捷键信息
function LuaShortcutKeyMgr.WriteInfo()
    --todo:读取服务器或本地快捷键信息
end
--endregion

function LuaShortcutKeyMgr.Update()
    LuaShortcutKeyMgr.CheckShortcutKeyInput()
end

return LuaShortcutKeyMgr