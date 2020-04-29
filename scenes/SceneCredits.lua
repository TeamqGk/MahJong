local SceneCredits = {}

local BM = BouttonManager.newBM()
local Boutton = {}
local BackGround = ImgManager.new("img/bg_logo.jpg")-- pFile
BackGround:scaleToScreen()


local loop = 0
function SceneCredits.load() -- love.load()
  BM:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
  BM:setSpace("Y", 55) -- def 30
  BM:setSpace("x", 40) -- def 30
  --
  Boutton[1] = BM.newBox ()
  Boutton[1]:addText(Font, 22, "CryptoLogiq.itch.io")
  Boutton[1]:setAction(function() love.system.openURL("https://cryptologiq.itch.io/") end)
  --
  Boutton[2] = BM.newBox ()
  Boutton[2]:addText(Font, 22, "qgkMask.itch.io")
  Boutton[2]:setAction(function() love.system.openURL("https://itch.io/profile/qgkmask") end)
  --
  Boutton[3] = BM.newBox ()
  Boutton[3]:addText(Font, 22, "Hydrogene.itch.io")
  Boutton[3]:setAction(function() love.system.openURL("https://hydrogene.itch.io/") end)
  --
  Boutton[4] = BM.newBox ()
  Boutton[4]:addText(Font, 22, "GitHub project")
  Boutton[4]:setAction(function() love.system.openURL("https://github.com/TeamqGk/MahJong") end) -- go to webpage of Github project
  --
  Boutton[5] = BM.newBox ()
  Boutton[5]:addText(Font, 22, "Retour Menu")
  Boutton[5]:setAction(function() SceneManager:setScene("MenuIntro") end)
  --
  BM:setPos("Y") -- align alls button to axe Y or X
  --
  BM:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
end
--

function SceneCredits.update(dt) -- love.load()
  BM:update(dt)
end
--

function SceneCredits.draw()-- love.draw()
  BackGround:draw()
  --
  BM:draw()
end
--

function SceneCredits.keypressed(key, scancode, isrepeat)
  if debug then
    if key == "kp+" then
      BM:setPos("Y")
    elseif key == "kp-" then      
      BM:setPos("X")
    end
  end
  if key == "escape" then
    --SceneManager:setScene("") --> TODO: go to old scene (implement this)
  end
end
--

function SceneCredits.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if BM.current.ready then
      BM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
    end
  end
end
--

---------------------------- END -----------------------------------------
return SceneCredits
