-- Auto-aggregate all spec files in this directory
local M = {}

local spec_files = {
  "blink-cmp",
  "copilot",
  "keymaps",
  "mason-local",
  "nixd",
  "noice",
  "render-markdown",
  "vim-swapfile",
  -- Add more spec files here as needed
}

for _, file in ipairs(spec_files) do
  local ok, specs = pcall(require, "user.specs." .. file)
  if ok and specs then
    for _, spec in ipairs(specs) do
      table.insert(M, spec)
    end
  end
end

return M
