function CreateMinimapIcon(name,iconpath,savedb,tooltips,onleftclick,onrightclick)
	local MinimapIcon={};
	MinimapIcon.Name=name;
	if (not MinimapIcon.Name) or (not savedb) then
		return nil;
	end
	MinimapIcon.IconPath=iconpath;
	MinimapIcon.SaveDB=savedb;
	MinimapIcon.Tooltips=tooltips;
	MinimapIcon.OnLeftClick=onleftclick;
	MinimapIcon.OnRightClick=onrightclick;
	MinimapIcon.MinimapDBIcon = LibStub("LibDBIcon-1.0",true);
	MinimapIcon.MinimapLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(MinimapIcon.Name, {
		type = "data source",
		text = MinimapIcon.Name,
		icon = MinimapIcon.IconPath or "",
	});
	MinimapIcon.MinimapLDB.OnClick=function(self, button)
		if button == "LeftButton" then
			if MinimapIcon.OnLeftClick then
				MinimapIcon.OnLeftClick(self);
			end
		elseif button == "RightButton" then
			if MinimapIcon.OnLeftClick then
				MinimapIcon.OnRightClick(self);
			end
		end
	end;
	MinimapIcon.MinimapLDB.OnTooltipShow=function(tt)
		tt:ClearLines();
		if MinimapIcon.Tooltips and type(MinimapIcon.Tooltips)=="table" then
			local i;
			for i=1, table.getn(MinimapIcon.Tooltips) do
				tt:AddLine(MinimapIcon.Tooltips[i].text,MinimapIcon.Tooltips[i].r or 1,MinimapIcon.Tooltips[i].g or 1,MinimapIcon.Tooltips[i].b or 1);
			end
		end
	end
	MinimapIcon.Show=function(self)
		self.MinimapDBIcon:Show(self.Name);
	end
	MinimapIcon.Hide=function(self)
		self.MinimapDBIcon:Hide(self.Name);
	end
	if MinimapIcon.MinimapDBIcon then
		MinimapIcon.MinimapDBIcon:Register(MinimapIcon.Name, MinimapIcon.MinimapLDB, MinimapIcon.SaveDB);
		MinimapIcon.MinimapDBIcon:Show(MinimapIcon.Name);
		return MinimapIcon;
	else
		return nil;
	end
end