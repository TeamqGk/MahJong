local  SaveCasseBriqueManager = {}

--
function SaveCasseBriqueManager.resetSave()
  SaveCasseBriqueManager.init(true)
end
--

--
function SaveCasseBriqueManager.save()
  SaveManager.saveGame("SaveCasseBrique", SaveCasseBrique)
end
--

--
--function SaveCasseBrique.changeList()
--  --
--  local function updateList(pStart)
--    for i = 10, pStart , -1 do
--      local backup = SaveCasseBrique[i+1]
--      local new = SaveCasseBrique[i]
--      --
--      for k , v in pairs(backup) do
--        new[k] = v
--      end
--      --
--    end
--  end
--  --
--  for i = 1, 10 do
--    if SaveCasseBrique.BestScore >= SaveCasseBrique[i].BestScore then
--      updateList(i)
--      return true
--    end
--  end
--  --
--end
----

--
function SaveCasseBriqueManager.init(pReset)
  if pReset or not SaveCasseBriqueManager.LoadSave()then
    print("Creation d'un fichier de sauvegarde SaveCasseBrique.sav...")
    --
    SaveCasseBrique = {}
    --
    for i = 1 , 10 do
      SaveCasseBrique[i] = {}
      SaveCasseBrique[i].BestScore = " - - - "
      SaveCasseBrique[i].Date = "-- / -- / --"
      SaveCasseBrique[i].Level = "--"
    end
    SaveManager.saveGame("SaveCasseBrique", SaveCasseBrique)
    print("save crée.")
  end
end
--

--
function SaveCasseBriqueManager.LoadSave()
  SaveCasseBrique = SaveManager.loadGame("SaveCasseBrique")
  if not SaveCasseBrique then
    SaveCasseBrique = {}
    return false
  else
    for i = 1 , 10 do
      if not SaveCasseBrique[i] then
        SaveCasseBrique[i] = {}
        SaveCasseBrique[i].BestScore = " - - - "
        SaveCasseBrique[i].Date = "-- / -- / --"
        SaveCasseBrique[i].Level = "--"
      end
    end
    return true
  end
end
--

--
function SaveCasseBriqueManager.load()
  SaveCasseBriqueManager.init()
end
--
function SaveCasseBriqueManager.update(dt)
end
--
function SaveCasseBriqueManager.draw()
end
--

return SaveCasseBriqueManager