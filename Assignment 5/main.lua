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

-- Left and right arrows
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

-- Functions for the left and right arrow to move the character
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

-- Right and left wall
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

-- Instruction image(text)
-----------------------
local instructions = display.newImageRect("assets/instructions.png", 550, 300)
instructions.x = display.contentCenterX
instructions.y = display.contentCenterY
instructions.id = "instruction text"
------------------------

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

-- Functions for instruction text and to make it so when the user clicks the start button the text goes away
----------------------

function instructions:touch( event )
	if ( event.phase == "ended" ) then
		instructions:removeSelf()

-- Apple image
------------------

local apple = display.newImageRect("Assets/apple.png", 35, 35)
apple.x = 160
apple.y = 0 
apple.id = "apple"
physics.addBody( apple, "dynamic", { 
    friction = 0.5, 
    bounce = 0.3,
    } )
apple.isFixedRotation = true

-------------------


local function appleCollision( character, event )
 
    if ( event.phase == "began" ) then
    	local ding = audio.loadSound("sounds/ding.mp3")
		audio.play(ding)
		apple:removeSelf()
		local counterText = display.newText( "1", display.contentCenterX - 260, display.contentCenterY + 130, native.systemFont, 30 )
		counterText:setFillColor( 0/255, 255/255, 255/255 )
        print( character.id .. ": collision began with " .. event.other.id )
    elseif ( event.phase == "ended" ) then
        print( character.id .. ": collision ended with " .. event.other.id )
    end
end

--local function appleCollision( theGround, event )
-- 
--    if ( event.phase == "began" ) then
--		local Xs = display.newImageRect( "assets/allgreyxs.png", 550, 375 )
--		Xs.x = display.contentCenterX
--		Xs.y = display.contentCenterY - 19
--		Xs.id = "xs"
--        print( theGround.id .. ": collision began with " .. event.other.id )
--    elseif ( event.phase == "ended" ) then
--        print( theGround.id .. ": collision ended with " .. event.other.id )
--    end
--end

apple:addEventListener( "collision", apple )
apple.collision = appleCollision
apple:addEventListener( "collision", apple )
apple.collision = appleCollision

    end

    return true
end
----------------------

leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )
instructions:addEventListener( "touch", instructions )
character:addEventListener( "collision", character )
character.collision = characterCollision