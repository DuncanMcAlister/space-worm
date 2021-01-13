WINDOW_WIDTH = 600  
WINDOW_HEIGHT = 420

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'
Class = require 'class'

require 'ball'
require 'poo'

math.randomseed(os.time())

-- food attributes

timer = 0
time = 3

food = {}
food.x = math.random(80, WINDOW_WIDTH - 80)
food.y = math.random(80, WINDOW_HEIGHT - 80)
food.w = 5
food.h = 5

pointer = {}


x = 1

pieces = {}


poos = {}


pieces[1] = Ball(WINDOW_WIDTH / 2 + 5, WINDOW_HEIGHT / 2 + 5, 20, 20)

sounds = {
    ['dead'] = love.audio.newSource('point.mp3', 'static'),
    ['cursor'] = love.audio.newSource('hit.mp3', 'static'),
    ['eat'] = love.audio.newSource('eat.mp3', 'static')

}


BALL_SPEED = 100



function love.load()

    love.window.setTitle('Space Worm')

    -- makes text look 'blocky'
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    background = love.graphics.newImage("space.jpg")

    smallFont = love.graphics.newFont('font.ttf', 20)

    largeFont = love.graphics.newFont('font.ttf', 30)

    gameState = 'start'

    pointerState = 'top'

    score = 0

    hiscore = 0
    
end

function love.update(dt)

    -- set up directions when gameState is play

    if gameState == 'play' then
        movingRight = false
        movingLeft = false
        movingUp = false
        movingDown = false

        if love.keyboard.isDown('right') then
            movingRight = true
            movingLeft = false
            movingUp = false
            movingDown = false
        elseif love.keyboard.isDown('left') then
            movingRight = false
            movingLeft = true
            movingUp = false
            movingDown = false
        elseif love.keyboard.isDown('up') then
            movingRight = false
            movingLeft = false
            movingUp = true
            movingDown = false
        elseif love.keyboard.isDown('down') then
            movingRight = false
            movingLeft = false
            movingUp = false
            movingDown = true
        end

        -- moves snake head with arrows

        if movingRight == true then
            pieces[1].dx = BALL_SPEED
            pieces[1].dy = 0
        elseif movingLeft == true then
            pieces[1].dx = -BALL_SPEED
            pieces[1].dy = 0
        elseif movingUp == true then
            pieces[1].dx = 0
            pieces[1].dy = -BALL_SPEED
        elseif movingDown == true then
            pieces[1].dx = 0
            pieces[1].dy = BALL_SPEED
        end

        -- snake dies if turns in on itself

        if #pieces > 1 then
            if pieces[2].dx > 0 and love.keyboard.isDown('left') then
                gameState = 'dead'
                sounds['dead']:play()
            elseif pieces[2].dx < 0 and love.keyboard.isDown('right') then
                gameState = 'dead'
                sounds['dead']:play()
            elseif pieces[2].dy < 0 and love.keyboard.isDown('down') then
                gameState = 'dead'
                sounds['dead']:play()
            elseif pieces[2].dy > 0 and love.keyboard.isDown('up') then
                gameState = 'dead'
                sounds['dead']:play()
            end
        end

        -- move the body of the snake

        for x = 2, #pieces do


            if pieces[x - 1].dy < 0 then
                if pieces[x - 1].x < pieces[x].x + 1 and pieces[x - 1].x > pieces[x].x - 1 then
                    pieces[x].dx = 0
                    pieces[x].dy = -BALL_SPEED
                elseif pieces[x - 1].x < pieces[x].x - 1 then
                    pieces[x].dx = -BALL_SPEED
                    pieces[x].dy = 0
                else
                    pieces[x].dx = BALL_SPEED
                    pieces[x].dy = 0
                end
            elseif pieces[x - 1].dy > 0 then
                if pieces[x - 1].x < pieces[x].x + 1 and pieces[x - 1].x > pieces[x].x - 1 then
                    pieces[x].dx = 0
                    pieces[x].dy = BALL_SPEED
                elseif pieces[x - 1].x > pieces[x].x + 1 then
                    pieces[x].dx = BALL_SPEED
                    pieces[x].dy = 0
                else
                    pieces[x].dx = -BALL_SPEED
                    pieces[x].dy = 0
                end
            elseif pieces[x - 1].dx > 0 then
                if pieces[x - 1].y < pieces[x].y + 1 and pieces[x - 1].y > pieces[x].y - 1 then
                    pieces[x].dx = BALL_SPEED
                    pieces[x].dy = 0
                elseif pieces[x - 1].y > pieces[x].y + 1 then
                    pieces[x].dx = 0
                    pieces[x].dy = BALL_SPEED

                else
                    pieces[x].dx = 0
                    pieces[x].dy = -BALL_SPEED
                end
            elseif pieces[x - 1].dx < 0 then
                if pieces[x - 1].y < pieces[x].y + 1 and pieces[x - 1].y > pieces[x].y - 1 then
                    pieces[x].dx = -BALL_SPEED
                    pieces[x].dy = 0
                elseif pieces[x - 1].y < pieces[x].y - 1 then
                    pieces[x].dx = 0
                    pieces[x].dy = -BALL_SPEED
                else
                    pieces[x].dx = 0
                    pieces[x].dy = BALL_SPEED
                end

                if pieces[1].dx > 0 and pieces[2].dx > 0 then
                    distance = pieces[1].x - pieces[2].x
                    if distance > 21 then
                        pieces[1].dx = BALL_SPEED * 0.95
                    elseif distance < 20 then
                        pieces[1].dx = BALL_SPEED * 1.05
                    else
                        pieces[1].dx = BALL_SPEED
                    end

                elseif pieces[1].dx < 0 and pieces[2].dx < 0 then
                    distance = pieces[2].x - pieces[1].x
                    if distance > 21 then
                        pieces[1].dx = -BALL_SPEED * 0.95
                    elseif distance < 20 then
                        pieces[1].dx = -BALL_SPEED * 1.05
                    else
                        pieces[1].dx = -BALL_SPEED
                    end

                elseif pieces[1].dy > 0 and pieces[2].dy > 0 then
                    distance = pieces[1].y - pieces[2].y
                    if distance > 21 then
                        pieces[1].dy = BALL_SPEED * 0.95
                    elseif distance < 20 then
                        pieces[1].dy = BALL_SPEED * 1.05
                    else
                        pieces[1].dy = BALL_SPEED
                    end

                elseif pieces[1].dy < 0 and pieces[2].dy < 0 then
                    distance = pieces[2].y - pieces[1].y
                    if distance > 21 then
                        pieces[1].dy = -BALL_SPEED * 0.95
                    elseif distance < 20 then
                        pieces[1].dy = -BALL_SPEED * 1.05
                    else
                        pieces[1].dy = -BALL_SPEED
                    end
                end

                if pieces[x - 1].dx > 0 and pieces[x].dx > 0 then
                    distance = pieces[x - 1].x - pieces[x].x
                    if distance > 20.5 then
                        pieces[x].dx = BALL_SPEED * 1.05
                    end
                elseif pieces[x - 1].dx < 0 and pieces[x].dx < 0 then
                    distance = pieces[x].x - pieces[x - 1].x
                    if distance > 20.5 then
                        pieces[x].dx = -BALL_SPEED * 1.05
                    end
                elseif pieces[x - 1].dy < 0 and pieces[x].dy < 0 then
                    distance = pieces[x].y - pieces[x - 1].y
                    if distance > 20.5 then
                        pieces[x].dy = -BALL_SPEED * 1.05
                    end
                elseif pieces[x - 1].dy > 0 and pieces[x].dy > 0 then
                    distance = pieces[x - 1].y - pieces[x].y1
                    if distance > 20.5 then
                        pieces[x].dy = BALL_SPEED * 1.05
                    end
                end
            
            end

            -- corrects for wonky pieces

            if pieces[x].dy < 0 and pieces[x - 1].dy < 0 and pieces[x].x ~= pieces[x - 1].x then
                pieces[x].x = pieces[x - 1].x
            elseif pieces[x].dy > 0 and pieces[x - 1].dy > 0 and pieces[x].x ~= pieces[x - 1].x then
                pieces[x].x = pieces[x - 1].x
            elseif pieces[x].dx > 0 and pieces[x - 1].dx > 0 and pieces[x].y ~= pieces[x - 1].y then
                pieces[x].y = pieces[x - 1].y
            elseif pieces[x].dx < 0 and pieces[x - 1].dx < 0 and pieces[x].y ~= pieces[x - 1].y then
                pieces[x].y = pieces[x - 1].y
            end

        end


        -- if snake eats piece of food, move the food to different random location and grow the snake by one piece

        if pieces[1].x + pieces[1].w >= food.x and pieces[1].x <= food.x and food.y >= pieces[1].y and food.y + food.h <= pieces[1].y + pieces[1].h then
            food.x = math.random(80, WINDOW_WIDTH - 80)
            food.y = math.random(80, WINDOW_HEIGHT - 80)

            sounds['eat']:play()

            -- move food if poo behind food


            if #poos > 0 then
                for x = 1, #poos do
                    if (food.x >= poos[x].x -4 and food.x <= poos[x].x + 4) and (food.y >= poos[x].y - 4 and food.y <= poos[x].y + 4) then
                        food.x = math.random(80, WINDOW_WIDTH - 80)
                        food.y = math.random(80, WINDOW_HEIGHT - 80)
                    end
                end
            end

            -- increase score

            score = score + 10

            -- hiscore stored between games

            if score > hiscore then
                hiscore = score
            end

            x = x + 1

            -- grows new piece of snake 

            if pieces[x - 1].dx > 0 then
                table.insert(pieces, Ball(pieces[x - 1].x - 21, pieces[x - 1].y, 20, 20))
            elseif pieces[x - 1].dx < 0 then
                table.insert(pieces, Ball(pieces[x - 1].x + 21, pieces[x - 1].y, 20, 20))
            elseif pieces[x - 1].dy < 0 then
                table.insert(pieces, Ball(pieces[x - 1].x, pieces[x - 1].y + 21, 20, 20))
            elseif pieces[x - 1].dy > 0 then
                table.insert(pieces, Ball(pieces[x - 1].x, pieces[x - 1].y - 21, 20, 20)) 
            else
                table.insert(pieces, Ball(pieces[x - 1].x - 21, pieces[x - 1].y, 20, 20))
            end

            -- add poo if digestion mode selected 50% of eats

            if pointerState == 'bottom' then
                if math.random(1, 2) == 1  and #pieces > 3 then
                    if pieces[#pieces].dx > 0 then
                        table.insert(poos, Poo(pieces[#pieces].x - 20, pieces[#pieces].y, 7))
                    elseif pieces[#pieces].dx < 0 then
                        table.insert(poos, Poo(pieces[#pieces].x + 40, pieces[#pieces].y, 7))
                    elseif pieces[#pieces].dy < 0 then
                        table.insert(poos, Poo(pieces[#pieces].x, pieces[#pieces].y + 20, 7))
                    else
                        table.insert(poos, Poo(pieces[#pieces].x, pieces[#pieces].y - 20, 7))
                    end
                end
            end

            -- remove poo 1 time in 7 if more than 3 poos on screen

            if pointerState == 'bottom' and #poos > 3 then
                if math.random(1, 7) == 1 then
                    table.remove(poos, math.random(1, #poos))
                end
            end

            

        end

        -- dies if snake hits the edge
        if (pieces[1].dx > 0 and pieces[1].x >= WINDOW_WIDTH - 40 - 20) or (pieces[1].dx < 0 and pieces[1].x <= 40) 
        or (pieces[1].dy > 0 and pieces[1].y >= WINDOW_HEIGHT - 80 + 20) or (pieces[1].dy < 0 and pieces[1].y <= 40) then
            gameState = 'dead'
            sounds['dead']:play()
        end

        --dies if snake bites its tail

        if #pieces > 2 then
            for x = 3, #pieces do
                if pieces[1].dx > 0 and pieces[1].x + pieces[1].w >= pieces[x].x and pieces[1].x <= pieces[x].x and pieces[1].y <= pieces[x].y and pieces[1].y + pieces[1].h >= pieces[x].y then
                    gameState = 'dead'
                    sounds['dead']:play()
                elseif pieces[1].dx < 0 and pieces[1].x <= pieces[x].x + pieces[x].w and pieces[1].x + pieces[1].w >= pieces[x].x + pieces[x].w and pieces[1].y <= pieces[x].y and pieces[1].y + pieces[1].h >= pieces[x].y then
                    gameState = 'dead'
                    sounds['dead']:play()
                elseif pieces[1].dy < 0 and pieces[1].y <= pieces[x].y + pieces[x].h and pieces[1].y + pieces[1].h >= pieces[x].y + pieces[x].h and pieces[1].x <= pieces[x].x and pieces[1].x + pieces[1].w >= pieces[x].x then
                    gameState = 'dead'
                    sounds['dead']:play()
                elseif pieces[1].dy > 0 and pieces[1].y + pieces[1].h >= pieces[x].y and pieces[1].y <= pieces[x].y and pieces[1].x <= pieces[x].x and pieces[1].x + pieces[1].w >= pieces[x].x then
                    gameState = 'dead'
                    sounds['dead']:play()
                end
            end
        end

        -- dies if snake hits a poo

        if #poos > 0 then
            for x = 1, #poos do
                if pieces[1].dx > 0 and pieces[1].x + pieces[1].w >= poos[x].x and pieces[1].x <= poos[x].x and pieces[1].y <= poos[x].y and pieces[1].y + pieces[1].h >= poos[x].y then
                    gameState = 'dead'
                    sounds['dead']:play()
                elseif pieces[1].dx < 0 and pieces[1].x <= poos[x].x and pieces[1].x + pieces[1].w >= poos[x].x and pieces[1].y <= poos[x].y and pieces[1].y + pieces[1].h >= poos[x].y then
                    gameState = 'dead'
                    sounds['dead']:play()
                elseif pieces[1].dy < 0 and pieces[1].y <= poos[x].y and pieces[1].y + pieces[1].h >= poos[x].y and pieces[1].x <= poos[x].x and pieces[1].x + pieces[1].w >= poos[x].x then
                    gameState = 'dead'
                    sounds['dead']:play()
                elseif pieces[1].dy > 0 and pieces[1].y + pieces[1].h >= poos[x].y and pieces[1].y <= poos[x].y and pieces[1].x <= poos[x].x and pieces[1].x + pieces[1].w >= poos[x].x then
                    gameState = 'dead'
                    sounds['dead']:play()
                end
            end
        end

        -- update body

        for y = 1, #pieces do
            pieces[y]:update(dt)
        end

    -- play sound, game over message after 1/2 second when dead, snake implodes. Clear pieces and poos tables. Restart
    
    elseif gameState == 'dead' then
        timer = timer + love.timer.getDelta()
        

        for x = 1, #pieces do
            table.remove(pieces, x)
        end

        for x = 1, #poos do
            table.remove(poos, x)
        end

        


        if timer >= time then

            pieces[1] = Ball(WINDOW_WIDTH / 2 + 5, WINDOW_HEIGHT / 2 + 5, 20, 20)

            food.x = math.random(80, WINDOW_WIDTH - 80)
            food.y = math.random(80, WINDOW_HEIGHT - 80)

            x = 1
            
            timer = 0

            gameState = 'start'

            score = 0

            
        end     

    -- start menu controls 
    elseif gameState == 'start' then
        if love.keyboard.isDown('down') then
            pointerState = 'bottom'
            sounds['cursor']:play()
        elseif love.keyboard.isDown('up') then
            pointerState = 'top'
            sounds['cursor']:play()
        end

        if pointerState == 'top' then
            pointer.y1 = 155
            pointer.y2 = 185
            pointer.y3 = 170
            pointer.x1 = 10
            pointer.x2 = 10
            pointer.x3 = 20
        else
            pointer.y1 = 205
            pointer.y2 = 235
            pointer.y3 = 220
            pointer.x1 = 10
            pointer.x2 = 10
            pointer.x3 = 20
        end
    end


end

-- play and pause controls

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    elseif gameState == 'start' and (key == 'enter' or key == 'return') then
        gameState = 'play'
    elseif gameState == 'play' and key == 'space' then
        gameState = 'pause'
    elseif gameState == 'pause' and key == 'space' then
        gameState = 'play'
    end
end

function love.draw()

    -- render background
    
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end

    -- start menu display

    if gameState == 'start' then

        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Space Worm!', 0, 10, WINDOW_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin... if you DARE!', 0, 30, WINDOW_WIDTH, 'center')
        love.graphics.polygon('fill', pointer.x1, pointer.y1, pointer.x2, pointer.y2, pointer.x3, pointer.y3)
        love.graphics.print('Just Score - as high as possible!', 25, 160)
        love.graphics.print('Digestion mode - avoid the "brown rocks"!', 25, 210)


    else
            -- draw game boundary
        love.graphics.rectangle('line', 40, 40, WINDOW_WIDTH - 80, WINDOW_HEIGHT - 80)
        -- draw food
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle('fill', food.x, food.y, food.w, food.h)
        love.graphics.setColor(1, 1, 1, 1)
    
        love.graphics.print('Score: ' .. tostring(score), 10, 10)
        love.graphics.print('Hi score: ' .. tostring(hiscore), WINDOW_WIDTH - 200, 10)


        if gameState == 'dead' then
            love.graphics.setFont(largeFont)
            if timer >= 0.5 then
                love.graphics.printf('Game over!', 0, WINDOW_HEIGHT / 2 - 30, WINDOW_WIDTH, 'center')
            end
        end




        -- draw poos
        if #poos > 0 then
            for y = 1, #poos do
                love.graphics.setColor(122 / 255, 89 / 255, 1 / 255, 1)
                poos[y]:render()
                love.graphics.setColor(1, 1, 1, 1)
    
            end
        end
        
        -- draw pieces
        for x = 1, #pieces do
            love.graphics.setColor(175 / 255, 238 / 255, 238 / 255, 1)
            pieces[x]:render()
            love.graphics.setColor(1, 1, 1, 1)
        end
        
    end

end
