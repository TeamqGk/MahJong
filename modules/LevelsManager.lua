local LevelsManager = {}

-- gestion of folder and files of levels
local pFolder = "scenes/MahJong/levels"
local filesTable = love.filesystem.getDirectoryItems(pFolder)

function LevelsManager.autoload()
  --
  Levels = {}
  --
  local i = 0
  for k,file in ipairs(filesTable) do
--    print("le dossier module contient l'element n°"..k.." : "..file)
    if string.find(file,".lua") then
      i = i + 1
      --
      local level = {}
      level.name = string.gsub(file,".lua","")
      level.file = pFolder.."/"..tostring(level.name)
      --
      Levels[i] = require(level.file)
      Levels[i].name = level.name
      Levels[i].file = level.file
      Levels[i].level = i
      Levels[i].load = false
      --
    end
  end

  if debug then print("Alls Levels is Loads ! find "..#Levels.." levels.".." i="..i) end
end
--

function LevelsManager.reset(pLevel)
  if debug then print("pLevel ["..pLevel.."] à été trouvé et le level à été chargé ? "..tostring(Levels[pLevel].load)) end
  --
  local backup = {}
  backup.name = Levels[pLevel].name
  backup.file = Levels[pLevel].file
  --
  Levels[pLevel] = {}
  local reload = love.filesystem.load(backup.file..".lua")
  Levels[pLevel] = reload()
  --
  Levels[pLevel].name =  backup.name
  Levels[pLevel].file =  backup.file
  Levels[pLevel].level = pLevel
  --
  if debug then print(Levels[pLevel].file..", have been clear ? ") if Levels[pLevel].load == false then print("Yes, Level is Reset ! car le level est chargé ? "..tostring(Levels[pLevel].load)) else print(" erreur !") end end
  --
  --
end
--

return LevelsManager