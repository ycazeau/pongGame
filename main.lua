
Class = require 'Class'
--[[ Using the push library]]
push = require 'push'

require 'Ball' 
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243


PADDLE_SPEED = 200


--[[ Runs when the game firsst start uo, only one; used to in itislize the game ]]
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --[[ Setting up the new font ]]
    smallFont = love.graphics.newFont('font.ttf', 8)

    --[[ Font to draw the score]]
    scoreFont = love.graphics.newFont('font.ttf', 32)


    --[[ Initialize window with virtual resolution]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       resizable = false,
       vsync = true       
   })
    --[[Declare score variable]]
    player1Score = 0
    player2Score = 0
   
    --[[ Position of the paddles on Y axis (the can only move up and down)]]
    --[[ They are global so they can be detected by other functions and modules]]
   player1 = Paddle(10, 30, 5, 20)
   player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

   -- Place the ball in the middle on the screen
   ball = Ball(VIRTUAL_WIDTH / 2-2, VIRTUAL_HEIGHT / 2-2, 4, 4)

   gameState = 'start'

end

--[[ Using update function to move the paddles]]
function love.update(dt)

    if ball:collides(player1) then
        -- Deflect the ball to the right
        ball.dx = -ball.dx
    end

    if ball:collides(player2) then
        -- Deflect the ball to the left
        ball.dx = -ball.dx
    end

    if ball.y <=  0 then
        -- Deflect the ball down
        ball.dy = -ball.dy
        ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        -- Deflect the ball up
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
    end
       
   
    --[[ move the left paddle or the player 1]]
    if love.keyboard.isDown('right') then
        --[[ use math.max to block the paddle at the top of the screen]]
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('left') then
        --[[ use math.min to block the paddle at the bottom of the screen]]
        player1.dy = PADDLE_SPEED

        else 
            player1.dy = 0
    end

    --[[ move the right paddle or the player 2]]
    if love.keyboard.isDown('up') then
        --[[ use math.max to block the paddle at the top of the screen]]
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
         --[[ use math.min to block the paddle at the bottom of the screen]]
         player2.dy = PADDLE_SPEED

         else
            player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end   

    player1:update(dt)
    player2:update(dt)
end

--[[ when pressed escape button quit the game]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
        gameState = 'play'
    else
        gameState = 'start'
        ball:reset()
        end
    end
end

--[[  Called after update by Love, used to draw anything to the screen, updated or otherwise ]]
function love.draw()
    push:apply('start')

    --[[ the grey color]]
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    --[[ Using the font to set the welcome text at the top of the screen]]
    love.graphics.setFont(smallFont)
  
    if gameState == 'start' then
        love.graphics.printf("Hello Start State !", 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf("Hello Play State !", 0, 20, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    
    --[[ Draw the score on the middle of the screen]]
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2+30, VIRTUAL_HEIGHT/3)

    player1:render()
    player2:render()

    ball:render()

    displayFPS()

    push:apply('end')         
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end