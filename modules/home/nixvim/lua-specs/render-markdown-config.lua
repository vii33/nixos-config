-- Disable LaTeX rendering to avoid tree-sitter parser warnings
-- Also ensure proper lazy loading to prevent setup() errors in snacks explorer
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    opts = {
      latex = {
        enabled = false,
      },
      file_types = { "markdown", "norg", "rmd", "org", "codecompanion" },
    },
  },
}
