local BouttonManager = {}
BouttonManager.current = {ready = false}

function BouttonManager.newBox (pw, ph)
  local new = {}
  new.id = #BouttonManager+1
  new.w = pw
  new.h = ph
  new.ox = pw * 0.5
  new.oy = ph * 0.5
  --
  new.x = screen.ox - new.ox
  new.y = screen.oy - new.oy
  --
  new.red = 1
  new.green = 1
  new.blue = 1
  new.alpha = 1
  new.color = {new.red, new.green, new.blue, new.alpha}
  --
  new.isVisible = true

  function new:setPos(x,y, pStyle)
    --
    if pStyle == "center" then
      self.x = x - self.ox
      self.y = y - self.oy
    else
      self.x = x
      self.y = y
    end
    self:update()
    --
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
  --
  function new:setColorFixe() -- set the current to Fixe
    self.colorFixe = self.color
  end
  --
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
  --
  function new:updateText()
    if self.text then
      self.text.w, self.text.h = self.text.print:getDimensions()
      self.text.ox, self.text.oy = self.text.w*0.5, self.text.h*0.5
      self.text.x, self.text.y = self.x + self.ox, self.y + self.oy
    end
  end
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
    if debug then
      love.graphics.print("button["..self.id.."].ready : "..tostring(self.ready),self.x, self.y)
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

function BouttonManager:setPos(pStyle, DecX, DecY) -- pStyle "x" ou "y", DecX in pixel, DecY in pixel
  if pStyle then pStyle = tostring(string.lower(pStyle)) end
  if pStyle ~= "x" and pStyle ~= "y" then
    print(' Attention BouttonManager:setPosAlignCenter(pStyle) attends un string "x" ou "y" ! ')
    return false
  else
    print("alignement pour "..#BouttonManager.." boutons sur l'axe "..pStyle.." ! ")
  end
  -----------------------------------------------------------------------------------------------
  if #BouttonManager >= 1 then
    --
    local temp = {}
    --
    temp.spaceX = 4 or DecX
    temp.spaceY = 4 or DecY
    temp.escapeTotalX = temp.spaceX * (#BouttonManager+1)
    temp.escapeTotalY = temp.spaceY * (#BouttonManager+1)
    --
    temp.w_total = 0
    temp.h_total = 0
    for i = 1, #BouttonManager do
      local b = BouttonManager[1]
      if b.isVisible then
        temp.w_total = temp.w_total + b.w
        temp.h_total = temp.h_total + b.h
      end
    end
    temp.w_total = temp.w_total + temp.escapeTotalX
    temp.h_total = temp.h_total + temp.escapeTotalY
    --
    local start = {}
    start.spaceX = temp.spaceX
    start.spaceY = temp.spaceY
    start.x = screen.ox - (temp.w_total * 0.5)
    start.y = screen.oy - (temp.h_total * 0.5)
    print("start.x : "..start.x)
    --
    if pStyle == "x" then
      for i = 1, #BouttonManager do
        local b = BouttonManager[i]
        if b.isVisible then
          b:setPos(start.x, screen.oy, "center")
          b:updateText()
          start.x = start.x + b.w + start.spaceX
        end
      end
    elseif pStyle == "y" then
      for i = 1, #BouttonManager do
        local b = BouttonManager[i]
        if b.isVisible then
          b:setPos(screen.ox, start.y, "center")
          b:updateText()
          start.y = start.y + b.h + start.spaceY
        end
      end
    end
  end
end
--

function BouttonManager.update(dt)
  if #BouttonManager >= 1 then
    for i = #BouttonManager, 1, -1 do
      local b = BouttonManager[i]
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
    for i = #BouttonManager, 1, -1 do
      local b = BouttonManager[i]
      b:draw()
    end
  end
end
--

return BouttonManager
