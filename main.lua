-- initializing whos turn it is for when the ball hits the bat to determine who gets the point 
playOnesTurn = true
playerTwosTurn = false

-- Initialize sound
sound = love.audio.newSource("/retro-gaming-271301.mp3", "stream") 

-- Ball position and size
local ballX = math.min(50, love.graphics.getWidth() - 50)
local ballY = math.min(50, love.graphics.getHeight() - 50)

local ballRadius = 10

playerOneScore = 0
playerTwoScore = 0

gameTimer = 350

playBatSpeed = 100

-- sizeing of the game area
local courtX= 10
local courtY = 30 
local courtWidth= (720-30)
local courtHeight  = (1280-30)

-- creating bat parameters
local playerOneBatX,playerOneBaty = 10,250
local playerTwoBatX,playerTwoBaty = courtHeight,250
local batSizeWidth = 10
local batSizeHeight = 50

-- Track whether music is playing
isPlaying = true

function love.load()
    -- changing the font
    gameFont = love.graphics.newFont(25)

    -- Play the game sound on load
    love.audio.play(sound) 

    background = love.graphics.newImage("troll.jpeg")
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
