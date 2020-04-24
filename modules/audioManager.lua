local audioManager = {}
local audio = {}
local music = {}
local sound = {}
local volume = {}


function audioManager.init()
  volume = {}
  volume.master = 0
  love.audio.setVolume( volume.master )
  volume.speed = 1
  volume.up = false
  volume.down = false
  volume.gain = 5
  --
  audio = {}
  audio.master = 0.6
  --
  music = {}
  music.current = false
  sound = {}
  sound.current = false
  --
end
--

function audioManager.addMusic(pFile, pLoop, pVolume, pPlay)
  local new = {}
  new.source = love.audio.newSource(pFile, "stream")
  new.source:setLooping(pLoop)
  new.volume = {}
  new.volume.set = pVolume
  new.volume.actual = 0
  new.volume.speed = 1
  new.source:setVolume(new.volume.actual)
  table.insert(music, new)
  if pPlay then new.source:play() end
end
--

function audioManager.addSound(pFile, pLoop, pVolume)
  local new = {}
  new.source = love.audio.newSource(pFile, "stream")
  new.source:setLooping(pLoop)
  new.source:setVolume(pVolume)
  table.insert(sound, new)
  return new.source
end
--

function audioManager.setVolume(pVolume)
  if type(pVolume) == "number" then
    if pVolume >= 0 and pVolume <= 1 then
      audio.master = pVolume
      return
    end
  end
  print("error, you need use cl.audioManager.setVolume( 0 to 1) // example : 0 = 0 %; 0.5 = 50 %; 1 = 100 %")
end
--

function audioManager.update(dt)
  -- MASTER VOLUME
  if volume.up or volume.down then
    local gain = 0
    if volume.up then gain = volume.master + volume.gain elseif volume.down then gain = volume.master - volume.gain end
    if gain >= 0 and gain <= 1 then   volume.master = gain end
  end
  --
  if volume.master <= audio.master then
    volume.master = volume.master + (volume.speed * dt)
  elseif volume.master >= audio.master then
    volume.master = audio.master
  end
  love.audio.setVolume(volume.master)


  --VOLUME MUSIC TRANSITION
  for i=1, #music do
    local vol = music[i].volume
    local source = music[i].source
    if vol.actual <= vol.set then
      vol.actual= vol.actual + (vol.speed * dt)
    elseif vol.actual <= vol.set then
      vol.actual = vol.set
    end
    source:setVolume(vol.actual)
  end
end
--

function audioManager.draw()
  cl.resetColor()
  --
  cl.resetColor()
end
--

--
audioManager.init()
--
return audioManager