local composer = require "composer"
local rateMe = require "coronaRateMe.rateMeUtilities"

rateMe.appLaunch()
rateMe.automaticAlert(true)
composer.gotoScene("menu")
