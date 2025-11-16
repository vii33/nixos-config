-- Disable LaTeX rendering to avoid tree-sitter parser warnings
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      latex = {
        enabled = false,
      },
    },
  },
}
