local CCD = {}

CCD.math = {}
function CCD.math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end


function CCD.LineInRect(pX, pY, pRayon,              rX, rY, rW, rH)

  -- temporary variables to set edges for testing
  local oldX = pX
  local oldY = pY
  local testX = pX
  local testY = pY


  -- which edge is closest?
  -- horizontal (x)
  if (pX < rX) then-- test left edge
    testX = rX    
  elseif (pX > rX + rW) then-- right edge
    testX = rX + rW
  end 
  -- Vertical (Y)
  if (pY < rY) then -- top edge
    testY = rY    
  elseif (pY > rY + rH) then -- bottom edge
    testY = rY + rH  
  end 

-- get distance from closest edges
  local distX = pX - testX
  local distY = pY - testY
  local distance = math.sqrt( (distX*distX) + (distY*distY) ) -- Pythagore

-- if the distance is less than the radius, collision!
  if (distance <= pRayon) then
    return {collision = true, x = testX, y = testY, oldX = oldX, oldY = oldY}
  else
    return {collision = false, x = testX, y = testY, oldX = oldX, oldY = oldY}
  end
end
--


function CCD.getLine(pBall)
  --
  local line = {}
  line.x1 = pBall.old.x
  line.y1 = pBall.old.y
  line.x2 = pBall.x
  line.y2 = pBall.y
  --
  line.dist = CCD.math.dist(line.x1,line.y1, line.x2,line.y2)
  --
  return  line
end
--

function CCD.getPoints(pBall, pLine, dt)
  local nbPoints = math.floor(pLine.dist / pBall.rayon) + 1
  local points = {}
  for i = 1, nbPoints do
    points[i] = {}
    local p = points[i]
    if i == nbPoints then
      p.x = pLine.x2
      p.y = pLine.y2
      p.rayon = pBall.rayon
    else
      p.x = pBall.x + ( pBall.vx * (pBall.rayon* i))
      p.y = pBall.y + ( pBall.vy * (pBall.rayon* i))
      p.rayon = pBall.rayon
    end
  end
  return points
end
--

function CCD.Ball_vs_Rect(pBall, pRect, dt) -- return (collision = true/false, x, y)
  local line = CCD.getLine(pBall, dt)
  local points = CCD.getPoints(pBall, line, dt)
  local collide =  {collision = false, x = 0, y = 0}
  for i = 1, #points do
    local p = points[i]
    collide = CCD.LineInRect(p.x, p.y, p.rayon,              pRect.x, pRect.y, pRect.w, pRect.h)
    if collide.collision then
      return collide -- True !
    end
  end
  -- 
  return collide -- False !
  --
end
--



return CCD