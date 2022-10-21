---元素背包面板，不筛选，对应的物品高亮显示，点击对应物品提示镶嵌按钮
---@class UIBagMain_UnionSummonToken:UIBagMain_Normal
local UIBagMain_UnionSummonToken = {}
setmetatable(UIBagMain_UnionSummonToken, luaComponentTemplates.UIBagMainNormal)

---@return CSBagItemHint
function UIBagMain_UnionSummonToken:GetBagItemHint()
    if self.mBagItemHint == nil then
        self.mBagItemHint = CS.CSScene.MainPlayerInfo.BagInfo.BagItemHint
    end
    return self.mBagItemHint
end

--region 重写刷新方法
---刷新所有格子之前,获取推荐的装备队列
function UIBagMain_UnionSummonToken:BeforeRefreshAllGrids()
    self.mList = self:GetBagItemHint():GetHintList(LuaEnumMainHint_BetterBagItemType.UnionSummonToken)
end

---刷新单个格子时,高亮显示提示的装备
function UIBagMain_UnionSummonToken:RefreshSingleGrid(bagGrid, bagItemInfo, itemTbl)
    self:RunBaseFunction("RefreshSingleGrid", bagGrid, bagItemInfo, itemTbl)
    if self.mList ~= nil then
        for i = 0, self.mList.Count - 1 do
            local temp = self.mList[i]
            if temp and bagItemInfo.lid == temp then
                bagGrid:SetCompActive(bagGrid.Components.ChosenEffect, true)
                break
            end
        end
    end
    self:RefreshEquipDurabilityIsLess(bagGrid, bagItemInfo, itemTbl)
end
return UIBagMain_UnionSummonToken