local SceneOptions = {}
---------------------------- START ----------------------------
local BM = BouttonManager.newBM()
local BM2 = BouttonManager.newBM()
local Boutton = {}
local Boutton2 = {}

local delete = false
SceneOptions.showMessage = false


function Boutton.init()
  BM:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = BM.newBox ()
  Boutton[1]:addText(Font, 22, "Oui")
  Boutton[1]:setPos(screen.w * 0.5 - (Boutton[1].w+10), screen.oy)
  Boutton[1]:setVisible(false)
  Boutton[1]:setAction(function()  SaveMahJongManager.resetSave(); SaveCasseBriqueManager.resetSave() ; love.window.setFullscreen(false) ;SceneOptions.showMessageBox = love.window.showMessageBox("Save have been delete","The game need to restart...")
 ; SceneOptions.showMessage = true end)
  --
  Boutton[2] = BM.newBox ()
  Boutton[2]:addText(Font, 22, "Non")
  Boutton[2]:setPos(screen.w * 0.5 + 10, screen.oy)
  Boutton[2]:setVisible(false)
  Boutton[2]:setAction(function() SceneOptions.delete(false) end)
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
  Boutton2[1]:addText(Font, 22, "Reset Save")
  Boutton2[1]:setAction(function() SceneOptions.delete(true) end)
  --
  Boutton2[2] = BM2.newBox ()
  Boutton2[2]:addText(Font, 22, "Retour Menu")
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

function SceneOptions.delete(pBool)
  if pBool then
    Boutton2[1]:setEffect(false) -- reset save
    Boutton2[2]:setVisible(false) -- Retour Menu
    Boutton[1]:setVisible(true) -- oui
    Boutton[2]:setVisible(true) -- non
  else
    Boutton2[1]:setEffect(true) -- reset save
    Boutton2[2]:setVisible(true) -- Retour Menu
    Boutton[1]:setVisible(false) -- oui
    Boutton[2]:setVisible(false) -- non
  end
end
--

function SceneOptions.load() -- love.load()
  Boutton.init()
  Boutton2.init()
end
--

function SceneOptions.update(dt) -- love.updadte(dt)
  if not SceneOptions.showMessage then
    BM:update(dt)
    BM2:update(dt)
  else
    if SceneOptions.showMessageBox then
      love.event.quit("restart")
    end
  end
end
--

function SceneOptions.draw()-- love.draw()-- love.draw()
  love.graphics.setBackgroundColor(0,0,0,1)
  --
  MenuAnimations.draw()
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
