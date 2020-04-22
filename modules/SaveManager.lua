local SaveManager = {}

local SaveGame = {}
--
function SaveManager.newSave(pDataTable)
  SaveGame = pDataTable
end
--

function SaveManager.loadGame(pNumber)
  --
  local path = "save/"..pNumber.."/".."mahjong.sav"
  local file -- the datas of file (encrypted string)
  local decode -- decrypte file to readable string
  local data -- transform an decrypte file to readable string
  --
  if love.filesystem.getInfo( path, "file" ) then
    file = love.filesystem.read(path)
    decode = love.data.decode( "string", "base64", file)
    data = lume.deserialize(decode)
  else
    print("not save find.")
    return false
  end
  --
  SaveGame = data

end
--

function SaveManager.saveGame(pDataTable,pNumber)
  --
  local data -- is a data read by memories
  local save -- the datas transform to string (not crypted)
  local encoded -- encrpyt save to string not readable
  --
  data = pDataTable
  data.saveDate = os.date() -- add a date for player see the date of save
  --
  save = lume.serialize(data)
  --
  encoded = love.data.encode( "string", "base64", save, 150)
  --
  love.filesystem.write("save/"..pNumber.."/".."mahjong.sav", encoded)
end
--

function SaveManager.saveCfg(pDataTable)
  --
  local data = pDataTable
  data.saveDate = os.date() -- add a date for player see the date of save
  --
  local saveCfg = json.encode(data)
  --
  love.filesystem.write("config.json", saveCfg)
  --
end
--

function SaveManager.loadCfg(Path)
  --
  local file = Path
  --
  local data = love.filesystem.read("config.json", file)
  --
  local loadcfg = json.decode(file)
  --
  return loadcfg
end
--

return SaveManager