-- Created by Ranjithkumar Matheswaran on 20 Jan 2016
-- For Womi Studios by Perk.com
--
local M = {}

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
    rateMeFile.nextAlertIn = initialAlertCount
		saveTable(rateMeFile,"rateMeFile.json")
	end
end


function M.appLaunch(initialCount)
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  local appLaunchCount = data.appLaunchCount
  data.appLaunchCount = initialCount + 1
  saveTable(data,"rateMeFile.json")
end

function M.neverAskAgain()
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  data.showAlert = false
  saveTable(data,"rateMeFile.json")
end


function M.remindMeLater(nextAlertFrequency)
  checkForRateMeData()
  local data = loadTable("rateMeFile.json")
  local nextAlert = data.nextAlertIn
  data.nextAlertIn = nextAlert + nextAlertFrequency
  saveTable(data,"rateMeFile.json")
end

function M.getNewHeight(image , newWidth)
    local r = image.width / image.height
    local newHeight = newWidth / r
    print("w",image.width,"h",image.height,"r",r,newHeight,newWidth)
    return newHeight
end


return M
