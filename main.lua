-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local background = display.newImage("1.jpg")
background.x = display.stageWidth / 2
background.y = display.stageHeight / 2

local ant = display.newImage("ant.png")
ant.xScale = .8
ant.yScale = .8

local time = system.getTimer()
local moveAmount = 4

local function animate(e)
	local now = system.getTimer()
	local elapsed = now - time
	local moveDist = moveAmount * (elapsed / 1000.0) * 10
	time = now
	
	ant.x = ant.x + moveDist
end

Runtime:addEventListener("enterFrame", animate);