local BouttonManager = {}
BouttonManager.current = {ready = false}

function BouttonManager.newBox (pw, ph)
  local new = {}
  new.id = #BouttonManager+1
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
      self:setColor(0,0,1,0.25)
    else
      self:resetColor()
    end
    --
    self:updateText()
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

  function new:setColorText(red, green, blue, alpha)
    --
    if not red then red = 1 end
    if not green then green = 1 end
    if not blue then blue = 1 end
    if not alpha then alpha = 1 end
    --
    self.colorText = {red, green, blue, alpha}
  end
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
  function new:addText(pFont, pString, r, g, b, a)
    self.text = {}
    self.text.print = love.graphics.newText(pFont, pString)
    --
    self:updateText()
    --

    if not r or not g or not b or not  a then
      self:setColorText(1,1,1,1)
    else
      self:setColorText(r,g,b,a)
    end
  end
  function new:updateText()
    if self.text then
      self.text.w, self.text.h = self.text.print:getDimensions()
      self.text.ox, self.text.oy = self.text.w*0.5, self.text.h*0.5
      self.text.x, self.text.y = self.x + self.ox, self.y + self.oy
    end
  end
  --
  function new:draw()
    love.graphics.setColor(self.color )
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1,1,1,1)
    --
    if self.text then
      love.graphics.setColor(self.colorText)
      local t = self.text
      love.graphics.draw(t.print, t.x, t.y, 0, 1, 1, t.ox, t.oy)
    end
    if self.ready and debug then
      love.graphics.print("button["..self.id.."].ready : "..tostring(self.ready))
    end
    --
    love.graphics.setColor(1,1,1,1)
  end
  --
  --
  table.insert(BouttonManager, new)
  return new
end
--

function BouttonManager:setPosAlignY()
  if #BouttonManager >= 1 then
    --
    local temp = {}
    temp.x = 0
    temp.y = 0
    temp.w = 0
    temp.h = 0
    temp.oy = 0
    --
    temp.espace = 8
    --
    for i = 1, #BouttonManager do
      local b = BouttonManager[1]
      temp.h = b.h + temp.espace
    end
    --
    temp.oy = temp.h * 0.5
    --
    temp.x = screen.ox
    temp.y = 0--screen.oy - temp.h
    --
    for i = 1, #BouttonManager do
      local b = BouttonManager[1]
      local x = temp.x - b.ox
      local y = temp.y + (temp.h * i)
      b:setPos(x,y)
    end
  end
end
--

function BouttonManager.update(dt)
  if #BouttonManager >= 1 then
    for i = 1, #BouttonManager do
      local b = BouttonManager[1]
      b:update(dt)
      if b.ready then
        BouttonManager.current = b
      end
    end
  end
end
--

function BouttonManager.draw()
  if #BouttonManager >= 1 then
    for i = 1, #BouttonManager do
      local b = BouttonManager[1]
      b:draw()
    end
  end
end
--

return BouttonManager
