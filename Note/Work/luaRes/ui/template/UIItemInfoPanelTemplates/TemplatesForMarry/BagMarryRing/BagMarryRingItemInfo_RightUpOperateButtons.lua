local BagMarryRingItemInfo_RightUpOperateButtons = {}
setmetatable(BagMarryRingItemInfo_RightUpOperateButtons,luaComponentTemplates.UIItemInfoPanel_Info_RightUpOperateButtons)

---使用信息刷新
---@param commonData UIItemTipInfoCommonData
function BagMarryRingItemInfo_RightUpOperateButtons:RefreshWithInfo(commonData)
    local bagItemInfo = commonData.bagItemInfo
    local itemInfo = commonData.itemInfo
    self.mBagItemInfo = bagItemInfo
    self.mItemInfo = itemInfo
    if bagItemInfo and itemInfo then
        self.uiItemInfoPanel = uimanager:GetPanel("UIItemInfoPanel")
        self.uiPetInfoPanel = uimanager:GetPanel("UIPetInfoPanel")
        self.isEquiped = CS.CSScene.MainPlayerInfo.EquipInfo:IsEquip(bagItemInfo.lid)
        local allOperateTable = self:FilterOperate(CS.Cfg_ItemsOperateTableManager.Instance:GetOperateList(itemInfo.leftOperate), bagItemInfo, itemInfo)
        if self:GetBtns_UIGridContainer() ~= nil then
            local count = #allOperateTable;
            ---如果没有按钮列表就关闭激活
            self.go:SetActive(count > 0);
            if(count > 0) then
                self:GetBtns_UIGridContainer().MaxCount = #allOperateTable
                for i = 0, self:GetBtns_UIGridContainer().controlList.Count - 1 do
                    self:SetButton(self:GetBtns_UIGridContainer().controlList[i], allOperateTable[i + 1])
                end
                ---右上角按钮展开收起自适应
                if self:GetBtns_UIGridContainer().controlList.Count > 1 then
                    self.btnListOpenAndClose = templatemanager.GetNewTemplate(self:GetBtns_UIGridContainer(), luaComponentTemplates.UIItemInfoPanel_Info_OpenCloseBtnList)
                else
                    if #allOperateTable > 0 then
                        self:BGSelfAdaptaion()
                        self:GetBackGround_GameObject():SetActive(true)
                    else
                        self:GetBackGround_GameObject():SetActive(false)
                    end
                    self:GetShowClose_GameObject():SetActive(false)
                end
            end
        end
    else
        self.go:SetActive(false);
    end
    self.tipLevel = CS.Cfg_GlobalTableManagerBase.Instance[20180] == nil and 0 or tonumber(CS.Cfg_GlobalTableManagerBase.Instance[20180].value);
end
return BagMarryRingItemInfo_RightUpOperateButtons