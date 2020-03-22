
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243



--[[
    Runs when the game firsst start uo, only one; used to in itislize the game
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --[[
        Setting up the new font
    ]]
    smallFont = love.graphics.newFont('font.ttf', 10)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       resizable = false,
       vsync = true       
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

    --[[ the grey color]]
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    --[[Draw the rectangle or ball ]]
    love.graphics.rectangle('fill', VIRTUAL_WIDTH /2-2, VIRTUAL_HEIGHT /2-2, 5, 5)

    --[[ Draw the paddles]]
    love.graphics.rectangle('fill', 5, 20,5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40,5, 20)


    love.graphics.printf(
        
        "Hello Pong!",           -- Text to render
        0,                      -- Startting X (0 since we're going to center it based on width)
        20,      -- Starting Y(halfway down the screen)
        VIRTUAL_WIDTH,          -- Number of pixels to center within (the entire screen here)
        'center')              -- Alignement mode, can be 'center', 'left', 'right'

    push:apply('end')     
end