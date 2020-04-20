local ImgManager = {}

function ImgManager.new(pFile)
  local new = {}
  new.file = pFile
  new.img = love.graphics.newImage(pFile)
  new.w_def, new.h_def = new.img:getDimensions()
  new.w, new.h = new.w_def, new.h_def
  new.sx = 1
  new.sy = 1
  function new:scaleToScreen()
    self.sx = screen.w / self.w_def
    self.sy = screen.h / self.h_def
    print("new sx, sy : "..self.sx,self.sy)
  end
  return new
end

return ImgManager
