local ImgManager = {}

function ImgManager.new(pFile)
  local new = {}
  new.file = pFile
  new.img = love.graphics.newImage(pFile)
  new.w_def, new.h_def = new.img:getDimensions()
  new.w, new.h = new.w_def, new.h_def
  new.x = 0
  new.y = 0
  new.sx = 1
  new.sy = 1
  new.color = {1,1,1,1}
  --
  function new:setColor(r,g,b,a)
    self.color = {r,g,b,a}
  end
  --
  function new:setSizes(w, h)
    self.w = w
    self.h = h
    --
    if self.w < self.w_def then
      self.sx = w / self.w_def
    else
      self.sx = self.w_def / w 
    end
    --
    if h < self.h_def then
      self.sy = h / self.h_def
    else
      self.sy = self.h_def / h 
    end
    --
    print(self.sx, self.sy)
  end
  --
  function new:setPos(x, y)
    self.x, self.y = x, y
  end
  --
  function new:scaleToScreen()
    self.sx = screen.w / self.w_def
    self.sy = screen.h / self.h_def
    self.w = self.w_def * self.sx
    self.h = self.h_def * self.sy
--    if debug then print("new sx, sy : "..self.sx,self.sy) end
  end
  --
  function new:scaleToWidth()
    self.sx = screen.w / self.w_def
    self.w = self.w_def * self.sx
--    if debug then print("new sx: "..self.sx) end
  end
  --
  function new:scaleToHeight()
    self.sy = screen.h / self.h_def
    self.h = self.h_def * self.sy
--    if debug then print("new sy : "..self.sy) end
  end
  --
  function new:draw()
    love.graphics.setColor(self.color)
    --
    love.graphics.draw(self.img,self.x,self.y,0,self.sx,self.sy)
    love.graphics.setColor(0,1,0,1)
    --
    love.graphics.setColor(1,1,1,1)
  end
  return new
end

return ImgManager
