local SceneManager = {}
SceneManager.scenes = {}
SceneManager.current = nil

function SceneManager:addScene(module, name, pSetActiveScene)
  local newScene = {}
  newScene.name = name
  newScene.module = module
  table.insert(self.scenes, newScene)
  if pSetActiveScene == true then
    self.current = self.scenes[#self.scenes]
  end
end
--

function SceneManager:setScene(name)
  for i = 1, #self.scenes do
    if name == self.scenes[i].name then
      self.current = self.scenes[i]
      if not self.current.module.loadScene then
        SceneManager:load()
      end
      return
    end
  end

  print("ereur, la scene "..name.." n'existe pas !")
end
--

function SceneManager:load()
  if not self.current then
  else
    if self.current.module.load ~= nil then
      if not self.current.module.loadScene then
        self.current.module.loadScene = true
        self.current.module.load()
      end
    end
  end
  --
end
--

function SceneManager:update(dt)
  --
  if not self.current then
  else
    if self.current.module.update ~= nil then
      self.current.module.update(dt)
    end
  end
  --
end
--

function SceneManager:draw()
  --
  if not self.current then
  else
    if self.current.module.draw ~= nil then
      self.current.module.draw()
    end
  end
  --
end
--

function SceneManager:keypressed(key, scancode)
  if not self.current then
  else
    if self.current.module.keypressed ~= nil then
      self.current.module.keypressed(key, scancode)
    end
  end
end
--

function SceneManager:keyreleased(key, scancode)
  if not self.current then
  else
    if self.current.module.keyreleased ~= nil then
      self.current.module.keyreleased(key, scancode)
    end
  end
end
--

function SceneManager:mousepressed(x, y, button, isTouch)
  if not self.current then
  else
    if self.current.module.mousepressed ~= nil then
      self.current.module.mousepressed(x,y,button)
    end
  end
end
--

function SceneManager:mousereleased(x, y, button, isTouch)
  if not self.current then
  else
    if self.current.module.mousereleased ~= nil then
      self.current.module.mousereleased(x,y,button)
    end
  end
end
--


return SceneManager
