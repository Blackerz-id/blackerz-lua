-- credits...

-- bottom text

local coro = require("coro-http")
local JSON = require("json")
local fs = require("fs")

local configs = JSON.parse(fs.readSync(fs.openSync("./endpoints.json")))
local blackerzMT = {}
blackerzMT.__index = blackerzMT

local baseURL = configs.baseURL
local endpoints = configs.url

function fixURL(url, ...)
  return (baseURL..url):format(...)
end

-- Previous function was  `blackerz:auth()`
function blackerzMT:verify(v1, dID)
   self.t = v1
   self.d = dID -- latest version; client id is now optional
   return self
end

function blackerzMT:botData(id)
   local res, body = coro.request("GET", fixURL(endpoints.getBotData, id), {{["Content-Type"] = "application/json"}})
   return JSON.parse(body) -- result
end

function blackerzMT:editBot(id, info)
    assert(self.t, "use blackerz:auth(v1 token, devID?) first to edit bots.")
    assert(type(info)=="table", "#2 params must be valid table")
    
    local data = {}

    if type(info.shortDescription) == "string" and #info.shortDescription <= 120 and #info.shortDescription > 0 then data.shortDescription = info.shortDescription end
    if type(info.longDescription) == "string" and #info.longDescription < 2000 and #info.longDescription > 0 then data.longDescription = info.longDescription end
    if type(info.prefix) == "string" and #info.prefix < 6 and #info.prefix > 0 then data.prefix = info.prefix end
    if type(info.tags) == "table" then data.tags = info.tags end

    local res, body = coro.request("POST", fixURL(endpoints.editBotData, id), {{
      ["Content-Type"] = "application/json",
      ["Authorization"] = self.t,
      ["clientId"] = self.d
    }}, JSON.stringify(data))
  
    return res.code == 201, JSON.parse(body) -- success: (true|false), body: data returned by server.
end

function blackerz()
  local self = setmetatable({}, blackerzMT)

  -- todo: check any param on this function and set it to self.t/self.d
  
  return self
end

return blackerz
