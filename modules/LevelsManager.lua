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
      --
    end
  end

  if debug then print("Alls Levels is Loads ! find "..#Levels.." levels.".." i="..i) end
end
--

function LevelsManager.reset(pLevel)
  --
  for i = 1, #Levels do
    local reset = Levels[i]
    --
    if reset.level == pLevel then
      if debug then print("pLevel ["..pLevel.."] à été trouvé") end
      --
      local backup = {}
      backup.name = reset.name
      backup.file = reset.file
      --
      reset = {}
      local reload = love.filesystem.load(backup.file..".lua")
      reset = reload()
      --
      reset.name =  backup.name
      reset.file =  backup.file
      --
      if debug then print(reset.file..", reset ? ") if reset.load == false then print("Yes, Level is Reset !") else print(" erreur !") end end
      --
      break
    end
    --
  end
end
--

return LevelsManager