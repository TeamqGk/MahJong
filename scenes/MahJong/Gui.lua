local Gui = {}


function Gui.resetSave()
  Gui.init(true)
end
--

function Gui.init(pReset)
  if pReset or not Gui.LoadSave()then
    print("Creation d'un fichier de sauvegarde...")
    Gui.save = {}
    --
    Gui.save.currentLevel = 1
    Gui.save.levelMax = 1
    Gui.save.currentMove = 0
    Gui.save.name = ""
    --
    Gui.save.level = {}
    for i = 1 , #Levels do
      Gui.save.level[i] = {}
      local current = Gui.save.level[i]
      --
      current.currentTime = 0
      current.bestTime = 0
      --
    end
    SaveManager.saveGame(Gui.save, "MahJong")
  else
    --test :
    if debug then
      print(" la table Gui.save contient :")
    for k, v in pairs(Gui.save) do
      print(k.." : "..tostring(v))
    end
    end
  end
end
--

function Gui.LoadSave()
  Gui.save = SaveManager.loadGame("MahJong")
  if not Gui.save then
    Gui.save = {}
    return false
  else
    return true
  end
end
--




function Gui.load()
  Gui.init()
end
--
function Gui.update(dt)
end
--
function Gui.draw()
end
--

return Gui