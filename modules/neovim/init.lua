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
option.smartcase = true
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
keymap('n', '<leader>g', function() require('snacks').lazygit() end)

keymap({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
keymap({ 'n', 'v', 'x' }, '<leader>p', '"+p<CR>')

keymap('n', '<leader>lf', vim.lsp.buf.format)
keymap('n', '<leader>d', vim.diagnostic.open_float)

keymap('n', '<leader>ff', function() require('fff').find_files() end, { desc = 'find files' })
keymap('n', '<leader>fg', function() require('fff').live_grep() end, { desc = 'live grep' })

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

autocmd('FileType', {
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end
})

-- diagnostic
vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
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
require('mini.statusline').setup()
require('mini.diff').setup()

require('blink.cmp').setup({
	keymap = { preset = 'default' },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
	},
	sources = {
		default = { 'lsp', 'path', 'snippets' },
	},
	snippets = { preset = 'luasnip' },
	fuzzy = { implementation = 'prefer_rust_with_warning' },
	signature = { enabled = true },
})

require('blink.pairs').setup({})

require('fff').setup({})
require('oil').setup()

require('stay-centered').setup()
require('umbra').setup()
