vim.g.mapleader=' '
-- vim.cmd('inoremap <silent> jk <Esc>')

-- Relative numbering
vim.opt.rnu = true
vim.opt.nu = true

-- Tab width
vim.opt.shiftwidth = 8
vim.opt.tabstop = 8

-- Search option
vim.o.ignorecase = true
vim.o.smartcase = true
-- Clear highlights after search
vim.cmd('nnoremap <silent> <leader>h :noh<CR>')

-- Ctrl+s to save
vim.cmd('inoremap <silent> <C-s> <Esc>:w<CR>')

-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{'rebelot/kanagawa.nvim', priority = 1000, config = true, opts = ...},
	{'windwp/nvim-autopairs', event = 'InsertEnter', config = true, opts = {}},
	{'nvim-treesitter/nvim-treesitter'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
		dependencies = {
			-- LSP support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},
			-- Autocomplete
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			-- Snippet
			{'L3MON4D3/LuaSnip'},
			{'saadparwaiz1/cmp_luasnip'},
		}
	},
	{'lervag/vimtex', lazy = false},
	{'pysan3/fcitx5.nvim'},
})

-- Colorscheme
vim.cmd("colorscheme kanagawa-wave") -- Default
-- vim.cmd("colorscheme kanagawa-dragon") -- Black
-- vim.cmd("colorscheme kanagawa-lotus") -- White

-- LSP config
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
end)

local lspconfig = require('lspconfig')
lspconfig.clangd.setup({})
lspconfig.texlab.setup({})
lspconfig.lua_ls.setup({})
lspconfig.jdtls.setup({})

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {'clangd', 'lua_ls', 'jdtls', 'texlab'},
	handlers = {
		lsp_zero.default_setup,
	},
})

-- Autocomplete
local luasnip = require('luasnip')
local cmp = require('cmp')
cmp.setup({
	source = {
		{name = 'nvim_lsp'},
		{name = 'luasnip'},
		{name = 'buffer'},
		{name = 'path'},
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.scroll_docs(-5),
		['<C-n>'] = cmp.mapping.scroll_docs(5),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.confirm({ select = true}),
		--[[
		['<C-l>'] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		["<C-h>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		]]
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
			return vim_item
		end
	},
})

-- fcitx5.nvim
require('fcitx5').setup({
	imname = {
		norm = 'keyboard-us',
	},
})
