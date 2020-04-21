local SceneLogo = {}

local BouttonManager = require ("modules/BouttonManager")
print("#BouttonManager = "..#BouttonManager)
local Boutton = {}


local loop = 0
function SceneLogo.load() -- love.load()
  Boutton[1] = BouttonManager.newBox (screen.w * 0.3, screen.h * 0.1)
  Boutton[1]:setColor(0,1,0,0.25)
  Boutton[1]:setColorFixe()
  Boutton[1]:addText(Font[22], "Jouer !")
  --
  Boutton[2] = BouttonManager.newBox (screen.w * 0.3, screen.h * 0.1)
  Boutton[2]:setColor(0,1,0,0.25)
  Boutton[2]:setColorFixe()
  Boutton[2]:addText(Font[22], "Options")
  --
  print("#BouttonManager = "..#BouttonManager)
  --
  loop = loop + 1
  print("if find the bug look the value of loop : "..loop)
end
--

function SceneLogo.update(dt) -- love.load()
  BouttonManager:setPosAlignY()
  --
  BouttonManager.update(dt)
end
--

function SceneLogo.draw()-- love.draw()
  if debug then
    love.graphics.line(screen.ox, screen.y, screen.ox, screen.h)
    love.graphics.line(screen.x, screen.oy, screen.w, screen.oy)
  end
  --
  BouttonManager.draw()
  --
  if #BouttonManager ~= #Boutton then
  love.graphics.print(#BouttonManager.." #BouttonManager for only "..#Boutton.." #Boutton ?! Bug ! You do FixMe !",10,10)
  end
end
--

function SceneLogo.keypressed(key, scancode, isrepeat)
  if key == "return" or key == "space" then
    SceneManager:setScene("SceneGame")
  end
end
--

function SceneLogo.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if BouttonManager.current.ready then
      SceneManager:setScene("SceneGame")
    end
  end
end
--

---------------------------- END -----------------------------------------
return SceneLogo
