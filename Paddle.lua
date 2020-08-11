Paddle = Class{}

function Paddle:init( x, y , width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy=0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.x = math.max(0, self.x + self.dy * dt)
    elseif self.dy > 0 then
        self.x  = math.min(VIRTUAL_WIDTH -50, self.x + self.dy * dt) 
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end 