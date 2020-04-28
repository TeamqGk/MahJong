local ChangeLevel = {}


local fenetre = {}

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

  --
  fenetre.w = screen.w * 0.8
  fenetre.h = screen.h * 0.8
  fenetre.x = screen.w*0.1
  fenetre.y = screen.h*0.1
end
--

function ChangeLevel.update(dt)
end
--

function ChangeLevel.draw()
  if ChangeLevel.show then
    love.graphics.setColor(0.25,0.25,0.25,1)
    love.graphics.rectangle("fill",fenetre.x,fenetre.y,fenetre.w,fenetre.h,10)
  end
end
--






return ChangeLevel