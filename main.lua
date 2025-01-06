-- initializing whos turn it is for when the ball hits the bat to determine who gets the point 
playOnesTurn = true
playerTwosTurn = false

-- Initialize sound
sound = love.audio.newSource("/retro-gaming-271301.mp3", "stream")

-- Ball position and size
local ballX = math.min(50, love.graphics.getWidth() - 50)
local ballY = math.min(50, love.graphics.getHeight() - 50)

local ballRadius = 10

local playerOneScore = 0
local playerTwoScore = 0

--game timer
gameTimer = 350

-- speed given to the players bats
playBatSpeed = 100

-- sizeing of the game area
local courtX = 10
local courtY = 30
local courtWidth = (720 - 30)
local courtHeight = (1280 - 30)

-- creating bat parameters
local playerOneBatX, playerOneBaty = 10, 250
local playerTwoBatX, playerTwoBaty = courtHeight, 250
local batSizeWidth = 10
local batSizeHeight = 50

-- Track whether music is playing
isPlaying = true

-- attempting to create a menu for my pong game:

BUTTON_HEIGHT = 64

local buttons = {}

function newButton(text, fn)
    return {
        text = text,
        fn = fn
    }
end

function love.load()
    -- changing the font
    font = love.graphics.newFont(25)

    -- Play the game sound on load
    love.audio.play(sound)

    background = love.graphics.newImage("troll.jpeg")

    -- trying to load in my buttons:
    table.insert(buttons, newButton(
        "start game",
        function()
            print("Starting game")
        end))

    table.insert(buttons, newButton(
        "Load game",
        function()
            print("Loading game")
        end))

    table.insert(buttons, newButton(
        "Settings",
        function()
            print("going to settings menu")
        end))

    table.insert(buttons, newButton(
        "exit",
        function()
            love.event.quit(0)
        end))
end

function love.update(dt)
    -- Decrease the timer
    gameTimer = gameTimer - dt
    if gameTimer <= 0 then
        gameTimer = 0
    end

    ballX = ballX + playBatSpeed * dt -- Moves the ball to the right over time (dt - distance over time )
end

function love.draw()
    love.graphics.setColor(1, 1, 1) -- Set color to white

    love.graphics.rectangle("fill", playerOneBatX, playerOneBaty, batSizeWidth, batSizeHeight)
    love.graphics.rectangle("fill", playerTwoBatX, playerTwoBaty, batSizeWidth, batSizeHeight)
    love.graphics.rectangle("line", courtX, courtY, courtHeight, courtWidth)

    -- Draw the game ball
    love.graphics.circle("fill", ballX, ballY, ballRadius)

    -- Draw player scores and the timer
    love.graphics.print("Player One Score: " .. playerOneScore, courtY, 10)
    love.graphics.print("Player Two Score: " .. playerTwoScore, courtX + courtHeight - 150, 10)
    love.graphics.print("Game - Timer: " .. math.ceil(gameTimer), (love.graphics.getWidth()) / 2, 10)

    -- Game over condition
    if gameTimer == 0 or playerOneScore == 10 or playerTwoScore == 10 then
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf("Game Over!", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
    end

    -- player one movement:
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

    -- player two movement:
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

    -- Player 1's paddle
    playerOneBaty = math.max(courtY, math.min(playerOneBaty, courtY + courtHeight - batSizeHeight))

    -- Player 2's paddle
    playerTwoBaty = math.max(courtY, math.min(playerTwoBaty, courtY + courtHeight - batSizeHeight))

    -- Drawing buttons
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local button_width = ww * 0.3
    local margin = 16
    local cursor_y = 0

    local total_height = (BUTTON_HEIGHT + margin) * #buttons
    for i, button in ipairs(buttons) do
        local bx = (ww * 0.5) - (button_width * 0.5)
        local by = (wh * 0.5) - (BUTTON_HEIGHT * 0.5) - (total_height * 0.5) + cursor_y

        local color = 

        love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)

        local textW = font:getWidth(button.text)
        local textH = font:getHeight(button.text)

        love.graphics.setColor(1, 0, 0) -- Set color to red for text
        love.graphics.printf(
            button.text,
            font,
            bx,
            by + (BUTTON_HEIGHT - textH) / 2,
            button_width,
            "center"
        )

        love.graphics.setColor(1, 1, 1) -- Set color back to white for next button background

        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end
end

function love.keypressed(key)
    if key == "space" then
        if isPlaying then
            love.audio.pause(sound) -- Pause the music
        else
            love.audio.play(sound) -- Play the music
        end
        isPlaying = not isPlaying -- Toggle the state
    end
end
