local SceneLogo = {}

local BouttonManager = require ("modules/BouttonManager")
local Boutton = {}


local loop = 0
function SceneLogo.load() -- love.load()
  BouttonManager:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BouttonManager:setColor(0,1,0,0.25)
  --
  Boutton[1] = BouttonManager.newBox ()
--  Boutton[1]:setColor(0,1,0,0.25)
  Boutton[1]:addText(Font[22], "Jouer !")
  --
  Boutton[2] = BouttonManager.newBox ()
--  Boutton[2]:setColor(0,1,0,0.25)
  Boutton[2]:addText(Font[22], "Options")
  --
  Boutton[3] = BouttonManager.newBox ()
--  Boutton[3]:setColor(0,1,0,0.25)
  Boutton[3]:addText(Font[22], "Quitter")
  --
  BouttonManager:setPos("X")
end
--

function SceneLogo.update(dt) -- love.load()
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
  if debug then
    if key == "kp+" then
      BouttonManager:setPos("Y")
    elseif key == "kp-" then      
      BouttonManager:setPos("X")
    end
  end
  if key == "escape" then
    love.event.quit()
  end
end
--

function SceneLogo.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if BouttonManager.current.ready then
      SceneManager:setScene("SceneMahJong")
    end
  end
end
--

---------------------------- END -----------------------------------------
return SceneLogo
