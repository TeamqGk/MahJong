local SaveManager = {}

local SaveGame = {}
--
function SaveManager.load(pNumber)
  --
  local folder = "Saves/"
  local filename = "save.sav"
  --
  local path = folder..filename
  local f = {}

  if love.filesystem.getInfo( path, "file" ) then
    print("not save game find.")
  else
    f.load = love.filesystem.load(path)
    f.load()
  end

--  love.filesystem.read(filename)
--  love.filesystem.write(filename,data)
end
--

function SaveManager.save(pNumber)
  --
  if not SaveGame[pNumber] then
    SaveGame[pNumber]= {}
  end
  --
end
--



function SaveManager.new()
  local f = {}

  function f.init()
    SaveGame.levelMax = 0
    SaveGame.levelCurrent = 0
    SaveGame.tutorial = false
  end
--
  return f
end
--


return SaveManager