local option = vim.opt
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local lsp = vim.lsp

-- option
option.number = true
option.relativenumber = true
option.signcolumn = "no"
option.wrap = false
option.tabstop = 2
option.shiftwidth = 2

option.ignorecase = true
option.incsearch = true

option.smartindent = true

option.autoread = true
option.undofile = true
option.swapfile = false

option.termguicolors = true
option.winborder = "none"

option.splitbelow = true
option.splitright = true


-- keymap
vim.g.mapleader = " "

keymap('n', '<leader>e', ':Oil<CR>')
keymap('n', '<leader>g', ':Neogit<CR>')

keymap({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
keymap({ 'n', 'v', 'x' }, '<leader>p', '"+p<CR>')

keymap('n', '<leader>lf', vim.lsp.buf.format)
keymap('n', '<leader>j', vim.lsp.completion.get)

keymap('n', '<leader>ff', ":Pick files<CR>")
keymap('n', '<leader>fb', ":Pick buffers<CR>")
keymap('n', '<leader>fg', ":Pick grep_live<CR>")
keymap('n', '<leader>fh', ":Pick help<CR>")

keymap('n', 'R', 'gR')

keymap('x', 'J', ':move .+1<CR>gv=gv')
keymap('x', 'K', ':move .-2<CR>gv=gv')

keymap('t', '<Esc>', '<C-\\><C-n>')

-- autocmd
autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank { timeout = 250 }
	end
})

-- lsp
lsp.enable({ "lua_ls", "clangd", "zls", "nil_ls", "pylsp", "gopls" })
lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})

-- plugin
require('mini.pick').setup()
require('mini.statusline').setup()
require('mini.git').setup()
require('mini.diff').setup()

require('blink.cmp').setup({
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = {
				border = "none",
			},
		},
		menu = {
			border = "none",
			draw = { gap = 1 },
		},
	}
})
require('blink.pairs').setup({})

require('oil').setup()
require('stay-centered').setup()

require('kanagawa').setup({
	overrides = function(colors)
		local theme = colors.theme
		return {
			Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = theme.ui.bg_p2 },
		}
	end,
	theme = {
		all = {
			ui = {
				bg_gutter = "none"
			}
		}
	}
})
vim.cmd("colorscheme kanagawa-dragon");
