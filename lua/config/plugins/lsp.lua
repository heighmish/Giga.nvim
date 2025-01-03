return {
  {
    "williamboman/mason.nvim",
    dependencies = {},
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {},
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason-lspconfig",
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "stevearc/conform.nvim",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({ capabilities = capabilities })
        end,
      })

      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { desc = desc })
      end

      local builtin = require("telescope.builtin")
      nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
      nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
      nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
      nmap("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
      nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
      nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then
            return
          end
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function()
              require("conform").format({ bufnr = args.buf, id = c.id })
            end,
          })
        end,
      })
    end,
  },
}
