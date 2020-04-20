local SceneGame = {}
----------------------------- START -----------------------------------------
local GridManager = {}
local Grid = {}

-- requires
local QuadManager = require("QuadManager")

-- Images
local Img = {}
Img.MahJong = {}
Img.MahJong.file = "img/mahjong_pieces_modif_1.png"
Img.MahJong.img = love.graphics.newImage(Img.MahJong.file)

-- Quads Images
Img.MahJong.quad = QuadManager.new(Img.MahJong,3,16)--ImageTable, Plig, pCol



function GridManager.setGrid(pMap)
  Grid = require(pMap) -- map
  --
  local StartX = screen.w * 0.1
  local StartY = screen.h * 0.1
  --
  Grid.x = StartX
  Grid.y = StartY
  Grid.w = screen.w - (StartX * 2)
  Grid.h = screen.h - (StartY * 2)
  Grid.caseW = Grid.w / Grid.colonnes
  Grid.caseH = Grid.h / Grid.lignes
  Grid.caseOx = Grid.caseW * 0.5
  Grid.caseOy = Grid.caseH * 0.5
  --
  local x = StartX
  local y = StartY
  --
  for etages = 1, Grid.etages do-- etage
    for lignes = 1,  Grid.lignes do-- lignes
      for colonnes = 1, Grid.colonnes do-- colonnes
        local case = Grid[etages][lignes][colonnes]
        local mahjong = 0
        -- on creer un MahJong si il y a un nombre !
        if  type(case) == "number"  then
          mahjong = case
        end
        --
        Grid[etages][lignes][colonnes] = {}
        case = Grid[etages][lignes][colonnes]
        case.type = mahjong
        case.etages = etages
        case.lignes = lignes
        case.colonnes = colonnes
        case.x = x
        case.y = y
        case.w = Grid.caseW
        case.h = Grid.caseH
        case.ox = x + Grid.caseOx
        case.oy = y + Grid.caseOy

        -- incrementation de x + la largeur d'une case (w)
        x = x + Grid.caseW
      end
      --
      x = StartX
      y = y + Grid.caseH
      --
    end
    --
    x = StartX
    y = StartY
    --
  end

  print (#Grid, #Grid[1], #Grid[1][1])
end


local indexTest = 0

function GridManager.draw()
  love.graphics.setColor(1,1,1,1) -- reset color
  --
  local indexTotal = Grid.etages * (Grid.lignes * Grid.colonnes)
  --
  for etages = 1, #Grid do-- etages
    for lignes = 1,  #Grid[1] do-- lignes
      for colonnes = 1, #Grid[1][1] do-- colonnes
        --
        local case = Grid[etages][lignes][colonnes] -- table
        love.graphics.setColor(1,1,1,1) -- reset color

        -- draw chaque etage d'une douleur diff pour le debug
        local colorRect = {}
        if case.type == 1 then
          colorRect = {0,1,0,0.25}--vert
        elseif case.type == 2 then
          colorRect = {1,0,0,0.25}--rouge
        elseif case.type == 3 then
          colorRect = {0,0,1,0.25}--bleu
        elseif case.type == 4 then
          colorRect = {1,1,0,0.25}--jaune (r+g)
        end

        --
        if case.type >= 1 then
          -- draw Mahjong Test
          -- TODO: Set Scales for Quads MahJong
          love.graphics.draw(Img.MahJong.img, Img.MahJong.quad[case.type], case.x, case.y)--, 0, 1, 1, case.ox, case.oy)

          -- draw Rect represent Grid Pos, color represent etage
          love.graphics.setColor(colorRect)
          love.graphics.rectangle("fill", case.x+2, case.y+2, case.w-3, case.h-3)
        end

        -- reset color
        love.graphics.setColor(1,1,1,1) -- reset color
      end
    end
  end

  --reset color
  love.graphics.setColor(1,1,1,1)
end


function SceneGame.load() -- love.load()
  screen.update(dt)
  GridManager.setGrid("level_1")
end
--

function SceneGame.draw()-- love.draw()
  love.graphics.scale(screen.sx, screen.sy)
  GridManager.draw()
end
--


---------------------------- END -----------------------------------------
return SceneGame
