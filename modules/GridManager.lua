local GridManager = {}

function GridManager.resetLevel(pLevel)
  GridManager.setGrid(pLevel, true)  
end
--

function GridManager.setGrid(pLevel, pReset)
  Grid = {}
  Grid = Levels[pLevel]
  if pReset == true then
    LevelsManager.reset(pLevel)
  end
  if debug then print("Grid.load : "..tostring(Grid.load)) end

--

  --[[ return :
  Grid.etages, Grid.lignes, Grid.colonnes
  & all etages Tables
  ]]--

  -- level actuel ?
  Grid.level = pLevel

  --
  Grid.name = "Level : "..pLevel

  -- Load image BackGround ( info is on map level_x.lua)
  Img.BG = ImgManager.new("scenes/MahJong/levels/img/"..Grid.image)-- pFile
  Img.BG:scaleToScreen()



  -- Settings of grid
  Grid.w = Grid.colonnes * Img.MahJong.quad.w
  Grid.h = Grid.lignes * Img.MahJong.quad.h
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
  Grid.mahjongTotal = 0
  --
  for etages = 1, Grid.etages do-- etage
    for lignes = 1,  Grid.lignes do-- lignes
      for colonnes = 1, Grid.colonnes do-- colonnes
        local case = Grid[etages][lignes][colonnes]

        if not Grid.load or pReset then
          -- on creer un MahJong si il y a un nombre !
          local backup
          if  type(case) == "number"  then
            backup = etages
            Grid.mahjongTotal = Grid.mahjongTotal + 1
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
        end
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
  if not Grid.load or pReset  then
    GridManager.setRandMahjong()
    --
    Grid.load = true
    if pReset then print("ICI") end
  end
end
--

function GridManager.setRandMahjong()
  -- initalisation d'un nouveau math.randomseed
  globals.math.newRandom() --love.math.setRandomSeed(love.timer.getTime()) -- set Random Seed !

  -- Verifier que le nombre de MahJong ne soit pas impaire sinon deux solutions :
  -- 1. on place un mahjong au piff et on reduit notre total de mahjong a placer de 1
  -- 2. on en supprime un au piff dans le tableau...

  -- Mask note : il faut ques les [Col and Lig] soient differentes sinon impossible a finir (non identique)

  -- test Paire ou Impaire ?!
  local testPaire = 2 -- le plus petit chiffre paire que je connaisse xD
  if debug then print("Grid.mahjongTotal % ToalMahJong = "..Grid.mahjongTotal % testPaire) end
  if Grid.mahjongTotal % testPaire == 0 then -- return le reste de la division (donc si le reste vaut zero c'est un nombre paire, sinon impaire)
    Grid.impaire = false
  else
    Grid.impaire = true
  end
  print("Grid.impaire : "..tostring(Grid.impaire))


  -- on scan les grilles :
  local i = Grid.mahjongTotal
  while  i >= 1 do

    -- on selectione un mahjong au hasard
    local rand = 32
    while rand  == 32 do
      rand = love.math.random(1,MahJong.total)
    end

    -- on place le pahlong sur un etage visible en Col et Lig aleatoire
    local l, c = GridManager.testMohJang(rand) -- placement du premier pion
    GridManager.testMohJang(rand,l,c) -- placement du secon pion
    i = i - 2
  end
end
--

function GridManager.testMohJang(pRand,pLig,pCol)
  --
  local loopTest = true
  --
  while loopTest do
    local superposed = false
    local l = love.math.random(1,Grid.lignes)
    local c = love.math.random(1,Grid.colonnes)
    if PLig and pCol then
      if PLig == l and pCol == c then
        superposed = true
      end
    end
    if not superposed then
      for e = 1, Grid.etages do
        --
        if loopTest then
          local caseTest = Grid[e][l][c]
          -- print("caseTest en Grid["..e.."]["..l.."]["..c.."].type : "..caseTest.type)
          --
          if caseTest.type >= 1 then
            if not caseTest.mahjong then
              caseTest.mahjong = pRand
              loopTest = false
            end
          end
        end
        --
      end
    end
  end
  return l, c
end
--

function GridManager.draw()
  love.graphics.setColor(1,1,1,1) -- reset color

  -- BackGround :
  love.graphics.setColor(1,1,1,0.4) -- reset color
  love.graphics.draw(Img.BG.img, 0, 0, 0, Img.BG.sx, Img.BG.sy)
  love.graphics.setColor(1,1,1,1) -- reset color

  love.graphics.print("Grid.level : "..Grid.level)

  --
  local indexTotal = Grid.etages * (Grid.lignes * Grid.colonnes)
  --
  for etages = 1, #Grid do-- etages
    for lignes = 1,  #Grid[1] do-- lignes
      for colonnes = 1, #Grid[1][1] do-- colonnes
        --
        local case = Grid[etages][lignes][colonnes] -- table
        love.graphics.setColor(1,1,1,1) -- reset color

        if case.type >= 1 then
          -- draw Mahjong Test
          -- TODO: Set Scales for Quads MahJong
          love.graphics.setColor(1,1,1,1) -- reset color
          love.graphics.draw(Img.MahJong.img, Img.MahJong.quad[case.mahjong], case.x, case.y)--, 0, 1, 1, case.ox, case.oy)
          love.graphics.setColor(1,1,1,1) -- reset color
        end

        -- draw chaque etage d'une douleur diff pour le debug
        if debug then
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
            -- draw Rect represent Grid Pos, color represent etage
            love.graphics.setColor(colorRect)
            love.graphics.rectangle("fill", case.x+2, case.y+2, case.w-3, case.h-3)
          end
        end

        -- reset color
        love.graphics.setColor(1,1,1,1) -- reset color
      end
    end
  end

  --reset color
  love.graphics.setColor(1,1,1,1)
end
--

return GridManager