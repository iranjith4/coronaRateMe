-- Created by Ranjithkumar Matheswaran on 20 Jan 2016
-- For Womi Studios by Perk.com
-- ╦ ╦╔═╗╔╦╗╦  ╔═╗╔╦╗╦ ╦╔╦╗╦╔═╗╔═╗
-- ║║║║ ║║║║║  ╚═╗ ║ ║ ║ ║║║║ ║╚═╗
-- ╚╩╝╚═╝╩ ╩╩  ╚═╝ ╩ ╚═╝═╩╝╩╚═╝╚═╝
--
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--PLEASE EDIT THIS VALUES AS PER APP ||||||||||||||||||||||||||||||||||||||||||||
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
local firstAlertAfter = 4
local laterAlertAfter = 4
local appIconUrl = "Icon-60.png"
local appStoreId = "id1025709661"
local androidPackageName = ""
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
local json = require "json"
local M = {}

function M.firstAlertAfter()
  return getFirstAlertAfter
end

function M.laterAlertAfter()
  return laterAlertAfter
end

function M.appIconUrl ()
  return appIconUrl
end

function M.appStoreId()
  return appStoreId
end

function M.androidPackageName ()
  return androidPackageName
end


function loadTable(filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
         -- read all contents of file into a string
         local contents = file:read( "*a" )
         myTable = json.decode(contents);
         io.close( file )
         return myTable
    end
    return nil
end

function saveTable(t, filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

function checkForRateMeData()
	local rateMeFile = loadTable("rateMeFile.json")
	if rateMeFile == nil then
		rateMeFile = {}
		rateMeFile.showAlert = true
    rateMeFile.appLaunchCount = 0
    rateMeFile.nextAlertIn = firstAlertAfter
    rateMeFile.status = "NONE"
    rateMeFile.automatic = true
		saveTable(rateMeFile,"rateMeFile.json")
	end
end

function M.getAppLaunchCount()
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  return data.appLaunchCount
end

function M.getStatus()
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  return data.status
end

function changeNextAlertIn(value)
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  data.nextAlertIn = value
  saveTable(data,"rateMeFile.json")
end

function M.checkForAlert()
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  if data.showAlert == true then
    if data.nextAlertIn == data.appLaunchCount then
      return true
    else
      if data.nextAlertIn < data.appLaunchCount then
        changeNextAlertIn(data.appLaunchCount + 4)
      end
      return false
    end
  else
    return false
  end
end

function M.automaticAlert(isAlert)
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  data.automatic = isAlert
  saveTable(data,"rateMeFile.json")
end

function M.appLaunch()
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  local appLaunchCount = data.appLaunchCount
  data.appLaunchCount = appLaunchCount + 1
  saveTable(data,"rateMeFile.json")
end

function M.neverAskAgain()
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  data.showAlert = false
  data.status = "NEVER"
  saveTable(data,"rateMeFile.json")
end

function M.rated ()
  -- body...
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  data.showAlert = false
  data.status = "RATED"
  saveTable(data,"rateMeFile.json")
end


function M.remindMeLater()
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  local nextAlert = data.nextAlertIn
  data.nextAlertIn = nextAlert + laterAlertAfter
  data.status = "LATER"
  saveTable(data,"rateMeFile.json")
end

function M.getNewHeight(image , newWidth)
    local r = image.width / image.height
    local newHeight = newWidth / r
    return newHeight
end

function M.osType()
    local os = system.getInfo("platformName")
    if ( os == "iPhone OS") then
        return "ios"
    elseif ( os == "Android" ) then
        return "android"
    end
end

return M
