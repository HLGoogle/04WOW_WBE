
	WowBeeFrame = {}
	local Lib = WowBeeFrame;
	
	local MINIMAPSHAPES = {
		["ROUND"] = { true, true, true, true },
		["SQUARE"] = { false, false, false, false },
		["CORNER-TOPLEFT"] = { true, false, false, false },
		["CORNER-TOPRIGHT"] = { false, false, true, false },
		["CORNER-BOTTOMLEFT"] = { false, true, false, false },
		["CORNER-BOTTOMRIGHT"] = { false, false, false, true },
		["SIDE-LEFT"] = { true, true, false, false },
		["SIDE-RIGHT"] = { false, false, true, true },
		["SIDE-TOP"] = { true, false, true, false },
		["SIDE-BOTTOM"] = { false, true, false, true },
		["TRICORNER-TOPLEFT"] = { true, true, true, false },
		["TRICORNER-TOPRIGHT"] = { true, false, true, true },
		["TRICORNER-BOTTOMLEFT"] = { true, true, false, true },
		["TRICORNER-BOTTOMRIGHT"] = { false, true, true, true },
	};
	
	-- Backdrop Handlers
	local _FrameBackdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
	local _FrameBackdropTitle = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "",
		tile = true, tileSize = 16, edgeSize = 0,
		insets = { left = 3, right = 3, top = 3, bottom = 0 }
	}
	local _FrameBackdropCommon = {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 }
	}

	-- Event Handlers
	local function frameOnShow(self)
		PlaySound "igCharacterInfoOpen"
	end
	
	local function frameOnHide(self)
		self:StopMovingOrSizing()
		PlaySound "igCharacterInfoClose"
	end

	local function frameOnMouseDown(self)
		if not self.InDesignMode then
			self:StartMoving()
		end
	end

	local function frameOnMouseUp(self)
		self:StopMovingOrSizing()
	end

	local function sizerseOnMouseDown(self)
		if not self:GetParent().InDesignMode and self:GetParent():IsResizable() then
			self:GetParent():StartSizing("BOTTOMRIGHT")
		end
	end

	local function sizerOnMouseUp(self)
		self:GetParent():StopMovingOrSizing()
	end

	local function frameSetTitle(self,text)
		getglobal(self:GetName().."_Caption_Title"):SetText(text);
	end
	
	local function frameSetMessage(self,text)
		getglobal(self:GetName().."_StatusBar_Text"):SetText(text);
	end
	
	local function frameSetResizable(self,bool)
		if(bool)then
			getglobal(self:GetName().."_Sizer"):Show();
		else
			getglobal(self:GetName().."_Sizer"):Hide();
		end
	end
	
	local function scrollSetText(self)
		return getglobal(self:GetName().."_Code"):GetText();
	end

	local function scrollSetEdit(self)
		return getglobal(self:GetName().."_Code")
	end
	
	local function zoneText_OnUpdate(self)
		assert(self);
		local elapsed = GetTime() - self.StartTime;
		local fadeInTime = self.FadeInTime;
		if ( elapsed < fadeInTime ) then
			local alpha = (elapsed / fadeInTime);
			self:SetAlpha(alpha);
			return;
		end
		local holdTime = self.HoldTime;
		if ( elapsed < (fadeInTime + holdTime) ) then
			self:SetAlpha(1.0);
			return;
		end
		local fadeOutTime = self.FadeOutTime;
		if ( elapsed < (fadeInTime + holdTime + fadeOutTime) ) then
			local alpha = 1.0 - ((elapsed - holdTime - fadeInTime) / fadeOutTime);
			self:SetAlpha(alpha);
			return;
		end
		self:Hide();
	end

	local function zoneText_OnShow(self)
		assert(self);
		self.StartTime = GetTime();
		self:Show();
	end

	function Lib.CreateMain(name,parent,text)
		-- New Frame
		frame = CreateFrame("Frame", name, parent)
		frame:Hide();
		frame:SetWidth(400)
		frame:SetHeight(300)
		frame:SetMovable(1)
		frame:SetResizable(1)
		frame:SetToplevel(1)
		frame:EnableMouseWheel(1)
		frame:EnableMouse(1)
		frame:EnableKeyboard(1);
		frame:SetPoint("CENTER", parent, "CENTER",0,0)
		frame:SetMinResize(300,200)
        frame:SetBackdrop(_FrameBackdrop)
		frame:SetBackdropColor(0, 0, 0)
		frame:SetBackdropBorderColor(0.4, 0.4, 0.4)

		local title = CreateFrame("Frame", "$parent_Caption", frame)
		--title:EnableMouse(true)
		title:SetHeight(25)
		title:SetPoint("TOPLEFT", frame, "TOPLEFT")
		title:SetPoint("RIGHT", frame, "RIGHT")
		title:SetBackdrop(_FrameBackdropTitle)
		title:SetBackdropColor(1, 0, 0, 0)
		--title:SetScript("OnMouseDown" ,frameOnMouseDown)
		--title:SetScript("OnMouseUp" ,frameOnMouseUp)

		local titleText = title:CreateFontString("$parent_Title", "OVERLAY", "GameFontNormalSmall")
		titleText:SetPoint("CENTER", title, "CENTER")
		titleText:SetHeight(5)
		titleText:SetText(text)

		local closeButton = CreateFrame("Button", "$parent_Close", frame,"UIPanelCloseButton")
		closeButton:SetWidth(28);
		closeButton:SetHeight(28);
		closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
		closeButton:SetFrameLevel(title:GetFrameLevel() + 1)
        --closeButton:SetStyle("CLOSE")
		
        local statusText = frame:CreateFontString("$parent_StatusBar_Text", "OVERLAY", "GameFontNormalSmall")
        statusText:SetJustifyH("LEFT")
        statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 4)
        statusText:SetPoint("RIGHT", frame, "RIGHT")
        statusText:SetText("")
		statusText:SetTextColor(1, 0, 0, 1)
		-- Sizer
		local sizer_se = CreateFrame("Button", "$parent_Sizer", frame)
		sizer_se:SetWidth(16)
		sizer_se:SetHeight(16)
		sizer_se:EnableMouse(true)
		sizer_se:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		sizer_se:SetNormalTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]])
		sizer_se:SetHighlightTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]])
		sizer_se:SetPushedTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]])
		sizer_se:SetScript("OnMouseDown" ,sizerseOnMouseDown)
		sizer_se:SetScript("OnMouseUp" ,sizerOnMouseUp)
		
		
		frame:HookScript("OnShow" ,frameOnShow)
		frame:HookScript("OnHide" ,frameOnHide)
		frame:HookScript("OnMouseDown" ,frameOnMouseDown)
		frame:HookScript("OnMouseUp" ,frameOnMouseUp)

		frame.SetTitle = frameSetTitle
		frame.SetMessage = frameSetMessage
		--frame.SetResizable = frameSetResizable
		frame.Close=closeButton;
		hooksecurefunc(frame, "SetResizable", frameSetResizable)
		--hooksecurefunc(frame, "Show", frameOnShow)
		--hooksecurefunc(frame, "MouseDown", frameOnMouseDown)
		--hooksecurefunc(frame, "MouseUp", frameOnMouseUp)
		return frame
	end

	function Lib.CreateEditerMenu(name,parent,edit)
		local f=CreateFrame("Frame",name,parent);
		--Menu MainFrame
		f.Alpha=1;																	--Alpha
		f.BorderColor={R=0,G=1,B=1,A=0.5};										--BorderColor
		f.BorderWidth=1;															--BorderWidth
		f.BackColor={R=0.5,G=0.5,B=0.5,A=1};										--BackColor
		f.ForeColor={R=1,G=1,B=1,A=1};												--ForeColor
		f.ItemBackColor={R=0.2,G=0.4,B=1,A=1};										--ItemBackColor
		f.Picture=nil;																--Picture
		f.ItemGap=10;																--ItemGap
		f.BackGroundTexture=f:CreateTexture();
		f.BackGroundTexture:SetAllPoints();
		f.BackGroundTexture:SetDrawLayer("BACKGROUND");
		f.Name=name;
		f.Width=200;																--Width
		f.Height=20;																--Height
		f.Points={{point="TOPLEFT",relativepoint="TOPLEFT",x=0,y=0}};				--Points
		--Menu Items
		f.Edit=edit;
		f.Items={};
		f.ItemsClicked=false;
		f.AddItem=function(self,name,text,func,position)										--NewItem(name,text,func)
			if not name or not text or not func then
				return false;
			end
			local itemcount=table.getn(self.Items);
			local tempitem;
			if not self.Items[itemcount+1] then
				tempitem=CreateFrame("Frame",name .. "Items" .. tostring(table.getn(self.Items)+1),self);
			else
				tempitem=self.Items[itemcount+1];
			end
			tempitem:EnableMouse(1);
			tempitem.Name=name;
			tempitem.Text=text;
			tempitem.Func=func;
			tempitem.Clicked=false;
			tempitem.showtext=tempitem.showtext or tempitem:CreateFontString();
			tempitem.showtext:SetFontObject("GameFontHighlightSmallOutline");
			tempitem.showtext:ClearAllPoints();
			tempitem.showtext:SetPoint("LEFT",tempitem,"LEFT",0,1);
			tempitem.showsel=tempitem.showsel or tempitem:CreateTexture();
			tempitem.showsel:SetAllPoints();
			tempitem.showsel:SetTexture(f.ItemBackColor.R,f.ItemBackColor.G,f.ItemBackColor.B,f.ItemBackColor.A);
			tempitem.showsel:Hide();
			tempitem:SetScript("OnEnter",function(self)
				self.showsel:Show();
			end);
			tempitem:SetScript("OnLeave",function(self)
				self.showsel:Hide();
			end);
			tempitem:SetScript("OnMouseUp",function(self)
				self.Func(self,f.Edit);
			end);
			tempitem:Show();
			if position and type(position)=="number" and position<=itemcount then
				table.insert(self.Items,position,tempitem);
			else
				table.insert(self.Items,tempitem);
			end
		end;
		f.GetItem=function(self,name)												--GetItem(name)
			local i;
			for i=1, table.getn(self.Items) do
				if self.Items[i].Name==name then
					return self.Items[i];
				end
			end
		end;
		f.DelItem=function(self,name)
			local i;
			for i=1, table.getn(self.Items) do
				if self.Items[i].Name==name then
					table.remove(self.Items,i);
					return true;
				end
			end
		end;
		--Auto Redraw
		f:SetScript("OnUpdate",function(self)
			local i;
			self:SetAlpha(self.Alpha);
			if self.BorderWidth>0 then
				self:SetBackdrop({edgeFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND",tile=1,tileSize=1,edgeSize=self.BorderWidth,insets={left=self.BorderWidth,right=self.BorderWidth,top=self.BorderWidth,bottom=self.BorderWidth}});
				self:SetBackdropBorderColor(self.BorderColor.R,self.BorderColor.B,self.BorderColor.G,self.BorderColor.A);
			else
				--[[local _FrameBackdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 3, right = 3, top = 3, bottom = 3 }
		}]]
				--self:SetBackdrop({tile=1,tileSize=1,edgeSize=1,insets={left=3,right=3,top=3,bottom=0}});
				self:SetBackdropBorderColor(self.BackColor.R,self.BackColor.B,self.BackColor.G,self.BackColor.A);
			end
			if self.Picture then
				self.BackGroundTexture:SetTexture(self.Picture);
				self.BackGroundTexture:SetAlpha(self.BackColor.A);
			else
				self.BackGroundTexture:SetTexture(self.BackColor.R,self.BackColor.G,self.BackColor.B,self.BackColor.A);
			end
			self:SetWidth(self.Width);
			self:SetHeight(self.Height);
			self:ClearAllPoints();
			for i=1, table.getn(self.Points or {}) do
				self:SetPoint(self.Points[i].point,parent,self.Points[i].relativepoint,self.Points[i].x,self.Points[i].y);
			end
			for i=1, table.getn(self.Items) do
				local tempitem=self.Items[i];
				tempitem.showtext:SetTextColor(self.ForeColor.R,self.ForeColor.G,self.ForeColor.B,self.ForeColor.A);
				tempitem.showtext:SetText(tempitem.Text);
				tempitem:SetWidth(tempitem.showtext:GetWidth());
				tempitem:ClearAllPoints();
				if i==1 then
					tempitem:SetPoint("LEFT",self,"LEFT",1+self.BorderWidth,0);
					tempitem:SetHeight(self:GetHeight()-self.BorderWidth*2);
				else
					tempitem:SetPoint("LEFT",self.Items[i-1],"RIGHT",self.ItemGap,0);
					tempitem:SetHeight(self.Items[i-1]:GetHeight());
				end
			end
		end);
		return f;
	end

	function Lib.CreateEditer(name,parent,ref)
	
		local frame = CreateFrame("Frame", name, parent);

		local scroll = CreateFrame("ScrollFrame", "$parent_Editer", frame, "UIPanelScrollFrameTemplate");
			scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -5);
			scroll:SetPoint("BOTTOMRIGHT",frame, "BOTTOMRIGHT", -27, 4);
		scroll:EnableMouse(true);
		
		local edit = CreateFrame("EditBox", "$parent_Code", frame);
		edit:SetAutoFocus(false);
		edit:SetMultiLine(true);
		edit:SetFontObject("GameFontNormal");
		edit:SetTextInsets(5, 5, 3, 3);
		edit.Main=parent;
		
		edit:HookScript("OnEscapePressed", function(self)
			self:ClearFocus();
		end);
		edit:HookScript("OnTabPressed", function(self)
			self:Insert("    ");
		end);
		
		IndentationLib.enable(edit,nil,4);
		
		scroll:HookScript("OnMouseDown" , function()
			edit:SetFocus();
		end);
		scroll:HookScript("OnSizeChanged" , function(self)
			local left, bottom, width, height = self:GetBoundsRect();							
			edit:SetWidth(width-20);
			edit:SetHeight(height);
		end);
		scroll:SetScrollChild(edit);

		local scrollBackground = CreateFrame("Frame", "$parent_CodeBackground", frame);
		scrollBackground:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0);
		scrollBackground:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0);
		scrollBackground:SetBackdrop(_FrameBackdrop);
		scrollBackground:SetBackdropColor(0, 0, 0);
		scrollBackground:SetBackdropBorderColor(0.4, 0.4, 0.4);

	
		local menu=Lib.CreateEditerMenu("$parent_Menu",frame,edit);
		menu.Points={{point="TOPLEFT",relativepoint="TOPLEFT",x=3,y=-5},{point="TOPRIGHT",relativepoint="TOPRIGHT",x=-3,y=-5}};
		menu.ItemGap=15;
		menu.BorderWidth=0;
		menu:Hide()
		
		menu:HookScript("OnHide" , function(self)
			scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -5);
			scroll:SetPoint("BOTTOMRIGHT",frame, "BOTTOMRIGHT", -27, 4);
		end);
		if(ref)then
			ref.Event=edit
		end
		menu:HookScript("OnShow" , function(self)
			scroll:SetPoint("TOPLEFT", menu, "BOTTOMLEFT", 3, -1);
			scroll:SetPoint("BOTTOMRIGHT",frame, "BOTTOMRIGHT", -27, 4);
		end);


		frame.SetText=function(self,text) edit:SetText(text) end;
		frame.GetText=function(self) return edit:GetText() end;
		frame.Insert=function(self,text) edit:Insert(text) end;
		frame.Edit=edit;
		frame.Menu=menu;
		
		return frame;
	end

	function Lib.CreateCheckBox(name,parent)
		-- New Frame
		local frame = CreateFrame("Frame", name, parent)
		frame:EnableMouse(1);
		frame:SetHeight(22);
		frame.Mask_MouseOver=frame:CreateTexture();
		frame.Mask_MouseOver:SetDrawLayer("BORDER");
		frame.Mask_MouseOver:SetTexture("Interface\\GLUES\\CharacterSelect\\Glues-CharacterSelect-Highlight");
		frame.Mask_MouseOver:SetBlendMode("ADD");
		frame.Mask_MouseOver:SetAllPoints();
		frame.Mask_MouseOver:Hide();
		frame.Mask_MouseDown=frame:CreateTexture();
		frame.Mask_MouseDown:SetDrawLayer("ARTWORK");
		frame.Mask_MouseDown:SetTexture("Interface\\GLUES\\CharacterSelect\\Glue-CharacterSelect-Highlight");
		frame.Mask_MouseDown:SetBlendMode("ADD");
		frame.Mask_MouseDown:SetAllPoints();
		frame.Mask_MouseDown:Hide();

		frame.Check=CreateFrame("CheckButton", "$parent_Check", frame)
		frame.Check:SetPoint("LEFT",frame,"LEFT",3,0);
		frame.Check:SetWidth(16);
		frame.Check:SetHeight(16);
		frame.Check:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
		frame.Check:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
		frame.Check:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
		frame.Check:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
		frame.Check:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])

		frame.Run=frame:CreateTexture();
		frame.Run:SetTexture("Interface\\OPTIONSFRAME\\VoiceChat-Play");
		frame.Run:SetGradient("Horizontal", 0,1,0,0,1,0);
		frame.Run:SetPoint("CENTER",0,0);
		frame.Run:SetWidth(12);
		frame.Run:SetHeight(12);
		frame.Run:SetDrawLayer("ARTWORK");
		frame.Run:SetPoint("RIGHT",frame.Check,"RIGHT",0,0);
		frame.Run:Hide();
		
		frame.Number=frame:CreateFontString();
		frame.Number:SetFontObject("NumberFontNormalYellow");
		frame.Number:SetPoint("LEFT",frame.Check,"RIGHT",0,0);
		
		frame.Icon=frame:CreateTexture();
		frame.Icon:SetWidth(frame:GetHeight()-8);
		frame.Icon:SetHeight(frame:GetHeight()-8);
		frame.Icon:SetPoint("LEFT",frame.Number,"RIGHT",0,0);
		--frame.Icon:SetPoint("LEFT",frame.Check,"LEFT",0,0);
		frame.Icon:SetDrawLayer("OVERLAY");
		
		frame.Name=frame:CreateFontString();
		frame.Name:SetFontObject("GameFontHighLightSmall");
		frame.Name:SetTextColor(1,1,1,1);
		frame.Name:SetPoint("LEFT",frame.Icon,"RIGHT",1,0);
		--frame.Name:SetPoint("LEFT",frame.Number,"RIGHT",0,0);
		--[[frame.Delete=CreateFrame("Button","$parent_Delete",frame);
		frame.Delete:SetFrameStrata("HIGH");
		frame.Delete:SetWidth(24);
		frame.Delete:SetHeight(24);
		frame.Delete:SetNormalTexture("Interface\\BUTTONS\\CancelButton-Up");--UI-MinusButton-Up
		frame.Delete:SetPushedTexture("Interface\\BUTTONS\\CancelButton-Down");
		frame.Delete:SetHighlightTexture("Interface\\BUTTONS\\CancelButton-Hilight");
		frame.Delete:SetPoint("RIGHT",frame,"RIGHT",-8,0);
		frame.Delete:Hide();
		]]
		frame.Play=frame:CreateTexture();
		frame.Play:SetTexture("Interface\\OPTIONSFRAME\\VoiceChat-Play");
		frame.Play:SetGradient("Horizontal", 0,1,0,0,1,0);
		frame.Play:SetPoint("CENTER",0,0);
		frame.Play:SetWidth(12);
		frame.Play:SetHeight(12);
		frame.Play:SetDrawLayer("ARTWORK");
		frame.Play:SetPoint("RIGHT",frame,"RIGHT",-8,0);
		frame.Play:Hide();
		frame.ItemsMenu=CreateFrame("Frame",  name.."_ItemsMenu", UIParent, "UIDropDownMenuTemplate");
		frame.Value="";

		frame.Check.GetValue = function(self) return frame.Value end
--		frame.Delete.GetValue = function(self) return frame.Value end
		frame.GetValue = function(self) return frame.Value end
		frame.SetValue = function(self,v) frame.Value=v end

		return frame
	end
	
	function Lib.CreateVarBox(name,parent)
		-- New Frame
		local frame = CreateFrame("Frame", name, parent)
		frame:EnableMouse(1);
		frame:SetHeight(28);
		
		frame.Check=CreateFrame("CheckButton", "$parent_Check", frame)
		frame.Check:SetPoint("LEFT",frame,"LEFT",3,0);
		frame.Check:SetWidth(16);
		frame.Check:SetHeight(16);
		frame.Check:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
		frame.Check:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
		frame.Check:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
		frame.Check:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
		frame.Check:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])
		
		frame.Number=frame:CreateFontString();
		frame.Number:SetFontObject("NumberFontNormalYellow");
		frame.Number:SetPoint("LEFT",frame.Check,"RIGHT",0,0);
		frame.Number:Hide();
		
		frame.Name=frame:CreateFontString();
		frame.Name:SetFontObject("GameFontHighLightSmall");
		frame.Name:SetTextColor(1,1,1,1);
		frame.Name:SetPoint("LEFT",frame.Check,"RIGHT",5,0);

		frame.Value=CreateFrame("EditBox","$parent_Edit",frame,"InputBoxTemplate");
		frame.Value:SetAutoFocus(false);
		frame.Value:SetHeight(16);
		frame.Value:SetWidth(50);
		frame.Value:SetPoint("LEFT",frame.Name,"RIGHT",10,0);
	
		frame.Join=frame:CreateFontString();
		frame.Join:SetFontObject("GameFontHighLightSmall");
		frame.Join:SetTextColor(1,1,1,1);
		frame.Join:SetPoint("LEFT",frame.Value,"RIGHT",5,0);
	
		frame.Vice=CreateFrame("EditBox","$parent_Edit2",frame,"InputBoxTemplate");
		frame.Vice:SetAutoFocus(false);
		frame.Vice:SetHeight(16);
		frame.Vice:SetWidth(50);
		frame.Vice:SetPoint("LEFT",frame.Join,"RIGHT",10,0);
	
		frame.Description=frame:CreateFontString();
		frame.Description:SetFontObject("GameFontHighLightSmall");
		frame.Description:SetTextColor(1,1,1,1);
		frame.Description:SetPoint("LEFT",frame.Vice,"RIGHT",10,0);
		frame.ItemsMenu=CreateFrame("Frame",  name.."_ItemsMenu", UIParent, "UIDropDownMenuTemplate");
		frame.Values="";

		frame.Check.GetValue = function(self) return frame.Values end
		frame.GetValue = function(self) return frame.Values end
		frame.SetValue = function(self,v) frame.Values=v end

		return frame
	end
	
	
	function Lib.CreateMinimapButton(name, iconPath, iconSize)
		if type(name) ~= "string" then
			error(string.format("bad argument #1 to 'UICreateMinimapButton' (string expected, got %s)", type(name)));
			return nil;
		end	
		local PRIVATE = PRIVATE or "{952D6D3A-25E4-49AF-B281-AFDF3D958372}";
		local button = CreateFrame("Button", name, UIParent); -- The minimap button

		-- A private frame to maintain events and store data
		local private = CreateFrame("Frame", name.."_Private_Frame", button);
		button[PRIVATE] = private;	

		-- An array of mouse button strings, used for opening the associated option frames
		private._optionFrameMouseButtons = {};

		-- Rotated angle degree
		private._rotated = 0;

		private._CalcAngle = function(self, cursor)

			local mx, my = Minimap:GetCenter();
			local scale = Minimap:GetEffectiveScale();

			local px, py = GetCursorPosition();
			if cursor then
				px, py = GetCursorPosition();
				px, py = px / scale, py / scale;
			else
				px, py = self:GetParent():GetCenter();
				if not px then
					return 0;
				end
			end
			
			return math.deg(math.atan2(py - my, px - mx)) % 360;
		end

		private.SavePosition = function(self, db)
			db = db or self:_GetDB();
			if type(db) == "table" then
				db.angle = self:GetParent():GetAngle();
				db.point = nil;
				if self._detached then
					db.point = { self:GetParent():GetPoint(1) };
				end
			end
		end

		private.LoadPosition = function(self, db)
			db = db or self:_GetDB();
			if type(db) == "table" then
				if type(db.angle) == "number" then
					self:GetParent():SetAngle(db.angle);				
				end

				if self._detached and type(db.point) == "table" then
					self:GetParent():ClearAllPoints();
					self:GetParent():SetPoint(unpack(db.point));
				end

				self:SavePosition(db);
			end
		end

		private._GetDB = function(self)
			local db = self._registeredDB;
			if type(db) == "string" then
				db = getglobal(db);
			end

			if type(db) == "table" then
				if type(db[PRIVATE]) ~= "table" then
					db[PRIVATE] = {};
				end

				return db[PRIVATE];
			end

			return nil;
		end	
		
		private._OnDradStart = function(self)
			self:GetParent():LockHighlight();
			if self._detached then
				self:GetParent():StartMoving();
			else
				self._isMoving = 1;
			end		
		end
		
		private._OnDradStop = function(self)		
			self._isMoving = nil;		
			self:GetParent():StopMovingOrSizing();
			self:GetParent():UnlockHighlight();
			self:SavePosition();
			
			local angle = self:_CalcAngle();
			local x, y = self:GetParent():GetCenter();

			-- If the user has not specified a saved-variables table, maybe he wants to do it himself as long as
			-- there's a particular function defined
			if type(self:GetParent().OnDragStop) == "function" then
				if self._detached then
					self:GetParent():OnDragStop(x, y);
				else
					self:GetParent():OnDragStop(angle);
				end
			end
		end
		
		-- Private frame - OnEvent
		private:SetScript("OnEvent", function(self, event)
			-- Verify the table which was passed in from a previous call of button:RegisterDB, this will only occur if the user
			-- passed a string as the table name. If the table is valid, we unregister this event, otherwise we will have to check
			-- it every time upon "PLAYER_ENTERING_WORLD", fortunately this isn't a frequent event and won't cause any serious
			-- performance drop.
			if event == "PLAYER_ENTERING_WORLD" then
				local db = self:_GetDB();
				if db then
					self:UnregisterEvent("PLAYER_ENTERING_WORLD");
					self:LoadPosition(db);					
				end
			end
		end);

		-- Private frame - OnUpdate	
		private:SetScript("OnUpdate", function(self, elapsed)
			if self._isMoving then
				if not self:IsVisible() or not IsMouseButtonDown("LeftButton") then
					self:_OnDradStop();
				else
					-- Update button position around the minimap if the user is dragging				
					self:GetParent():SetAngle(self:_CalcAngle(1));
				end
			end
			
			-- Flash handling
			if self._flash then
				self._flashElapsed = (self._flashElapsed or 0) + elapsed;
				if self._iconTexture:IsShown() then
					-- icon is shown, should hide?
					if self._flashElapsed > self._showDuration then
						self._flashElapsed = 0;
						self._iconTexture:Hide();
					end
				else
					-- icon is hidden, should show?
					if self._flashElapsed > self._hideDuration then
						self._flashElapsed = 0;
						self._iconTexture:Show();
						self._flashRepeated = self._flashRepeated + 1;
						if self._repeat and self._flashRepeated >= self._repeat then						
							self._stopping = 1;
							self._flash = nil;
						end
					end
				end				
			elseif self._stopping then
				-- stopped
				self._stopping = nil;
				self._iconTexture:Show();
			end
		end);	

		-- Sets up the button attributes as how a "minimap button" should look like
		button:EnableMouse(true);
		button:SetMovable(true);
		--button:SetClampedToScreen(true);
		button:SetWidth(31);
		button:SetHeight(31);
		--button:SetFrameStrata("LOW"); -- Minimap strata is "BACKGROUND" at current version
		button:SetFrameStrata("MEDIUM"); -- Minimap strata is "BACKGROUND" at current version
		--button:SetFrameLevel(Minimap:GetFrameLevel() + 3);
		button:SetFrameLevel(999);
		
		-- Creates the button-face texture using user specified icon
		private._iconTexture = button:CreateTexture(nil, "ARTWORK"); -- Button-face texture
		private._iconTexture:SetPoint("CENTER", button, "CENTER", 0, 1);

		-- Creates the button border texture using wow default minimap tracking border
		local overlay = button:CreateTexture(nil, "OVERLAY");
		overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder"); -- button border, use the minimap tracking button style
		overlay:SetWidth(53);
		overlay:SetHeight(53);
		overlay:SetPoint("TOPLEFT", button, "TOPLEFT");

		-- Set a highlight texture to make it look nice when the mouse cursor hovers in
		button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");

		-- Registers necessary events and scripts to respond mouse-drags properly.
		button:RegisterForDrag("LeftButton");
		button:SetScript("OnDragStart", function(self) self[PRIVATE]:_OnDradStart() end);
		button:SetScript("OnDragStop", function(self) self[PRIVATE]:_OnDradStop() end);

		button.OnTooltipRequest = function(self)
			local tooltip = self[PRIVATE]._tooltip;
			if tooltip then
				local i;
				for i = 1, table.getn(tooltip) do
					GameTooltip:AddLine(tooltip[i].text, tooltip[i].r, tooltip[i].g, tooltip[i].b, tooltip[i].wrap);
				end
			end
		end

		button:SetScript("OnEnter", function(self)
			if type(self.OnTooltipRequest) == "function" then
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
				GameTooltip:ClearLines();
				self:OnTooltipRequest();
				if GameTooltip:NumLines() > 0 then
					GameTooltip:Show();
				end
			end
		end);

		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end);

		-- To open the associated option frame, if any.
		button:SetScript("OnMouseUp", function(self, mb)
			local private = self[PRIVATE];
			local frame = private._optionFrame;
			if type(frame) == "string" then
				frame = getglobal(frame);
			end
			
			if type(frame) == "table" and type(frame.IsShown) == "function" then
				mb = string.lower(mb);
				local b;
				for _, b in ipairs(private._optionFrameMouseButtons) do
					if b == mb then
						if frame:IsShown() then
							frame:Hide();
						else
							frame:Show();
						end
						return;
					end
				end
			end
		end);

		-----------------------------------------------------------
		-- Derive Texture functions
		-----------------------------------------------------------

		local FUNCTABLE = { "GetBlendMode", "SetBlendMode", "GetTexCoord", "SetTexCoord", "GetTexture", "SetTexture", "GetVertexColor", "SetVertexColor", "IsDesaturated", "SetDesaturated", "SetGradient", "SetGradientAlpha" };
		local func;
		for _, func in ipairs(FUNCTABLE) do
			button[func] = function(self, ...)
				local icon = self[PRIVATE]._iconTexture;
				return icon[func](icon, ...);
			end
		end

		-----------------------------------------------------------
		-- Register our own functions to the button object
		-----------------------------------------------------------

		-- Clears all existing tooltip texts
		button.ClearTooltipLines = function(self)
			self[PRIVATE]._tooltip = nil;
		end

		-- Adds a line of tooltip text
		button.AddTooltipLine = function(self, text, r, g, b, wrap)
			if not self[PRIVATE]._tooltip then
				self[PRIVATE]._tooltip = {};
			end

			if type(text) ~= "string" or text == "" then
				text = " "; -- A blank line
			end
			table.insert(self[PRIVATE]._tooltip, { ["text"] = text, ["r"] = r, ["g"] = g, ["b"] = b, ["wrap"] = wrap } );
		end	

		-- Registers a saved-variables table to where the button angle will be saved	
		button.RegisterDB = function(self, db)
			local private = self[PRIVATE];
			private:UnregisterAllEvents();
			private._registeredDB = db;
			local t = type(db);
			if t == "table" then
				-- Table is valid, update angle immediately
				private:LoadPosition(db);
			elseif t == "string" then
				-- Table is not yet valid, this could be caused by calling MinimapButton:RegisterDB before "ADDON_LOADED" event fires,
				-- so we leave it alone and check later. This allows the programmer to call MinimapButton:RegisterDB in "OnLoad" function
				-- of their addons.
				private:RegisterEvent("PLAYER_ENTERING_WORLD");
			else
				private._registeredDB = nil;
			end
		end

		-- Associates an option frame which will be opened/closed when the user clicks on the button
		button.SetOptionFrame = function(self, frame, ...)
			local private = self[PRIVATE];
			private._optionFrame = frame;
			private._optionFrameMouseButtons = {};
			local count = select("#", ...);
			local i;
			for i = 1, count do
				local b = select(i, ...);
				if type(b) == "string" then
					table.insert(private._optionFrameMouseButtons, string.lower(b));
				end
			end

			if table.getn(private._optionFrameMouseButtons) == 0 then
				private._optionFrameMouseButtons = { "leftbutton", "rightbutton" };
			end
		end

		-- Retrieves the associated option frame
		button.GetOptionFrame = function(self)
			return self[PRIVATE]._optionFrame;
		end
		
		-- Rotates the button icon by angle degrees
		button.Rotate = function(self, angle)
			local private = self[PRIVATE];
			if type(angle) ~= "number" then
				angle = 0;
			end

			angle = math.floor(angle) % 360;
			if angle < 0 then
				angle = angle + 360;
			end

			if angle == self:GetRotated() then
				return angle;
			end

			private._rotated = angle;

			if angle == 0 then
				self:SetTexCoord(0, 1, 0, 1);
			else
				local LRx, LRy = 0.5 + math.cos(math.rad(angle + 45)) / math.sqrt(2), 0.5 + math.sin(math.rad(angle + 45)) / math.sqrt(2);
				local LLx, LLy = 0.5 + math.cos(math.rad(angle + 135)) / math.sqrt(2), 0.5 + math.sin(math.rad(angle + 135)) / math.sqrt(2);
				local ULx, ULy = 0.5 + math.cos(math.rad(angle + 225)) / math.sqrt(2), 0.5 + math.sin(math.rad(angle + 225)) / math.sqrt(2);
				local URx, URy = 0.5 + math.cos(math.rad(angle - 45)) / math.sqrt(2), 0.5 + math.sin(math.rad(angle - 45)) / math.sqrt(2);	
				self:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
			end
			return angle;
		end

		-- Retrieves rotated angle degrees of the button icon, 0 if not rotated at all
		button.GetRotated = function(self) return self[PRIVATE]._rotated or 0; end	

		-- Retrieves button texture size
		button.GetIconSize = function(self)
			return self[PRIVATE]._iconTexture:GetWidth();
		end

		-- Sets button texture size
		button.SetIconSize = function(self, size)
			local icon = self[PRIVATE]._iconTexture;
			if type(size) ~= "number" then
				size = 20;
			end
			size = math.max(16, math.min(size, 64));
			icon:SetWidth(size);
			icon:SetHeight(size)
			return size;
		end	

		-- Sets button orbit
		button.SetOrbit = function(self, square, radius)
			self[PRIVATE]._square = square;
			if type(radius) ~= "number" then
				radius = Minimap:GetWidth() / 2 + 9;
			end
			self[PRIVATE]._radius = math.max(0, math.min(radius, 200));
			self:SetAngle(self:GetAngle()); -- refresh position
		end

		-- Retrieves button orbit
		button.GetOrbit = function(self) 
			return self[PRIVATE]._square, self[PRIVATE]._radius or 80;
		end

		-- Retrieves button angle
		button.GetAngle = function(self, cursor)
			return self[PRIVATE]:_CalcAngle(cursor);
		end
		
		-- Sets button angle
		button.SetAngle = function(self, angle)
			if type(angle) ~= "number" then
				angle = math.random(150, 300);
			end

			--angle = math.floor(angle) % 360;
			local r = math.rad(angle);
			local x, y, q = math.cos(r), math.sin(r), 1;
			if x < 0 then q = q + 1 end
			if y > 0 then q = q + 2 end

			local square, radius = self:GetOrbit();
			local minimapShape = GetMinimapShape and GetMinimapShape();
			local quadTable = MINIMAPSHAPES[tostring(minimapShape)];
			if not quadTable then
				quadTable = MINIMAPSHAPES[square and "SQUARE" or "ROUND"];
			end

			if quadTable[q] then
				x, y = x * radius, y * radius;
			else
				local diagRadius = math.sqrt(2 * radius ^ 2) - 10;
				x = math.max(-radius, math.min(x * diagRadius, radius));
				y = math.max(-radius, math.min(y * diagRadius, radius));
			end

			-- apply new position
			self:ClearAllPoints();
			self:SetPoint("CENTER", Minimap, "CENTER", x, y);
			return angle;
		end

		button.IsFlashing = function(self)
			local private = self[PRIVATE];
			return private._flash, private._showDuration, private._hideDuration, private._repeat, (private._flashRepeated or 0);
		end

		-- Start flashing
		button.StartFlash = function(self, showDuration, hideDuration, repeatTimes)
			if type(showDuration) == "number" and showDuration > 0 and type(hideDuration) == "number" and hideDuration > 0 then
				local private = self[PRIVATE];
				private._flash = nil;
				private._showDuration = showDuration;
				private._hideDuration = hideDuration;
				private._repeat = tonumber(repeatTimes);			
				private._flashRepeated = 0;
				private._shown = nil;
				private._stopping = nil;
				private._flash = true;
				return true;
			end
			return nil;
		end

		-- Stop flashing
		button.StopFlash = function(self)
			local private = self[PRIVATE];
			private._stopping = true;
			private._flash = nil;
			private._iconTexture:Show();
		end

		button.Attach = function(self)
			self[PRIVATE]._detached = nil;
			self:SetAngle(self:GetAngle());
		end

		button.Detach = function(self)
			self[PRIVATE]._detached = 1;		
		end	

		button.IsDetached = function(self)
			return self[PRIVATE]._detached;
		end

		-- Initializes button position and texture	
		button:SetTexture(iconPath);
		button:SetIconSize(iconSize);
		button:SetAngle(); -- Sets a random angle upon creation

		-----------------------------------------------------------
		-- Deprecated methods, you shall never call them anymore
		-----------------------------------------------------------

		-- Deprecated, only for downward compatibility to old versions.
		button.SetTooltipText = function(self, text, anchor, r, g, b, wrap)
			self:ClearTooltipLines();
			self:AddTooltipLine(text, r, g, b, wrap);
		end

		-- Deprecated, only for downward compatibility to old versions.
		button.GetTooltipText = function(self)
			local tooltip = self[PRIVATE]._tooltip;
			if tooltip then
				return tooltip[1].text, tooltip[1].r, tooltip[1].g, tooltip[1].b, tooltip[1].wrap; 
			else
				return nil;
			end
		end	
		
		-- Deprecated, only for downward compatibility to old versions.
		button.SetGreyscale = function(self, ...)
			return self:SetDesaturated(...);
		end

		-- Deprecated, only for downward compatibility to old versions.
		button.IsGreyscale = function(self)
			return self:IsDesaturated();
		end

		-- Deprecated, only for downward compatibility to old versions.
		button.GetIconPath = function(self)
			return self:GetTexture();
		end

		-- Deprecated, only for downward compatibility to old versions.
		button.SetIconPath = function(self, ...)
			return self:SetTexture(...);
		end	

		return button; -- from this point on you can use it as a "Button" frame object
	end

	function Lib.CreateZoneText(name, parent)
		local zoneTextFrame = CreateFrame("Frame", name, parent);
		zoneTextFrame:SetWidth(128);
		zoneTextFrame:SetHeight(128);
		zoneTextFrame:SetPoint("BOTTOM", parent, "BOTTOM", 0, 512);
		zoneTextFrame:SetToplevel(true);
		
		zoneTextFrame.FadeInTime = 1;
		zoneTextFrame.HoldTime = 15;
		zoneTextFrame.FadeOutTime = 5;
		zoneTextFrame:Hide();
		
		local zoneTextString = zoneTextFrame:CreateFontString("$parent_Text", "ARTWORK", "ZoneTextFont");
		zoneTextString:SetWidth(512);
		zoneTextString:SetPoint("CENTER");
		zoneTextString:SetTextColor(1,0,0);
		   
		local infoTextString = zoneTextFrame:CreateFontString("$parent_Info", "ARTWORK", "PVPInfoTextFont");
		infoTextString:SetWidth(512);
		infoTextString:SetPoint("TOP", zoneTextString, "BOTTOM", 0, 0);
		infoTextString:SetTextColor(0,1,0);
		
		zoneTextFrame:HookScript("OnShow" , zoneText_OnShow);
		zoneTextFrame:HookScript("OnUpdate" , zoneText_OnUpdate);
		
		zoneTextFrame.SetText = function(self,text,info) zoneTextString:SetText(text) infoTextString:SetText(info) end
		return zoneTextFrame;
	end

--GUI Model: DropDownSearch
function Lib.CreateDropDownSearch(name,parent,default,list,applyfunc)
	--Container Frame
	local frame=CreateFrame("Frame",name,parent);
	frame:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=1,tileSize=16,edgeSize=16,insets={left=1,right=1,top=1,bottom=1}});
	frame:SetBackdropBorderColor(0.8,0.8,0.8,0.8);
	frame:EnableMouse(1);
	frame:SetWidth(150);
	frame:SetHeight(23);
	frame:ClearAllPoints();
	frame:SetPoint("CENTER",parent,"CENTER",0,0);
	frame:Show();
	--Inner Data Field
	frame.TextList=list;		--All Data Field
	frame.CurrentTextList={};	--Shown Data Field
	if applyfunc and type(applyfunc)=="function" then
		frame.Func=applyfunc;
	end
	--Drop Button
	frame.DDButton=CreateFrame("Button",name .. "Button",frame);
	frame.DDButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up");
	frame.DDButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down");
	frame.DDButton:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled");
	frame.DDButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight","ADD");
	frame.DDButton:SetWidth(21);
	frame.DDButton:SetHeight(21);
	frame.DDButton:SetPoint("TOPRIGHT",frame,"TOPRIGHT",-1,-1);
	frame.DDButton:SetScript("OnClick",function()
		if(not frame.Disable)then
			if frame.DDList:IsVisible() then
				frame.DDList:Hide();
			else
				frame.CurrentTextList={};
				local i;
				for i=1, table.getn(frame.TextList) do
					table.insert(frame.CurrentTextList,frame.TextList[i]);
				end
				frame.DDList:Show();
			end
		end
	end);
	--Editbox
	frame.DDEdit=frame:CreateFontString(name .. "EditBox");  --CreateFrame("EditBox",name .. "EditBox",frame);
	frame.DDEdit:SetHeight(20);
	frame.DDEdit:SetPoint("LEFT",frame,"LEFT",4,0);
	frame.DDEdit:SetPoint("RIGHT",frame.DDButton,"LEFT",-1,0);
--	frame.DDEdit:SetFrameStrata("MEDIUM");
	--frame.DDEdit:SetMaxLetters(10);
	frame.DDEdit:SetFontObject("GameFontHighlightSmall");
	frame.DDEdit:SetTextColor(1,1,0);
	frame.DDEdit:SetText(default or "");
	frame.DDEdit:SetJustifyH("CENTER");
	frame.DDEdit:SetJustifyV("MIDDLE");
	--frame.DDEdit.OriginalText=frame.DDEdit:GetText();
	--frame.DDEdit.Parent=frame;
--[[	frame.DDEdit:SetScript("OnEnterPressed",function(self)
		if(frame.Disable)then
			self:ClearFocus();
			return;
		end
		if self:GetText()=="" then
			frame.DDEdit:SetText(frame.DDEdit.OriginalText);
			self:ClearFocus();
			return;
		end
		--print("self:GetText():"..self:GetText());
		if frame.Func then
			frame.Func(self.Parent,self:GetText());
		end
		frame.DDEdit.OriginalText=frame.DDEdit:GetText();
		self:ClearFocus();
	end);
	frame.DDEdit:SetScript("OnEscapePressed",function(self)
		frame.DDEdit:SetText(frame.DDEdit.OriginalText);
		self:ClearFocus();
	end);
	frame.DDEdit:SetScript("OnEditFocusGained",function(self)
		self.Focus=true;
		frame.DDEdit:HighlightText();
		frame.DDEdit.OriginalText=frame.DDEdit:GetText();
	end);
	frame.DDEdit:SetScript("OnEditFocusLost",function(self)
		self.Focus=nil;
		frame.DDList:Hide();
	end);
	frame.DDEdit:SetScript("OnTextChanged",function(self)
		if not self.Focus then
			return;
		end
		local i;
		frame.CurrentTextList={};
		for i=1, table.getn(frame.TextList) do
			if string.sub(frame.TextList[i].Name,1,string.len(self:GetText()))==self:GetText() then
				table.insert(frame.CurrentTextList,frame.TextList[i]);
			end
		end
		frame.DDList:Hide();
		frame.DDList:Show();
	end);]]
	--DropdownList Frame
	frame.DDList=CreateFrame("Frame",name .. "List",frame);
	frame.DDList:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\ChatFrame\\CHATFRAMEBACKGROUND",
	tile=1,tileSize=2,edgeSize=2,insets={left=2,right=2,top=2,bottom=2}});
	frame.DDList:SetFrameStrata("DIALOG");
	frame.DDList:SetBackdropBorderColor(0.6,0.6,0.6,1);
	frame.DDList:SetBackdropColor(0.2,0.4,0.6,1);
	frame.DDList:EnableMouse(1);
	frame.DDList:ClearAllPoints();
	frame.DDList:SetPoint("TOPLEFT",frame,"BOTTOMLEFT",2,0);
	frame.DDList:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",-2,0);
	frame.DDList:Hide();
	frame.DDList.Items={};
	
	frame.DDList.Update=function(self)
		local i;
		if table.getn(frame.CurrentTextList)<1 then
			self:Hide();
			return;
		end
		for i=0, table.getn(frame.CurrentTextList) do
			if frame.DDList.Items[i]==nil then
				frame.DDList.Items[i]=CreateFrame("Frame","GUI_MAINFRAME_SCHEMEDROPDOWN_LIST" .. tostring(i),frame.DDList);
				frame.DDList.Items[i].Mask=frame.DDList.Items[i]:CreateTexture();
				frame.DDList.Items[i].Label=frame.DDList.Items[i]:CreateFontString();
				frame.DDList.Items[i].Icon=frame.DDList.Items[i]:CreateTexture();

				frame.DDList.Items[i]:SetFrameStrata("DIALOG");
				frame.DDList.Items[i]:ClearAllPoints();
				frame.DDList.Items[i]:EnableMouse(1);
				frame.DDList.Items[i]:SetScript("OnEnter",function(self) self.Mask:Show(); end);
				frame.DDList.Items[i]:SetScript("OnLeave",function(self) self.Mask:Hide(); end);
				frame.DDList.Items[i]:SetHeight(20);
				
				frame.DDList.Items[i].Mask:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar");
				frame.DDList.Items[i].Mask:SetAllPoints();
				frame.DDList.Items[i].Mask:SetWidth(30);
				frame.DDList.Items[i].Mask:Hide();
				frame.DDList.Items[i].Mask:SetDrawLayer("BACKGROUND");
				
				frame.DDList.Items[i].Icon:SetWidth(16);
				frame.DDList.Items[i].Icon:SetHeight(16);
				frame.DDList.Items[i].Icon:SetPoint("LEFT",0,0);
				frame.DDList.Items[i].Icon:SetDrawLayer("OVERLAY");
				
				frame.DDList.Items[i].Label:SetFontObject("GameFontNormalSmall");
				frame.DDList.Items[i].Label:SetDrawLayer("OVERLAY");
				--frame.DDList.Items[i].Label:SetAllPoints();
				frame.DDList.Items[i].Label:SetPoint("LEFT",frame.DDList.Items[i].Icon,"RIGHT",2,0);
				frame.DDList.Items[i].Label:SetPoint("RIGHT",frame.DDList.Items[i],"RIGHT",0,0);
				--frame.DDList.Items[i].Label:Show();

				
			end
			if i==0 then
				frame.DDList.Items[i]:SetPoint("TOPLEFT",frame.DDList,"TOPLEFT",2,-2);
				frame.DDList.Items[i]:SetPoint("TOPRIGHT",frame.DDList,"TOPRIGHT",-2,-2);
			else
				frame.DDList.Items[i]:SetPoint("TOPLEFT",frame.DDList.Items[i-1],"BOTTOMLEFT",0,-1);
				frame.DDList.Items[i]:SetPoint("TOPRIGHT",frame.DDList.Items[i-1],"BOTTOMRIGHT",0,-1);
			end

			if i==0 then
				frame.DDList.Items[i].Icon:SetTexture("Interface\\Icons\\Spell_ChargePositive");
				frame.DDList.Items[i].Label:SetText("新建");
				frame.DDList.Items[i]:SetScript("OnMouseUp",function(self)
					frame.DDEdit.Value=self.Label.Value;
					frame.DDList:Hide();
					if frame.AddFunc then
						frame.AddFunc(frame,frame.DDEdit.Value);
					end
				end);
			else
				frame.DDList.Items[i].Icon:SetTexture(frame.CurrentTextList[i].Icon);
				frame.DDList.Items[i].Label:SetText(frame.CurrentTextList[i].Title);
				frame.DDList.Items[i].Label.Value=frame.CurrentTextList[i].Name;
				frame.DDList.Items[i]:SetScript("OnMouseUp",function(self)
					--frame.DDEdit:SetText(self.Label.Value);
					frame.DDEdit:SetText(self.Label:GetText());
					frame.DDEdit.Value=self.Label.Value;
					frame.DDList:Hide();
					if frame.Func then
						frame.Func(frame,frame.DDEdit.Value);
					end
				end);
			end

			frame.DDList.Items[i]:Show();
		end
		i=table.getn(frame.CurrentTextList);
		repeat
			i=i+1;
			if frame.DDList.Items[i] then
				frame.DDList.Items[i]:Hide();
			end
		until not frame.DDList.Items[i]
		frame.DDList:SetHeight(3+table.getn(frame.CurrentTextList)*21+21);
	end;
	frame.DDList:SetScript("OnShow",function(self) self:Update(); end);
	
	frame.Disable=nil;
	frame.GetText=function(self)
		return frame.DDEdit:GetText();
	end
	return frame;
end
	
	
--Create a menu bar
function Lib.CreateFrameMenu(name,parent)
	local f=CreateFrame("Frame",name,parent);
	--Menu MainFrame
	f.Alpha=1;																	--Alpha
	f.BorderColor={R=0,G=1,B=1,A=0.5};										--BorderColor
	f.BorderWidth=1;															--BorderWidth
	f.BackColor={R=0.5,G=0.5,B=0.5,A=1};										--BackColor
	f.ForeColor={R=1,G=1,B=1,A=1};												--ForeColor
	f.ItemBackColor={R=0.2,G=0.4,B=1,A=1};										--ItemBackColor
	f.Picture=nil;																--Picture
	f.ItemGap=10;																--ItemGap
	f.BackGroundTexture=f:CreateTexture();
	f.BackGroundTexture:SetAllPoints();
	f.BackGroundTexture:SetDrawLayer("BACKGROUND");
	f.Name=name;
	f.Width=200;																--Width
	f.Height=20;																--Height
	f.Points={{point="TOPLEFT",relativepoint="TOPLEFT",x=0,y=0}};				--Points
	--Menu Items
	f.Items={};
	f.ItemsClicked=false;
	f.AddItem=function(self,name,text,func,position)										--NewItem(name,text,func)
		if not name or not text or not func then
			return false;
		end
		local itemcount=table.getn(self.Items);
		local tempitem;
		if not self.Items[itemcount+1] then
			tempitem=CreateFrame("Frame",name .. "Items" .. tostring(table.getn(self.Items)+1),self);
		else
			tempitem=self.Items[itemcount+1];
		end
		tempitem:EnableMouse(1);
		tempitem.Name=name;
		tempitem.Text=text;
		tempitem.Func=func;
		tempitem.Clicked=false;
		tempitem.showtext=tempitem.showtext or tempitem:CreateFontString();
		tempitem.showtext:SetFontObject("GameFontHighlightSmallOutline");
		tempitem.showtext:ClearAllPoints();
		tempitem.showtext:SetPoint("LEFT",tempitem,"LEFT",0,1);
		tempitem.showsel=tempitem.showsel or tempitem:CreateTexture();
		tempitem.showsel:SetAllPoints();
		tempitem.showsel:SetTexture(f.ItemBackColor.R,f.ItemBackColor.G,f.ItemBackColor.B,f.ItemBackColor.A);
		tempitem.showsel:Hide();
		tempitem:SetScript("OnEnter",function(self)
			self.showsel:Show();
		end);
		tempitem:SetScript("OnLeave",function(self)
			self.showsel:Hide();
		end);
		tempitem:SetScript("OnMouseUp",function(self)
			self.Func(self,self.Name,self.Text);
		end);
		tempitem:Show();
		if position and type(position)=="number" and position<=itemcount then
			table.insert(self.Items,position,tempitem);
		else
			table.insert(self.Items,tempitem);
		end
	end;
	f.GetItem=function(self,name)												--GetItem(name)
		local i;
		for i=1, table.getn(self.Items) do
			if self.Items[i].Name==name then
				return self.Items[i];
			end
		end
	end;
	f.DelItem=function(self,name)
		local i;
		for i=1, table.getn(self.Items) do
			if self.Items[i].Name==name then
				table.remove(self.Items,i);
				return true;
			end
		end
	end;
	--Auto Redraw
	f:SetScript("OnUpdate",function(self)
		local i;
		self:SetAlpha(self.Alpha);
		if self.BorderWidth>0 then
			self:SetBackdrop({edgeFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND",tile=1,tileSize=1,edgeSize=self.BorderWidth,insets={left=self.BorderWidth,right=self.BorderWidth,top=self.BorderWidth,bottom=self.BorderWidth}});
			self:SetBackdropBorderColor(self.BorderColor.R,self.BorderColor.B,self.BorderColor.G,self.BorderColor.A);
		else
			--[[local _FrameBackdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}]]
			--self:SetBackdrop({tile=1,tileSize=1,edgeSize=1,insets={left=3,right=3,top=3,bottom=0}});
			self:SetBackdropBorderColor(self.BackColor.R,self.BackColor.B,self.BackColor.G,self.BackColor.A);
		end
		if self.Picture then
			self.BackGroundTexture:SetTexture(self.Picture);
			self.BackGroundTexture:SetAlpha(self.BackColor.A);
		else
			self.BackGroundTexture:SetTexture(self.BackColor.R,self.BackColor.G,self.BackColor.B,self.BackColor.A);
		end
		self:SetWidth(self.Width);
		self:SetHeight(self.Height);
		self:ClearAllPoints();
		for i=1, table.getn(self.Points or {}) do
			self:SetPoint(self.Points[i].point,parent,self.Points[i].relativepoint,self.Points[i].x,self.Points[i].y);
		end
		for i=1, table.getn(self.Items) do
			local tempitem=self.Items[i];
			tempitem.showtext:SetTextColor(self.ForeColor.R,self.ForeColor.G,self.ForeColor.B,self.ForeColor.A);
			tempitem.showtext:SetText(tempitem.Text);
			tempitem:SetWidth(tempitem.showtext:GetWidth());
			tempitem:ClearAllPoints();
			if i==1 then
				tempitem:SetPoint("LEFT",self,"LEFT",1+self.BorderWidth,0);
				tempitem:SetHeight(self:GetHeight()-self.BorderWidth*2);
			else
				tempitem:SetPoint("LEFT",self.Items[i-1],"RIGHT",self.ItemGap,0);
				tempitem:SetHeight(self.Items[i-1]:GetHeight());
			end
		end
	end);
	return f;
end

--GUI Model: DropDownSearch
function Lib.CreateDropDownSearch2(name,parent,default,list,applyfunc)
	--Container Frame
	local DropDownSearch=CreateFrame("Frame",name,parent);
	DropDownSearch:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=1,tileSize=16,edgeSize=16,insets={left=1,right=1,top=1,bottom=1}});
	DropDownSearch:SetBackdropBorderColor(0.8,0.8,0.8,0.8);
	DropDownSearch:EnableMouse(1);
	DropDownSearch:SetWidth(150);
	DropDownSearch:SetHeight(23);
	DropDownSearch:ClearAllPoints();
	DropDownSearch:SetPoint("CENTER",parent,"CENTER",0,0);
	DropDownSearch:Show();
	--Inner Data Field
	DropDownSearch.TextList=list;		--All Data Field
	DropDownSearch.CurrentTextList={};	--Shown Data Field
	if applyfunc and type(applyfunc)=="function" then
		DropDownSearch.Func=applyfunc;
	end
	--Drop Button
	DropDownSearch.DDButton=CreateFrame("Button",name .. "Button",DropDownSearch);
	DropDownSearch.DDButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up");
	DropDownSearch.DDButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down");
	DropDownSearch.DDButton:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled");
	DropDownSearch.DDButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight","ADD");
	DropDownSearch.DDButton:SetWidth(21);
	DropDownSearch.DDButton:SetHeight(21);
	DropDownSearch.DDButton:SetPoint("TOPRIGHT",DropDownSearch,"TOPRIGHT",-1,-1);
	DropDownSearch.DDButton:SetScript("OnClick",function()
		if(not DropDownSearch.Disable)then
			if DropDownSearch.DDList:IsVisible() then
				DropDownSearch.DDList:Hide();
			else
				DropDownSearch.CurrentTextList={};
				local i;
				for i=1, table.getn(DropDownSearch.TextList) do
					table.insert(DropDownSearch.CurrentTextList,DropDownSearch.TextList[i]);
				end
				DropDownSearch.DDList:Show();
			end
		end
	end);
	--Editbox
	DropDownSearch.DDEdit=CreateFrame("EditBox",name .. "EditBox",DropDownSearch);
	DropDownSearch.DDEdit:SetAutoFocus(false);
	DropDownSearch.DDEdit:SetHeight(20);
	DropDownSearch.DDEdit:SetPoint("LEFT",DropDownSearch,"LEFT",4,0);
	DropDownSearch.DDEdit:SetPoint("RIGHT",DropDownSearch.DDButton,"LEFT",-1,0);
	DropDownSearch.DDEdit:SetFrameStrata("MEDIUM");
	DropDownSearch.DDEdit:SetMaxLetters(10);
	DropDownSearch.DDEdit:SetFontObject("GameFontHighlightSmall");
	DropDownSearch.DDEdit:SetTextColor(1,1,0);
	DropDownSearch.DDEdit:SetText(default or "");
	DropDownSearch.DDEdit:SetJustifyH("CENTER");
	DropDownSearch.DDEdit:SetJustifyV("MIDDLE");
	DropDownSearch.DDEdit.OriginalText=DropDownSearch.DDEdit:GetText();
	DropDownSearch.DDEdit.Parent=DropDownSearch;
	DropDownSearch.DDEdit:SetScript("OnEnterPressed",function(self)
		if(DropDownSearch.Disable)then
			self:ClearFocus();
			return;
		end
		if self:GetText()=="" then
			DropDownSearch.DDEdit:SetText(DropDownSearch.DDEdit.OriginalText);
			self:ClearFocus();
			return;
		end
		--print("self:GetText():"..self:GetText());
		if DropDownSearch.Func then
			DropDownSearch.Func(self.Parent,self:GetText());
		end
		DropDownSearch.DDEdit.OriginalText=DropDownSearch.DDEdit:GetText();
		self:ClearFocus();
	end);
	DropDownSearch.DDEdit:SetScript("OnEscapePressed",function(self)
		DropDownSearch.DDEdit:SetText(DropDownSearch.DDEdit.OriginalText);
		self:ClearFocus();
	end);
	DropDownSearch.DDEdit:SetScript("OnEditFocusGained",function(self)
		self.Focus=true;
		DropDownSearch.DDEdit:HighlightText();
		DropDownSearch.DDEdit.OriginalText=DropDownSearch.DDEdit:GetText();
	end);
	DropDownSearch.DDEdit:SetScript("OnEditFocusLost",function(self)
		self.Focus=nil;
		DropDownSearch.DDList:Hide();
	end);
	DropDownSearch.DDEdit:SetScript("OnTextChanged",function(self)
		if not self.Focus then
			return;
		end
		local i;
		DropDownSearch.CurrentTextList={};
		for i=1, table.getn(DropDownSearch.TextList) do
			if string.sub(DropDownSearch.TextList[i].Name,1,string.len(self:GetText()))==self:GetText() then
				table.insert(DropDownSearch.CurrentTextList,DropDownSearch.TextList[i]);
			end
		end
		DropDownSearch.DDList:Hide();
		DropDownSearch.DDList:Show();
	end);
	--DropdownList Frame
	DropDownSearch.DDList=CreateFrame("Frame",name .. "List",DropDownSearch);
	DropDownSearch.DDList:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\ChatFrame\\CHATFRAMEBACKGROUND",
	tile=1,tileSize=2,edgeSize=2,insets={left=2,right=2,top=2,bottom=2}});
	DropDownSearch.DDList:SetFrameStrata("DIALOG");
	DropDownSearch.DDList:SetBackdropBorderColor(0.6,0.6,0.6,1);
	DropDownSearch.DDList:SetBackdropColor(0.2,0.4,0.6,1);
	DropDownSearch.DDList:EnableMouse(1);
	DropDownSearch.DDList:ClearAllPoints();
	DropDownSearch.DDList:SetPoint("TOPLEFT",DropDownSearch,"BOTTOMLEFT",2,0);
	DropDownSearch.DDList:SetPoint("TOPRIGHT",DropDownSearch,"BOTTOMRIGHT",-2,0);
	DropDownSearch.DDList:Hide();
	DropDownSearch.DDList.Items={};
	DropDownSearch.DDList.Update=function(self)
		local i;
		if table.getn(DropDownSearch.CurrentTextList)<1 then
			self:Hide();
			return;
		end
		for i=1, table.getn(DropDownSearch.CurrentTextList) do
			if DropDownSearch.DDList.Items[i]==nil then
				DropDownSearch.DDList.Items[i]=CreateFrame("Frame","GUI_MAINFRAME_SCHEMEDROPDOWN_LIST" .. tostring(i),DropDownSearch.DDList);
				DropDownSearch.DDList.Items[i].SelMask=DropDownSearch.DDList.Items[i]:CreateTexture();
				DropDownSearch.DDList.Items[i].SelText=DropDownSearch.DDList.Items[i]:CreateFontString();
			end
			DropDownSearch.DDList.Items[i]:Show();
			DropDownSearch.DDList.Items[i]:SetFrameStrata("DIALOG");
			DropDownSearch.DDList.Items[i]:ClearAllPoints();
			DropDownSearch.DDList.Items[i]:EnableMouse(1);
			DropDownSearch.DDList.Items[i]:SetScript("OnEnter",function(self) self.SelMask:Show(); end);
			DropDownSearch.DDList.Items[i]:SetScript("OnLeave",function(self) self.SelMask:Hide(); end);
			DropDownSearch.DDList.Items[i]:SetHeight(20);
			if i==1 then
				DropDownSearch.DDList.Items[i]:SetPoint("TOPLEFT",DropDownSearch.DDList,"TOPLEFT",2,-2);
				DropDownSearch.DDList.Items[i]:SetPoint("TOPRIGHT",DropDownSearch.DDList,"TOPRIGHT",-2,-2);
			else
				DropDownSearch.DDList.Items[i]:SetPoint("TOPLEFT",DropDownSearch.DDList.Items[i-1],"BOTTOMLEFT",0,-1);
				DropDownSearch.DDList.Items[i]:SetPoint("TOPRIGHT",DropDownSearch.DDList.Items[i-1],"BOTTOMRIGHT",0,-1);
			end
			DropDownSearch.DDList.Items[i].SelMask:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar");
			DropDownSearch.DDList.Items[i].SelMask:SetAllPoints();
			DropDownSearch.DDList.Items[i].SelMask:SetWidth(30);
			DropDownSearch.DDList.Items[i].SelMask:Hide();
			DropDownSearch.DDList.Items[i].SelMask:SetDrawLayer("BACKGROUND");
			DropDownSearch.DDList.Items[i].SelText:SetFontObject("GameFontNormalSmall");
			DropDownSearch.DDList.Items[i].SelText:SetDrawLayer("OVERLAY");
			DropDownSearch.DDList.Items[i].SelText:SetText(DropDownSearch.CurrentTextList[i].Title);
			DropDownSearch.DDList.Items[i].SelText.Value=DropDownSearch.CurrentTextList[i].Name;
			DropDownSearch.DDList.Items[i].SelText:SetAllPoints();
			DropDownSearch.DDList.Items[i].SelText:Show();
			DropDownSearch.DDList.Items[i]:SetScript("OnMouseUp",function(self)
				DropDownSearch.DDEdit:ClearFocus();
				--DropDownSearch.Value=self.SelText.Value;
				--DropDownSearch.DDEdit:SetText(self.SelText:GetText());
				DropDownSearch.DDEdit:SetText(self.SelText.Value);
				DropDownSearch.DDList:Hide();
				if DropDownSearch.Func then
					DropDownSearch.Func(DropDownSearch,DropDownSearch.DDEdit:GetText());
				end
			end);
		end
		i=table.getn(DropDownSearch.CurrentTextList);
		repeat
			i=i+1;
			if DropDownSearch.DDList.Items[i] then
				DropDownSearch.DDList.Items[i]:Hide();
			end
		until not DropDownSearch.DDList.Items[i]
		DropDownSearch.DDList:SetHeight(3+table.getn(DropDownSearch.CurrentTextList)*21);
	end;
	DropDownSearch.DDList:SetScript("OnShow",function(self) self:Update(); end);
	
	DropDownSearch.Disable=nil;
	--[[DropDownSearch.Value="";
	DropDownSearch.SetValue=function(self,title,value)
		self.DDEdit:SetText(title);
		self.Value=value;
	end
	DropDownSearch.GetValue=function(self)
		return self.Value;
	end]]
	return DropDownSearch;
end
	
--Create a standard SingleLine Editbox
--Interfaces: SetText(txt),GetText(),SetFont(fontobject),SetFontColor(R,G,B,A),SetTooltip(title,lines)
--Override Events: OnText(txt)
function Lib.CreateSingleEditBox(name,parent,default)
	local EditBoxContainer=CreateFrame("Frame",name,parent);
	EditBoxContainer:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=1,tileSize=16,edgeSize=16,insets={left=1,right=1,top=1,bottom=1}});
	EditBoxContainer:SetBackdropBorderColor(0.8,0.8,0.8,0.8);
	EditBoxContainer:EnableMouse(1);
	EditBoxContainer:SetWidth(150);
	EditBoxContainer:SetHeight(23);
	EditBoxContainer:ClearAllPoints();
	EditBoxContainer:SetPoint("CENTER",parent,"CENTER",0,0);
	EditBoxContainer:Show();
	EditBoxContainer.EditBox=CreateFrame("EditBox",name .. "EditBox",EditBoxContainer);
	EditBoxContainer.EditBox:SetFontObject("GameFontNormal");
	EditBoxContainer.EditBox:SetAllPoints();
	EditBoxContainer.EditBox:SetText(default or "test");
	EditBoxContainer.EditBox:SetJustifyH("CENTER");
	EditBoxContainer.EditBox:SetJustifyV("MIDDLE");
	EditBoxContainer.EditBox:SetAutoFocus(nil);
	EditBoxContainer.EditBox.text=EditBoxContainer.EditBox:GetText();
	EditBoxContainer.EditBox.Flag=false;
	EditBoxContainer.EditBox:SetScript("OnEnterPressed",function(self)
		self.text=self:GetText();
		self:GetParent().OnText(self:GetParent(),self:GetText());
		self.Flag=true;
		self:ClearFocus();
	end);
	EditBoxContainer.EditBox:SetScript("OnEscapePressed",function(self)
		self:ClearFocus();
	end);
	EditBoxContainer.EditBox:SetScript("OnEditFocusLost",function(self)
		if not self.Flag then
			EditBoxContainer.EditBox:SetText(self.text);
		end
		self.Flag=false;
	end);
	EditBoxContainer.EditBox:SetScript("OnEditFocusGained",function(self)
		EditBoxContainer.EditBox:HighlightText();
	end);
	EditBoxContainer.EditBox:SetScript("OnEnter",function(self)
		if not self:GetParent().TooltipTitle then
			GameTooltip:ClearLines();
			GameTooltip:Hide();
			self:GetParent().OnMouseEnter(self:GetParent());
			return;
		end
		GameTooltip:SetOwner(self:GetParent():GetParent(),"ANCHOR_TOPLEFT");
		GameTooltip:ClearLines();
		GameTooltip:SetText(self:GetParent().TooltipTitle,0.9,0.9,0.5);
		if self:GetParent().TooltipLines then
			for _,line in pairs(self:GetParent().TooltipLines) do
				GameTooltip:AddLine(line,0.8,0.8,0.1);
			end
		end
		GameTooltip:Show();
		self:GetParent().OnMouseEnter(self:GetParent());
	end);
	EditBoxContainer.EditBox:SetScript("OnLeave",function(self)
		GameTooltip:Hide();
		self:GetParent().OnMouseLeave(self:GetParent());
	end);
	EditBoxContainer.OnText=function(self,text) end;
	EditBoxContainer.OnMouseEnter=function(self) end;
	EditBoxContainer.OnMouseLeave=function(self) end;
	EditBoxContainer.SetText=function(self,text) self.EditBox.text=text; self.EditBox:SetText(text); end;
	EditBoxContainer.GetText=function(self) return self.EditBox:GetText() end;
	EditBoxContainer.SetFont=function(self,fontobject) self.EditBox:SetFontObject(fontobject); end;
	EditBoxContainer.SetFontColor=function(self,r,g,b,a) self.EditBox:SetTextColor(r,g,b,a); end;
	EditBoxContainer.SetTooltip=function(self,title,lines) self.TooltipTitle=title;self.TooltipLines=lines; end;
	return EditBoxContainer;
end

--Custom Action Frame
function Lib.ShowCustomAction(title,name,icon,resultfunc,args)
local icon=1;gsub(icon, "[%l%u]+\\", "");
	--Initialize Params
	local i;
	if not title or not name or not icon or not resultfunc then
		return;
	end
	--[[if type(icon)=="string" then
		for i=1, GetNumMacroIcons() do
			if GetMacroIconInfo(i)==icon then
				icon=i;
				break;
			end
		end
	end]]--4.33
	--Initialize Frame
	--if(not MacroPopupFrame)then
		MacroFrame_LoadUI();
		--RefreshPlayerSpellIconInfo();
	--end
	if(not MacroPopupFrame.Bak)then
		MacroPopupFrame.Bak = MacroPopupFrame.Bak or {};
		local f = MacroPopupFrame.Bak;
		--if not f.macroUILoaded then
		--	MacroFrame_LoadUI();
		--	f.macroUILoaded=true;
		--end
		
		f.OnShow=MacroPopupFrame:GetScript("OnShow");
		f.OnEnterPressed=MacroPopupEditBox:GetScript("OnEnterPressed");
		f.Points={};
		for i=1,MacroPopupFrame:GetNumPoints() do
			f.Points[i]={MacroPopupFrame:GetPoint(i)};
		end
		
	_,_,_,_,f.fontstring = MacroPopupFrame:GetRegions();
	f.fontstringtext=f.fontstring:GetText();

	f.OnOkayClick=MacroPopupOkayButton:GetScript("OnClick");
	f.mode=MacroPopupFrame.mode;
	end
	
	MacroPopupFrame.mode="mc";
	MacroPopupFrame.func=resultfunc;
	MacroPopupFrame.args=args;
	
	MacroPopupFrame.selectedIcon=icon;
	--MacroPopupFrame.selectedIconTexture=icon;--GetMacroIconInfo(icon);
	MacroPopupEditBox:SetText(name);
	MacroPopupFrame:ClearAllPoints();
	MacroPopupFrame:SetPoint("CENTER",UIParent,"CENTER",0,0);
	MacroPopupFrame:SetScript("OnShow", MacroPopupFrame_Update);
	
	MacroPopupFrame.Bak.fontstring:SetText(title);
	MacroPopupFrame.OnOkay=function(self,text,icon)
			MacroPopupFrame:Hide();
			self.func(self,text,icon,MacroPopupFrame.args);
	end
	
	MacroPopupEditBox:SetScript("OnEnterPressed", function(self)
		--4.33--MacroPopupFrame:OnOkay(MacroPopupEditBox:GetText(),GetMacroIconInfo(MacroPopupFrame.selectedIcon));
		MacroPopupFrame:OnOkay(MacroPopupEditBox:GetText(),"Interface\\Icons\\INV_Misc_QuestionMark");
	end);
	MacroPopupOkayButton:SetScript("OnClick",function(self)
		--4.33--MacroPopupFrame:OnOkay(MacroPopupEditBox:GetText(),GetMacroIconInfo(MacroPopupFrame.selectedIcon));getglobal("MacroPopupButton"..MacroPopupFrame.selectedIcon.."Icon"):GetTexture()
		MacroPopupFrame:OnOkay(MacroPopupEditBox:GetText(),"Interface\\Icons\\INV_Misc_QuestionMark");
	end);
	MacroPopupFrame:Show();
	MacroPopupFrame:HookScript("OnHide", function(self)
		MacroPopupFrame:ClearAllPoints();
		for i=1, table.getn(MacroPopupFrame.Bak.Points) do
			MacroPopupFrame:SetPoint(MacroPopupFrame.Bak.Points[i][1],MacroPopupFrame.Bak.Points[i][2],MacroPopupFrame.Bak.Points[i][3],MacroPopupFrame.Bak.Points[i][4],MacroPopupFrame.Bak.Points[i][5]);
		end
		MacroPopupFrame:SetScript("OnShow", MacroPopupFrame.Bak.OnShow);
		MacroPopupEditBox:SetScript("OnEnterPressed", MacroPopupFrame.Bak.OnEnterPressed);
		MacroPopupOkayButton:SetScript("OnClick",MacroPopupFrame.Bak.OnOkayClick);
		MacroPopupFrame.Bak.fontstring:SetText(MacroPopupFrame.Bak.fontstringtext);
		MacroPopupFrame.mode=MacroPopupFrame.Bak.mode;
	end);
end
