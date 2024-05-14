local config = {
  sort_case_insensitive = true, -- used when sorting files and directories in the tree
  default_component_configs = { indent = { padding = 2 } },
  source_selector = {
    winbar = true,
    statusline = false,
    sources = {
      { source = "filesystem" },
      { source = "buffers" },
    },
    content_layout = "center",
  },
  window = {
    position = "left",
    mappings = {
      ["o"] = "open",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["z"] = "close_all_nodes",
      ["Z"] = "expand_all_nodes",
      ["a"] = { "add", config = { show_path = "relative" } },
      ["A"] = { "add_directory", config = { show_path = "relative" } },
      ["r"] = { "rename", config = { show_path = "relative" } },
      ["y"] = { "copy_to_clipboard", config = { show_path = "relative" } },
      ["x"] = { "cut_to_clipboard", config = { show_path = "relative" } },
      ["p"] = { "paste_from_clipboard", config = { show_path = "relative" } },
    },
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
end
