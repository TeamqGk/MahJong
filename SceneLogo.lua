local SceneLogo = {}

local BoxManager = {}
local Box = {}

function mouseOnBox(pBox)
  return globals.math.AABB(mouse.x,mouse.y,mouse.w,mouse.h, pBox.x,pBox.y,pBox.w,pBox.h)
end

function BoxManager.newBox (px, py, pw, ph)
  local new = {}
  new.x = px
  function new:setTitle()
  end
  return new
end
function BoxManager(dt)
  for i=#Box,1, -1 do
    local b = Box[i]
    --

  end
end





function SceneLogo.load() -- love.load()
end
--

function SceneLogo.update(dt) -- love.load()
  BoxManager(dt)
end
--

function SceneLogo.draw()-- love.draw()
  love.graphics.print("Press Start",screen.ox,screen.oy)
end
--

function SceneLogo.keypressed(key, scancode, isrepeat)
  if key == "return" or key == "space" then
    SceneManager:setScene("SceneGame")
  end
  if mouseOnBox then
    --body...
  end
end


---------------------------- END -----------------------------------------
return SceneLogo
