local  SaveMahJongManager = {}

function SaveMahJongManager.resetSave()
  SaveMahJongManager.init(true)
end
--

function SaveMahJongManager.init(pReset)
  if pReset or not SaveMahJongManager.LoadSave()then
    print("Creation d'un fichier de sauvegarde SaveMahJong.sav...")
    SaveMahJong  = {}
    --
    SaveMahJong.currentLevel = 1
    SaveMahJong.levelMax = 1
    --
    SaveMahJong.level = {}
    --
    if not Levels[1] then
      LevelsManager.autoload()
    end
    --
    for i = 1 , #Levels do
      SaveMahJong.level[i] = {}
      SaveMahJong.level[i].currentTime = 0
      SaveMahJong.level[i].currentTimeText = ""
      SaveMahJong.level[i].bestTime = 0
      SaveMahJong.level[i].bestTimeText = "level not clear"
    end
    SaveManager.saveGame("SaveMahJong", SaveMahJong)
    print("save crée.")
  end
end
--

function SaveMahJongManager.LoadSave()
  SaveMahJong = SaveManager.loadGame("SaveMahJong")
  if not SaveMahJong then
    SaveMahJong = {}
    return false
  else
    for i = 1 , #Levels do
      if not SaveMahJong.level[i] then
        SaveMahJong.level[i] = {}
        SaveMahJong.level[i].currentTime = 0
        SaveMahJong.level[i].bestTime = 0
      end
    end
    return true
  end
end
--




function SaveMahJongManager.load()
  SaveMahJongManager.init()
end
--
function SaveMahJongManager.update(dt)
end
--
function SaveMahJongManager.draw()
end
--

return SaveMahJongManager