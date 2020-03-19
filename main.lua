WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

--[[
    Runs when the game firsst start uo, only one; used to in itislize the game
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       vsync = true,
       resizable = false
   })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    Called after update by Love, used to draw anything to the screen, updated or otherwise
]]
function love.draw()
    push:apply('start')

    love.graphics.printf(
        "Hello Pong!",           -- Text to render
        0,                      -- Startting X (0 since we're going to center it based on width)
        VIRTUAL_HEIGHT / 2 - 6,      -- Starting Y(halfway down the screen)
        VIRTUAL_WIDTH,          -- Number of pixels to center within (the entire screen here)
        'center')              -- Alignement mode, can be 'center', 'left', 'right'

    push:apply('end')     
end