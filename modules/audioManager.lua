local audioManager = {}

function audioManager.newAM()
  local f = {}
  --  
  f.volume = {}
  f.volume.master = 0
  love.audio.setVolume( f.volume.master )
  f.volume.speed = 1
  f.volume.up = false
  f.volume.down = false
  f.volume.gain = 5
  --
  f.audio = {}
  f.audio.master = 0.6
  --
  f.music = {}
  f.music.current = false
  --
  f.sound = {}
  f.sound.current = false
  --

  function f:addMusic(pFile, pLoop, pVolume, pPlay)
    local new = {}
    new.source = love.audio.newSource(pFile, "stream")
    new.source:setLooping(pLoop)
    new.volume = {}
    new.volume.set = pVolume
    new.volume.actual = 0
    new.volume.speed = 1
    new.source:setVolume(new.volume.actual)
    table.insert(self.music, new)
    if pPlay then new.source:play() end
    return new.source
  end
  --

  function f:addSound(pFile, pLoop, pVolume)
    local new = {}
    new.source = love.audio.newSource(pFile, "static")
    new.source:setLooping(pLoop)
    new.source:setVolume(pVolume)
    table.insert(self.sound, new)
    return new.source
  end
  --

  function f:setVolume(pVolume)
    if type(pVolume) == "number" then
      if pVolume >= 0 and pVolume <= 1 then
        self.audio.master = pVolume
        return
      end
    end
    print("error, you need use audioManager:setVolume( 0 to 1) // example : 0 = 0 %; 0.5 = 50 %; 1 = 100 %")
  end
  --

  function f:update(dt)
    -- MASTER VOLUME
    if self.volume.up or self.volume.down then
      local gain = 0
      if self.volume.up then gain = self.volume.master + self.volume.gain elseif self.volume.down then gain = self.volume.master - self.volume.gain end
      if gain >= 0 and gain <= 1 then   self.volume.master = gain end
    end
    --
    if self.volume.master <= self.audio.master then
      self.volume.master = self.volume.master + (self.volume.speed * dt)
    elseif self.volume.master >= self.audio.master then
      self.volume.master = self.audio.master
    end
    love.audio.setVolume(self.volume.master)
    --
    --VOLUME MUSIC TRANSITION
    for i=1, #self.music do
      local vol = self.music[i].volume
      local source = self.music[i].source
      if vol.actual <= vol.set then
        vol.actual= vol.actual + (vol.speed * dt)
      elseif vol.actual <= vol.set then
        vol.actual = vol.set
      end
      source:setVolume(vol.actual)
    end
  end
  --

  return f
end
--
return audioManager