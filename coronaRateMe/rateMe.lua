-- Created by Ranjithkumar Matheswaran on 20 Jan 2016
-- For Womi Studios by Perk.com
-- ╦ ╦╔═╗╔╦╗╦  ╔═╗╔╦╗╦ ╦╔╦╗╦╔═╗╔═╗
-- ║║║║ ║║║║║  ╚═╗ ║ ║ ║ ║║║║ ║╚═╗
-- ╚╩╝╚═╝╩ ╩╩  ╚═╝ ╩ ╚═╝═╩╝╩╚═╝╚═╝
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
local composer = require( "composer" )
local rateMeUtilities = require ("coronaRateMe.rateMeUtilities")

local firstAlertAfter = rateMeUtilities.firstAlertAfter()
local laterAlertAfter = rateMeUtilities.laterAlertAfter()
local appIconUrl = rateMeUtilities.appIconUrl()
local appStoreId = rateMeUtilities.appStoreId()
local androidPackageName = rateMeUtilities.androidPackageName()
local alertWidth = display.contentWidth * 0.80
local buttonWidth = alertWidth * 0.80
local starWidth = buttonWidth / 10

local scene = composer.newScene()

local function rateNowDone()
  rateMeUtilities.rated()
  composer.hideOverlay( "fade", 200 )
end


-- Button Call backs
local function rateNowListener(event)
  if event.phase == "ended" then
    if rateMeUtilities.osType() == "ios" then
      local url = "itms-apps://itunes.apple.com/app/"..appStoreId
      system.openURL(url)
    elseif rateMeUtilities.osType() == "android" then
      local url = "market://details?id="..androidPackageName
      system.openURL(url)
    end
    rateNowDone()
  end
end

local function remindMeLaterListener(event)
  if event.phase == "ended" then
    composer.hideOverlay( "fade", 200 )
    rateMeUtilities.remindMeLater()
  end
end

local function noThanksListener(event)
  if event.phase == "ended" then
    composer.hideOverlay( "fade", 200 )
    rateMeUtilities.neverAskAgain()
  end
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    local background = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight + 200)
    background:setFillColor(0,0,0,0.8)
    sceneGroup:insert(background)

    local topBg = display.newImage("coronaRateMe/gray_top.png")
    topBg.height = rateMeUtilities.getNewHeight(topBg,alertWidth)
    topBg.width = alertWidth
    topBg.x = display.contentCenterX
    topBg.y = display.contentHeight * 0.30
    sceneGroup:insert(topBg)

    --Adding the App Icon
    local appIconD = alertWidth * 0.25
    local appIcon = display.newImageRect(appIconUrl,appIconD, appIconD)
    appIcon.x = display.contentCenterX
    appIcon.y = topBg.y + topBg.height / 2 - appIconD / 2 - 20
    appIcon.cornerRadius = 50
    sceneGroup:insert(appIcon)

    local middleBg = display.newImage("coronaRateMe/blue_centre.png")
    middleBg.height = rateMeUtilities.getNewHeight(middleBg,alertWidth)
    middleBg.width = alertWidth
    middleBg.x = display.contentCenterX
    middleBg.y = topBg.y + topBg.height / 2 + middleBg.height / 2
    sceneGroup:insert(middleBg)

    local text = display.newText( "Hello World!", middleBg.x, middleBg.y, native.systemFont, 15 )
    text:setFillColor( 1, 1, 1 )
    sceneGroup:insert(text)

    local bottomBg = display.newImage("coronaRateMe/bottom_bg.png")
    bottomBg.height = rateMeUtilities.getNewHeight(bottomBg,alertWidth)
    bottomBg.width = alertWidth
    bottomBg.x = display.contentCenterX
    bottomBg.y = middleBg.y + middleBg.height / 2 + bottomBg.height / 2
    sceneGroup:insert(bottomBg)

    --Adding Star
    local starX = display.contentCenterX - 4 * starWidth
    local starY = bottomBg.y - bottomBg.height / 2 + starWidth
    for i = 0,4,1 do
      local star = display.newImage("coronaRateMe/star.png")
      star.height = rateMeUtilities.getNewHeight(star,starWidth)
      star.width = starWidth
      star.x = starX
      star.y = starY
      starX = starX + 2 * starWidth
      sceneGroup:insert(star)
    end

    local rateNowButton = display.newImage("coronaRateMe/button_rate_now.png")
    rateNowButton.height = rateMeUtilities.getNewHeight(rateNowButton,buttonWidth)
    rateNowButton.width = buttonWidth
    rateNowButton.x = display.contentCenterX
    rateNowButton.y = starY + starWidth * 2
    rateNowButton:addEventListener("touch",rateNowListener)
    sceneGroup:insert(rateNowButton)

    local remindMeButton = display.newImage("coronaRateMe/button_remind.png")
    remindMeButton.height = rateMeUtilities.getNewHeight(remindMeButton, buttonWidth)
    remindMeButton.width = buttonWidth
    remindMeButton.x = display.contentCenterX
    remindMeButton.y = rateNowButton.y + rateNowButton.height
    remindMeButton:addEventListener("touch",remindMeLaterListener)
    sceneGroup:insert(remindMeButton)

    local noThanksButton = display.newImage("coronaRateMe/button_no_thanks.png")
    noThanksButton.height = rateMeUtilities.getNewHeight(noThanksButton, buttonWidth)
    noThanksButton.width = buttonWidth
    noThanksButton.x = display.contentCenterX
    noThanksButton.y = remindMeButton.y + remindMeButton.height
    noThanksButton:addEventListener("touch",noThanksListener)
    sceneGroup:insert(noThanksButton)
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
