local BestScore = {}
local lg = love.graphics
--
BestScore.show = false  
BestScore.x = screen.w * 0.1
BestScore.y = screen.h * 0.1
BestScore.w = screen.w * 0.8
BestScore.h = screen.h * 0.8
--
BestScore.text = {}
BestScore.text.string = " RECORDS : ".."\n\n"
BestScore.text.font = Font
BestScore.text.size = 100
BestScore.text.print = lg.newText(BestScore.text.font[BestScore.text.size], BestScore.text.string)
BestScore.text.x = screen.ox
BestScore.text.y = screen.oy
BestScore.text.w = screen.w
BestScore.text.h = screen.h
BestScore.text.ox = BestScore.text.w * 0.5
BestScore.text.oy = BestScore.text.h * 0.5
--

--
function BestScore.text:sizeText(pString)
  local function updateText()
    BestScore.text.print:setFont(BestScore.text.font[BestScore.text.size])
    BestScore.text.print:set(BestScore.text.string)
    BestScore.text.w = BestScore.text.print:getWidth()
    BestScore.text.print:setf(BestScore.text.string, BestScore.text.w, "center")
    BestScore.text.x = screen.ox
    BestScore.text.y = screen.oy
    BestScore.text.w = BestScore.text.print:getWidth()
    BestScore.text.h = BestScore.text.print:getHeight()
    BestScore.text.ox = BestScore.text.w * 0.5
    BestScore.text.oy = BestScore.text.h * 0.5
  end
  --

  BestScore.text.string = pString
  updateText()


  --
  if BestScore.text.h > BestScore.h - 4 or BestScore.text.h < BestScore.h - 10 or BestScore.text.w > BestScore.w - 4 then
    if BestScore.text.h > BestScore.h - 4 then
      if BestScore.text.size > 1 then
        BestScore.text.size = BestScore.text.size - 1
        updateText()
      end
    elseif BestScore.text.h < BestScore.h - 6 then
      if BestScore.text.size < 100 then
        BestScore.text.size = BestScore.text.size + 1
        updateText()
      end
    end
  end
end
--

function BestScore:update(dt)
  BestScore.x = screen.w * 0.1
  BestScore.y = screen.h * 0.1
  BestScore.w = screen.w * 0.8
  BestScore.h = screen.h * 0.8
  --
  local string = " RECORDS : ".."\n"

  for i = 1, 10 do
    local save = SaveCasseBrique[i]
    string = string..tostring(i)..".".."\t".."Date : "..save.Date.."\t".."Score : "..save.BestScore.."\n"
  end


  BestScore.text:sizeText(string)

end
--

function BestScore.showMenu()
  BestScore.show = not BestScore.show
  --
  BestScore.x = screen.w * 0.1
  BestScore.y = screen.h * 0.1
  BestScore.w = screen.w * 0.8
  BestScore.h = screen.h * 0.8
  print(BestScore.text.string)
end
--


function BestScore:draw()
  if BestScore.show then
    -- rect
    lg.setColor(0,0,0,0.55)
    lg.rectangle("fill", self.x, self.y, self.w, self.h, 25)

    -- text
    lg.setColor(1,1,1,1)
    local board = BestScore.text
    lg.draw(board.print, board.x, board.y, 0, 1, 1, board.ox, board.oy)

    -- repere
    if debug then
      lg.setColor(1,0,0,1)
      lg.circle("fill", screen.ox,screen.oy,5)
    end
  end
end
--



return BestScore