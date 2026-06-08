local L=WowBeeLocale;
local Lib={};
function Lib.WowBeeHelperFrame()

	local frame= WowBeeFrame.CreateMain("WowBeeHelperFrame",UIParent,L["GUI_MAINFRAME_TITLE"]);
	frame:SetWidth(200);
	frame:SetHeight(350);
	frame:SetMinResize(200,150);
	frame:SetMaxResize(280,500);
	--frame:SetClampedToScreen(1);
	
	frame.ProjectTitle=CreateFrame("Frame","$parent_ProjectTitle",frame);
	frame.ProjectTitle:SetPoint("TOPLEFT", frame,"TOPLEFT",3,-30);
	frame.ProjectTitle:SetPoint("TOPRIGHT", frame, "TOPRIGHT");
	frame.ProjectTitle:SetHeight(25);

	frame.ProjectTitle.Label=frame.ProjectTitle:CreateFontString("$parent_Label");
	frame.ProjectTitle.Label:SetFontObject("GameFontRedSmall");
	frame.ProjectTitle.Label:SetText(L["GUI_MAINFRAME_SCHEMEDROPDOWN"]);
	frame.ProjectTitle.Label:SetPoint("TOPLEFT",frame.ProjectTitle,"TOPLEFT",2,0);
	frame.ProjectTitle.Label:SetJustifyV("MIDDLE");
	
	frame.ProjectTitle.Delete=CreateFrame("Button","$parent_SchemeDelete",frame.ProjectTitle);
	frame.ProjectTitle.Delete:SetWidth(32);
	frame.ProjectTitle.Delete:SetHeight(32);
	frame.ProjectTitle.Delete:SetNormalTexture("Interface\\BUTTONS\\CancelButton-Up");
	frame.ProjectTitle.Delete:SetPushedTexture("Interface\\BUTTONS\\CancelButton-Down");
	frame.ProjectTitle.Delete:SetHighlightTexture("Interface\\BUTTONS\\CancelButton-Highlight");
	frame.ProjectTitle.Delete:SetPoint("TOPRIGHT",frame.ProjectTitle,"TOPRIGHT",0,8);

	frame.Scheme= WowBeeFrame.CreateDropDownSearch("$parent_DDS",frame,"",{})
	frame.Scheme:ClearAllPoints();
	frame.Scheme:SetPoint("LEFT",frame.ProjectTitle.Label,"RIGHT",0,0);
	frame.Scheme:SetPoint("RIGHT",frame.ProjectTitle.Delete,"LEFT",5,0);
	
	frame.List=CreateFrame("ScrollFrame", "$parent_List", frame, "UIPanelScrollFrameTemplate");
	frame.List:EnableMouse(1);
	frame.List:SetPoint("TOPLEFT", frame.ProjectTitle, "BOTTOMLEFT", 1, 0);
	frame.List:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -32, 50);

	frame.List.Background = CreateFrame("Frame", "$parent_ListBackground", frame);
	frame.List.Background:SetPoint("TOPLEFT", frame.List, "TOPLEFT", 1, 5);
	frame.List.Background:SetPoint("BOTTOMRIGHT", frame.List, "BOTTOMRIGHT", 27, -5);
	frame.List.Background:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	});
	frame.List.Background:SetBackdropColor(0, 0, 0,0.8);
	frame.List.Background:SetBackdropBorderColor(0.4, 0.4, 0.4);
	
	frame.List:EnableMouseWheel(1);
	frame.List.ScrollChild=CreateFrame("Frame","$parent_List_Child",frame.List);
	frame.List:SetScrollChild(frame.List.ScrollChild);
	frame.List:HookScript("OnSizeChanged" , function(self)
			local left, bottom, width, height = self:GetBoundsRect();							
			self.ScrollChild:SetWidth(width);
			self.ScrollChild:SetHeight(height);
	end);	
	frame.List.RightClickMenu=CreateFrame("Frame", "$parent_RightClickMenu", UIParent, "UIDropDownMenuTemplate");
	
	frame.Input=CreateFrame("Button","$parent_Input",frame,"GameMenuButtonTemplate");
	frame.Input:SetWidth(45);
	frame.Input:SetPoint("TOPLEFT",frame.List,"BOTTOMLEFT",3,-5);
	frame.Input:SetText(L["SCHEMECONTROL_INPUT_BUTTON"]);
	--frame.Input:Disable();
	frame.Output=CreateFrame("Button","$parent_Output",frame,"GameMenuButtonTemplate");
	frame.Output:SetWidth(45);
	frame.Output:SetPoint("LEFT",frame.Input,"RIGHT",3,0);
	frame.Output:SetText(L["SCHEMECONTROL_OUTPUT_BUTTON"]);
	--frame.Output:Disable();
	frame.StartStop=CreateFrame("Button","$parent_StartStop",frame,"GameMenuButtonTemplate");
	frame.StartStop:SetWidth(70);
	frame.StartStop:SetPoint("LEFT",frame.Output,"RIGHT",3,0);
	frame.StartStop.HoverTexture=frame.StartStop:CreateTexture();
	frame.StartStop.HoverTexture:SetTexture("Interface\\OPTIONSFRAME\\VoiceChat-Play");
	frame.StartStop.HoverTexture:SetGradient("Horizontal", 0,1,0,0,1,0);
	frame.StartStop.HoverTexture:SetPoint("LEFT",10,0);
	frame.StartStop.HoverTexture:SetWidth(12);
	frame.StartStop.HoverTexture:SetHeight(12);
	frame.StartStop.HoverTexture:SetDrawLayer("OVERLAY");
	frame.StartStop.Label=frame.StartStop:GetFontString();
	frame.StartStop.Label:SetPoint("LEFT",frame.StartStop.HoverTexture,"RIGHT",3,0);
	return frame;
end

function Lib.WowBeeScriptBoxFrame()
	local frame= WowBeeFrame.CreateMain("WowBeeScriptBoxFrame",UIParent);
	frame:SetWidth(300);
	frame:SetHeight(300);
	frame:SetMinResize(200,200);
	frame:SetClampedToScreen(1);
	
    frame.Code = WowBeeFrame.CreateEditer("$parent_CodeFrame", frame);
	frame.Code:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -30);
	frame.Code:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5);
	frame.Edit=frame.Code.Edit;
	frame.Insert=function(self,text)
		self.Edit:ClearFocus(0);
		self.Edit:SetCursorPosition(0);
		self.Edit:Insert(text) end
	frame:SetScript("OnHide", function(self) self.Edit:SetText("")  end);
	return frame;
end

function Lib.WowBeeVarFrame(parent)
	local frame = WowBeeFrame.CreateMain("WowBeeVarFrame",UIParent);

	frame:SetWidth(400);
	frame:SetHeight(300);
	frame:SetMinResize(200,150);
	frame:SetMaxResize(680,500);
	--frame:SetResizable(nil);
	frame:SetClampedToScreen(1);

	frame.List=CreateFrame("ScrollFrame", "$parent_List", frame, "UIPanelScrollFrameTemplate");
	frame.List:EnableMouse(1);
	frame.List:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -30);
	frame.List:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -32, 10);

	frame.List.Background = CreateFrame("Frame", "$parent_ListBackground", frame);
	frame.List.Background:SetPoint("TOPLEFT", frame.List, "TOPLEFT", 1, 5);
	frame.List.Background:SetPoint("BOTTOMRIGHT", frame.List, "BOTTOMRIGHT", 27, -5);
	frame.List.Background:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	});
	frame.List.Background:SetBackdropColor(0, 0, 0,0.8);
	frame.List.Background:SetBackdropBorderColor(0.4, 0.4, 0.4);
	
	frame.List:EnableMouseWheel(1);
	frame.List.ScrollChild=CreateFrame("Frame","$parent_List_Child",frame.List);
	frame.List:SetScrollChild(frame.List.ScrollChild);
	frame.List:HookScript("OnSizeChanged" , function(self)
			local left, bottom, width, height = self:GetBoundsRect();							
			self.ScrollChild:SetWidth(width);
			self.ScrollChild:SetHeight(height);
	end);
	frame.List.RightClickMenu=CreateFrame("Frame", "$parent_RightClickMenu", UIParent, "UIDropDownMenuTemplate");
	
	
	frame.Edit=WowBeeFrame.CreateMain("WowBeeAddVarFrame",UIParent);
	frame.Edit:SetResizable(nil);
	frame.Edit:SetWidth(350);
	frame.Edit:SetHeight(235);
	frame.Edit.MaxSize=200;
	frame.Edit.MinSize=20;
	
	frame.Edit.Background = CreateFrame("Frame", "$parent_ListBackground", frame.Edit);
	frame.Edit.Background:SetPoint("TOPLEFT", frame.Edit, "TOPLEFT", 5, -25);
	frame.Edit.Background:SetPoint("BOTTOMRIGHT", frame.Edit, "BOTTOMRIGHT", -5, 35);
	frame.Edit.Background:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	});
	frame.Edit.Background:SetBackdropColor(0, 0, 0,0.8);
	frame.Edit.Background:SetBackdropBorderColor(0.4, 0.4, 0.4);
	
	frame.Edit.NameLabel=frame.Edit.Background:CreateFontString("$parent_NameLabel");
	frame.Edit.NameLabel:SetFontObject("GameFontNormal");
	frame.Edit.NameLabel:SetText(L["VARIABLE_NAME"]);
	frame.Edit.NameLabel:SetPoint("TOPLEFT",frame.Edit.Background,"TOPLEFT",5,-10);
	frame.Edit.NameLabel:SetJustifyV("MIDDLE");
	
	frame.Edit.Name=CreateFrame("EditBox","$parent_NameEdit",frame.Edit.Background,"InputBoxTemplate");
	frame.Edit.Name:SetAutoFocus(false);
	frame.Edit.Name:SetHeight(16);
	frame.Edit.Name:SetWidth(200);
	frame.Edit.Name:SetPoint("LEFT",frame.Edit.NameLabel,"RIGHT",10,0);
	--main.List.Edit2:SetNumeric(true)
	frame.Edit.Name:SetFontObject("GameFontHighlightSmall");
	
	frame.Edit.DescriptionLabel=frame.Edit.Background:CreateFontString("$parent_DescribeLabel");
	frame.Edit.DescriptionLabel:SetFontObject("GameFontNormal");
	frame.Edit.DescriptionLabel:SetText(L["VARIABLE_DESCRIPTION"]);
	frame.Edit.DescriptionLabel:SetPoint("TOPLEFT",frame.Edit.NameLabel,"BOTTOMLEFT",0,-10);
	frame.Edit.DescriptionLabel:SetJustifyV("MIDDLE");
	
	frame.Edit.Description=CreateFrame("EditBox","$parent_DescribeEdit",frame.Edit.Background,"InputBoxTemplate");
	frame.Edit.Description:SetAutoFocus(false);
	frame.Edit.Description:SetHeight(16);
	frame.Edit.Description:SetWidth(200);
	frame.Edit.Description:SetPoint("LEFT",frame.Edit.DescriptionLabel,"RIGHT",10,0);
	--main.List.Edit2:SetNumeric(true)
	frame.Edit.Description:SetFontObject("GameFontHighlightSmall");
	
	frame.Edit.TypeLabel=frame.Edit.Background:CreateFontString("$parent_TypeLabel");
	frame.Edit.TypeLabel:SetFontObject("GameFontNormal");
	frame.Edit.TypeLabel:SetText(L["VARIABLE_TYPE"]);
	frame.Edit.TypeLabel:SetPoint("TOPLEFT",frame.Edit.DescriptionLabel,"BOTTOMLEFT",0,-10);
	frame.Edit.TypeLabel:SetJustifyV("MIDDLE");
	
	frame.Edit.TypeRadio1=CreateFrame("CheckButton", "$parent_TypeRadio1", frame.Edit,"SendMailRadioButtonTemplate")
	frame.Edit.TypeRadio1:SetPoint("LEFT",frame.Edit.TypeLabel,"RIGHT",10,0);
	
	frame.Edit.TypeRadio1Label=frame.Edit.Background:CreateFontString("$parent_TypeRadio1Label");
	frame.Edit.TypeRadio1Label:SetFontObject("GameFontNormal");
	frame.Edit.TypeRadio1Label:SetText(L["VARIABLE_TYPERADIO1"]);
	frame.Edit.TypeRadio1Label:SetPoint("LEFT",frame.Edit.TypeRadio1,"RIGHT",0,0);

	frame.Edit.TypeRadio2=CreateFrame("CheckButton", "$parent_TypeRadio2",  frame.Edit,"SendMailRadioButtonTemplate")
	frame.Edit.TypeRadio2:SetPoint("LEFT",frame.Edit.TypeRadio1Label,"RIGHT",10,0);
	frame.Edit.TypeRadio2Label= frame.Edit.Background:CreateFontString("$parent_TypeRadio2Label");
	frame.Edit.TypeRadio2Label:SetFontObject("GameFontNormal");
	frame.Edit.TypeRadio2Label:SetText(L["VARIABLE_TYPERADIO2"]);
	frame.Edit.TypeRadio2Label:SetPoint("LEFT",frame.Edit.TypeRadio2,"RIGHT",0,0);
	
	frame.Edit.TypeRadio3=CreateFrame("CheckButton", "$parent_TypeRadio3",  frame.Edit,"SendMailRadioButtonTemplate")
	frame.Edit.TypeRadio3:SetPoint("LEFT",frame.Edit.TypeRadio2Label,"RIGHT",10,0);
	frame.Edit.TypeRadio3Label= frame.Edit.Background:CreateFontString("$parent_TypeRadio3Label");
	frame.Edit.TypeRadio3Label:SetFontObject("GameFontNormal");
	frame.Edit.TypeRadio3Label:SetText(L["VARIABLE_TYPERADIO3"]);
	frame.Edit.TypeRadio3Label:SetPoint("LEFT",frame.Edit.TypeRadio3,"RIGHT",0,0);
	
	frame.Edit.Join=CreateFrame("EditBox","$parent_JoinEdit", frame.Edit.Background,"InputBoxTemplate");
	frame.Edit.Join:SetAutoFocus(false);
	frame.Edit.Join:SetHeight(16);
	frame.Edit.Join:SetWidth(20);
	frame.Edit.Join:SetPoint("LEFT",frame.Edit.TypeRadio3Label,"RIGHT",10,0);
	--main.List.Edit2:SetNumeric(true)
	frame.Edit.Join:SetFontObject("GameFontHighlightSmall");
	
	frame.Edit.SizeLabel= frame.Edit.Background:CreateFontString("$parent_SizeLabel");
	frame.Edit.SizeLabel:SetFontObject("GameFontNormal");
	frame.Edit.SizeLabel:SetText(L["VARIABLE_SIZE"]);
	frame.Edit.SizeLabel:SetPoint("TOPLEFT",frame.Edit.TypeLabel,"BOTTOMLEFT",0,-10);
	frame.Edit.SizeLabel:SetJustifyV("MIDDLE");

	frame.Edit.Size=CreateFrame("EditBox","$parent_SizeEdit", frame.Edit.Background,"InputBoxTemplate");
	frame.Edit.Size:SetAutoFocus(false);
	frame.Edit.Size:SetHeight(16);
	frame.Edit.Size:SetWidth(50);
	frame.Edit.Size:SetPoint("LEFT",frame.Edit.SizeLabel,"RIGHT",10,0);
	frame.Edit.Size:SetNumeric(true)
	frame.Edit.Size:SetFontObject("GameFontHighlightSmall");
	
	frame.Edit.SizeTLabel= frame.Edit.Background:CreateFontString("$parent_SizeTLabel");
	frame.Edit.SizeTLabel:SetFontObject("GameFontNormal");
	frame.Edit.SizeTLabel:SetText(string.format(L["VARIABLE_SIZET"],frame.Edit.MinSize,frame.Edit.MaxSize));
	frame.Edit.SizeTLabel:SetPoint("LEFT",frame.Edit.Size,"RIGHT",10,0);
	frame.Edit.SizeTLabel:SetJustifyV("MIDDLE");
	
	frame.Edit.EditLabel= frame.Edit.Background:CreateFontString("$parent_EditLabel");
	frame.Edit.EditLabel:SetFontObject("GameFontNormal");
	frame.Edit.EditLabel:SetText(L["VARIABLE_EDITTYPE"]);
	frame.Edit.EditLabel:SetPoint("TOPLEFT",frame.Edit.SizeLabel,"BOTTOMLEFT",0,-10);
	frame.Edit.EditLabel:SetJustifyV("MIDDLE");
	
	frame.Edit.EditRadio1=CreateFrame("CheckButton", "$parent_EditRadio1", frame.Edit,"SendMailRadioButtonTemplate")
	frame.Edit.EditRadio1:SetPoint("LEFT",frame.Edit.EditLabel,"RIGHT",10,0);
	frame.Edit.EditRadio1Label=frame.Edit.Background:CreateFontString("$parent_EditRadio1Label");
	frame.Edit.EditRadio1Label:SetFontObject("GameFontNormal");
	frame.Edit.EditRadio1Label:SetText(L["VARIABLE_EDITRADIO1"]);
	frame.Edit.EditRadio1Label:SetPoint("LEFT",frame.Edit.EditRadio1,"RIGHT",0,0);

	frame.Edit.EditRadio2=CreateFrame("CheckButton", "$parent_EditRadio2",  frame.Edit,"SendMailRadioButtonTemplate")
	frame.Edit.EditRadio2:SetPoint("LEFT",frame.Edit.EditRadio1Label,"RIGHT",10,0);
	frame.Edit.EditRadio2Label= frame.Edit.Background:CreateFontString("$parent_EditRadio2Label");
	frame.Edit.EditRadio2Label:SetFontObject("GameFontNormal");
	frame.Edit.EditRadio2Label:SetText(L["VARIABLE_EDITRADIO2"]);
	frame.Edit.EditRadio2Label:SetPoint("LEFT",frame.Edit.EditRadio2,"RIGHT",0,0);
	
	frame.Edit.EditRadio3=CreateFrame("CheckButton", "$parent_EditRadio3",  frame.Edit,"SendMailRadioButtonTemplate")
	frame.Edit.EditRadio3:SetPoint("LEFT",frame.Edit.EditRadio2Label,"RIGHT",10,0);
	frame.Edit.EditRadio3Label= frame.Edit.Background:CreateFontString("$parent_EditRadio2Label");
	frame.Edit.EditRadio3Label:SetFontObject("GameFontNormal");
	frame.Edit.EditRadio3Label:SetText(L["VARIABLE_EDITRADIO3"]);
	frame.Edit.EditRadio3Label:SetPoint("LEFT",frame.Edit.EditRadio3,"RIGHT",0,0);
	
	frame.Edit.ValueLabel= frame.Edit.Background:CreateFontString("$parent_ValueLabel");
	frame.Edit.ValueLabel:SetFontObject("GameFontNormal");
	frame.Edit.ValueLabel:SetText(L["VARIABLE_VALUE"]);
	frame.Edit.ValueLabel:SetPoint("TOPLEFT",frame.Edit.EditLabel,"BOTTOMLEFT",0,-10);
	frame.Edit.ValueLabel:SetJustifyV("MIDDLE");
	
	frame.Edit.Value=CreateFrame("EditBox","$parent_ValueEdit", frame.Edit.Background,"InputBoxTemplate");
	frame.Edit.Value:SetAutoFocus(false);
	frame.Edit.Value:SetHeight(16);
	frame.Edit.Value:SetWidth(50);
	frame.Edit.Value:SetPoint("LEFT",frame.Edit.ValueLabel,"RIGHT",10,0);
	--main.List.Edit2:SetNumeric(true)
	frame.Edit.Value:SetFontObject("GameFontHighlightSmall");
	
	frame.Edit.JoinLabel= frame.Edit.Background:CreateFontString("$parent_JoinLabel");
	frame.Edit.JoinLabel:SetFontObject("GameFontNormal");
	frame.Edit.JoinLabel:SetText("-");
	frame.Edit.JoinLabel:SetPoint("LEFT",frame.Edit.Value,"RIGHT",5,0);
	frame.Edit.JoinLabel:SetJustifyV("MIDDLE");
	frame.Edit.JoinLabel:Hide();
	
	frame.Edit.Vice=CreateFrame("EditBox","$parent_ViceEdit", frame.Edit.Background,"InputBoxTemplate");
	frame.Edit.Vice:SetAutoFocus(false);
	frame.Edit.Vice:SetHeight(16);
	frame.Edit.Vice:SetWidth(50);
	frame.Edit.Vice:SetPoint("LEFT",frame.Edit.JoinLabel,"RIGHT",10,0);
	--main.List.Edit2:SetNumeric(true)
	frame.Edit.Vice:SetFontObject("GameFontHighlightSmall");
	frame.Edit.Vice:Hide();
	
	--frame.Edit:Show();
	frame.Edit.Save=CreateFrame("Button","$parent_Save", frame.Edit,"GameMenuButtonTemplate");
	frame.Edit.Save:SetWidth(85);
	frame.Edit.Save:SetPoint("TOP",frame.Edit.Background,"BOTTOM",3,-5);
	frame.Edit.Save:SetPoint("CENTER",frame.Edit.Background,"CENTER",0,0);
	frame.Edit.Save:SetText(L["VARIABLE_SAVE"]);
	frame.Edit.Save:Disable();
	
	frame.Edit.Size:SetScript("OnLeave",function(self)
		frame.Edit:SetSize();
	end);
	
	frame.Edit.Join:SetScript("OnLeave",function(self)
		frame.Edit.JoinLabel:SetText(self:GetText());
	end);
	
	frame.Edit.SetSize=function(self)
		if(self.Size:GetText()=="")then
			self.Size:SetText(self.MinSize);
		elseif(tonumber(self.Size:GetText())>self.MaxSize)then
			self.Size:SetText(self.MaxSize);
		elseif(tonumber(self.Size:GetText())<self.MinSize)then
			self.Size:SetText(self.MinSize);
		end
			self.Value:SetWidth(tonumber(self.Size:GetText()));
			self.Vice:SetWidth(tonumber(self.Size:GetText()));
	end
	
	frame.Edit.SetTypeRadio=function(self)
		if(self.Type==1)then
			self.TypeRadio1:SetChecked(1);
			self.TypeRadio2:SetChecked(0);
			self.TypeRadio3:SetChecked(0);
			self.ValueLabel:Hide();
			self.JoinLabel:Hide();
			self.Value:Hide();
			self.Vice:Hide();
			self.Size:Hide();
			self.SizeLabel:Hide();
			self.SizeTLabel:Hide();
			self.Join:Hide();
			self.EditLabel:Hide();
			self.EditRadio1:Hide();
			self.EditRadio2:Hide();
			self.EditRadio3:Hide();
			self.EditRadio1Label:Hide();
			self.EditRadio2Label:Hide();
			self.EditRadio3Label:Hide();
		elseif(self.Type==3)then
			self.TypeRadio1:SetChecked(0);
			self.TypeRadio2:SetChecked(0);
			self.TypeRadio3:SetChecked(1);
			self.ValueLabel:Show();
			self.JoinLabel:Show();
			self.Value:Show();
			self.Vice:Show();
			self.Size:Show();
			self.SizeLabel:Show();
			self.SizeTLabel:Show();
			self.Join:Show();
			self.EditLabel:Show();
			self.EditRadio1:Show();
			self.EditRadio2:Show();
			self.EditRadio3:Show();
			self.EditRadio1Label:Show();
			self.EditRadio2Label:Show();
			self.EditRadio3Label:Show();
			self.MaxSize=80;
			self.MinSize=20;
			self:SetSize();
			self.SizeTLabel:SetText(string.format(L["VARIABLE_SIZET"],self.MinSize,self.MaxSize));
		else
			self.TypeRadio1:SetChecked(0);
			self.TypeRadio2:SetChecked(1);
			self.TypeRadio3:SetChecked(0);
			self.ValueLabel:Show();
			self.JoinLabel:Hide();
			self.Value:Show();
			self.Vice:Hide();
			self.Size:Show();
			self.SizeLabel:Show();
			self.SizeTLabel:Show();
			self.Join:Hide();
			self.EditLabel:Show();
			self.EditRadio1:Show();
			self.EditRadio2:Show();
			self.EditRadio3:Show();
			self.EditRadio1Label:Show();
			self.EditRadio2Label:Show();
			self.EditRadio3Label:Show();
			
			self.MaxSize=200;
			self.MinSize=20;
			self:SetSize();
			self.SizeTLabel:SetText(string.format(L["VARIABLE_SIZET"],self.MinSize,self.MaxSize));
		end
	end
	frame.Edit.SetEditRadio=function(self)
		if(self.ValueType==1)then
			self.EditRadio1:SetChecked(1);
			self.EditRadio2:SetChecked(0);
			self.EditRadio3:SetChecked(0);
			self.Value:SetNumeric(1);
			self.Vice:SetNumeric(1);
			if(tonumber(self.Value:GetText())==nil)then
				self.Value:SetText("");
			end
			if(tonumber(self.Vice:GetText())==nil)then
				self.Vice:SetText("");
			end
		elseif(self.ValueType==2)then
			self.EditRadio1:SetChecked(0);
			self.EditRadio2:SetChecked(1);
			self.EditRadio3:SetChecked(0);
			self.Value:SetNumeric(0);
			self.Vice:SetNumeric(0);
		elseif(self.ValueType==3)then
			self.EditRadio1:SetChecked(0);
			self.EditRadio2:SetChecked(0);
			self.EditRadio3:SetChecked(1);
			self.Value:SetNumeric(0);
			self.Vice:SetNumeric(0);
		end
	end
	
	
	frame.Edit.TypeRadio1:SetScript("OnClick",function(self)
		frame.Edit.Type=1;
		frame.Edit:SetTypeRadio();
	end);
	
	frame.Edit.TypeRadio2:SetScript("OnClick",function(self)
		frame.Edit.Type=2;
		frame.Edit:SetTypeRadio();
	end);
	
	frame.Edit.TypeRadio3:SetScript("OnClick",function(self)
		frame.Edit.Type=3;
		frame.Edit:SetTypeRadio();
	end);
	
	frame.Edit.EditRadio1:SetScript("OnClick",function(self)
		frame.Edit.ValueType=1;
		frame.Edit:SetEditRadio();
	end);
	
	frame.Edit.EditRadio2:SetScript("OnClick",function(self)
		frame.Edit.ValueType=2;
		frame.Edit:SetEditRadio();
	end);
	
	frame.Edit.EditRadio3:SetScript("OnClick",function(self)
		frame.Edit.ValueType=3;
		frame.Edit:SetEditRadio();
	end);
	
	frame.Edit:HookScript("OnShow" ,function(self)
		local v=self.Data or {};
		
		self.Name:SetText(v.Name or "");
		self.Description:SetText(v.Description or "");
		self.Join:SetText(v.Join or "-");
		self.Value:SetText(v.Value or "");
		self.Vice:SetText(v.ViceValue or "");
		self.Size:SetText(v.Size or 50);
		self.Type=v.Type or 2;
		self.ValueType=v.ValueType or 2;
		self:SetTypeRadio();
		self:SetEditRadio();
	end);

	frame.Edit.Name:SetScript("OnTextChanged",function(self)
		if(frame.Edit.Name:GetText()~="")then
			frame.Edit.Save:Enable();
		else
			frame.Edit.Save:Disable();
		end
	end);
	
	return frame;
end

function Lib.WowBeeScriptEditerFrame(parent)
	local frame= WowBeeFrame.CreateMain("WowBeeScriptEditerFrame",UIParent);
	frame:SetWidth(460);
	frame:SetHeight(500);
	frame:SetMinResize(360,200);
	frame:SetClampedToScreen(1);
	
	-- CodeFrame
    frame.Code = WowBeeFrame.CreateEditer("$parent_CodeFrame", frame, parent);
	frame.Code:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -25);
	frame.Code:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 25);
	frame.Exit=frame.Close;
	frame.Edit=frame.Code.Edit;
	frame.Menu=frame.Code.Menu;
	frame.Menu:Show();
	return frame;
end

function Lib.Init()
	local main=Lib.WowBeeHelperFrame();
	local box=Lib.WowBeeScriptBoxFrame();
	main.Var=Lib.WowBeeVarFrame(main);
	main.Editer=Lib.WowBeeScriptEditerFrame(main);
	
	local zone = WowBeeFrame.CreateZoneText("WowBeeZoneText", UIParent);
	local minimap = WowBeeFrame.CreateMinimapButton("WowBeeMinimapButton", "Interface\\Addons\\WBE\\WowBee.tga")
	minimap:RegisterDB("WowBeeIcon")
	minimap:AddTooltipLine(L["WOWBEE_TITLE"])
	minimap:AddTooltipLine(L["WOWBEE_TOOLTIP"], 0, 1, 0, 1)
	--minimap:SetDesaturated(true)
	minimap:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	WowBeeMenu = DropDownMenu_GetHandle()
end
Lib.Init();