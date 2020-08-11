-- ball Class

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    --[[ Render velocity]]
    self.dx = love.math.random(2) == 1 and -100 or 100
    self.dy = love.math.random(2) == 1 and -100 or 100

    --self.dy = math.random(-50, 50)
end

function Ball:collides(box)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > box.y + box.height or self.y  + self.height < box.y then
        return false
    end

    return true

end


--[[ Places the ball in the middle of the screen ]]
function Ball:reset()

--[[ Declare ball position in the middle of the screen ]]
self.x = VIRTUAL_WIDTH /2-2
self.y = VIRTUAL_HEIGHT /2-2

--[[ Give ball's X and Y velocity randomly  ]]
--self.dx = love.math.random(2) == 1 and -100 or 100
self.dy = love.math.random(2) == 1 and -100 or 100

--self.dx = math.random(-50, 50)
 
end
 
--[[
    Simply applies velocity to position, scaled by deltaTime.
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
        --[[Render the ball at the center ]]
        love.graphics.ellipse('fill', self.x, self.y, 4, 4)
end