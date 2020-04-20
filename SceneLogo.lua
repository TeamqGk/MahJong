local SceneLogo = {}

local debug = false

local BouttonManager = require ("BouttonManager")
local Boutton = {}
Boutton.current = {}

local Text = {}

function SceneLogo.load() -- love.load()
  Boutton[1] = BouttonManager.newBox (screen.w * 0.3, screen.h * 0.1)
  Boutton[1]:setCenterPos(screen.ox, screen.oy)
  Boutton[1]:setColor(0,1,0,0.25)
  Boutton[1]:setColorFixe()
  Boutton[1]:addText(Font[22], "Jouer !")
end
--

function SceneLogo.update(dt) -- love.load()
  Boutton[1]:update(dt)
  for i=1, #Boutton do
    if Boutton[i].ready then
      Boutton.current = Boutton[i]
      break
    end
  end
end
--

function SceneLogo.draw()-- love.draw()
  if debug then
    love.graphics.line(screen.ox, screen.y, screen.ox, screen.h)
    love.graphics.line(screen.x, screen.oy, screen.w, screen.oy)
  end
  --
  Boutton[1]:draw()
  --
--(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end
--

function SceneLogo.keypressed(key, scancode, isrepeat)
  if key == "return" or key == "space" then
    SceneManager:setScene("SceneGame")
  end
end

function SceneLogo.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if Boutton.current.ready then
      SceneManager:setScene("SceneGame")
    end
  end
end


---------------------------- END -----------------------------------------
return SceneLogo
