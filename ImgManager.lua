local ImgManager = {}

function ImgManager.new(pFile)
  local new = {}
  new.file = pFile
  new.img = love.graphics.newImage(pFile)
  new.w, new.h = new.img:getDimensions()
  return new
end

return ImgManager
