local LevelsManager = {}

function LevelsManager.autoload()
  local pFolder = "levels"
  --
  Levels = {}
  --
  local filesTable = love.filesystem.getDirectoryItems("levels")
  --
  local i = 1
  for k,file in ipairs(filesTable) do
--    print("le dossier module contient l'element n°"..k.." : "..file)
    if string.find(file,".lua") then
      --
      local level = {}
      level.name = string.gsub(file,".lua","")
      level.file = pFolder.."/"..tostring(level.name)
      --
      Levels[i] = require(level.file)
      --
      i = i + 1
    else
    end
  end
end
--



return LevelsManager