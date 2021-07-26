-- 

local coro = require("coro-http")
local json = require("json")

local web = "https://blackerz.herokuapp.com"

local ends = {
  bot = web .. "/api/v1/bots/-",
  edit = web .. "/api/v1/bots/-/edit"
}

function fix(url, id)
  local b = url:gsub('-', id)
  return b
end

function blackerz()
  local fns = {}

  function fns:auth(v1, dID)
    fns.t = v1
    fns.d = dID
  end

  function fns:botData(id)
    local res, body = coro.request("GET", fix(ends.bot, id), {{["Content-Type"] = "application/json"}})
    return json.parse(body) -- result
  end

  function fns:editBot(id, info)
    assert(fns.t, "use blackerz:auth(v1 token, devID) first to edit bots.")
    assert(fns.d, "you didn't input developer id in blackerz:auth(v1 token, devID)")
    assert(info, "you tried to edit a bot with nothing")

    local data = {}

    if info.shortDescription then data.shortDescription = info.shortDescription end

    coro.request("POST", fix(ends.edit, id), {{
      ["Content-Type"] = "application/json",
      ["Authorization"] = fns.t,
      ["clientId"] = fns.d
    }}, json.stringify(data))
  end

  return fns
end

return blackerz