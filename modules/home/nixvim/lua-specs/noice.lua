-- Override Noice configuration for longer popup display time
return {
  {
    "folke/noice.nvim",
    opts = {
      views = {
        notify = {
          timeout = 10000, -- Increase from default 3000ms 
        },
      },
    },
  },
}
