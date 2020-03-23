
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

    -- Set the title of the game
    love.window.setTitle('Pong Game by Kzo!')

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
    if gameState == 'play' then

        if ball.x <= 0 then
            player2Score = player2Score + 1
            ball:reset()
            gameState = 'start'
        end

        if ball.x >= VIRTUAL_WIDTH - 4 then
            player1Score = player1Score + 1
            ball:reset()
            gameState = 'start'
        end

        if ball:collides(player1) then
            -- Deflect the ball to the right
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
        end

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
                else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            -- Deflect the ball to the left
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball.y <=  0 then
            -- Deflect the ball down
            ball.y = 0
            ball.dy = -ball.dy         
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            -- Deflect the ball up
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
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