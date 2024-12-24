-- lua/config/plugins/telescope
return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 
	'nvim-lua/plenary.nvim', 
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require('telescope').setup {
	pickers = {
	  find_files = {
	    theme= "ivy"
	  }
	},
	extensions = {
	  fzf = {}
	}
      }

      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')

      vim.keymap.set("n", "<leader>sf", builtin.find_files)
      vim.keymap.set("n", "<leader>sg", builtin.live_grep)
      vim.keymap.set("n", "<leader>sh", builtin.help_tags)
      vim.keymap.set("n", "<leader>en", function()
	builtin.find_files {
	  cwd = vim.fn.stdpath("config")
	}
      end)
    end
  }
}
