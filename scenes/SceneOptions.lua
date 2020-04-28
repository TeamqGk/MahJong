local SceneOptions = {}
---------------------------- START ----------------------------
local BM = BouttonManager.newBM()
local BM2 = BouttonManager.newBM()
local Boutton = {}
local Boutton2 = {}
local BackGround = ImgManager.new("img/bg_logo.jpg")-- pFile
BackGround:scaleToScreen()


function Boutton.init()
  BM:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = BM.newBox ()
  Boutton[1]:addText(Font[22], "Oui")
  Boutton[1]:setPos(screen.w * 0.5 - (Boutton[1].w+10), screen.ox)
  Boutton[1]:setVisible(false)
  Boutton[1]:setAction(function()  SaveMahJongManager.resetSave(); love.event.quit("restart") end)
  --
  Boutton[2] = BM.newBox ()
  Boutton[2]:addText(Font[22], "Non")
  Boutton[2]:setPos(screen.w * 0.5 + 10, screen.ox)
  Boutton[2]:setVisible(false)
  Boutton[2]:setAction(function()  Boutton2[1]:setVisible(true) ; Boutton2[2]:setVisible(true) ; Boutton[1]:setVisible(false) ; Boutton[2]:setVisible(false)  end)
  --
end
--

function Boutton2.init()
  BM2:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM2:setColor(0,1,0,0.15)
  BM2:setColorText(0,0,0,0.75)
  BM2:setColorMouseOver(0,0,1,0.15)
  BM2:setSpace("Y", 55) -- def 30
  BM2:setSpace("x", 40) -- def 30
  --
  Boutton2[1] = BM2.newBox ()
  Boutton2[1]:addText(Font[22], "Reset Save")
  Boutton2[1]:setAction(function() Boutton2[1]:setVisible(false) ; Boutton2[2]:setVisible(false) ; Boutton[1]:setVisible(true) ; Boutton[2]:setVisible(true) end)
  --
  Boutton2[2] = BM2.newBox ()
  Boutton2[2]:addText(Font[22], "Retour Menu")
  Boutton2[2]:setAction(function() SceneManager:setScene("MenuIntro") end)

  --
  BM2:setPos("Y") -- align alls button to axe Y or X
  --
  BM2:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM2:setColor(0,1,0,0.15)
  BM2:setColorText(0,0,0,0.75)
  BM2:setColorMouseOver(0,0,1,0.15)
end
--







function SceneOptions.load() -- love.load()
  Boutton.init()
  Boutton2.init()
end
--

function SceneOptions.update(dt) -- love.updadte(dt)
  BM:update(dt)
  BM2:update(dt)
end
--

function SceneOptions.draw()-- love.draw()-- love.draw()
  BackGround:draw()
  --
  BM:draw()
  BM2:draw()
end
--

function SceneOptions.keypressed(key, scancode, isrepeat) -- love.keypressesed()
  if key == "escape" then
    SceneManager:setScene("MenuIntro")
  end
end

function SceneOptions.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if BM.current.ready then
      BM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
    elseif BM2.current.ready then
      BM2.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
    end
  end
end
--
-- etc...

---------------------------- END -----------------------------------------
return SceneOptions
