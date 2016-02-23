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
local buttonWidth
local popupHeight = 0
if rateMeUtilities.getOrientation() == "portrait" then
  buttonWidth = alertWidth * 0.80
else
  buttonWidth = alertWidth * 0.40
end
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

    local popupGroup = display.newGroup()
    popupGroup.width = display.contentWidth
    popupGroup.height = 0
    local params = event.params

    local background = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight + 200)
    background:setFillColor(0,0,0,0.8)
    sceneGroup:insert(background)


    local topBg
    if rateMeUtilities.getOrientation() == "portrait" then
      topBg = display.newImage("coronaRateMe/gray_top.png")
    else
      topBg = display.newImage("coronaRateMe/gray_top_l.png")
    end
    topBg.height = rateMeUtilities.getNewHeight(topBg,alertWidth)
    topBg.width = alertWidth
    topBg.x = display.contentCenterX
    if rateMeUtilities.getOrientation() == "portrait" then
      topBg.y =  topBg.height / 2
    else
      topBg.y =  topBg.height / 2
    end
    popupGroup:insert(topBg)

    popupHeight = popupHeight + topBg.height

    --Adding the Stars -  Only for landscape
    if rateMeUtilities.getOrientation() == "landscape" then
      local topbgStars = display.newImage("coronaRateMe/star_top_l.png")
      topbgStars.width = rateMeUtilities.getNewWidth(topbgStars,topBg.height - 5)
      topbgStars.height = topBg.height - 5
      topbgStars.x = display.contentCenterX
      topbgStars.y = topBg.y
      popupGroup:insert(topbgStars)
    end

    --Adding the App Name
    if rateMeUtilities.getOrientation() == "portrait" then
      local appNameOptions =
      {
        text = rateMeUtilities.getAppName(),
        width = alertWidth,     --required for multi-line and alignment
        font = native.systemFontBold,
        x = display.contentCenterX,
        fontSize = 16,
        align = "center"
      }
      local appTitle = display.newText( appNameOptions )
      appTitle.y = appTitle.height / 2 + 12
      popupGroup:insert(appTitle)
    end

    --Adding the App Icon
    local appIconD
    if rateMeUtilities.getOrientation() == "portrait" then
      appIconD = alertWidth * 0.25
    else
      appIconD = alertWidth * 0.15
    end
    local appIcon = display.newImageRect(appIconUrl,appIconD, appIconD)
    appIcon.x = display.contentCenterX
    if rateMeUtilities.getOrientation() == "portrait" then
      appIcon.y = topBg.y + topBg.height / 2 - appIconD / 2 - 20
    else
      appIcon.y = topBg.y + topBg.height / 2 - appIconD / 2 - 12
    end
    popupGroup:insert(appIcon)

    local middleBg
    if rateMeUtilities.getOrientation() == "portrait" then
      middleBg = display.newImage("coronaRateMe/blue_centre.png")
    else
      middleBg = display.newImage("coronaRateMe/blue_centre_l.png")
    end
    middleBg.height = rateMeUtilities.getNewHeight(middleBg,alertWidth)
    middleBg.width = alertWidth
    middleBg.x = display.contentCenterX
    middleBg.y = topBg.y + topBg.height / 2 + middleBg.height / 2
    popupGroup:insert(middleBg)

    popupHeight = popupHeight + middleBg.height

    local dummyTextOptions = {
      text = params.text,
      x = middleBg.x,
      y =  middleBg.y,
      width = alertWidth,     --required for multi-line and alignment
      font = native.systemFont,
      fontSize = 14,
      align = "center"
    }

    local dummyText = display.newText( dummyTextOptions )

    local textFontSize
    if dummyText.height > 18 then
      textFontSize = 11
    else
      textFontSize = 14
    end

    dummyText:removeSelf()
    dummyText = nil

    local textOptions =
    {
      text = params.text,
      x = middleBg.x,
      y =  middleBg.y,
      width = alertWidth,     --required for multi-line and alignment
      font = native.systemFont,
      fontSize = textFontSize,
      align = "center"
    }
    local text = display.newText( textOptions )
    text:setFillColor( 1, 1, 1 )
    print("Height of text")
    print(text.height)
    text.scale = 0.1
    popupGroup:insert(text)

    local bottomBg
    if rateMeUtilities.getOrientation() == "portrait" then
      bottomBg = display.newImage("coronaRateMe/bottom_bg.png")
    else
      bottomBg = display.newImage("coronaRateMe/bottom_bg_l.png")
    end
    bottomBg.height = rateMeUtilities.getNewHeight(bottomBg,alertWidth)
    bottomBg.width = alertWidth
    bottomBg.x = display.contentCenterX
    bottomBg.y = middleBg.y + middleBg.height / 2 + bottomBg.height / 2
    popupGroup:insert(bottomBg)

    popupHeight = popupHeight + bottomBg.height

    --Adding Star
    local starX = display.contentCenterX - 4 * starWidth
    local starY
    if rateMeUtilities.getOrientation() == "portrait" then
      starY = bottomBg.y - bottomBg.height / 2 + starWidth
    else
      starY = bottomBg.y - bottomBg.height / 2 + starWidth + 5
    end

    for i = 0,4,1 do
      local star = display.newImage("coronaRateMe/star.png")
      star.height = rateMeUtilities.getNewHeight(star,starWidth)
      star.width = starWidth
      star.x = starX
      star.y = starY
      starX = starX + 2 * starWidth
      popupGroup:insert(star)
    end

    local rateNowButton
    if rateMeUtilities.getOrientation() == "portrait" then
      rateNowButton = display.newImage("coronaRateMe/button_rate_now.png")
    else
      rateNowButton = display.newImage("coronaRateMe/button_rate_now_l.png")
    end
    rateNowButton.height = rateMeUtilities.getNewHeight(rateNowButton,buttonWidth)
    rateNowButton.width = buttonWidth
    rateNowButton.x = display.contentCenterX

    if rateMeUtilities.getOrientation() == "portrait" then
      rateNowButton.y = starY + starWidth * 2
    else
      rateNowButton.y = starY + starWidth * 2.5
    end
    rateNowButton:addEventListener("touch",rateNowListener)
    popupGroup:insert(rateNowButton)

    local remindMeButton = display.newImage("coronaRateMe/button_remind.png")
    remindMeButton.height = rateMeUtilities.getNewHeight(remindMeButton, buttonWidth)
    remindMeButton.width = buttonWidth

    if rateMeUtilities.getOrientation() == "portrait" then
      remindMeButton.x = display.contentCenterX
      remindMeButton.y = rateNowButton.y + rateNowButton.height
    else
      remindMeButton.x = display.contentCenterX - buttonWidth / 2 - 10
      remindMeButton.y = rateNowButton.y + rateNowButton.height + 5
    end
    remindMeButton:addEventListener("touch",remindMeLaterListener)
    popupGroup:insert(remindMeButton)

    local noThanksButton = display.newImage("coronaRateMe/button_no_thanks.png")
    noThanksButton.height = rateMeUtilities.getNewHeight(noThanksButton, buttonWidth)
    noThanksButton.width = buttonWidth
    if rateMeUtilities.getOrientation() == "portrait" then
      noThanksButton.x = display.contentCenterX
      noThanksButton.y = remindMeButton.y + remindMeButton.height
    else
      noThanksButton.x = display.contentCenterX + buttonWidth / 2 + 10
      noThanksButton.y = rateNowButton.y + rateNowButton.height + 5
    end
    noThanksButton:addEventListener("touch",noThanksListener)
    popupGroup:insert(noThanksButton)

    sceneGroup:insert(popupGroup)
    popupGroup.height = popupHeight
    popupGroup.y = display.contentHeight / 2 - popupHeight / 2

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
