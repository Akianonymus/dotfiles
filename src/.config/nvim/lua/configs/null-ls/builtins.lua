return function(builtins)
  local sources = {
    -- c/c++/java
    builtins.formatting.clang_format.with({ filetypes = { "java", "c", "cpp" } }),

    -- python
    -- builtins.formatting.black,
    -- builtins.formatting.isort,

    -- E501 - line too long
    -- W503 - line break before binary operator
    -- builtins.diagnostics.flake8.with({ extra_args = { "--ignore", "E501,W503" } }),

    -- rust
    -- builtins.formatting.rustfmt,

    -- php
    builtins.formatting.pretty_php,

    -- JS html css stuff
    builtins.formatting.prettierd.with({
      filetypes = { "html", "json", "scss", "css", "javascript", "javascriptreact", "typescript" },
    }),
    -- builtins.diagnostics.eslint.with({ command = "eslint_d" }),

    -- Lua
    builtins.formatting.stylua,
    require("none-ls-luacheck.diagnostics.luacheck").with({ extra_args = { "--global vim" } }),

    -- Shell
    builtins.formatting.shfmt,
    require("none-ls-shellcheck.diagnostics").with({ diagnostics_format = "#{m} [#{c}]" }),
    require("none-ls-shellcheck.code_actions"),
  }

  return sources
end
