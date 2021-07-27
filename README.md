# Blackerz-SDK
a developer kit to interact with the blackerz api

**example**
```lua
local blackerz = require("./blackerz.lua")

local bots = blackerz()

bots:verify("v1 token", "devID")
bots:botData("0")
bots:editBot("0", {--[[ ... ]]})
```

You can clone this repository to use the API.
```
git clone Blackerz-id/blackerz-lua
```

Get your V1 auth by login to the blackerz website then visit your profile, here's the link
https://blackerz.herokuapp.com/

Developed by Andrew & Fastering18, join blackerz https://discord.gg/t7zJBwynFU for more information.
