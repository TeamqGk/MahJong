local GridManager = {}

function GridManager.resetLevel(pLevel)
  GridManager.setGrid(pLevel, true)
end
--

function GridManager.setGrid(pLevel, pReset, pRandom)
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
          local add = false
          if  type(case) == "number"  then
            add = true
            Grid.mahjongTotal = Grid.mahjongTotal + 1
          end
          --
          Grid[etages][lignes][colonnes] = {}
          case = Grid[etages][lignes][colonnes]
          if add then
            case.add = true
          else
            case.add = false
          end
          case.mahjong = 0
          case.isActive = false
          case.etages = etages
          case.lignes = lignes
          case.colonnes = colonnes
          case.select = false
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
  end
end
--

function GridManager.setRandMahjong()
  -- initalisation d'un nouveau math.randomseed
--  globals.math.newRandom() --love.math.setRandomSeed(love.timer.getTime()) -- set Random Seed !

  -- Verifier que le nombre de MahJong ne soit pas impaire sinon deux solutions :
  -- 1. on place un mahjong au piff et on reduit notre total de mahjong a placer de 1
  -- 2. on en supprime un au piff dans le tableau...

  -- Mask note : il faut ques les [Col and Lig] soient differentes sinon impossible a finir (non identique)

  -- test Paire ou Impaire ?!
  local testPaire = 2 -- le plus petit chiffre paire que je connaisse xD
  if debug then print("Grid.mahjongTotal % TotalMahJong = "..Grid.mahjongTotal % testPaire) end
  if Grid.mahjongTotal % testPaire == 0 then -- return le reste de la division (donc si le reste vaut zero c'est un nombre paire, sinon impaire)
    Grid.impaire = false
  else
    Grid.impaire = true
  end
  print("Grid.impaire : "..tostring(Grid.impaire))


  -- on creer la table qui liste les Mahjong
  local tableRand = {}
  for i = 1 ,   MahJong.total do
    table.insert(tableRand, i)
    if debug then print("creation du mahjong n° "..i) end
  end
  -- melange de la table :
  for i = #tableRand, 1, -1 do
    local j = love.math.random(1,i)
    tableRand[i], tableRand[j] = tableRand[j], tableRand[i]
  end
  if debug then 
    for k , v in ipairs(tableRand) do
      print ("tableMahjong["..k.."] : "..v)
    end
  end
  --
  --
  local tableMahjong = {}
  local num = 1
  while #tableMahjong < Grid.mahjongTotal  do
    if num > MahJong.total then num = 1 end
    table.insert(tableMahjong, tableRand[num])
    table.insert(tableMahjong, tableRand[num])
    num = num + 1
  end
  if debug then print("#tableMahjong : "..#tableMahjong.."/"..Grid.mahjongTotal) end -- ok
  for k , v in ipairs(tableMahjong) do
    print ("tableMahjong["..k.."] : "..v)
  end

  -- on scan les grilles :
  Grid.mahjongPlaced = 0
  local i = 1
  while i < Grid.mahjongTotal  do
    -- on selectione un mahjong au hasard
    local rand = tableMahjong[#tableMahjong]
    local l, c = GridManager.testMohJang(rand) -- placement du premier pion
    i = i + 1
    table.remove(tableMahjong, #tableMahjong)
    --
    rand = tableMahjong[#tableMahjong]
    GridManager.testMohJang(rand, l, c) -- placement du second pion
    i = i + 1
    table.remove(tableMahjong, #tableMahjong)
    if Grid.mahjongPlaced == Grid.mahjongTotal then break end
  end
--
end
--

function GridManager.testMohJang(pRand, pLig, pCol)
  --
  local loopTest = true
  local l = 0
  local c = 0
  while loopTest do
    local superposed = false
    l = love.math.random(1, Grid.lignes)
    c = love.math.random(1, Grid.colonnes)
    if pLig and pCol then
      if l == pLig and c == pCol then
        superposed = true
        if debug then print("supersposé on recommence !") end
      end
    end
    --
    if not superposed then
      for i = 1, Grid.etages do
        local case = Grid[i][l][c]
        if case.add then
          case.add = false
          case.mahjong = pRand
          case.isActive = true
          --
          return l, c  
        end
      end
      --
    end
  end
end
--

function GridManager.draw()
  love.graphics.setColor(1,1,1,1) -- reset color

  -- BackGround :
  if not debug then
    love.graphics.setColor(1,1,1,0.55) -- reset color
    love.graphics.draw(Img.BG.img, 0, 0, 0, Img.BG.sx, Img.BG.sy)
    love.graphics.setColor(1,1,1,1) -- reset color
  end
  if debug then
    love.graphics.print("Grid.level : "..Grid.level)
  end

  --
  local indexTotal = Grid.etages * (Grid.lignes * Grid.colonnes)
  --
  for etages = 1, #Grid do-- etages
    for lignes = 1,  #Grid[1] do-- lignes
      for colonnes = 1, #Grid[1][1] do-- colonnes
        --
        local case = Grid[etages][lignes][colonnes] -- table
        love.graphics.setColor(1,1,1,1) -- reset color

        if case.isActive then -- draw Mahjong
          love.graphics.setColor(1,1,1,1) -- reset color
          love.graphics.draw(Img.MahJong.img, Img.MahJong.quad[case.mahjong], case.x, case.y)--, 0, 1, 1, case.ox, case.oy)
          love.graphics.setColor(1,1,1,1) -- reset color
        end

        if case.select and case.isActive then
          love.graphics.setColor(1,1,0,1) -- reset color
          love.graphics.rectangle("line", case.x, case.y, case.w, case.h)
          love.graphics.setColor(1,1,1,1) -- reset color
        end


        -- draw chaque etage d'une douleur diff pour le debug
        if debug then
          local colorRect = {}
          if case.etages == 1 then
            colorRect = {0,1,0,0.25}--vert
          elseif case.etages == 2 then
            colorRect = {1,0,0,0.25}--rouge
          elseif case.etages == 3 then
            colorRect = {0,0,1,0.25}--bleu
          elseif case.etages == 4 then
            colorRect = {1,1,0,0.25}
          elseif case.etages >= 5 then
            colorRect = {0,1,1,0.25}
          end

          --
          if case.isActive then
            -- draw Rect represent Grid Pos, color represent etage
            love.graphics.setColor(colorRect)
            love.graphics.rectangle("fill", case.x+2, case.y+2, case.w-3, case.h-3)
          end
          love.graphics.setColor(0,1,0,1) -- reset color
          love.graphics.rectangle("line", case.x, case.y, case.w, case.h)
          love.graphics.setColor(1,1,1,1) -- reset color
        end

        -- reset color
        love.graphics.setColor(1,1,1,1) -- reset color
      end
    end
  end

  if debug then
    love.graphics.setColor(1,0,0,1) -- reset color
    love.graphics.rectangle("line", Grid.x, Grid.y, Grid.w, Grid.h)
    love.graphics.setColor(1,1,1,1) -- reset color
  end

  --reset color
  love.graphics.setColor(1,1,1,1)
end
--

return GridManager
