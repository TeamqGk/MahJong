local GridManager = {}

function GridManager.resetLevel(pLevel)
  GridManager.setGrid(pLevel, true)
end
--

function GridManager.setGrid(pLevel, pReset, pRandom)
  timer.reset()
  
  --
  if pReset == true then
    LevelsManager.reset(pLevel)
  end
  Grid = {}
  if pLevel <= #Levels then
    Grid = Levels[pLevel]
  else
    Grid = Levels[1]
  end
--  if debug then print("Grid.load : "..tostring(Grid.load)) end

--

  --[[ return :
  Grid.etages, Grid.lignes, Grid.colonnes
  & all etages Tables
  ]]--

  -- Load image BackGround ( info is on map level_x.lua)
  Img.BG = ImgManager.new("scenes/MahJong/levels/img/"..Grid.image)-- pFile
  Img.BG:scaleToScreen()



  -- Settings of Scales
  local espaceW = screen.w * 0.4 -- Min
  local espaceH = screen.h * 0.4 -- Min
  local GridW = screen.w - espaceW -- MAX
  local GridH = screen.h - espaceH -- MAX
  --
  local sy = (GridH * 0.1) / Img.MahJong.quad.h
  local sx = sy
  --
  local CaseW = (Img.MahJong.quad.w * sx) -- Initial
  local CaseH = (Img.MahJong.quad.h * sy) -- Inital
  --  
  GridW = CaseW * Grid.colonnes
  GridH = CaseH * Grid.lignes
  --
  if GridW > screen.w - espaceH then
    local maxH = screen.w - espaceH
    sy = (maxH / Grid.lignes) / Img.MahJong.quad.h
    sx = sy
    --
    CaseW = (Img.MahJong.quad.w * sx) -- Initial
    CaseH = (Img.MahJong.quad.h * sy) -- Inital
    --  
    GridW = CaseW * Grid.colonnes
    GridH = CaseH * Grid.lignes
  end
  --
  local StartX = (screen.w - GridW) * 0.5
  local StartY = (screen.h - GridH) * 0.5
  --


  -- Settings of Sizes
  Grid.w = GridW
  Grid.h = GridH


  -- apply settings
  Grid.x = StartX
  Grid.y = StartY
  Grid.caseW = CaseW
  Grid.caseH = CaseH
  Grid.caseOx = Grid.caseW * 0.5
  Grid.caseOy = Grid.caseH * 0.5
  --
  local x = StartX
  local y = StartY
  --

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
        case.sy = sy
        case.sx = sx

        -- incrementation de x + la largeur d'une case (w)
        x = x + CaseW
      end
      --
      x = StartX
      y = y + CaseH
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
    if not GridManager.setRandMahjong(pLevel) then
      GridManager.resetLevel(pLevel)
    end
    --
    Grid.load = true
    timer.run = true
  end
end
--

function GridManager.setRandMahjong(pLevel)
  -- initalisation d'un nouveau math.randomseed
--  globals.math.newRandom() --love.math.setRandomSeed(love.timer.getTime()) -- set Random Seed !

  -- Verifier que le nombre de MahJong ne soit pas impaire sinon deux solutions :
  -- 1. on place un mahjong au piff et on reduit notre total de mahjong a placer de 1
  -- 2. on en supprime un au piff dans le tableau...

  -- Mask note : il faut ques les [Col and Lig] soient differentes sinon impossible a finir (non identique)

  -- test Paire ou Impaire ?!
  local testPaire = 2 -- le plus petit chiffre paire que je connaisse xD
--  if debug then print("Grid.mahjongTotal % TotalMahJong = "..Grid.mahjongTotal % testPaire) end
  if Grid.mahjongTotal % testPaire == 0 then -- return le reste de la division (donc si le reste vaut zero c'est un nombre paire, sinon impaire)
    Grid.impaire = false
  else
    Grid.impaire = true
  end
  if debug then print("Grid.impaire : "..tostring(Grid.impaire)) end


  -- on creer la table qui liste les Mahjong
  local tableRand = {}
  for i = 1 ,   MahJong.total do
    table.insert(tableRand, i)
--    if debug then print("creation du mahjong n° "..i) end
  end
  -- melange de la table :
  for i = #tableRand, 1, -1 do
    local j = love.math.random(1,i)
    tableRand[i], tableRand[j] = tableRand[j], tableRand[i]
  end
  if debug then 
    for k , v in ipairs(tableRand) do
--      print ("tableMahjong["..k.."] : "..v)
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
--  if debug then print("#tableMahjong : "..#tableMahjong.."/"..Grid.mahjongTotal) end -- ok
--  for k , v in ipairs(tableMahjong) do
--    print ("tableMahjong["..k.."] : "..v)
--  end

  -- on scan les grilles :
  while #tableMahjong > 0  do
    -- on selectione un mahjong au hasard
    local onGrid, l, c 
    local NewMahjong = tableMahjong[#tableMahjong]
    onGrid, l, c = GridManager.testMohJang(NewMahjong)
    if onGrid then -- placement du premier pion
      table.remove(tableMahjong, #tableMahjong)
    else
      return false
    end
    --
    NewMahjong = tableMahjong[#tableMahjong]
    onGrid, l, c = GridManager.testMohJang(NewMahjong, l, c) -- placement du second pion
    if onGrid then
      table.remove(tableMahjong, #tableMahjong)
    else
      return false
    end
  end

-- Ouf on a  reussi !
  return true
--
end
--

function GridManager.testMohJang(pRand, pLig, pCol)
  --
  local loopTest = true
  local l = 0
  local c = 0
  local loop = 0
  while loopTest do
    loop = loop + 1
    local superposed = false
    l = love.math.random(1, Grid.lignes)
    c = love.math.random(1, Grid.colonnes)
    if pLig and pCol then
      if l == pLig and c == pCol then
        superposed = true
--        if debug then print("supersposé on recommence !") end
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
          return true, l, c  
        end
      end
    end
    --
    if loop == 100 then
      return false
    end
  end
end
--

function GridManager.draw()
  love.graphics.setColor(1,1,1,1) -- reset color

  -- BackGround :
    love.graphics.setColor(1,1,1,0.55) -- reset color
    love.graphics.draw(Img.BG.img, 0, 0, 0, Img.BG.sx, Img.BG.sy)
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

        if case.isActive then -- draw Mahjong
          love.graphics.setColor(1,1,1,1) -- reset color
          love.graphics.draw(Img.MahJong.img, Img.MahJong.quad[case.mahjong], case.x, case.y, 0, case.sx, case.sy)
          love.graphics.setColor(1,1,1,1) -- reset color
        end

        if case.select and case.isActive then
          love.graphics.setColor(1,1,0,1) -- reset color
          love.graphics.rectangle("line", case.x, case.y, case.w, case.h)
          love.graphics.setColor(1,1,1,1) -- reset color
        end


        -- draw chaque etage d'une couleur diff pour le debug
        if case.isActive then
          local colorRect = {}
          local alpha = 0.1
          if case.etages == 1 then
            colorRect = {0,1,0,alpha}--vert
          elseif case.etages == 2 then
            colorRect = {1,0,0,alpha}--rouge
          elseif case.etages == 3 then
            colorRect = {0,0,1,alpha}--bleu
          elseif case.etages == 4 then
            colorRect = {1,1,0,alpha}
          elseif case.etages >= 5 then
            colorRect = {0,1,1,alpha}
          end
          love.graphics.setColor(colorRect)
          love.graphics.rectangle("fill", case.x+2, case.y+2, case.w-4, case.h-4)
        end

        -- debug show alls col and lig
        if debug then
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