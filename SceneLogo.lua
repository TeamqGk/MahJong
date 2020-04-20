local SceneLogo = {}

local debug = false

local BouttonManager = {}
local Boutton = {}
Boutton.current = {}

local Text = {}



function BouttonManager.newBox (pw, ph)
  local new = {}
  new.x = 0
  new.y = 0
  new.w = pw
  new.h = ph
  new.ox = pw * 0.5
  new.oy = ph * 0.5
  --
  new.red = 1
  new.green = 1
  new.blue = 1
  new.alpha = 1
  new.color = {new.red, new.green, new.blue, new.alpha}
  --
  function new:update(dt)
    self.ready = globals.math.AABB(mouse.x,mouse.y,mouse.w,mouse.h, self.x,self.y,self.w,self.h)
    if self.ready then
      Boutton.current = self
      self:setColor(0,0,1,0.25)
    else
      self:resetColor()
    end
  end
  --
  function new:setCenterPos(x,y)
    self.x = x - self.ox
    self.y = y - self.oy
  end
  --
  function new:setPos(x,y)
    self.x = x
    self.y = y
  end
  --
  function new:setColor(red, green, blue, alpha)
    --
    if not red then red = 1 end
    if not green then green = 1 end
    if not blue then blue = 1 end
    if not alpha then alpha = 1 end
    --
    self.color = {red, green, blue, alpha}
  end
  function new:setColorFixe() -- set the current to Fixe
    self.colorFixe = self.color
  end
  function new:resetColor()
    self.color = self.colorFixe
  end
  --
  function new:draw()
    love.graphics.setColor(self.color )
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1,1,1,1)
    if self.ready and debug then
      love.graphics.print("button.ready : "..tostring(self.ready))
    end
  end
  --
  return new
end





function SceneLogo.load() -- love.load()
  Boutton[1] = BouttonManager.newBox (screen.w * 0.3, screen.h * 0.1)
  Boutton[1]:setCenterPos(screen.ox, screen.oy)
  Boutton[1]:setColor(0,1,0,0.25)
  Boutton[1]:setColorFixe()
  --
  Text[1] = {} -- TODO: a rajouter au Button directement =)
  Text[1].text = love.graphics.newText(Font[22], "Ready to Play !")
  Text[1].w, Text[1].h = Text[1].text:getDimensions()
  Text[1].ox, Text[1].oy = Text[1].w*0.5, Text[1].h*0.5
  Text[1].x, Text[1].y = screen.ox, screen.oy
end
--

function SceneLogo.update(dt) -- love.load()
  Boutton[1]:update(dt)
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
  local t = Text[1]
  love.graphics.draw(t.text, t.x, t.y, 0, 1, 1, t.ox, t.oy)--(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
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
