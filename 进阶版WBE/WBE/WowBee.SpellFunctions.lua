--Tabled Cast Time Checking for When you Last Cast Something. 上次施法延迟检测
--CheckCastTime = {}
--Nova_CheckLastCast = nil
function Nova_CheckLastCast(spellid, ytime) -- SpellID of Spell To Check, How long of a gap are you looking for?
	if not CheckCastTime then CheckCastTime={} end
	if ytime > 0 then
		if #CheckCastTime > 0 then
			for i=1, #CheckCastTime do
				if CheckCastTime[i].SpellID == spellid then
					if GetTime() - CheckCastTime[i].CastTime > ytime then
						CheckCastTime[i].CastTime = GetTime()
						return true
					else
						return false
					end
				end
			end
		end
		table.insert(CheckCastTime, { SpellID = spellid, CastTime = GetTime() } )
		return true
	elseif ytime <= 0 then
		return true
	end
	return false
end



