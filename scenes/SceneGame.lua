local SceneGame = {}
----------------------------- START -----------------------------------------
-- Declare Global Tables of Game
Grid = {}
Img = {}
MahJong = {}


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



function Img.switch()

end
--


function SceneGame.load() -- love.load()
  screen.update(dt)
  GridManager.setGrid(0)
end
--

function SceneGame.draw()-- love.draw()
  love.graphics.scale(screen.sx, screen.sy)
  GridManager.draw()
end
--


---------------------------- END -----------------------------------------
return SceneGame
