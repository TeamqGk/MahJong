local ChangeLevel = {}


function ChangeLevel.limit(pSelect)
  if not ChangeLevel.current then ChangeLevel.current = SaveMahJong.currentLevel end
  --
  local max = SaveMahJong.levelMax
  --
  if ChangeLevel.current + (pSelect) > max then
    pSelect = max
  end
  if pSelect + (pSelect) < 1 then
    pSelect = 1
  end
  --
  ChangeLevel.current = pSelect
  --
  return pSelect
end
--

function ChangeLevel.load()
  ChangeLevel.show = false
  --ChangeLevel.current
end
--

function ChangeLevel.update(dt)
end
--

function ChangeLevel.draw()
  if ChangeLevel.show then
    
  end
end
--






return ChangeLevel