--- print with align support
---@param pos number - one of the positions from numpad
---@param msg string
---@param time number - amount of time it will be disaplyed
local function pprint(pos, msg, time)
  mp.command(string.format([[show-text "${osd-ass-cc/0}{\\an%s}${osd-ass-cc/1}%s" %s]], pos, msg, time))
end

local function on_pause_change(_, value)
  pprint(
    8,
    [[[${playlist-pos-1}/${playlist-count}] ${filename}\n${time-pos} / ${duration}${?percent-pos: ( ${percent-pos}% ) ]],
    value and 99999 or ""
  )
end

mp.register_event("file-loaded", function()
  -- always play on startup
  -- https://github.com/AN3223/dotfiles/blob/master/.config/mpv/scripts/always-play-on-startup.lua
  mp.set_property_bool("pause", false)

  mp.observe_property("pause", "bool", on_pause_change)
end)
