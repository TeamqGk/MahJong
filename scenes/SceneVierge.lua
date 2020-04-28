local SceneDeTest = {}
---------------------------- START ----------------------------

-- ton code









function SceneDeTest.load() -- love.load()
end
--

function SceneDeTest.update(dt) -- love.updadte(dt)
end
--

function SceneDeTest.draw()-- love.draw()-- love.draw()
  love.graphics.print("SceneDeTest",screen.ox,screen.oy)
end
--

function SceneDeTest.keypressed(key, scancode, isrepeat) -- love.keypressesed()
  if key == "escape" then
    SceneManager:setScene("MenuIntro")
  end
end
-- etc...

---------------------------- END -----------------------------------------
return SceneDeTest
