local SaveManager = {}

function SaveManager.saveGame(pDataTable)
  -- add/update a date on this save, for player see the date of save list
  pDataTable.saveDate = os.date()
  -- convertir la table en string --
  local dataString = lume.serialize(pDataTable)
  -- encrypte le string --
  local encryptDataString = love.data.encode( "string", "base64", dataString ,150)

  -- ecriture du fichier --
  love.filesystem.write("save.sav", encryptDataString)
end
--
function SaveManager.loadGame()
  print("On test le fichier save.sav :")
  if  love.filesystem.getInfo("save.sav") then
    print("fichier présent !")
    local dataFile = love.filesystem.read("save.sav")
    local decrypt = love.data.decode( "string", "base64", dataFile)
    local save = lume.deserialize(decrypt)
    return save -- et le renvoi !
  else
    print("fichier inexistant !")
    return false
  end
end
--

-- Extract Table to .CFG readeable
function SaveManager.saveCfg(pDataTable)
  table.save(pDataTable,"config.cfg")
end
--
function SaveManager.loadCfg(pFilePath)
  local loadcfg = table.load("config.cfg") --
  return loadcfg
end
--


return SaveManager