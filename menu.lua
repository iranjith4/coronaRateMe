-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
local widget = require ("widget")
local display = require ("display")
local rateMeUtilities = require "coronaRateMe.rateMeUtilities"

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function handleButtonEvent(event)
  if ( "ended" == event.phase ) then
      -- Calling the Show Rating
      local options =
      {
        isModal = true,
        effect = "fade",
        time = 200,
        params = {
          text = "Hello World !",
        }
      }

      composer.showOverlay("coronaRateMe.rateMe",options)
  end
end


-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view

    local background = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight + 200)
    background:setFillColor(1,0,1)
    sceneGroup:insert(background)


    local showRate = widget.newButton(
    {
        left = display.contentCenterX / 2,
        top = display.contentCenterY,
        id = "showRate",
        label = "Call Alert",
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        onEvent = handleButtonEvent
    })

    sceneGroup:insert(showRate)
    print(rateMeUtilities.getStatus())
    if rateMeUtilities.checkForAlert() then
      local options =
      {
        isModal = true,
        effect = "fade",
        time = 200,
        params = {
          text = "Hello World !",
        }
      }
      composer.showOverlay("coronaRateMe.rateMe",options)
    end

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
