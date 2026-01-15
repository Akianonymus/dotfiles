local config = {
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      local height = vim.api.nvim_win_get_height(0)
      return (height < 10 and height) or (height * 0.8)
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  -- i basically wanted to disable the mapping so lets use a russian alphabet
  open_mapping = [[д]],
  direction = "horizontal",
}

return function()
  require("toggleterm").setup(config)
end
