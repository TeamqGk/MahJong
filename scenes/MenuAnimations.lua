local MenuAnimations = {}
local lg = love.graphics
local BackGround = ImgManager.new("img/bg_logo.jpg")-- pFile
BackGround:scaleToScreen()

local ButterFlySpritSheet = ImgManager.new("img/Blue_Butterfly_Animation/SpriteSheet.png")
local ButterFlyQuad = QuadManager.new(ButterFlySpritSheet, 1, 15)
local ButterFly = {}
love.math.setRandomSeed(love.timer.getTime())
print(screen.w,screen.h)
for i = 1, 5 do
  ButterFly[i]  = AnimManager.new(ButterFlySpritSheet, ButterFlyQuad, 25)
  local fly = ButterFly[i]
  --
  local x = love.math.random(100 , screen.w - 100 )
  local y = love.math.random( 100 , screen.h - 100 )
  print(i, x, y)
  fly:setPos( x, y) -- setPos(x,y)
  --
  local scale = love.math.random(0.5,1)
  fly:setSizes( fly.w * scale, fly.h * scale) --setSizes(w,h)
  --
  local color = {1, 1, 1, 0.8}
  local colorRand = 0
  colorRand = love.math.random(1,3)
  local colorChange = 0
  colorChange = love.math.random(0,1)
  color[colorRand] = colorChange
  fly:setColor(color)
  --
  fly.vx = 0
  fly.vy = 0
  fly.speed = love.math.random(20,30)
  fly.start = 0
  fly.finish = love.math.random(30,120)
  --
end
--

function MenuAnimations.moveButterFly(dt)
  for i = 1, #ButterFly do
    ButterFly[i]:update(dt) -- update Anim
    local fly = ButterFly[i]
    fly.start = fly.start + fly.speed * dt
    if fly.start >= fly.finish then
      fly.start = 0 -- reset timer
      fly.finish = love.math.random(30,120) -- rand timer for aleat direction
      --
      local angle = love.math.random(0,6) -- changement de direction
      fly.vx = math.cos(angle)
      fly.vy = math.sin(angle)
    end
    -- move
    fly.x = fly.x + (fly.vx * fly.timer.speed * dt)
    fly.y = fly.y + (fly.vy * fly.timer.speed * dt)
  end
end
--

function MenuAnimations.drawButterFly()
  for i = 1, #ButterFly do
    ButterFly[i]:draw()
  end
end
--


function MenuAnimations.update(dt) -- love.load()
  MenuAnimations.moveButterFly(dt)
end
--

function MenuAnimations.draw()-- love.draw()
  lg.setBackgroundColor(0,0,0,1)
  --
  BackGround:draw()
  --
  MenuAnimations.drawButterFly()
  --
  lg.setBackgroundColor(1,1,1,1)
end
--

---------------------------- END -----------------------------------------
return MenuAnimations
