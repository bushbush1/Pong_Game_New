-- Initializing which player's turn it is for when the ball hits the bat to determine who gets the point
playOnesTurn = true
playerTwosTurn = false

-- Initialize sounds
menuSound = love.audio.newSource("/retro-gaming-271301.mp3", "stream")
gameSound = love.audio.newSource("/gaming-music-8-bit-console-play-background-intro-theme-278382.mp3", "stream")
settingsSound = love.audio.newSource("/settingsAudio.mp3", "stream")
byyyyye = love.audio.newSource("exit.mp3", "stream")

-- Ball position and size
local ballX = math.min(50, love.graphics.getWidth() - 50)
local ballY = math.min(50, love.graphics.getHeight() - 50)
local ballRadius = 10

local playerOneScore = 0
local playerTwoScore = 0

-- Game timer
gameTimer = 350

-- Speed for player paddles
playBatSpeed = 100
maxBallSpeed = 500

-- Game area size
local courtX = 10
local courtY = 30
local courtWidth = (1280 - 30)
local courtHeight = (720 - 30)

-- Mid court line / halfway line
local midCourtLine = (courtWidth / 2) 

-- Player bat position and size
local playerOneBatX, playerOneBaty = 10, 250
local playerTwoBatX, playerTwoBaty = courtWidth, 250 
local batSizeWidth = 10
local batSizeHeight = 50

-- Track whether music is playing
isPlaying = true

-- Menu button settings
BUTTON_HEIGHT = 64

local buttons = {}
local gameState = "menu" -- Values: "menu", "game"

function newMenuButton(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

function love.load()
    gameState = "menu"
    font = love.graphics.newFont(25)
    love.audio.play(menuSound)

    ballSpeedX = 200
    ballSpeedY = 200

    table.insert(buttons, newMenuButton(
        "start game",
        function()
            print("Starting game")
            gameState = "game"
            love.audio.stop()
            love.audio.play(gameSound)
        end))

    table.insert(buttons, newMenuButton(
        "Load game",
        function()
            print("Loading game")
        end))

    table.insert(buttons, newMenuButton(
        "Settings",
        function()
            print("going to settings menu")
            love.audio.stop()
            love.audio.play(settingsSound)
            gameState = settings
        end))

    table.insert(buttons, newMenuButton(
        "exit",
        function()
            print("exiting the game")
            love.audio.stop()
            love.audio.play(byyyyye)
            love.event.quit(10)
        end))
end

-- Function to change ball speed after a collision
function changeBallSpeed(ballSpeedX, ballSpeedY, playerID)
    -- Reverse the X speed (bounce effect)
    ballSpeedX = -ballSpeedX
    ballSpeedY = - ballSpeedY

    -- Apply different speed modifiers based on player
    if playerID == 1 then
        ballSpeedX = ballSpeedX * 1.1  -- Player One gets a 10% speed increase
    elseif playerID == 2 then
        ballSpeedX = ballSpeedX * 1.2  -- Player Two gets a 20% speed increase
    end

    -- Optionally increase Y speed by 10%
    ballSpeedY = ballSpeedY * 1.1

    -- Apply max speed limits
    if ballSpeedX > maxBallSpeed then
        ballSpeedX = maxBallSpeed
    elseif ballSpeedX < -maxBallSpeed then
        ballSpeedX = -maxBallSpeed
    end

    if ballSpeedY > maxBallSpeed then
        ballSpeedY = maxBallSpeed
    elseif ballSpeedY < -maxBallSpeed then
        ballSpeedY = -maxBallSpeed
    end

    return ballSpeedX, ballSpeedY
end

function love.update(dt)
    if gameState == "game" then
        gameTimer = gameTimer - dt
        if gameTimer <= 0 then
            gameTimer = 0
        end

        -- Update ball position
        ballX = ballX + ballSpeedX * dt
        ballY = ballY + ballSpeedY * dt

        -- Ensure the ball doesn't go out of bounds horizontally (left/right)
        ballX = math.max(courtX + ballRadius, math.min(ballX, courtX + courtWidth - ballRadius))

        -- Ball boundary check for the top and bottom of the court (vertical boundaries)
        if ballY - ballRadius <= courtY then
            ballY = courtY + ballRadius  -- Place the ball just at the top boundary
            ballSpeedY = -ballSpeedY  -- Reverse Y speed to make the ball bounce downward
        elseif ballY + ballRadius >= courtY + courtHeight then
            ballY = courtY + courtHeight - ballRadius  -- Place the ball just at the bottom boundary
            ballSpeedY = -ballSpeedY  -- Reverse Y speed to make the ball bounce upward
        end

        -- Logic for collision with Player One's bat
        if ballX - ballRadius <= playerOneBatX + batSizeWidth and ballX + ballRadius >= playerOneBatX then
            if ballY >= playerOneBaty and ballY <= playerOneBaty + batSizeHeight then
                ballX = playerOneBatX + batSizeWidth + ballRadius  -- Set ball just outside the bat
                ballSpeedX, ballSpeedY = changeBallSpeed(ballSpeedX, ballSpeedY, 1)  -- Change speed and direction
            end
        end

        -- Logic for collision with Player Two's bat
        if ballX + ballRadius >= playerTwoBatX and ballX - ballRadius <= playerTwoBatX + batSizeWidth then
            if ballY >= playerTwoBaty and ballY <= playerTwoBaty + batSizeHeight then
                ballX = playerTwoBatX - ballRadius  -- Set ball just outside the bat
                ballSpeedX, ballSpeedY = changeBallSpeed(ballSpeedX, ballSpeedY, 2)  -- Change speed and direction
            end
        end

        -- Player movement controls
        if love.keyboard.isDown("w") then
            playerOneBaty = playerOneBaty - 10
        end
        if love.keyboard.isDown("s") then
            playerOneBaty = playerOneBaty + 10
        end
        if love.keyboard.isDown("d") then
            playerOneBatX = playerOneBatX + 10
        end
        if love.keyboard.isDown("a") then
            playerOneBatX = playerOneBatX - 10
        end
        if love.keyboard.isDown("up") then
            playerTwoBaty = playerTwoBaty - 10
        end
        if love.keyboard.isDown("down") then
            playerTwoBaty = playerTwoBaty + 10
        end
        if love.keyboard.isDown("left") then
            playerTwoBatX = playerTwoBatX - 10
        end
        if love.keyboard.isDown("right") then
            playerTwoBatX = playerTwoBatX + 10
        end

        -- Prevent bats from leaving the court area
        playerOneBatX = math.max(courtX, math.min(playerOneBatX, courtX + courtWidth - batSizeWidth))
        playerTwoBatX = math.max(courtX, math.min(playerTwoBatX, courtX + courtWidth - batSizeWidth))
        playerOneBaty = math.max(courtY, math.min(playerOneBaty, courtY + courtHeight - batSizeHeight))
        playerTwoBaty = math.max(courtY, math.min(playerTwoBaty, courtY + courtHeight - batSizeHeight))
    end
end

function love.draw()
    if gameState == "menu" then
        love.graphics.setColor(1, 1, 1)

        local ww = love.graphics.getWidth()
        local wh = love.graphics.getHeight()
        local button_width = ww * 0.3
        local margin = 16
        local cursor_y = 0

        local total_height = (BUTTON_HEIGHT + margin) * #buttons
        for i, button in ipairs(buttons) do
            button.last = button.now

            local bx = (ww * 0.5) - (button_width * 0.5)
            local by = (wh * 0.5) - (BUTTON_HEIGHT * 0.5) - (total_height * 0.5) + cursor_y

            local color = {0.4, 0.4, 0.5, 1.0}

            local mx, my = love.mouse.getPosition()

            local hot = mx > bx and mx < bx + button_width and
                        my > by and my < by + BUTTON_HEIGHT

            if hot then
                color = {0.8, 0.8, 1.0, 2.0}
            end

            button.now = love.mouse.isDown(1)

            if button.now and not button.last and hot then
                button.fn()
            end

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill",
                bx,
                by,
                button_width,
                BUTTON_HEIGHT)

            local textW = font:getWidth(button.text)
            local textH = font:getHeight(button.text)

            love.graphics.setColor(1, 0, 0)
            love.graphics.printf(
                button.text,
                font,
                bx,
                by + (BUTTON_HEIGHT - textH) / 2,
                button_width,
                "center"
            )

            love.graphics.setColor(1, 1, 1)

            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
        end

    elseif gameState == "game" then
        love.graphics.setColor(1, 1, 1)

        love.graphics.rectangle("fill", playerOneBatX, playerOneBaty, batSizeWidth, batSizeHeight)
        love.graphics.rectangle("fill", playerTwoBatX, playerTwoBaty, batSizeWidth, batSizeHeight)
        love.graphics.circle("fill", ballX, ballY, ballRadius)

        love.graphics.rectangle("line", courtX, courtY, courtWidth, courtHeight)

        local midX = courtX + courtWidth / 2
        love.graphics.line(midX, courtY, midX, courtY + courtHeight)

        love.graphics.print("Player One Score: " .. playerOneScore, courtY, 10)
        love.graphics.print("Player Two Score: " .. playerTwoScore, courtX + courtWidth - 150, 10)
        love.graphics.print("Game Timer: " .. math.ceil(gameTimer), (love.graphics.getWidth()) / 2, 10)

        if gameTimer == 0 or playerOneScore == 10 or playerTwoScore == 10 then
            love.graphics.setColor(1, 1, 0)
            love.graphics.printf("Game Over!", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
        end

        love.graphics.print("Horizontal / BallX Speed: " .. ballSpeedX,250)
        love.graphics.print("vertical / Bally Speed: " .. ballSpeedY,1000)
    end
end

function love.keypressed(key)
    if key == "space" then
        if isPlaying then
            love.audio.pause()
        else
            love.audio.play()
        end
        isPlaying = not isPlaying
    end
end
