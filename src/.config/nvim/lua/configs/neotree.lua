local existing_paths = {}
local function open_grug_far(paths, merge)
  local grug_far = require("grug-far")

  if not grug_far.has_instance("explorer") then
    grug_far.open({ instanceName = "explorer" })
  else
    grug_far.open_instance("explorer")
  end
  if merge then
    for _, value in ipairs(existing_paths) do
      if not vim.tbl_contains(paths, value) then
        table.insert(paths, value)
      end
    end
  end
  grug_far.update_instance_prefills("explorer", { paths = table.concat(paths, " ") }, false)
  existing_paths = paths
end

local config = {
  sort_case_insensitive = true, -- used when sorting files and directories in the tree
  default_component_configs = { indent = { padding = 2 } },
  source_selector = {
    winbar = true,
    statusline = false,
    sources = {
      { source = "filesystem" },
      { source = "buffers" },
      { source = "git_status" },
    },
    content_layout = "center",
  },
  window = {
    position = "left",
    mappings = {
      ["/"] = "noop",
      ["o"] = "open",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["a"] = { "add", config = { show_path = "relative" } },
      ["A"] = { "add_directory", config = { show_path = "relative" } },
      ["r"] = { "rename", config = { show_path = "relative" } },
      ["y"] = { "copy_to_clipboard", config = { show_path = "relative" } },
      ["x"] = { "cut_to_clipboard", config = { show_path = "relative" } },
      ["p"] = { "paste_from_clipboard", config = { show_path = "relative" } },
      ["Z"] = "grug_far_replace_merge",
      ["z"] = "grug_far_replace",
      ["f"] = "noop",
      ["ff"] = "find_files_fzf",
      ["fw"] = "find_word_fzf",
      ["h"] = "close_node",
      ["l"] = "open_node",
    },
  },
  commands = {
    open_node = function(state)
      local cc = require("neo-tree.sources.filesystem.commands")
      local node = state.tree:get_node()
      if node.type == "directory" then
        cc.open(state)
        vim.fn.feedkeys("j")
      end
    end,
    find_files_fzf = function(state)
      local node = state.tree:get_node()
      local cwd = node.type == "directory" and vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":p"))
        or vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":h"))
      vim.cmd("FzfLua files cwd=" .. cwd)
    end,
    find_word_fzf = function(state)
      local node = state.tree:get_node()
      local cwd = node.type == "directory" and vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":p"))
        or vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":h"))
      vim.cmd("FzfLua live_grep cwd=" .. cwd)
    end,
    grug_far_replace_merge = function(state)
      open_grug_far({ vim.fn.fnameescape(vim.fn.fnamemodify(state.tree:get_node():get_id(), ":~")) }, true)
    end,
    grug_far_replace_merge_visual = function(_, selected_nodes)
      local paths = {}
      for _, node in pairs(selected_nodes) do
        table.insert(paths, vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":~")))
      end
      open_grug_far(paths, true)
    end,
    grug_far_replace = function(state)
      open_grug_far({ vim.fn.fnameescape(vim.fn.fnamemodify(state.tree:get_node():get_id(), ":~")) })
    end,
    grug_far_replace_visual = function(_, selected_nodes)
      local paths = {}
      for _, node in pairs(selected_nodes) do
        table.insert(paths, vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":~")))
      end
      open_grug_far(paths)
    end,
  },

  filesystem = {
    filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = true, hide_hidden = false },
    follow_current_file = { enabled = true },
    group_empty_dirs = false, -- when true, empty folders will be grouped together
    window = { mappings = { ["b"] = "navigate_up", ["O"] = "set_root" } },
  },
}
return function()
  -- Unless you are still migrating, remove the deprecated commands from v1.x
  vim.g.neo_tree_remove_legacy_commands = 1

  require("neo-tree").setup(config)
  require("lsp-file-operations").setup()
end
