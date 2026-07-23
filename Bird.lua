Bird = {}
Bird.__index = Bird

function Bird.new()
    local self = setmetatable({}, Bird)

    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = 24
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.velocity = 0

    return self
end

function Bird:update(dt)
    self.velocity = self.velocity + GRAVITY * dt
    self.y = self.y + self.velocity * dt
end

function Bird:render()
    love.graphics.setColor(1,1,1)
     love.graphics.draw(
        self.image,
        self.x + self.width / 2,
        self.y + self.height / 2,
        math.min(math.max(self.velocity / 700, -0.4), 0.5),
        1, 1,
        self.width / 2,
        self.height / 2
    )
end

function Bird:collides(pipe)
    if self.x + self.width > pipe.x and
       self.x < pipe.x + pipe.width and
       self.y + self.height > pipe.y and
       self.y < pipe.y + pipe.height then
        return true
    end
    return false
end