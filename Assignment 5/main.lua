-----------------------------------------------------------------------------------------
--
-- Created by: Aden Rao
-- Created on: April 21, 2019
--
-- This program is a game where there is a character and he has to pick up apples that are falling from trees into a basket by moving the character the around. For every apple they pick up the player gets one point. If an apple hits the ground then the player gets an x and once they get 3 Xs the game is over. If they collect a poisonous apple then the game also ends.  
--
-----------------------------------------------------------------------------------------

-- Hides status bar
--------------------
display.setStatusBar(display.HiddenStatusBar)
--------------------

-- Score and lives variables
----------------
local score = 0
local lives = 3
----------------

-- Physics
---------------------
local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
-- physics.setDrawMode( "hybrid" ) 
------------------------

-- Ground image with physics
-------------------
local theGround = display.newImageRect( "assets/land.jpg", 565, 320)
theGround.x = display.contentCenterX
theGround.y = display.contentHeight + 114
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.7 
    } )
-------------------

-- Background image 
---------------------
local background = display.newImageRect("assets/background.png", 565, 320)
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = "background"
----------------------

-- Character sprite and physics for the character
-----------------------
local character = display.newImageRect("assets/person2.png", 120, 150)
character.x = display.contentCenterX
character.y = display.contentCenterY + 37
character.id = "character"
physics.addBody( character, "dynamic", { 
    density = 1.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
-----------------------

-- Score counter image
----------------------
local scoreCounter = display.newImageRect( "assets/scoreindicator.png", 100, 75 )
scoreCounter.x = 10
scoreCounter.y = 280
scoreCounter.id = "scoreCounter"
----------------------

--Score counter text in the bottom left
scoreText = display.newText( "Score: " .. score, display.contentCenterX - 230, display.contentCenterY + 131, native.systemFont, 22 )
scoreText:setFillColor( 0 )

-- Lives text in the bottom right
livesText = display.newText( "Lives: " .. lives, display.contentCenterX + 230, display.contentCenterY + 142.5, native.systemFont, 22 )
livesText:setFillColor( 0 )

-- Left and right arrows for controlling the character but just the images
------------------------
local leftArrow = display.newImageRect( "./assets/leftArrow.png", 25, 35 )
leftArrow.x = display.contentCenterX - 50
leftArrow.y = display.contentHeight - 20
leftArrow.id = "left arrow"

local rightArrow = display.newImageRect( "./assets/rightArrow.png", 25, 35 )
rightArrow.x = display.contentCenterX + 35
rightArrow.y = display.contentHeight - 20
rightArrow.id = "right arrow"
-------------------------

-- Functions for the left and right arrow that give the images the ability to move the character
-----------------------------------
function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character left
        transition.moveBy( character, { 
        	x = -50, -- move -50 in the x direction 
        	y = 0, 
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character right
        transition.moveBy( character, { 
        	x = 50, -- move 50 in the x direction 
        	y = 0, 
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end
---------------------------------------

-- Right and left wall to stop the character from falling of the map
--------------------

-- Left wall
local leftWall = display.newRect( -40, display.contentHeight / 2, 1, display.contentHeight )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

-- Right wall
local rightWall = display.newRect( 522, display.contentHeight, 1, display.contentHeight + 500)
rightWall.alpha = 0.0
physics.addBody( rightWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

--------------------

-- Instruction image(text), the text that tells the user how to play the game
-----------------------
local instructions = display.newImageRect("assets/instructions.png", 550, 300)
instructions.x = display.contentCenterX
instructions.y = display.contentCenterY
instructions.id = "instruction text"
------------------------

-- The fucntion that makes the instruction text go away when the user click the start button
function instructions:touch( event )
    if ( event.phase == "ended" ) then
        instructions:removeSelf()

-- Apple image that is in a while loop to keep on dropping apples until the lives is 0 and it also drops them at random places from the top.
------------------
while(lives > 0) do
    local apple = display.newImageRect("Assets/apple.png", 35, 35)
    apple.x = math.random (1, 300)
    apple.y = 0
    apple.id = "apple"
    physics.addBody( apple, "dynamic", { 
        friction = 0.5, 
        bounce = 0.3,
        } )
    apple.isFixedRotation = true
    timer.performWithDelay(3)
end
-------------------

-- Fucntion for the collision detection of the apple
local function appleCollision( self, event )

 
    if ( event.phase == "began" ) then -- If statement for determing what sprite the apple hit

        if event.other.id == "character" then -- Id statement for the apple hitting the character
            local ding = audio.loadSound("sounds/ding.mp3")
            audio.play(ding)
            apple:removeSelf()
            score = score + 1
            scoreText.text = ("Score: ".. score)
            print( character.id .. ": collision began with " .. event.other.id )
        end
    elseif ( event.phase == "ended" ) then
        lives = lives - 1
        livesText.text = ("Lives: ".. lives) 
        local gameOverSound = audio.loadSound("sounds/gameover.mp3")
        audio.play(gameOverSound)
        apple:removeSelf()
        print( character.id .. ": collision ended with " .. event.other.id )
    end
end

-- Event listeners for the apple collision
apple:addEventListener( "collision", apple )
apple.collision = appleCollision

    end

    return true
end
----------------------

-- Event listeners for the left and right arrows and the instructions (touch events) and there is also a collision event listener for the character
leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )
instructions:addEventListener( "touch", instructions )
character:addEventListener( "collision", character )
character.collision = characterCollision