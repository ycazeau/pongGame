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


--[[ Runs when the game first start uo, only one; used to in initialize the game ]]
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set the title of the game
    love.window.setTitle('Pong Game by Yves Ronaldo CAZEAU')

    --[[ Setting up the welcome text ]]
    welcomeFont = love.graphics.newFont('eafont.ttf',20)

    --[[ Setting up font for fps ]]
    fpsFont = love.graphics.newFont('eafont.ttf', 8)

    --[[ Font to draw the score]]
    scoreFont = love.graphics.newFont('eafont.ttf', 32)


    -- Using the sounds table to add sound to the game
        sounds = {
            ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
            ['point_scored'] = love.audio.newSource('sounds/point_scored.wav', 'static'),
            ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
            ['bravo'] = love.audio.newSource('sounds/bravo.wav', 'static')

        }
         
    --[[ Initialize window with virtual resolution]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       resizable = true,
       vsync = true       
   })
    --[[Declare score variable]]
    player1Score = 50  
   
    servingPlayer = math.random(2) == 1 and 1 or 2

    winningPlayer = 0
    
    --[[ Position of the paddles on Y axis (the can only move left and right)]]
    --[[ They are global so they can be detected by other functions and modules]]

   player1 = Paddle(VIRTUAL_WIDTH / 2.2, VIRTUAL_HEIGHT - 15 , 50, 5)

   -- Place the ball in the middle on the screen
   ball = Ball(VIRTUAL_WIDTH / 2-2, VIRTUAL_HEIGHT / 2-2, 4, 4)

    if servingPlayer == 1 then
        ball.dy = 100 
    else
        ball.dy = -100
    end

   gameState = 'start'

end

function love.resize(w, h)
    push:  resize(w, h)
end

--[[ Using update function to move the paddles]]
function love.update(dt)

    if gameState == 'play' then

        -- Detect ball collision  with paddles
        if ball:collides(player1) then 
            ball.dy = -ball.dy
            player1Score = player1Score + 5

            sounds['paddle_hit'] : play()

            -- Keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(100, 150)
            else
                ball.dy = math.random(100, 150)
            end
        end

        -- player 1 wins(You Win!!)
        if player1Score == 100 then
            sounds['bravo'] : play()
            gameState = 'victory'
            winningPlayer = 1
            ball:reset()       
        end
    

        -- Detect upper and lower screen boundary collision and reverse it collide
        if ball.x <=  0 then
            ball.x = 0
            ball.dx = -ball.dx      
            
            sounds['wall_hit']:play()
        end

        if ball.y <=  0 then
            ball.dy = -ball.dy  
            ball.y = 0                
            
            sounds['wall_hit']:play()
        end

        -- When the ball reaches the down position
        if ball.y >= VIRTUAL_HEIGHT then 
            player1Score = player1Score - 5
            sounds['point_scored']:play()
            gameState = 'serve'
            ball:reset()
        end

        -- You Lose!!
        if player1Score == 0 then
        gameState = 'lost'          
        winningPlayer = 2   
        ball:reset()
        end

        if ball.x >= VIRTUAL_WIDTH then 
            ball.x = VIRTUAL_WIDTH
            ball.dx = -ball.dx

            sounds['wall_hit']:play()
        end

    
    end    
    --[[ move the left paddle or the player 1]]
    if love.keyboard.isDown('right') then
        --[[ use math.max to block the paddle at the top of the screen]]
        player1.dy = PADDLE_SPEED
    elseif love.keyboard.isDown('left') then
        --[[ use math.min to block the paddle at the bottom of the screen]]
        player1.dy = -PADDLE_SPEED

        else 
            player1.dy = 0
    end


    if gameState == 'play' then
        ball:update(dt)
    end   

    player1:update(dt)

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
            player1Score = 50
        elseif gameState =='lost' then
            gameState = 'start'
            player1Score = 50
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

    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(welcomeFont)
        --love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter To Play!", 0, 50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(welcomeFont)
        love.graphics.printf("Press Enter to Serve!",0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        -- draw a victory message
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.setFont(scoreFont)
        love.graphics.printf("You win!!",0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(welcomeFont)
        love.graphics.printf("Press Enter to Serve!",0, 80, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'lost' then
        -- draw a losing message
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(scoreFont)
        love.graphics.printf(" You Lose!!!",0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(welcomeFont)
        love.graphics.printf("Press Enter to Serve!",0, 80, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    end

    
    player1:render()
  

    ball:render()

    displayFPS()

    push:apply('end')         
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(fpsFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

    --[[ Draw the score in the right corner of the screen]]
function displayScore()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(scoreFont)    
    love.graphics.print(tostring(player1Score), 350,10)
    love.graphics.setColor(1, 1, 1, 1)   
end