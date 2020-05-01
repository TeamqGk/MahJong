local GridManager = {}

local tableMahjong = {}
local tableMahjongIsMove = {}


function GridManager.resetLevel(pLevel)
  GridManager.setGrid(pLevel, true)
end
--

function GridManager.setGrid(pLevel, pReset)
  timer.reset()

  --
  if pReset == true then
    LevelsManager.reset(pLevel)
  end
  if pLevel <= #Levels then
    Grid = {}
    Grid = Levels[pLevel]
  else
    GridManager.setGrid(1, true)
    return false
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

  if Grid.pics then
    Img.pics = ImgManager.new("scenes/MahJong/pics/"..Grid.pics)-- pFile
    if Grid.pics ~= "teach_warning.png" then
      local scaleScreenMax = 0.5
      if Img.pics.h > screen.h * scaleScreenMax then
        local scale = (screen.h * scaleScreenMax) / Img.pics.h
        local w, h = Img.pics.w * scale, Img.pics.h * scale
        Img.pics:setSizes(w,h)
      end
    else
      Img.pics:scaleToScreen()
    end
    Img.pics:setPos(screen.w - Img.pics.w, screen.h - Img.pics.h)
  end
  --

  if Grid.sound then
    Sounds[Grid.sound]:stop()
    Sounds[Grid.sound]:play()
  end


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
          case.isMove = false
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
        --
        case.etage = etages
        case.ligne = lignes
        case.colonne = colonnes

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
--    if debug tMahJong.total hen print("creation du mahjong n° "..i) end
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
  tableMahjong = {}
  local num = 1
  while #tableMahjong < Grid.mahjongTotal  do
    if num > MahJong.total then num = 1 end
    if Grid.impaire and #tableMahjong == 0 then
      table.insert(tableMahjong, tableRand[num])
    else
      table.insert(tableMahjong, tableRand[num])
      table.insert(tableMahjong, tableRand[num])
    end
    num = num + 1
  end
--  if debug then print("#tableMahjong : "..#tableMahjong.."/"..Grid.mahjongTotal) end -- ok
--  for k , v in ipairs(tableMahjong) do
--    print ("tableMahjong["..k.."] : "..v)
--  end

  -- on scan les grilles :
  while #tableMahjong > 0  do
    -- on selectione un mahjong au hasard
    local onGrid, l, c, e
    local NewMahjong = tableMahjong[#tableMahjong]
    onGrid, l, c, e = GridManager.testMohJang(NewMahjong)

    if onGrid then -- placement du premier pion
      table.remove(tableMahjong, #tableMahjong)
    else
      return false
    end
    --
    if #tableMahjong >= 1 then
      NewMahjong = tableMahjong[#tableMahjong]
      onGrid, l, c, e = GridManager.testMohJang(NewMahjong, l, c, e) -- placement du second pion
      if onGrid then
        table.remove(tableMahjong, #tableMahjong)
      else
        return false
      end
    end
  end

  GridManager.testMoveMahjong()

  if Grid.Move == 0 then
    return false
  end

-- Ouf on a  reussi !
  return true
--
end
--

function GridManager.testFirstSecond(pEtage,pLig)
  local first = true
  local second = true
  --
  local total = 0
  for col = 1 , Grid.colonnes do
    local case = Grid[pEtage][pLig][col]
    if case.isActive then
      total = total + 1
    end
  end
  --
  if total == 0 then
    first = true
  elseif total == 1 then
    second = true
  else
    first = false
    second = false
  end
  return first, second
end
--

function GridManager.testMohJang(pRand, pLig, pCol, pEtag)
  --
  local loopTest = true
  local l = 0
  local c = 0
  local loop = 0
  while loopTest do
    loop = loop + 1
    local superposed = false
    local glue = false
    l = love.math.random(1, Grid.lignes)
    c = love.math.random(1, Grid.colonnes)
    if pLig and pCol and pEtag then
      if l == pLig and c == pCol then
        superposed = true -- supersposé on recommence !
      end
    end
    --
    if not superposed then
      for e = 1, Grid.etages do
        --
        local first, second = GridManager.testFirstSecond(e,l,c)
        local ready = true
        --
        if not first or not second then
          if pEtag then
            if e == pEtag then
              if pCol -1 == c or pCol + 1 == c then
                ready = false
              end
            end
          end
        end
        --
        if ready then
          local case = Grid[e][l][c]
          if case.add then
            if GridManager.testGlueMohJang(e, l, c) then
              case.add = false
              case.mahjong = pRand
              case.isActive = true
              --
              return true, l, c, e
            end
          end
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

function GridManager.testGlueMohJang(pEtage, pLig, pCol)

  local first = true -- premier mahjong de la ligne ?
  for c = 1 , Grid.colonnes do
    local case = Grid[pEtage][pLig][c]
    if case.isActive then
      first = false
    end    
  end

  if debug then
    if first then  print("premier pion en Grid["..pEtage.."]["..pLig.."]["..pCol.."]") end
  end

  --
  local function left(pGlue)
    if pCol == 1 then return false end
    local case = Grid[pEtage][pLig][pCol-1]
    if case.isActive or first then
      return true
    else
      return false
    end
  end
  --
  local function right(pGlue)
    if pCol == Grid.colonnes then return false end
    local case = Grid[pEtage][pLig][pCol+1]
    if case.isActive or first then
      return true
    else
      return false
    end
  end
  --
  if left() or right() then
    return true 
  else
    return false
  end
end
--

function GridManager.resetIsMove()
  for etages = 1, Grid.etages do-- etage
    for lignes = 1,  Grid.lignes do-- lignes
      for colonnes = 1, Grid.colonnes do-- colonnes
        local case = Grid[etages][lignes][colonnes]
        case.isMove = false
      end
    end
  end
end
--
function GridManager.testIsMove(pEtage, pLig)
  local caseleft = false
  local caseright = false
  --
  local function left(pE,pL,pC)
    if pC == 1 then return false end
    local case = Grid[pE][pL][pC-1]
    if case.isActive then
      return true
    else
      return false
    end
  end
  --
  local function right(pE,pL,pC)
    if pC == Grid.colonnes then return false end
    local case = Grid[pE][pL][pC+1]
    if case.isActive then
      return true
    else
      return false
    end
  end
  --
  local function scanColLeftToRight()
    for c = 1 , Grid.colonnes do
      if right(pEtage, pLig, c) then
        local case = Grid[pEtage][pLig][c]
        if case.isActive then
          case.isMove = true
          return case
        end
      end
    end
    return false
  end 
  --
  local function scanColRightToLeft()
    for c = Grid.colonnes, 1, -1 do
      if left(pEtage, pLig, c) then
        local case = Grid[pEtage][pLig][c]
        if case.isActive then
          case.isMove = true
          return case
        end
      end
    end
    return false
  end
  --
  caseleft = scanColLeftToRight()
  caseright = scanColRightToLeft()
  --
  if not caseleft and not caseright then
    print("error")
  end
  return caseleft, caseright
end
--

function GridManager.testMoveMahjong()
  GridManager.resetIsMove() -- reset le tableau a false avant les test
  --
  tableMahjongIsMove = {}
  --
  for etages = 1, Grid.etages do-- etage
    for lignes = 1,  Grid.lignes do-- lignes
      local caseleft, caseright = false, false
      caseleft, caseright = GridManager.testIsMove(etages, lignes)
      if caseleft then 
        caseleft.find = false
        table.insert(tableMahjongIsMove, caseleft) 
      end
      if caseright then
        caseright.find = false
        table.insert(tableMahjongIsMove, caseright) 
      end
    end
  end
  --
  for i = #tableMahjongIsMove, 1, -1 do
    local case = tableMahjongIsMove[i]
    if not case.find then
      for i = #tableMahjongIsMove, 1, -1 do
        local test = tableMahjongIsMove[i]
        if case ~= test then
          if not test.find then
            if case.mahjong == test.mahjong then
              case.find = true
              test.find = true
            end
          end
        end
      end
    end
  end
  --
  for i = #tableMahjongIsMove, 1, -1 do
    local case = tableMahjongIsMove[i]
    if not case.find then
      table.remove(tableMahjongIsMove, i)
    end
  end
  --
  Grid.Move = #tableMahjongIsMove * 0.5

  --

end
--

function GridManager.draw()
  love.graphics.setColor(1,1,1,1) -- reset color

  -- BackGround :
  love.graphics.setColor(1,1,1,0.55) -- reset color
  love.graphics.draw(Img.BG.img, Img.BG.x, Img.BG.y, 0, Img.BG.sx, Img.BG.sy)
  if Grid.pics then
    love.graphics.setColor(1,1,1,1) -- reset color
    love.graphics.draw(Img.pics.img, Img.pics.x, Img.pics.y, 0, Img.pics.sx, Img.pics.sy)
  end
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
          love.graphics.setColor(0,0,0,1)
          love.graphics.rectangle("fill", case.x+2, case.y+2, case.w-4, case.h-4)
          if case.isMove then
            love.graphics.setColor(1,1,1,1)
          else
--            love.graphics.setColor(1,0,0,1)
            love.graphics.setColor(1,1,1,0.25)
          end
          love.graphics.draw(Img.MahJong.img, Img.MahJong.quad[case.mahjong], case.x, case.y, 0, case.sx, case.sy)
          love.graphics.setColor(1,1,1,1) -- reset color
        end
        --
        if case.select and case.isActive then
          love.graphics.setColor(1,1,0,1) -- reset color
          love.graphics.rectangle("line", case.x, case.y, case.w, case.h)
          love.graphics.setColor(1,1,1,1) -- reset color
        end
        --

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