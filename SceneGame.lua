local SceneGame = {}
----------------------------- START -----------------------------------------

local GridManager = {}

local Grid = {}


function GridManager.setGrid(pMap)
  Grid = require(pMap) -- map
  --
  local x = 0
  local y = 0
  local caseW = love.graphics.getWidth() / Grid.colonnes
  local caseH = love.graphics.getHeight() / Grid.lignes
  local caseOx = caseW * 0.5
  local caseOy = caseH * 0.5
  --
  for etages = 1, Grid.etages do-- etage
    for lignes = 1,  Grid.lignes do-- lignes
      for colonnes = 1, Grid.colonnes do-- colonnes
        local mahjong = Grid[etages][lignes][colonnes]
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
        case.w = caseW
        case.h = caseH
        case.ox = x + caseOx
        case.oy = y + caseOy

        -- incrementation de x + la largeur d'une case (w)
        x = x + caseW
      end
      --
      x = 0
      y = y + caseH
      --
    end
    --
    x = 0
    y = 0
    --
  end

  print (#Grid, #Grid[1], #Grid[1][1])
end


local indexTest = 0

function GridManager.draw()
  love.graphics.setColor(1,1,1,1)
  --
  local indexTotal = Grid.etages * (Grid.lignes * Grid.colonnes)
  --
  for etages = 1, #Grid do-- etages
    for lignes = 1,  #Grid[1] do-- lignes
      for colonnes = 1, #Grid[1][1] do-- colonnes
        --
        local case = Grid[etages][lignes][colonnes] -- table
        love.graphics.setColor(1,1,1,1) -- reset color

        local debug = false

        -- draw chaque etage d'une douleur diff pour le debug
        if case.type == 1 then
          love.graphics.setColor(0,1,0,1)
          debug = 1
        elseif case.type == 2 then
          love.graphics.setColor(1,0,0,1)
          debug = 2
        elseif case.type == 3 then
          love.graphics.setColor(0,0,1,1)
          debug = 3
        elseif case.type == 4 then
          love.graphics.setColor(1,1,0,1)
          debug = 4
        end
        --
        if case.type >= 1 then
          love.graphics.rectangle("fill", case.x+2, case.y+2, case.w-3, case.h-3)
        end

        --
        love.graphics.setColor(1,0,1,1)

        --love.graphics.print("l:"..lignes.."\n".."c:"..colonnes, case.ox, case.oy)

        if debug then
          if indexTest <= indexTotal then
            indexTest = indexTest + 1
            print(etages , lignes, colonnes, debug)
          end
          love.graphics.print(debug, case.ox, case.oy)
        end

        love.graphics.setColor(1,1,1,1) -- reset color
      end
    end
  end

  --
  love.graphics.setColor(1,1,1,1)
end


function SceneGame.load() -- love.load()
  GridManager.setGrid("level_1")
end
--

function SceneGame.draw()-- love.draw()
  GridManager.draw()
end
--


---------------------------- END -----------------------------------------
return SceneGame
