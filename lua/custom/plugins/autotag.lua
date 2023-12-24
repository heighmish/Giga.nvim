-- File: lua/custom/plugins/autotag.lua

return {
  "windwp/nvim-ts-autotag",
  -- Optional dependency
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
