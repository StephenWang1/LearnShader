--[[本文件为工具自动生成,禁止手动修改]]
---@class TABLE.cfg_conditions
local cfg_conditions = {}

cfg_conditions.__index = cfg_conditions

function cfg_conditions:UUID()
    return self.id
end

---@return number id#客户端#服务端#C  第1位代表目标类型，第2345位代表编号
function cfg_conditions:GetId()
    if self.id ~= nil then
        return self.id
    else
        if self:CsTABLE() ~= nil then
            self.id = self:CsTABLE().id
            return self.id
        else
            return nil
        end
    end
end

---@return number 目标类型#客户端#服务端#C#不存在共同参与合并的字段  1不低于等级；2低于等级；3不低于转生等级；4低于转生等级；5不低于行会等级；6不低于VIP等级；7低于等于VIP等级；8开服天数不小于；9开服天数小于；10不低于战力；11低于战力；12主角光翼等级；13等级下限#等级上限#转生下限#转生上限；14不低于灵兽转生等级；15不低于灵兽等级；16性别限制；17职业限制；18获得技能书（参数关联items表id（多个技能书id用#分隔））；19指定系统开启（参数关联notice表id）(仅服务器)；20地图消耗材料；21不低于战勋等级 22.加入了商会 23战勋等级下限#战勋等级上限 24背包内聚灵珠数量 25开服天数对应条件（cfg_conditions_servicetime表类型）(仅服务器)26开服天数对应排名的等级和战力（cfg_conditions_worldclass类型#1战力2等级0战力和等级）(仅服务器) 27首充奖励领取完成（关闭首充系统，每日充值系统的开启条件，参数填首充的noticeid）(仅服务器) 28充值钻石数不低于x百(x填在id里）(仅服务器)29对应灵兽位有灵兽上阵 30是否加入了行会 ，客户端用31 首充奖励是否领取，客户端用 返回true或false33消耗道具 数量#id#id（排序在前优先消耗，所有类型的道具总量足够即可）  34生命精魄个人等级和开服标准等级差值范围（差值下限#差值上限）（标准等级的配置在global22090）37 消耗资源 数量#id#id（排序在前优先消耗，所有类型的道具总量足够即可）38 是否领取过首个首冲 39首冲第一次已被领取 40首冲第一次已被领取且未购买过该礼包 41接取指定任务（参数填写taskid） 42 接取指定类型任务 （参数填写task type) 43 新vip等级不低于 44 新vip等级低于 45行会成员限制 46消灭指定地图中所有怪物 49.未加入任何商会,连体验卡也没加入=0 没加入比奇商会=1 没加入盟重商会=2 没有体验卡=3   50.判断平台条件  51 ：等级或转生（大于等于）  等级#转生 52行会首领击杀BOSS前3的权限可进入行会秘境  53判断时间区间的condition  54判断星期 55指定类型灵兽达到等级和转生等级要求 56 行会排名 57BUFF限制 58灵兽转生 59灵兽等级 60官位等级 61指定装备位是否有穿戴装备（仅客户端）62 技能等级cfg_skill_condition的ID 63  充值钻石数低于x，过零点生效 64充值钻石数大于等于x，过零点生效  65会员等级 77潜能星级 78背包道具检测(只判定交易钻石)  道具数量#道具id  83  穿戴灵 魂刻印（勋章）等级  84 人物法宝等级 85挖宝次数 87深渊禁地副本穿戴限制（数量#装备subtype#人物法宝类型）91 击杀指定怪物数量 （数量#monsterID）92 每日充值 >= x元（过0点重新计算）
function cfg_conditions:GetConditionType()
    if self.conditionType ~= nil then
        return self.conditionType
    else
        if self:CsTABLE() ~= nil then
            self.conditionType = self:CsTABLE().conditionType
            return self.conditionType
        else
            return nil
        end
    end
end

---@return TABLE.IntListJingHao 条件参数#客户端#服务端#C  45：1第一行会2第二行会3其他行会和散人 46：对应地图id 55：灵兽类型#等级#转生等级（1寒芒2落星3天成）61：装备位id（找客户端要）
function cfg_conditions:GetConditionParam()
    if self.conditionParam ~= nil then
        return self.conditionParam
    else
        if self:CsTABLE() ~= nil then
            return self:CsTABLE().conditionParam
        else
            return nil
        end
    end
end

---@return string 前端显示#客户端#C  服务端记录日志用
function cfg_conditions:GetShow()
    if self.show ~= nil then
        return self.show
    else
        if self:CsTABLE() ~= nil then
            return self:CsTABLE().show
        else
            return nil
        end
    end
end

---@return string 系统开启条件#客户端#C  客户端条件提示内容，预留
function cfg_conditions:GetTxt()
    if self.txt ~= nil then
        return self.txt
    else
        if self:CsTABLE() ~= nil then
            return self:CsTABLE().txt
        else
            return nil
        end
    end
end

--@return  TABLE.CFG_CONDITIONS C#中的数据结构
function cfg_conditions:CsTABLE()
    if self.csTABLE == nil then
        local isfind,data=CS.Cfg_ConditionManager.Instance:TryGetValue(self:UUID())
        self.csTABLE = data
    end
    return self.csTABLE 
end

---@param decodedData TABLE.cfg_conditions lua中的数据结构
function cfg_conditions:Init(decodedData)
    if (decodedData == nil) then
        return
    end
    
    ---@private
    self.id = decodedData.id
    
    ---@private
    self.conditionType = decodedData.conditionType
    
    ---@private
    self.conditionParam = decodedData.conditionParam
end

return cfg_conditions