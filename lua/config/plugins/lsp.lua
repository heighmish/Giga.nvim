return {
  {
    "williamboman/mason.nvim",
    dependencies = {},
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {},
    config = function()
      require("mason-lspconfig").setup()
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      'williamboman/mason-lspconfig',
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require("mason-lspconfig").setup_handlers {
        function(server_name)
          require("lspconfig")[server_name].setup { capabilities = capabilities }
        end
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
            end,
          })
        end,
      })
    end,
  },
}
