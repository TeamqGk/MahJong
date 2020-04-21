local SceneGame = {}
----------------------------- START -----------------------------------------
-- Declare Global Tables of Game
Levels = {}
Grid = {}
Img = {}
MahJong = {}
--


-- Images
Img.MahJong = ImgManager.new("img/mahjong_pieces_modif_1.png")-- pFile
--[[ return :
img.img
img.w
img.h
]]--

-- Quads Images
Img.MahJong.quad = QuadManager.new(Img.MahJong,3,16)--ImageTable, Plig, pCol
-- quad 1 to 37 Mahjong
-- and quads 38 & 39 Effects styles...
-- sets parametres of MahJong (look image of quads for help)
MahJong.total = 37
MahJong.vide = 38
MahJong.videmini = 39




function SceneGame.load() -- love.load()
  screen.update(dt)
  --
  LevelsManager.autoload()
  --
  GridManager.setGrid(1)
end
--

function SceneGame.draw()-- love.draw()
  love.graphics.scale(screen.sx, screen.sy)
  GridManager.draw()
end
--

function SceneGame:keypressed(key, scancode)
  if debug then
    if key == "kp+" or key == "kp-" then
      local level = Grid.level
      if key == "kp+" then
        level = level + 1
      elseif key == "kp-" then
                level = level - 1
    end
    --
    if level > #Levels then level = 1 elseif level < 1 then level = #Levels end
    --
    GridManager.setGrid(level)
    end
  end
  if key == "escape" then
    SceneManager:setScene("SceneLogo")
  end
end
--


---------------------------- END -----------------------------------------
return SceneGame
