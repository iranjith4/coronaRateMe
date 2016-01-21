# Corona Rate Me !
Asking rating to the app users made easy for games made with Corona SDK.

Made for Womi Studios, by Perk.com Inc.

##How to Integrate
* Download the repo, copy the `coronaRateMe` folder and paste at the root folder of your game where the `main.lua` is there.

##How to Use

You can use either
  1. Automatic Rating Popup
  2. Custom Call Event

### 1. Automatic Rating Popup

When you choose to use the `Automatic Rating`, You just need to mention the place where you need the Popup. Rest will be taken care. By default, the popup will be up, when the user launches for 4th time. When the user selects `Remind Me Later`, it will be asked when the app is launched 8th time (frequency = 4).

In the `main.lua` add the following code

```lua
local rateMeUtilities = require "coronaRateMe.rateMeUtilities"
rateMeUtilities.appLaunch()
rateMeUtilities.automaticAlert(true)
```

Then, at the place where you want the Popup to be automatically showed, add these below code.

```lua
local rateMeUtilities = require "coronaRateMe.rateMeUtilities"

if rateMeUtilities.checkForAlert() then
    local options =
    {
      isModal = true,
      effect = "fade",
      time = 200,
      params = {
        text = "Would you like to rate the App ?",
      }
    }
  composer.showOverlay("coronaRateMe.rateMe",options)
end
```

Best place to add the above code will be after the Game complete, or high score achieve.

Thats it !!


