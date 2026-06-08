-- 获取35码内所有怪物GUID
local t = LMonsterGUID(35)

-- 检查并打印返回的GUID
if t ~= nil then
    print("Monsters in range:")
    for k, v in pairs(t) do
        print(k, v)
    end
else
    print("No monsters found within 35 yards.")
end