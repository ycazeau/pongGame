
push = require 'push'

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
    player1Y = 30
    player2Y =  VIRTUAL_HEIGHT - 50 

    --[[ Declare ball position]]
   ballX = VIRTUAL_WIDTH /2-2
   ballY = VIRTUAL_HEIGHT /2-2

   --[[ Render velocity]]
   ballDX = math.random(2) == 1 and -100 or 100
   ballDDY = math.random(-50, 50)

   gameState = 'start'

end

--[[ Using update function to move the paddles]]
function love.update(dt)
    --[[ move the left paddle]]
    if love.keyboard.isDown('right') then
        --[[ use math.max to block the paddle at the top of the screen]]
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('left') then
        --[[ use math.min to block the paddle at the bottom of the screen]]
        player1Y = math.min(VIRTUAL_HEIGHT -20, player1Y + PADDLE_SPEED * dt)
    end

    --[[ move the right paddle]]
    if love.keyboard.isDown('up') then
        --[[ use math.max to block the paddle at the top of the screen]]
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
         --[[ use math.min to block the paddle at the bottom of the screen]]
        player2Y = math.min(VIRTUAL_HEIGHT, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDX * dt
    end

end

--[[ when pressed escape button quit the game]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
        gameState = 'play'
    elseif gameState == 'play' then
        gameState = 'start'
        --[[ Declare ball position]]
        ballX = VIRTUAL_WIDTH /2-2
        ballY = VIRTUAL_HEIGHT /2-2

        --[[ Render velocity]]
        ballDX = math.random(2) == 1 and -100 or 100
        ballDDY = math.random(-50, 50)

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
        love.graphics.printf("Hello Start Game !", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf("Hello Play Game !", 0, 20, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    
    --[[ Draw the score on the middle of the screen]]
    love.graphics.print(player1Score, VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH/2+30, VIRTUAL_HEIGHT/3)

    --[[ Draw the left paddle]]
    love.graphics.rectangle('fill', 10, player1Y,5, 20)

    --[[ Draw the right paddle]]
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y ,5, 20)

    --[[Draw the ball ]]
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)


    push:apply('end')         
end