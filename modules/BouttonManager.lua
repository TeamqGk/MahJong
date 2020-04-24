local BouttonManager = {}
--

function BouttonManager:newBM()
  local f = {}
  --
  f.w = 150
  f.h = 30
  f.spaceX = 30
  f.spaceY = 30
--
  f.color = {1,1,1,1}
  f.colorText = {0,0,0,1}
  f.colorMouseOver = {1,0,0,1}
--
  f.effect = 0
  f.effectMax = -15
  f.effectSpeed = 10

--
  f.current = {ready = false}
  --
  function f:setSpace(pSTringType, pVar)
    if pSTringType then pSTringType = tostring(string.lower(pSTringType)) end
    if pSTringType ~= "x" and pSTringType ~= "y" then
      print(' Attention f:setSpace(pSTringType) attends un string "x" ou "y" ! ')
      return false
    else
      print("espacement pour "..#f.." boutons sur l'axe "..pSTringType.." ! ")
    end
    if pSTringType == "x" then
      f.spaceX = pVar or 30
    elseif pSTringType == "y" then
      f.spaceY = pVar or 30 
    end
  end
  --
  function f:setDimensions(w, h)
    f.w = w 
    f.h = h
  end
--

  function f:setColor(r,g,b,a)
    f.color = {r,g,b,a}
  end
--

  function f:setColorText(r,g,b,a)
    f.colorText = {r,g,b,a}
  end
--

  function f:setColorMouseOver(r,g,b,a)
    f.colorMouseOver = {r,g,b,a}
  end
--

  function f:setPos(pStyle, DecX, DecY) -- pStyle "x" ou "y", DecX in pixel, DecY in pixel
    if pStyle then pStyle = tostring(string.lower(pStyle)) end
    if pStyle ~= "x" and pStyle ~= "y" then
      print(' Attention f:setPosAlignCenter(pStyle) attends un string "x" ou "y" ! ')
      return false
    else
      print("alignement pour "..#f.." boutons sur l'axe "..pStyle.." ! ")
    end
    -----------------------------------------------------------------------------------------------
    if #f >= 1 then
      --
      local temp = {}
      --
      temp.spaceX = f.spaceX or DecX
      temp.spaceY = f.spaceY or DecY
      --
      temp.w_total = temp.spaceX
      temp.h_total = temp.spaceY
      for i = 1, #f do
        local b = f[1]
        if b.isVisible then
          temp.w_total = temp.w_total + b.w + temp.spaceX
          temp.h_total = temp.h_total + b.h + temp.spaceY
        end
      end
      --
      local start = {}
      start.spaceX = temp.spaceX
      start.spaceY = temp.spaceY
      start.x = screen.ox - (temp.w_total * 0.5) + start.spaceX
      start.y = screen.oy - (temp.h_total * 0.5) + start.spaceY
      --
      local first = false
      if pStyle == "x" then
        for i = 1, #f do
          local b = f[i]
          if b.isVisible then
            if first == false then -- because is centred
              start.x = start.x + b.ox
              first = true
            end
            b:setPos(start.x, screen.oy, "center")
            b:updateText()
            start.x = start.x + b.w + start.spaceX
          end
        end
      elseif pStyle == "y" then
        for i = 1, #f do
          local b = f[i]
          if b.isVisible then
            if first == false then -- because is centred
              start.y = start.y + b.oy
              first = true
            end
            b:setPos(screen.ox, start.y, "center")
            b:updateText()
            start.y = start.y + b.h + start.spaceY
          end
        end
      end
    end
  end
--

  function f:update(dt)
    self.effect =  self.effect + self.effectSpeed * dt
    if self.effect <=  self.effectMax then
      self.effect = self.effectMax
      self.effectSpeed =  0 - self.effectSpeed
    elseif self.effect >= 0  then
      self.effect = 0
      self.effectSpeed = 0 - self.effectSpeed
    end

    if #self >= 1 then
      for i = #self, 1, -1 do
        local b = self[i]
        b:update(dt)
        if b.ready and b.isVisible then
          self.current = b
        end
      end
    end
  end
--

  function f:draw()
    local self = f
    if #self >= 1 then
      for i = #self, 1, -1 do
        local b = self[i]
        b:draw()
      end
    end
  end
--

  function f:newBox ()
    local Boutton = {}
    Boutton.id = #f+1
    Boutton.w = f.w
    Boutton.h = f.h
    Boutton.ox = f.w * 0.5
    Boutton.oy = f.h * 0.5
    --
    Boutton.x = screen.ox - Boutton.ox
    Boutton.y = screen.oy - Boutton.oy
    --
    Boutton.red = 1
    Boutton.green = 1
    Boutton.blue = 1
    Boutton.alpha = 1
    Boutton.color = false
    Boutton.colorFixe = false
    --
    Boutton.isVisible = true
    Boutton.isEffect = true
    --
    function Boutton:isEffect(pBool)
      if not pBool then self.isEffect = true end
      self.isEffect = pBool
    end
    --
    --
    function Boutton:setVisible(pBool)
      if not pBool then self.isVisible = true end
      self.isVisible = pBool
    end
    --
    function Boutton:setPos(x,y, pStyle)
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
    function Boutton:setColorText(r, g, b, a)
      --
      if not r or not g or not b or not  a then
        self.colorText = f.colorText
      else
        --
        self.colorText = {r, g, b, a}
      end
    end
    --
    function Boutton:setColor(r, g, b, a)
      --
      if not r or not g or not b or not  a then
        self.color =  f.color 
      else
        self.color = {r, g, b, a}
      end
      --
      if not self.colorFixe then self:setColorFixe() end
      if not self.colorFixe then self:setColorFixe() end
      --
    end
    --
    function Boutton:setcolorMouseOver() -- set the current to Fixe
      if not self.colorMouseOver then self.colorMouseOver = f.colorMouseOver end
      self.color = self.colorMouseOver
    end
    --
    function Boutton:setColorFixe() -- set the current to Fixe
      self.colorFixe = self.color
    end
    --
    function Boutton:resetColor()
      self.color = self.colorFixe
    end
    --
    function Boutton:addText(pFont, pString, r, g, b, a)
      self.text = {}
      self.text.print = love.graphics.newText(pFont, pString)
      --
      self:updateText()
      --
      if not r or not g or not b or not  a then
        self:setColorText()
      else
        self:setColorText(r,g,b,a)
      end
    end
    --
    --
    function Boutton:setAction(pAction)
      --function_name = function( arguments ) corps end
      if type(pAction) == "function" then
        self.action = function() pAction () end
      end
    end
    --
    function Boutton:updateText()
      --
      self.w = f.w
      self.h = f.h
      --
      if self.text then
        self.text.w, self.text.h = self.text.print:getDimensions()
        self.text.ox, self.text.oy = self.text.w*0.5, self.text.h*0.5
        self.text.x, self.text.y = self.x + self.ox, self.y + self.oy
      end
    end
    --
    function Boutton:update(dt)
      if not self.color then self:setColor() end
      self.ready = globals.math.AABB(mouse.x,mouse.y,mouse.w,mouse.h, self.x,self.y,self.w,self.h)
      if self.ready then
        self:setcolorMouseOver()
      else
        self:resetColor()
      end
      --
      self:updateText()
    end
    --
    function Boutton:draw()
      if self.isVisible then
        love.graphics.setColor(self.color)
        if self.isEffect then
          -- mirror W
          love.graphics.rectangle("fill", self.x, self.y, self.w, self.h,f.effect)
          love.graphics.rectangle("fill", self.x+self.w, self.y, 0 - self.w, self.h,(1*f.effect) - f.effect)
          -- mirror H
          love.graphics.rectangle("fill", self.x, self.y + self.h, self.w, 0 - self.h,f.effect*1.5)
          love.graphics.rectangle("fill", self.x+self.w, self.y + self.h, 0 - self.w, 0 - self.h,f.effect* - 1.5)
        else
          love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

        end
        --
        love.graphics.setColor(1,1,1,1)
        --
        if self.text then
          love.graphics.setColor(self.colorText)
          local t = self.text
          love.graphics.draw(t.print, t.x, t.y, 0, 1, 1, t.ox, t.oy)
        end
        --
      end
      love.graphics.setColor(1,1,1,1)
    end

    table.insert(f, Boutton)
    return Boutton
  end
--

  return f
end
--

return BouttonManager
