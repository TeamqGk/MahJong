local SceneGame = {}
----------------------------- START -----------------------------------------
local GridManager = {}
local Grid = {}
local Img = {}

local MergeMeOrNot = {}

-- requires
local QuadManager = require("QuadManager") -- lua file
local ImgManager = require("ImgManager") -- lua file

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
local MahJong = {}
MahJong.total = 37
MahJong.vide = 38
MahJong.videmini = 39

function GridManager.setRandMahjong()
  -- initalisation d'un nouveau math.randomseed
  globals.math.newRandom() --love.math.setRandomSeed(love.timer.getTime()) -- set Random Seed !

  -- Verifier que le nombre de MahJong ne soit pas impaire sinon deux solutions :
  -- 1. on place un mahjong au piff et on reduit notre total de mahjong a placer de 1
  -- 2. on en supprime un au piff dans le tableau...

  -- il faut ques les [Col and Lig] soient differentes sinon impossible a finir (non identique)

  -- on scan les grilles :
  for etages = 1, Grid.etages do-- etage
    for lignes = 1,  Grid.lignes do-- lignes
      for colonnes = 1, Grid.colonnes do-- colonnes
        local case = Grid[etages][lignes][colonnes]
        --
        if case.type >= 1 then -- map valeur
          if not case.mahjong then -- y a t'il deja un mahjong de placé ?
            -- selection d'un MahJong pour la case
            local rand = 32
            while rand  == 32 do
              rand = love.math.random(1,MahJong.total) -- on selectione un mahjong au hasard
            end
            --
            case.mahjong = rand -- on attribue le MahJong a cette case
            --
            local loop = true
            while not loop do
              local l = love.math.random(1,Grid.lignes)
              local c = love.math.random(1,Grid.colonnes)
              local e = love.math.random(1,Grid.etages)
              --
              local caseTest = Grid[e][l][c]
              --
              if caseTest.type >= 1 then
                if not case.mahjong then
                  caseTest.mahjong = rand
                  loop = false
                end
              end
              --
            end
          end
        end
      end
    end
  end
end

function GridManager.test(pCode)
  print("test")
end

function GridManager.setGrid(pMap)
  Grid = require(pMap)
  --[[ return :
  Grid.etages, Grid.lignes, Grid.colonnes
  & all etages Tables
  ]]--

  Grid.w = Grid.colonnes * Img.MahJong.quad.w
  Grid.h = Grid.lignes * Img.MahJong.quad.h
  print("w,h : ",w,h)
  print("quad.w,quad.h : ",Img.MahJong.quad.w,Img.MahJong.quad.h)
  --
  local StartX = (screen.w - Grid.w) * 0.5
  local StartY = (screen.h - Grid.h) * 0.5
  --
  Grid.x = StartX
  Grid.y = StartY
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
        -- on creer un MahJong si il y a un nombre !
        local backup
        if  type(case) == "number"  then
          backup = etages
        else
          backup = 0
        end
        --
        Grid[etages][lignes][colonnes] = {}
        case = Grid[etages][lignes][colonnes]
        case.type = backup
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
  print ("\n".."Nouvelle Grid of "..#Grid.." etages, "..#Grid[1].." lines and "..#Grid[1][1].." cols !".."\n")

  -- randomise mahjong in grid
  GridManager.setRandMahjong()
end


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
          love.graphics.draw(Img.MahJong.img, Img.MahJong.quad[case.mahjong], case.x, case.y)--, 0, 1, 1, case.ox, case.oy)

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
