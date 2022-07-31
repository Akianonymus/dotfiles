return function(builtins)
  local sources = {

    -- c/c++
    -- b.formatting.clang_format,

    -- python
    builtins.formatting.black,
    builtins.formatting.isort,

    -- E501 - line too long
    -- W503 - line break before binary operator
    builtins.diagnostics.flake8.with { extra_args = { "--ignore", "E501,W503" } },

    -- rust
    builtins.formatting.rustfmt,

    -- JS html css stuff
    builtins.formatting.prettierd.with {
      filetypes = { "html", "json", "scss", "css", "javascript", "javascriptreact", "typescript" },
    },
    --    b.diagnostics.eslint.with {
    --       command = "eslint_d",
    --    },

    -- Lua
    builtins.formatting.stylua,
    builtins.diagnostics.luacheck.with { extra_args = { "--global vim" } },

    -- Shell
    builtins.formatting.shfmt,
    builtins.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  }

  return sources
end
