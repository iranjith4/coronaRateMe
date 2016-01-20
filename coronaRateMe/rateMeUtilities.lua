local initialAlertCount = 4

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
    rateMeFile.appOpenCount = 0
    rateMeFile.nextAlertIn = initialAlertCount
		saveTable(rateMeFile,"rateMeFile.json")
	end
end

return M
