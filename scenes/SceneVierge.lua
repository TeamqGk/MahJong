local SceneDeTest = {}
---------------------------- START ----------------------------

-- ton code









function SceneDeTest.load() -- love.load()
end
--

function SceneDeTest.update(dt) -- love.load()
end
--

function SceneDeTest.draw()-- love.draw()
  love.graphics.print("SceneDeTest",screen.ox,screen.oy)
end
--

function SceneDeTest.keypressed(key, scancode, isrepeat)
  if key == "return" or key == "space" then
    SceneManager:setScene("SceneGame")
  end
end


---------------------------- END -----------------------------------------
return SceneDeTest
