local UIElementPanelTemplate = {}
--region init
function UIElementPanelTemplate:Init()
    self:InitComponent()
    self:BindEvent()
    self:InitParams()
    self:ResetPanel()
end

function UIElementPanelTemplate:InitComponent()
    self.itemTemplate_GameObject = self:Get("itemTemplate","GameObject")
    self.mItemTemplate_Icon_UISprite = self:Get("itemTemplate/icon","UISprite")
    self.mSuccessEffect_Go = self:Get("itemTemplate/successEffect","GameObject")
    self.mElementIcon = self:Get("itemTemplate/elementIcon","UISprite")
    self.mEquipAdd_GameObject = self:Get("itemTemplate/Euqip_add","GameObject")
    self.mElementAdd_GameObject = self:Get("itemTemplate/Element_add","GameObject")
    self.mElementRemoveBtn_GameObject = self:Get("itemTemplate/elementIcon/remove","GameObject")

    self.mStoneList_Go = self:Get("stoneList","GameObject")
    self.mStoneList_ScrollView = self:Get("stoneList/stoneList","UIScrollView")
    self.mStoneList_SpringPanel = self:Get("stoneList/stoneList","SpringPanel")

    self.mUseBtn_Go = self:Get("btn_use","GameObject")
    self.mUseBtn_UILabel = self:Get("btn_use/Label","UILabel")

    self.mEquipName_UILabel = self:Get("itemTemplate/name","UILabel")

    self.HintNoEquipTips = self:Get("NoEquipment","GameObject")
    self.HintNoEquipTipsGetEquipBtn = self:Get("NoEquipment/Get","GameObject")
end

function UIElementPanelTemplate:BindEvent()
    CS.UIEventListener.Get(self.mUseBtn_Go).LuaEventTable = self
    CS.UIEventListener.Get(self.mUseBtn_Go).OnClickLuaDelegate = self.UseBtnOnClick
    CS.UIEventListener.Get(self.HintNoEquipTipsGetEquipBtn).LuaEventTable = self
    CS.UIEventListener.Get(self.HintNoEquipTipsGetEquipBtn).OnClickLuaDelegate = self.GetHighEquip
    CS.UIEventListener.Get(self.mElementRemoveBtn_GameObject).LuaEventTable = self
    CS.UIEventListener.Get(self.mElementRemoveBtn_GameObject).OnClickLuaDelegate = self.RemoveElementBtnOnClick
    CS.UIEventListener.Get(self.itemTemplate_GameObject).LuaEventTable = self
    CS.UIEventListener.Get(self.itemTemplate_GameObject).OnClickLuaDelegate = self.OpenItemInfo
    CS.UIEventListener.Get(self.mEquipAdd_GameObject).LuaEventTable = self
    CS.UIEventListener.Get(self.mEquipAdd_GameObject).OnClickLuaDelegate = self.OpenChooseEquipHint
end

function UIElementPanelTemplate:InitParams()
    self.BagInfo = CS.CSScene.MainPlayerInfo.BagInfo
    self.GlobalTableManager = CS.Cfg_GlobalTableManager.Instance
    self.ElementInfo = CS.CSScene.MainPlayerInfo.ElementInfo
    self.ElementTableManager = CS.Cfg_ElementTableManager.Instance
    self.autoChoose = true
    self.originScrollPosition = self.mStoneList_ScrollView.transform.localPosition;
    self.stoneListTemplate = templatemanager.GetNewTemplate(self.mStoneList_Go, luaComponentTemplates.UIElement_StoneListTemplate)
end

function UIElementPanelTemplate:ResetPanel()
    self.mItemTemplate_Icon_UISprite.spriteName = ""
end
--endregion

--region ????????????
---????????????????????????????????????
function UIElementPanelTemplate:RefreshElementPanel(customData)
    self:ResetPanel()
    self.equipItemClass = customData.equipItemClass
    self.chooseElementItemId = customData.chooseElementItemId
    self.equipIndex = ternary(self.equipItemClass == nil,ternary(self.equipIndex == nil,0,self.equipIndex),self.equipItemClass.equipIndex)
    self.equipBagItemInfo = CS.CSScene.MainPlayerInfo.EquipInfo:GetEquipByEquipIndex(self.equipIndex)
    self.elementTableInfo = CS.CSScene.MainPlayerInfo.ElementInfo:GetElementTableInfo(self.equipIndex)
    self.equipIndexHaveElement = ternary(self.equipItemClass ~= nil and self.equipItemClass.elementTableInfo ~= nil,true,false)
    self.ElementBagItemInfoList = CS.CSScene.MainPlayerInfo.BagInfo:GetElementStoneList(self.equipIndex)
    self.stoneListTemplate:ScrollViewResetPosition()
    self:RefreshAllContent()
end

---????????????????????????
function UIElementPanelTemplate:RefreshElementPanelNoCustomData()
    self:ResetPanel()
    if self.equipItemClass ~= nil then
        self.elementTableInfo = CS.CSScene.MainPlayerInfo.ElementInfo:GetElementTableInfo(self.equipIndex)
        self.equipIndexHaveElement = self.elementTableInfo ~= nil
        self.ElementBagItemInfoList = CS.CSScene.MainPlayerInfo.BagInfo:GetElementStoneList(self.equipIndex)
    end
    self:RefreshAllContent()
end
--endregion

--region ????????????
---??????????????????
function UIElementPanelTemplate:RefreshAllContent()
    if self.equipItemClass ~= nil and self.equipIndex ~= nil then
        self:RefreshHeadLine()
        self:RefreshCurEquipIcon(self.ElementInfo:GetEquipSpriteName(self.equipIndex))
        self:RefreshElementList()
        self:RefreshUseBtnLabel()
    end
    self:RefreshLowEquipTips()
end

---??????????????????????????????
function UIElementPanelTemplate:RefreshHeadLine()
    if self.mEquipName_UILabel == nil or self.equipItemClass == nil then
        return
    end
    local haveEquip = self.equipItemClass.bagItemInfo ~= nil and self.equipItemClass.itemInfo ~= nil
    self.mEquipName_UILabel.gameObject:SetActive(haveEquip)
    if haveEquip then
        self.mEquipName_UILabel.text =self.ElementInfo:GetEquipInlayText(self.equipIndex)

        --self.mHeadLine_DesUp_UILabel.gameObject:SetActive(self.equipIndexHaveElement)
        --if self.equipIndexHaveElement == true then
        --    local elementInfo = self.ElementInfo:GetElement(self.equipIndex)
        --    if elementInfo ~= nil then
        --        local NowEquipElementStoneTab = CS.Cfg_ElementTableManager.Instance:getElementStone(elementInfo.id)
        --        local elementStoneItemInfoIsFind,elementStoneItemInfo = CS.Cfg_ItemsTableManager.Instance:TryGetValue(elementInfo.id)
        --        local stoneElementTypeName = self.ElementInfo:GetElementAttackName(NowEquipElementStoneTab)
        --        local stoneElementAttackContent = self.ElementInfo:GetElementAttackAttributeContent(NowEquipElementStoneTab)
        --
        --        if elementStoneItemInfoIsFind then
        --            self.mHeadLine_DesUp_UILabel.text = elementStoneItemInfo.name
        --            self.mHeadLine_DesDown_UILabel.text = luaEnumColorType.White .. stoneElementTypeName .. stoneElementAttackContent
        --        end
        --    end
        --else
        --    self.mHeadLine_DesDown_UILabel.text =self.ElementInfo:GetEquipInlayText(self.equipIndex)
        --end
    end
end

---?????????????????????????????????????????????
function UIElementPanelTemplate:RefreshLowEquipTips()
    if self.HintNoEquipTips ~= nil then
        self.HintNoEquipTips:SetActive(self.equipItemClass == nil)
        if self.equipItemClass == nil then
            self.mElementAdd_GameObject:SetActive(false)
        end
    end
end

---???????????????????????????
function UIElementPanelTemplate:RefreshCurEquipIcon(iconName)
    if self.mItemTemplate_Icon_UISprite ~= nil then
        self.mItemTemplate_Icon_UISprite.spriteName = iconName
        self.mItemTemplate_Icon_UISprite.gameObject:SetActive(iconName ~= "")
        self.mEquipAdd_GameObject:SetActive(iconName == "")
    end
    if self.mElementIcon ~= nil then
        self.mElementIcon.gameObject:SetActive(self.equipIndexHaveElement)
        self.mElementAdd_GameObject:SetActive(not self.equipIndexHaveElement)
        if self.equipIndexHaveElement == true and self.elementTableInfo ~= nil then
            self.mElementIcon.spriteName = self.elementTableInfo.icon
        end
    end
end

---?????????????????????????????????
--function UIElementPanelTemplate:RefreshElementForBagChange()
--    if self.equipIndex == nil then
--        return
--    end
--    self.ElementBagItemInfoList = CS.CSScene.MainPlayerInfo.BagInfo:GetElementStoneList(self.equipIndex)
--    if self.stoneListTemplate ~= nil then
--        self.stoneListTemplate:RefreshPanel({list = self.ElementBagItemInfoList,equipItemClass = self.equipItemClass})
--    end
--end

---?????????????????????
function UIElementPanelTemplate:RefreshElementList()
    if self.equipIndex == nil then
        return
    end
    if self.stoneListTemplate ~= nil then
        self.stoneListTemplate:RefreshPanel({list = self.ElementBagItemInfoList,equipItemClass = self.equipItemClass,chooseElementItemId = self.chooseElementItemId})
        self.chooseElementItemId = 0
    end
end

---?????????????????????????????????????????????????????????
function UIElementPanelTemplate:RefreshStoneInfoCurElement()
end

---??????????????????
function UIElementPanelTemplate:RefreshUseBtnLabel()
    self:SetUseBtnState(self.ElementBagItemInfoList ~= nil and self.ElementBagItemInfoList.Count > 0)
    local btnLabelText = ternary(self:EquipIndexHaveElementStone() == true,"??????","??????")
    self:SetUseBtnLabel(btnLabelText)
end
--endregion

--region ????????????
---??????????????????
function UIElementPanelTemplate:PlaySuccessfulEffect()
    if self.mSuccessEffect_Go ~= nil then
        self.mSuccessEffect_Go:SetActive(false)
        self.mSuccessEffect_Go:SetActive(true)
    end
end
--endregion

--region UI??????
---???????????????????????????
function UIElementPanelTemplate:StoneTemplateClick()
    if self.mStoneList_Go ~= nil then
        self:SetmStoneListState(not self.mStoneList_Go.activeSelf)
    end
end

---?????????????????????????????????
function UIElementPanelTemplate:StoneAddClick()
    if self.ElementBagItemInfoList ~= nil and self.ElementBagItemInfoList.Count > 0 then
        self:SetmStoneListState(not self.mStoneList_Go.activeSelf)
    else

    end
end

---????????????????????????
function UIElementPanelTemplate:UseBtnOnClick(go)
    if self.stoneListTemplate ~= nil and self.stoneListTemplate.gridTemplate ~= nil then
        local isCanInlay = self.ElementInfo:IsCanInlayByEquipIndex(self.equipIndex,self.stoneListTemplate.gridTemplate.bagItemInfo)
        if isCanInlay then
            networkRequest.ReqPutUpElement(self.equipIndex,self.stoneListTemplate.gridTemplate.bagItemInfo.lid)
        else
            Utility.ShowPopoTips(go.transform,nil,199)
        end
    end
end

---??????????????????
function UIElementPanelTemplate:GetHighEquip()
    uiTransferManager:TransferToPanel(LuaEnumTransferType.UISecretBookPanel_GetEquip)
end

---????????????????????????
function UIElementPanelTemplate:RemoveElementBtnOnClick()
    if self:EquipIndexHaveElementStone() == true then
    networkRequest.ReqTakeOffElement(self.equipIndex)
    end
end

function UIElementPanelTemplate:OpenItemInfo()
    if self.equipItemClass ~= nil then
        uiStaticParameter.UIItemInfoManager:CreatePanel({ bagItemInfo = self.equipItemClass.bagItemInfo, showRight = false})
    end
end

---????????????????????????
function UIElementPanelTemplate:OpenChooseEquipHint(go)
    Utility.ShowPopoTips(go,nil,229)
end
--endregion

--region UI????????????
---?????????????????????????????????
function UIElementPanelTemplate:SetmStoneListState(state)
    if not CS.StaticUtility.IsNull(self.mStoneList_Go) then
        self.mStoneList_Go:SetActive(state)
    end
end

---?????????????????????????????????
function UIElementPanelTemplate:SetUseBtnLabel(content)
    if self.mUseBtn_UILabel ~= nil then
        self.mUseBtn_UILabel.text = content
    end
end

---????????????????????????
function UIElementPanelTemplate:SetAutoChooseState(state)
    self.autoChoose = state
end

---????????????????????????
function UIElementPanelTemplate:SetUseBtnState(state)
    if self.mUseBtn_Go ~= nil then
        self.mUseBtn_Go:SetActive(state)
    end
end
--endregion

--region ????????????
---??????????????????????????????true?????????????????????false????????????????????????
function UIElementPanelTemplate:EquipIndexHaveElementStone()
    return self.ElementInfo:GetElement(self.equipIndex) ~= nil
end

---?????????????????????iteminfo
function UIElementPanelTemplate:GetBestElementItemInfo()
    if self.equipIndex == nil then
        return nil
    end
    local bestElementBagItemInfo = self.ElementInfo:AutoChooseElement(self.equipIndex)
    if bestElementBagItemInfo == nil then
        return nil
    end
    local itemInfoIsFind,itemInfo = CS.Cfg_ItemsTableManager.Instance:TryGetValue(bestElementBagItemInfo.itemId)
    return itemInfo
end
--endregion
return UIElementPanelTemplate