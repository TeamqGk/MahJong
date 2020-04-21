local ImgManager = {}

function ImgManager.new(pFile)
  local new = {}
  new.file = pFile
  new.img = love.graphics.newImage(pFile)
  new.w_def, new.h_def = new.img:getDimensions()
  new.w, new.h = new.w_def, new.h_def
  new.sx = 1
  new.sy = 1
  --
  function new:scaleToScreen()
    self.sx = screen.w / self.w_def
    self.sy = screen.h / self.h_def
    print("new sx, sy : "..self.sx,self.sy)
  end
  --
  function new:draw()
    if not self.color then self.color = {1,1,1,} end
    if not self.x then self.x = 0 end
    if not self.y then self.y = 0 end
    love.graphics.setColor(self.color)
    --
    love.graphics.draw(self.img,self.x,self.y,0,self.sx,self.sy)
    --
    love.graphics.setColor(1,1,1,1)
  end
  return new
end

return ImgManager
