
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


--[[
    Runs when the game firsst start uo, only one; used to in itislize the game
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --[[ Setting up the new font ]]
    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    --[[Declare score variable]]
    player1Score = 0
    player2Score = 0
   
    player1Y = 30
    player2Y =  VIRTUAL_HEIGHT - 40

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       resizable = false,
       vsync = true       
   })
end

function love.update(dt)
    if love.keyboard.isDown('right') then
        player1Y = player1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('left') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        player2Y = player2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

--[[ when pressed escape button quit the game]]
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

    --[[ Using the font to set the welcome text at the top of the screen]]
    love.graphics.setFont(smallFont)

  
    love.graphics.printf(
        
        "Hello Pong!",           -- Text to render
        0,                      -- Startting X (0 since we're going to center it based on width)
        20,      -- Starting Y(halfway down the screen)
        VIRTUAL_WIDTH,          -- Number of pixels to center within (the entire screen here)
        'center')              -- Alignement mode, can be 'center', 'left', 'right'

    love.graphics.setFont(scoreFont)
    love.graphics.print( player1Score, VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print( player2Score, VIRTUAL_WIDTH/2+30, VIRTUAL_HEIGHT/3)

    --[[ Draw the left paddle]]
    love.graphics.rectangle('fill', 10, player1Y,5, 20)

    --[[ Draw the right paddle]]
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10,player2Y ,5, 20)

    --[[Draw the ball ]]
    love.graphics.rectangle('fill', VIRTUAL_WIDTH /2-2, VIRTUAL_HEIGHT /2-2, 4, 4)


    push:apply('end')         
end