local QuadManager = {}
--
function QuadManager.new(pImageTable, pLig, pCol)
  local img = pImageTable
  img.w, img.h = img.img:getDimensions()
  img.quad_w, img.quad_h = img.w / pCol, img.h / pLig
  --
  local newQuad = {}
  local x,y = 0, 0
  local i = 1 -- start Index for newQuad[i] = {}
  --
  for l = 1 , pLig do
    for c = 1 , pLig do
      newQuad[i] = love.graphics.newQuad(x, y, img.quad_w, img.quad_h, img.w, img.h)
      --
      x = x + img.quad_w
      i = i + 1 -- next index incrementation
    end
    --
    x = 0
    y = y + img.quad_h
    --
  end
  --
  return newQuad
end
--















return QuadManager
