local QuadManager = {}
--
function QuadManager.new(pImageTable, pLig, pCol)
  local img = pImageTable
  --
  local newQuad = {}
  newQuad.w, newQuad.h = img.w / pCol, img.h / pLig
  --
  local x,y = 0, 0
  local i = 1 -- start Index for newQuad[i] = {}
  --
  for l = 1 , pLig do
    for c = 1 , pLig do
      newQuad[i] = love.graphics.newQuad(x, y, newQuad.w, newQuad.h, img.w, img.h)
      --
      x = x + newQuad.w
      i = i + 1 -- next index incrementation
    end
    --
    x = 0
    y = y + newQuad.h
    --
  end
  --
  return newQuad
end
--















return QuadManager
