Pipe = {}
Pipe.__index = Pipe

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 150

function Pipe.new(orientation, y)
    local self = setmetatable({},Pipe)

    self.image = love.graphics.newImage('pipe.png')
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.orientation = orientation
    self.width = self.image:getWidth()
    self.height = PIPE_HEIGHT
    self.scored = false

    return self
end

function Pipe:update(dt)
    self.x = self.x - PIPE_SPEED * dt
end

function Pipe:render()
    love.graphics.setColor(1,1,1)

    local scaleY = PIPE_HEIGHT / self.image:getHeight()

    if self.orientation == 'top' then
        love.graphics.draw(self.image, self.x, self.y + PIPE_HEIGHT, 0, 1, -scaleY)
    else
        love.graphics.draw(self.image, self.x, self.y, 0, 1, scaleY)  
 
    end
end