push = require 'push'

require 'Pipe'

require 'Bird'

GRAVITY = 500

-- virtual resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- actual window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Scroll speeds
BACKGROUND_SCROLL_SPEED = 30
GROUND_SCROLL_SPEED = 60

-- Looping points
BACKGROUND_LOOPING_POINT = VIRTUAL_WIDTH

--scroll values
local backgroundScroll = 0
local groundScroll = 0

-- images
local background
local ground

function love.load()
    gameState = 'titlescreen'
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.window.setTitle('Flappy Bird')
    smallFont = love.graphics.newFont('Retro Font.ttf', 8)
    mediumFont = love.graphics.newFont('Retro Font.ttf', 14)

    bird = Bird.new()

    pipes = {}
    spawnTimer = 0
    PIPE_SPAWN_INTERVAL = 2
    score = 0

    background = love.graphics.newImage('background.png')
    ground = love.graphics.newImage('ground.png')

end

function love.update(dt)
  if gameState == 'playing' then
     bird:update(dt)
      backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
     groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
     -- spawn pipes
     spawnTimer = spawnTimer + dt
    if spawnTimer >= PIPE_SPAWN_INTERVAL then
     spawnTimer = 0
     local gapHeight = 90
     local gapY = math.random(60, VIRTUAL_HEIGHT - 60 - gapHeight)
    
     table.insert(pipes, Pipe.new('top', gapY - PIPE_HEIGHT))
     table.insert(pipes, Pipe.new('bottom', gapY + gapHeight))
    end

     -- update pipes
    for _, pipe in pairs(pipes) do
      pipe:update(dt)
       if not pipe.scored and pipe.orientation == 'bottom' then
          if pipe.x + pipe.width < bird.x then
            pipe.scored = true
            score = score + 1
          end
      end
    end
     -- check collision
    for _, pipe in pairs(pipes) do
     if bird:collides(pipe) then
        gameState = 'GameOver'
     end
    end

    -- check ground collision
    if bird.y + bird.height >= VIRTUAL_HEIGHT - 16 then
       gameState = 'GameOver'
    end 
  end
end

function love.draw()
    love.graphics.draw(background, -backgroundScroll, 0, 0, 
        VIRTUAL_WIDTH / background:getWidth(), 
        VIRTUAL_HEIGHT / background:getHeight())
    love.graphics.draw(background, -backgroundScroll + VIRTUAL_WIDTH, 0, 0,
        VIRTUAL_WIDTH / background:getWidth(),
        VIRTUAL_HEIGHT / background:getHeight())
    for _, pipe in pairs(pipes) do
    pipe:render()
    end
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    bird:render()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Score: ' .. score, 8, 8)

  if gameState == 'titlescreen' then
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Flappy Bird', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Space to Play', 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')
end

  if gameState == 'GameOver' then
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Score: ' .. score, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Space to Restart', 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
  end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        if gameState =='titlescreen' then
            gameState = 'playing'
        elseif gameState == 'GameOver' then
            bird.y = VIRTUAL_HEIGHT / 2 - bird.height / 2
            bird.velocity = 0
            pipes = {}
            score = 0
            spawnTimer = 0
            gameState = 'playing'
        elseif gameState == 'playing' then
            bird.velocity = -200
        end
    end
end

