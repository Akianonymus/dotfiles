local Element = require("uosc_shared/elements/Element")

---@class Curtain : Element
local Curtain = class(Element)

function Curtain:new()
  return Class.new(self) --[[@as Curtain]]
end
function Curtain:init()
  Element.init(self, "curtain", { ignores_menu = true })
  self.opacity = 0
  ---@type string[]
  self.dependents = {}
end

---@param id string
function Curtain:register(id)
  self.dependents[#self.dependents + 1] = id
  if #self.dependents == 1 then
    self:tween_property("opacity", self.opacity, 1)
  end
end

---@param id string
function Curtain:unregister(id)
  self.dependents = itable_filter(self.dependents, function(item)
    return item ~= id
  end)
  if #self.dependents == 0 then
    self:tween_property("opacity", self.opacity, 0)
  end
end

function Curtain:render()
  if self.opacity == 0 or options.curtain_opacity == 0 then
    return
  end
  local ass = assdraw.ass_new()
  ass:rect(0, 0, display.width, display.height, {
    color = "000000",
    opacity = options.curtain_opacity * self.opacity,
  })
  return ass
end

return Curtain
