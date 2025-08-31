-- load vim options
require("config.options")


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
	spec = {
		--  Themes
		{ "folke/tokyonight.nvim", priority = 1000 },
		{ "EdenEast/nightfox.nvim" , priority = 1000},
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
		{ "rose-pine/neovim", name = "rose-pine", priority = 1000 },

		--  LSP + Mason
		{ "neovim/nvim-lspconfig" },
		{
			"williamboman/mason.nvim",
			config = true,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
			config = function()
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				require("mason-lspconfig").setup({
					ensure_installed = { "omnisharp" },
					handlers = {
						function(server_name)
							require("lspconfig")[server_name].setup({
								capabilities = capabilities,
							})
						end,
					},
				})
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "c_sharp", "html", "json", "lua" },
					highlight = { enable = true },
				})
			end,
		},

		-- Autocomplete
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<Tab>"] = cmp.mapping.select_next_item(),
						["<S-Tab>"] = cmp.mapping.select_prev_item(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<C-Space>"] = cmp.mapping.complete(),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "buffer" },
						{ name = "path" },
					}),
				})
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			},
			config = function()
				local actions = require("telescope.actions")

				require("telescope").setup({
					defaults = {
						borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
						layout_config = { height = 0.8 },
						file_ignore_patterns = { "node_modules", "%.dll", "%.exe" },
						mappings = {
							i = {
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,
							},
							n = {
								["j"] = actions.move_selection_next,
								["k"] = actions.move_selection_previous,
							},
						},
					},
				})

				require("telescope").load_extension("fzf")
			end,
		},




		--  Debugging
		{ "nvim-neotest/nvim-nio" },
		{ "mfussenegger/nvim-dap" },
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap" },
			config = function()
				require("dapui").setup()
			end,
		},

		--  Statusline
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({ options = { theme = "auto" } })
			end,
		},
	},

	install = { colorscheme = { "tokyonight", "catppuccin", "rose-pine", "habamax" } },
	checker = { enabled = true },
})

-- 🌠 Set colorscheme
vim.cmd.colorscheme("carbonfox")


local builtin = require("telescope.builtin")

-- Search files
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find file" })

-- Search code (functions, members, etc.)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search code" })

-- Search current buffer
vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })

