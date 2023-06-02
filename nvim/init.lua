--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a  every line of code, top-to-bottom, and understand
  what your configuration is doing.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  search through `:help lua-guide`
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Lazy package manager
require('config.lazy')
require('config.keymaps')
require('config.options')
--
-- require('config.options')

-- Setup neovim lua configuration
-- require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
-- -- Setup mason so it can manage external tooling
-- require('mason').setup()
--
-- -- Ensure the servers above are installed
-- local mason_lspconfig = require 'mason-lspconfig'
--
-- mason_lspconfig.setup {
--   ensure_installed = vim.tbl_keys(servers),
-- }
--
-- mason_lspconfig.setup_handlers {
--   function(server_name)
--     require('lspconfig')[server_name].setup {
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = servers[server_name],
--     }
--   end,
-- }



-- PLUGINS: ensure that nvim-tree setup
-- require('nvim-tree').setup {}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
