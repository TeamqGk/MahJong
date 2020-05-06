local AnimManager = {}

function AnimManager.new(pImage, pTableQuad,pSpeed)
  local new = {}
  --
  for k, v in pairs(pImage) do
    new[k] = v
  end
  for i=1, #pTableQuad do
    new[i] = pTableQuad[i]
  end
  --
  if not pSpeed then pSpeed = 60 end
  new.current = 1
  new.maxFrames = #pTableQuad
  new.timer = {}
  new.timer.start = 1
  new.timer.finish = 60
  new.timer.speed = pSpeed
  --
  function new:update(dt)
    local t = new.timer
    t.start = t.start + t.speed * dt
    if t.start >= new.maxFrames then
      t.start = 1
    end
    new.current = math.floor(t.start)
  end
  --
  function new:draw()
    love.graphics.setColor(self.color)
    --
    love.graphics.draw(new.img, new[new.current], self.x, self.y, 0, self.sx, self.sy)
    --
    love.graphics.setColor(1,1,1,1)
  end
  return new
end
--

return AnimManager