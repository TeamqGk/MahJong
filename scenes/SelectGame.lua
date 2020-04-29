local SceneSelectGame = {}
---------------------------- START ----------------------------

local BM_Games = BouttonManager.newBM()
local Boutton = {}
local BackGround = ImgManager.new("img/bg_logo.jpg")-- pFile
BackGround:scaleToScreen()



function SceneSelectGame.load() -- love.load()
    BM_Games:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM_Games:setColor(0,1,0,0.15)
  BM_Games:setColorText(0,0,0,0.75)
  BM_Games:setColorMouseOver(0,0,1,0.15)
  BM_Games:setSpace("Y", 55) -- def 30
  BM_Games:setSpace("x", 40) -- def 30
  --
  Boutton[1] = BM_Games.newBox ()
  Boutton[1]:addText(Font, 22, "MahJong")
  Boutton[1]:setAction(function() SceneManager:setScene("MahJong") end)
  --
  Boutton[2] = BM_Games.newBox ()
  Boutton[2]:addText(Font, 22, "Casse Brique")
  Boutton[2]:setAction(function() SceneManager:setScene("CasseBrique") end)
  --
  Boutton[3] = BM_Games.newBox ()
  Boutton[3]:addText(Font, 22, "Retour Menu")
  Boutton[3]:setAction(function()  SceneManager:setScene("MenuIntro") end)
  --
  BM_Games:setPos("Y") -- align alls button to axe Y or X
  --
  BM_Games:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM_Games:setColor(0,1,0,0.15)
  BM_Games:setColorText(0,0,0,0.75)
  BM_Games:setColorMouseOver(0,0,1,0.15)
end
--

function SceneSelectGame.update(dt) -- love.load()
    BM_Games:update(dt)
end
--

function SceneSelectGame.draw()-- love.draw()
  BackGround:draw()
  --
  BM_Games:draw()
end
--

function SceneSelectGame.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    SceneManager:setScene("MenuIntro")
  end
end
--

function SceneSelectGame.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if BM_Games.current.ready then
      BM_Games.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
    end
  end
end
--

---------------------------- END -----------------------------------------
return SceneSelectGame
