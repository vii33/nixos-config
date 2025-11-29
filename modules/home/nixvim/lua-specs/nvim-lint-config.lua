return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      
      -- Configure ruff to use the Nix-provided binary
      lint.linters.ruff = {
        cmd = "ruff",
        stdin = false,
        args = { "check", "--output-format", "json" },
        parser = require("lint.parser").from_json,
      }
      
      -- Assign ruff as linter for Python files
      lint.linters_by_ft = {
        python = { "ruff" },
      }
      
      -- Auto-run linters on save
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
