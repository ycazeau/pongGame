--[[
    Pong Game by Yves Ronaldo CAZEAU
]]

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
    love.window.setTitle('Pong Game by Yves Ronaldo CAZEAU!')

    --[[ Setting up the new font ]]
    smallFont = love.graphics.newFont('font.ttf', 8)

    --[[ Font to draw the score]]
    scoreFont = love.graphics.newFont('font.ttf', 32)

        --[[ Font to draw the score]]
        victoryFont = love.graphics.newFont('font.ttf', 24)

    -- Using the sounds table to add sound to the game
        sounds = {
            ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
            ['point_scored'] = love.audio.newSource('sounds/point_scored.wav', 'static'),
            ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
        }
         
    --[[ Initialize window with virtual resolution]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       resizable = true,
       vsync = true       
   })
    --[[Declare score variable]]
    player1Score = 0
    player2Score = 0
   
    servingPlayer = math.random(2) == 1 and 1 or 2

    winningPlayer = 0
    
    --[[ Position of the paddles on Y axis (the can only move up and down)]]
    --[[ They are global so they can be detected by other functions and modules]]
   player1 = Paddle(10, 30, 5, 20)
   player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

   -- Place the ball in the middle on the screen
   ball = Ball(VIRTUAL_WIDTH / 2-2, VIRTUAL_HEIGHT / 2-2, 4, 4)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

   gameState = 'start'

end

function love.resize(w, h)
    push:  resize(w, h)
end

--[[ Using update function to move the paddles]]
function love.update(dt)

    if gameState == 'serve' then
        -- before switching to play, initialize ball's velocity based
        -- on player who last scored
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then

        -- Detect ball collision  with paddles
        if ball:collides(player1) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            sounds['paddle_hit'] : play()

            -- Keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            sounds['paddle_hit'] : play()

            -- Keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Detect upper and lower screen boundary collision and reverse it collide
        if ball.y <=  0 then
            ball.y = 0
            ball.dy = -ball.dy      
            
            sounds['wall_hit']:play()
        end

        -- The ball size
        if ball.y >= VIRTUAL_HEIGHT - 4 then 
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end
    
        -- if we reach the left or right edge of the screen
        -- go back and start and update the score
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            ball:reset()

            sounds['point_scored']:play()
            
            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player2Score >= 10 then
                gameState = 'victory'
                winningPlayer = 1
            else
                gameState = 'serve'
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            ball:reset()

            sounds['point_scored']:play()

            if player1Score >= 10 then
                gameState = 'victory'
                winningPlayer = 1
            else
                gameState = 'serve'
            end
        end
    
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
            gameState = 'serve'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
        elseif gameState == 'serve' then
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

    displayScore(

    )
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter To Play!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player " .. tostring(servingPlayer) .. " 's turn!",0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Serve!",0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        -- draw a victory message
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!",0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to Serve!",0, 42, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    end

    
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

function displayScore()
    love.graphics.setFont(scoreFont)    
    --[[ Draw the score on the middle of the screen]]
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2+30, VIRTUAL_HEIGHT/3)
end