-- Runs first
function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    score = 0
    timer = 0
    gameState = 1 -- When game is state at 'Main Menu'
    highestScore = 0

    gameFont = love.graphics.newFont(20)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshair = love.graphics.newImage('sprites/crosshair.png')

    love.mouse.setVisible(false)
end

-- dt -> Delta Time
-- it will run at every frame
function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = 1 --Game state changes back to Main menu
    end
end

-- to draw anything
function love.draw()
    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.circle('fill', target.x, target.y, target.radius)

    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print('Score: ' .. score, 5, 5)
    love.graphics.print('Time Left:' .. math.ceil(timer), 300, 5)

    if gameState == 1 and highestScore < score then
        highestScore = score
    end
    love.graphics.print('Highest Score: ' .. highestScore, 600, 5)

    if gameState == 1 then
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.printf('Click anywhere to begin!', 0, 250, love.graphics.getWidth(), 'center')
    end

    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - 82, target.y - 80, math.rad(0), 160/sprites.target:getWidth(), 160/sprites.target:getHeight())
    end

    love.graphics.draw(sprites.crosshair, love.mouse.getX()-25, love.mouse.getY()-25, math.rad(0), 50/sprites.crosshair:getWidth(), 50/sprites.crosshair:getHeight())

end 

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)

        elseif score > 0 then
            score = score - 1
        end

    elseif button == 1 and gameState == 1 then
        gameState = 2
        timer = 10
        score = 0
    end

    if button == 2 and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 2
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
            timer = timer - 1
        end
    end

end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end